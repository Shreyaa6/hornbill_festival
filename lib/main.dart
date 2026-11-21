import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'data/mock_user.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/intro/app_intro_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  // Load saved Firestore user session if previously logged in
  await MockUser().init();

  // Edge-to-edge system navigation bar matching app background
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFF6F6F6),
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  runApp(const HornbillApp());
}

class HornbillApp extends StatelessWidget {
  const HornbillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hornbill Festival',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const AppEntryPoint(),
        '/main': (context) => const MainNavigationScreen(),
        '/intro': (context) => AppIntroScreen(
              onFinish: () => Navigator.pushReplacementNamed(context, '/main'),
            ),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}

class AppEntryPoint extends StatefulWidget {
  const AppEntryPoint({super.key});

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  bool _hasSeenIntro = false;

  @override
  Widget build(BuildContext context) {
    if (!_hasSeenIntro) {
      return AppIntroScreen(
        onFinish: () {
          final user = MockUser();
          if (!user.isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LoginScreen(
                  onLoginSuccess: () {
                    setState(() {
                      _hasSeenIntro = true;
                    });
                  },
                ),
              ),
            );
          } else {
            setState(() {
              _hasSeenIntro = true;
            });
          }
        },
      );
    }
    return const MainNavigationScreen();
  }
}
