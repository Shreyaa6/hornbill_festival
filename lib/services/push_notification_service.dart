import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../screens/home/notifications_screen.dart';
import 'app_config_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('[FCM] Background message: ${message.messageId}');
}

class PushNotificationService {
  PushNotificationService._internal();
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;

  static const String _topic = 'all_users';
  static const String _channelId = 'hornbill_notifications';
  static const String _channelName = 'Hornbill Festival Updates';

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool _permissionRequested = false;

  /// Call once at app startup. Sets up background/tap listeners only — never
  /// triggers an iOS notification permission prompt.
  Future<void> initialize() async {
    if (_initialized || kIsWeb) return;
    _initialized = true;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // ---- Local notifications (Android foreground + tap handling) ----
    const androidInit = AndroidInitializationSettings('ic_stat_notification');
    // All Darwin permission flags set to false so iOS never shows the system
    // permission prompt here. The prompt is deferred to requestPermissionAndSubscribe()
    // which is only called after the user reaches the Home screen.
    const darwinInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
    );
    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final data = Map<String, dynamic>.from(jsonDecode(response.payload!) as Map);
            _openNotificationFromData(data);
          } catch (_) {}
        }
      },
    );

    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Festival announcements, circulars, and live alerts.',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // ---- FCM listeners (safe — no permission prompt) ----

    // Display foreground notifications on Android via local notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification == null) return;
      if (defaultTargetPlatform == TargetPlatform.android) {
        final payload = jsonEncode({
          'title': message.data['title'] ?? notification.title ?? '',
          'body': message.data['body'] ?? notification.body ?? '',
          'file': message.data['file'] ?? '',
        });
        _localNotifications.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          payload: payload,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              _channelName,
              importance: Importance.high,
              priority: Priority.high,
              icon: 'ic_stat_notification',
              color: Color(0xFF003848),
              largeIcon: DrawableResourceAndroidBitmap('@drawable/launch_logo'),
            ),
          ),
        );
      }
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _openNotificationFromRemoteMessage(message);
    });

    // Handle notification tap when app was terminated
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 1200), () {
        _openNotificationFromRemoteMessage(initialMessage);
      });
    }

    // If permission was already granted on a previous launch, re-apply foreground
    // options and re-subscribe — no prompt is shown when status is already granted.
    final currentSettings = await FirebaseMessaging.instance.getNotificationSettings();
    if (currentSettings.authorizationStatus == AuthorizationStatus.authorized ||
        currentSettings.authorizationStatus == AuthorizationStatus.provisional) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      _subscribeToTopic(FirebaseMessaging.instance);
      _permissionRequested = true; // skip re-asking in requestPermissionAndSubscribe
    }
  }

  /// Requests notification permission. Called once when the logged-in user
  /// reaches the Home screen. Never called at startup.
  Future<void> requestPermissionAndSubscribe() async {
    if (_permissionRequested || kIsWeb) return;
    _permissionRequested = true;

    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('[FCM] Authorization status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      _subscribeToTopic(messaging);
    }
  }

  void _openNotificationFromRemoteMessage(RemoteMessage message) {
    final data = Map<String, dynamic>.from(message.data);
    data['title'] = data['title'] ?? message.notification?.title ?? '';
    data['body'] = data['body'] ?? message.notification?.body ?? '';
    _openNotificationFromData(data);
  }

  void _openNotificationFromData(Map<String, dynamic> data) {
    final nav = AppConfigService().navigatorKey.currentState;
    if (nav == null) {
      Future.delayed(const Duration(milliseconds: 600), () {
        _openNotificationFromData(data);
      });
      return;
    }

    nav.push(
      MaterialPageRoute(
        builder: (_) => NotificationsScreen(
          initialNotification: {
            'title': (data['title'] ?? '').toString(),
            'body': (data['body'] ?? '').toString(),
            'file': (data['file'] ?? data['url'] ?? data['link'] ?? '').toString(),
            'date': (data['date'] ?? '').toString(),
          },
        ),
      ),
    );
  }

  Future<void> _subscribeToTopic(FirebaseMessaging messaging) async {
    try {
      final token = await messaging.getToken();
      debugPrint('[FCM] Device Token: $token');
      await messaging.subscribeToTopic(_topic);
      debugPrint('[FCM] Subscribed to topic: $_topic');
    } catch (e) {
      debugPrint('[FCM] Topic subscribe deferred (waiting for APNs/token): $e');
      messaging.onTokenRefresh.listen((token) async {
        debugPrint('[FCM] Refreshed Token: $token');
        try {
          await messaging.subscribeToTopic(_topic);
        } catch (_) {}
      });
    }
  }
}
