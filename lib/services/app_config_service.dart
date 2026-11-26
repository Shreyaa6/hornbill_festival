import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app_config.dart';
import '../screens/update/app_update_screen.dart';
import '../data/mock_user.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/intro/app_intro_screen.dart';

class AppConfigService {
  static final AppConfigService _instance = AppConfigService._internal();
  factory AppConfigService() => _instance;
  AppConfigService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<DocumentSnapshot>? _configSubscription;
  bool _isUpdateScreenShowing = false;
  bool get isUpdateScreenShowing => _isUpdateScreenShowing;

  static const String collectionName = 'app_config_festival';
  static const int currentAndroidBuild = 28;
  static const int currentIosBuild = 23;
  static const String currentAndroidVersion = '2.5.3';
  static const String currentIosVersion = '2.3.0';

  AppConfig _config = const AppConfig();
  AppConfig get config => _config;

  String get privacyPolicyUrl => _config.privacyPolicyUrl;
  String get termsUrl => _config.termsUrl;
  String get accountDeletionUrl => _config.accountDeletionUrl;

  /// Starts listening to real-time changes in Firestore collection `app_config_festival/config`.
  /// The INSTANT you change the version or config in Firestore Console,
  /// this listener triggers and displays the update screen without needing a refresh.
  void startLiveConfigListener() {
    _configSubscription?.cancel();
    try {
      _configSubscription = FirebaseFirestore.instance
          .collection(collectionName)
          .doc('config')
          .snapshots()
          .listen((snapshot) {
        if (!snapshot.exists || snapshot.data() == null) return;
        final raw = Map<String, dynamic>.from(snapshot.data() as Map);
        Map<String, dynamic> data = raw;
        if (raw['config'] is Map) {
          data = Map<String, dynamic>.from(raw['config'] as Map);
        }

        _config = AppConfig.fromMap(data);
        debugPrint(
            "[AppConfig Live] Real-time Firestore update: minAndroid=${_config.minAndroidVersion}, minBuild=${_config.minAndroidBuild}");

        final hasUpdate = _config.isUpdateAvailable(
          currentVersion: currentAndroidVersion,
          currentAndroidBuild: currentAndroidBuild,
        );

        debugPrint(
            "[AppConfig Live] hasUpdate: $hasUpdate, isUpdateScreenShowing: $_isUpdateScreenShowing");

        if (hasUpdate) {
          if (!_isUpdateScreenShowing) {
            _isUpdateScreenShowing = true;
            final nav = navigatorKey.currentState;
            if (nav != null) {
              nav.push(
                MaterialPageRoute(
                  builder: (_) => AppUpdateScreen(
                    config: _config,
                    isMandatory: true,
                  ),
                ),
              );
            }
          }
        } else {
          // If update screen is currently showing and version was changed back to lower/current, auto dismiss!
          if (_isUpdateScreenShowing) {
            _isUpdateScreenShowing = false;
            final nav = navigatorKey.currentState;
            if (nav != null && nav.canPop()) {
              nav.pop();
            }
          }
        }
      }, onError: (e) {
        debugPrint("[AppConfig Live] listener error: $e");
      });
    } catch (e) {
      debugPrint("[AppConfig Live] stream init error: $e");
    }
  }

