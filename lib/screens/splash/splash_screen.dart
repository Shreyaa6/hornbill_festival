import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock_user.dart';
import '../../services/app_config_service.dart';
import '../intro/app_intro_screen.dart';
import '../main_navigation_screen.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();

    // Start fetching dynamic app config in parallel immediately on boot
    AppConfigService().fetchConfig();

    _timer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) {
        _navigateNext();
      }
    });
  }

  void _navigateNext() async {
    if (!mounted) return;

    // Fetch dynamic app config from Firestore collection 'app_config_festival'
    try {
      await AppConfigService().fetchConfig();
      if (!mounted) return;
      final updatePrompted =
          await AppConfigService().checkAndPromptUpdate(context);
      if (updatePrompted) {
        // App update screen has been presented
        return;
      }
    } catch (e) {
      debugPrint('[Splash] error checking update: $e');
    }

    if (!mounted) return;

    // Ensure user session state is initialized
    await MockUser().init();
    if (!mounted) return;

    final user = MockUser();
    if (user.isLoggedIn) {
      // User IS signed in: direct to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } else {
      // User is NOT signed in: to Get Started screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AppIntroScreen()),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
