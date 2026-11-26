import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class AppConfig {
  final String privacyPolicyUrl;
  final String termsUrl;
  final String accountDeletionUrl;
  final int minAndroidBuild;
  final int minIosBuild;
  final String minAndroidVersion;
  final String minIosVersion;
  final bool isUpdateMandatory;
  final String updateTitle;
  final String updateMessage;
  final String playStoreUrl;
  final String appStoreUrl;

  const AppConfig({
    this.privacyPolicyUrl = 'https://nititechnologies.in/privacy-policy',
    this.termsUrl = 'https://nititechnologies.in/terms',
    this.accountDeletionUrl = 'https://nititechnologies.in/account-deletion',
    this.minAndroidBuild = 0,
    this.minIosBuild = 0,
    this.minAndroidVersion = '',
    this.minIosVersion = '',
    this.isUpdateMandatory = false,
    this.updateTitle = 'New Version Available',
    this.updateMessage =
        'A new version of Hornbill Festival is available with important updates. Please update to continue.',
    this.playStoreUrl =
        'https://play.google.com/store/apps/details?id=hornbill.festival.nagaland',
    this.appStoreUrl = 'https://apps.apple.com/app/id6737766797',
  });

  factory AppConfig.fromMap(Map<String, dynamic> data) {
    // Check multiple aliases so user can configure in Firebase however they like
    final androidVer = data['min_version_android']?.toString() ??
        data['min_android_version']?.toString() ??
        data['android_version']?.toString() ??
        data['min_version']?.toString() ??
        data['version']?.toString() ??
        '2.5.3';

    final iosVer = data['min_version_ios']?.toString() ??
        data['min_ios_version']?.toString() ??
        data['ios_version']?.toString() ??
        data['min_version']?.toString() ??
        data['version']?.toString() ??
        '2.3.0';

    final androidBuild = data['min_android_build'] ??
        data['min_build_android'] ??
        data['min_build'] ??
        data['build'] ??
        0;

    final iosBuild = data['min_ios_build'] ??
        data['min_build_ios'] ??
        data['min_build'] ??
        data['build'] ??
        0;

    final isMandatory = data['is_update_mandatory'] == true ||
        data['is_update_mandatory']?.toString().toLowerCase() == 'true' ||
        data['is_mandatory'] == true ||
        data['is_mandatory']?.toString().toLowerCase() == 'true' ||
        data['force_update'] == true ||
        data['force_update']?.toString().toLowerCase() == 'true' ||
        data['mandatory_update'] == true ||
        data['mandatory'] == true;

    return AppConfig(
      privacyPolicyUrl: data['privacy_policy_url']?.toString() ??
          data['privacyPolicyUrl']?.toString() ??
          'https://nititechnologies.in/privacy-policy',
      termsUrl: data['terms_url']?.toString() ??
          data['termsUrl']?.toString() ??
          'https://nititechnologies.in/terms',
      accountDeletionUrl: data['account_deletion_url']?.toString() ??
          data['accountDeletionUrl']?.toString() ??
          'https://nititechnologies.in/account-deletion',
      minAndroidBuild: (androidBuild is num)
          ? androidBuild.toInt()
          : (int.tryParse(androidBuild.toString()) ?? 0),
      minIosBuild: (iosBuild is num)
          ? iosBuild.toInt()
          : (int.tryParse(iosBuild.toString()) ?? 0),
      minAndroidVersion: androidVer.trim(),
      minIosVersion: iosVer.trim(),
      isUpdateMandatory: isMandatory,
      updateTitle: data['update_title']?.toString() ?? 'New Version Available',
      updateMessage: data['update_message']?.toString() ??
          'A new version of Hornbill Festival is available with important updates. Please update to continue.',
      playStoreUrl: data['play_store_url']?.toString() ??
          'https://play.google.com/store/apps/details?id=hornbill.festival.nagaland',
      appStoreUrl: data['app_store_url']?.toString() ??
          'https://apps.apple.com/app/id6737766797',
    );
  }

  /// Compares two semver strings like "2.5.2" and "2.5.3".
  /// Returns -1 if v1 < v2, 1 if v1 > v2, 0 if equal.
  static int compareSemVer(String v1, String v2) {
    try {
      final cleanV1 = v1
          .replaceAll(RegExp(r'^[vV]'), '')
          .split('+')
          .first
          .split('-')
          .first
          .trim();
      final cleanV2 = v2
          .replaceAll(RegExp(r'^[vV]'), '')
          .split('+')
          .first
          .split('-')
          .first
          .trim();
      final parts1 =
          cleanV1.split('.').map((p) => int.tryParse(p) ?? 0).toList();
      final parts2 =
          cleanV2.split('.').map((p) => int.tryParse(p) ?? 0).toList();
      final maxLen =
          parts1.length > parts2.length ? parts1.length : parts2.length;
      for (int i = 0; i < maxLen; i++) {
        final p1 = i < parts1.length ? parts1[i] : 0;
        final p2 = i < parts2.length ? parts2[i] : 0;
        if (p1 < p2) return -1;
        if (p1 > p2) return 1;
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }

  /// Returns true if an update is available (min version or build > current).
  bool isUpdateAvailable({
    String currentVersion = '2.5.3',
    int currentAndroidBuild = 28,
    int currentIosBuild = 23,
    bool? isAndroid,
    bool? isIos,
  }) {
    if (kIsWeb) return false;

    try {
      final checkIos = isIos ?? Platform.isIOS;
      final checkAndroid = isAndroid ?? (!checkIos);

      if (checkAndroid) {
        if (minAndroidVersion.isNotEmpty) {
          final cmp = compareSemVer(currentVersion, minAndroidVersion);
          if (cmp < 0) return true;
        }
        if (minAndroidBuild > currentAndroidBuild) return true;
      } else if (checkIos) {
        if (minIosVersion.isNotEmpty) {
          final cmp = compareSemVer(currentVersion, minIosVersion);
          if (cmp < 0) return true;
        }
        if (minIosBuild > currentIosBuild) return true;
      }
    } catch (_) {}
    return false;
  }

  /// Returns true if an update is available AND marked as mandatory.
  bool shouldForceUpdate({
    String currentVersion = '2.5.3',
    int currentAndroidBuild = 28,
    int currentIosBuild = 23,
    bool? isAndroid,
    bool? isIos,
  }) {
    return isUpdateAvailable(
      currentVersion: currentVersion,
      currentAndroidBuild: currentAndroidBuild,
      currentIosBuild: currentIosBuild,
      isAndroid: isAndroid,
      isIos: isIos,
    ) && isUpdateMandatory;
  }

  String get storeUrl {
    if (!kIsWeb) {
      try {
        if (Platform.isIOS) return appStoreUrl;
      } catch (_) {}
    }
    return playStoreUrl;
  }
}