  /// Fetches the dynamic configuration from Firestore collection `app_config_festival`.
  Future<AppConfig> fetchConfig() async {
    try {
      final firestore = FirebaseFirestore.instance;
      Map<String, dynamic>? data;

      // 1. Try document named 'config' with server-first fetch
      try {
        DocumentSnapshot snap;
        try {
          snap = await firestore
              .collection(collectionName)
              .doc('config')
              .get(const GetOptions(source: Source.server));
        } catch (_) {
          snap = await firestore
              .collection(collectionName)
              .doc('config')
              .get();
        }
        if (snap.exists && snap.data() != null && snap.data() is Map) {
          final raw = Map<String, dynamic>.from(snap.data() as Map);
          if (raw['config'] is Map) {
            data = Map<String, dynamic>.from(raw['config'] as Map);
          } else {
            data = raw;
          }
        }
      } catch (e) {
        debugPrint("[AppConfig] doc('config') fetch error: $e");
      }

      // 2. If no version data found yet, try subcollection 'app_config_festival/config/config'
      if (data == null ||
          (!data.containsKey('min_version_android') &&
              !data.containsKey('min_version') &&
              !data.containsKey('min_android_version'))) {
        try {
          final subSnap = await firestore
              .collection(collectionName)
              .doc('config')
              .collection('config')
              .limit(1)
              .get(const GetOptions(source: Source.serverAndCache));
          if (subSnap.docs.isNotEmpty) {
            data = Map<String, dynamic>.from(subSnap.docs.first.data());
          }
        } catch (e) {
          debugPrint("[AppConfig] subcollection fetch error: $e");
        }
      }

      // 3. Fallback: scan any document in 'app_config_festival'
      if (data == null ||
          (!data.containsKey('min_version_android') &&
              !data.containsKey('min_version') &&
              !data.containsKey('min_android_version'))) {
        try {
          final querySnap = await firestore
              .collection(collectionName)
              .limit(5)
              .get(const GetOptions(source: Source.serverAndCache));
          for (final doc in querySnap.docs) {
            final docData = doc.data();
            if (docData.containsKey('min_version_android') ||
                docData.containsKey('min_version') ||
                docData.containsKey('min_android_version') ||
                docData.containsKey('play_store_url')) {
              data = Map<String, dynamic>.from(docData);
              break;
            } else if (docData['config'] is Map) {
              data = Map<String, dynamic>.from(docData['config'] as Map);
              break;
            }
          }
        } catch (e) {
          debugPrint("[AppConfig] collection scan error: $e");
        }
      }

      // 4. Fallback: check 'version_control' collection
      if (data == null ||
          (!data.containsKey('min_version_android') &&
              !data.containsKey('min_version') &&
              !data.containsKey('min_android_version'))) {
        try {
          final vcSnap = await firestore
              .collection('version_control')
              .limit(1)
              .get(const GetOptions(source: Source.serverAndCache));
          if (vcSnap.docs.isNotEmpty) {
            data = Map<String, dynamic>.from(vcSnap.docs.first.data());
          }
        } catch (_) {}
      }

      if (data != null && data.isNotEmpty) {
        _config = AppConfig.fromMap(data);
        debugPrint(
            "[AppConfig] Loaded config: minAndroid=${_config.minAndroidVersion}, minIos=${_config.minIosVersion}, isMandatory=${_config.isUpdateMandatory}");

        // Cache in SharedPreferences for fast offline boot
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_privacy_url', _config.privacyPolicyUrl);
        await prefs.setString('cached_terms_url', _config.termsUrl);
        await prefs.setString('cached_deletion_url', _config.accountDeletionUrl);
      }
    } catch (e) {
      debugPrint("AppConfigService fetch error: $e");
      // Load cached preferences if offline
      try {
        final prefs = await SharedPreferences.getInstance();
        final pUrl = prefs.getString('cached_privacy_url');
        final tUrl = prefs.getString('cached_terms_url');
        final dUrl = prefs.getString('cached_deletion_url');
        if (pUrl != null || tUrl != null) {
          _config = AppConfig(
            privacyPolicyUrl: pUrl ?? _config.privacyPolicyUrl,
            termsUrl: tUrl ?? _config.termsUrl,
            accountDeletionUrl: dUrl ?? _config.accountDeletionUrl,
          );
        }
      } catch (_) {}
    }
    return _config;
  }

  /// Checks if an update is available or mandatory and prompts the AppUpdateScreen.
  /// Evaluates both version string (e.g. 2.5.3) and build number.
  /// Returns true if update screen was displayed.
  Future<bool> checkAndPromptUpdate(BuildContext context) async {
    String currentVer = '2.5.3';
    if (!kIsWeb) {
      try {
        if (Platform.isIOS) currentVer = '2.3.0';
      } catch (_) {}
    }

    final hasUpdate = _config.isUpdateAvailable(
      currentVersion: currentVer,
      currentAndroidBuild: currentAndroidBuild,
      currentIosBuild: currentIosBuild,
    );

    debugPrint(
        "[AppConfig] checkAndPromptUpdate: hasUpdate=$hasUpdate, currentVer=$currentVer, minAndroid=${_config.minAndroidVersion}, isMandatory=${_config.isUpdateMandatory}");

    if (hasUpdate && context.mounted) {
      _isUpdateScreenShowing = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AppUpdateScreen(
            config: _config,
            isMandatory: true,
          ),
        ),
      );
      return true;
    }
    return false;
  }

  /// Proceeds into the app after user dismisses a non-mandatory update prompt.
  static void proceedAfterUpdate(BuildContext context) async {
    await MockUser().init();
    if (!context.mounted) return;

    final user = MockUser();
    if (user.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AppIntroScreen()),
      );
    }
  }

  /// Explicitly open the AppUpdateScreen (e.g. from Account Settings / Check for Updates)
  void showUpdateScreen(BuildContext context, {bool isMandatory = true}) {
    _isUpdateScreenShowing = true;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppUpdateScreen(
          config: _config,
          isMandatory: isMandatory,
        ),
      ),
    ).then((_) {
      _isUpdateScreenShowing = false;
    });
  }

  /// Bottom sheet variant of the update prompt matching filter dropdown design
  Future<void> showUpdateBottomSheet(
    BuildContext context, {
    bool isMandatory = false,
  }) async {
    final title = _config.updateTitle.isNotEmpty &&
            _config.updateTitle != 'Update Required'
        ? _config.updateTitle
        : 'New Version Available';

    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => PopScope(
        canPop: false,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Grab Handle
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 24),

                // Clean App Logo in Centre
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),

                // Title: New Version Available
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 10),

                // Message Text
                Text(
                  _config.updateMessage.isNotEmpty
                      ? _config.updateMessage
                      : 'A new version of Hornbill Festival is available with important updates. Please update to continue.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14.5,
                    height: 1.5,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 24),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Update Now',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      final storeUri = Uri.parse(_config.storeUrl);
                      try {
                        await launchUrl(
                          storeUri,
                          mode: LaunchMode.externalApplication,
                        );
                      } catch (e) {
                        debugPrint("Could not open store: $e");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

