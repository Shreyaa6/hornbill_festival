import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/app_theme.dart';
import 'data/mock_user.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/intro/app_intro_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'services/app_config_service.dart';
import 'services/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    // Start real-time Firestore listener for instant in-app update trigger
    AppConfigService().startLiveConfigListener();
    // Initialize FCM push notifications & subscribe to 'all_users'
    await PushNotificationService().initialize();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  // Load saved Firestore user session if previously logged in
  await MockUser().init();

  // Edge-to-edge system navigation bar with solid black bottom nav bar & white action buttons
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(HornbillApp.defaultOverlayStyle);

  runApp(const HornbillApp());
}

class HornbillApp extends StatelessWidget {
  const HornbillApp({super.key});

  static const SystemUiOverlayStyle defaultOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // Android: black / dark text & icons
    statusBarBrightness: Brightness.light,    // iOS: black / dark text & icons
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: true,
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: defaultOverlayStyle,
      child: MaterialApp(
        navigatorKey: AppConfigService().navigatorKey,
        title: 'Hornbill Festival',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        builder: (context, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: defaultOverlayStyle,
            child: child ?? const SizedBox.shrink(),
          );
        },
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/main': (context) => const MainNavigationScreen(),
          '/intro': (context) => const AppIntroScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
        },
      ),
    );
  }
}
