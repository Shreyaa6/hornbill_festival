import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_user.dart';
import '../../services/firebase_service.dart';
import '../auth/login_screen.dart';
import '../main_navigation_screen.dart';

class AppIntroScreen extends StatefulWidget {
  final VoidCallback? onFinish;

  const AppIntroScreen({super.key, this.onFinish});

  @override
  State<AppIntroScreen> createState() => _AppIntroScreenState();
}

class _AppIntroScreenState extends State<AppIntroScreen> {
  bool _showDisclaimer = false;

  @override
  void initState() {
    super.initState();
    _checkDisclaimerRequirement();
  }

  Future<void> _checkDisclaimerRequirement() async {
    // Only show disclaimer when user is NOT signed in
    final user = MockUser();
    if (user.isLoggedIn) {
      if (mounted) setState(() => _showDisclaimer = false);
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final alreadyDismissed = prefs.getBool('disclaimer_acknowledged') ?? false;
      if (!alreadyDismissed && mounted) {
        setState(() => _showDisclaimer = true);
      }
    } catch (_) {
      if (mounted) setState(() => _showDisclaimer = true);
    }
  }

  void _dismissDisclaimer() async {
    setState(() {
      _showDisclaimer = false;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('disclaimer_acknowledged', true);
    } catch (_) {}
  }

  static const String _defaultPlayStoreUrl =
      'https://play.google.com/store/apps/details?id=hornbill.services.nagaland';
  static const String _defaultAppStoreUrl =
      'https://apps.apple.com/in/app/hornbill-services/id6738601371';

  Future<void> _openHornbillServices() async {
    String url = '';
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;

    try {
      final doc = await FirebaseService()
          .firestore
          .collection('app_config_services')
          .doc('version_control')
          .get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (isIOS) {
          url = data['app_store_url']?.toString().trim() ?? '';
        } else {
          url = data['play_store_url']?.toString().trim() ?? '';
        }
      }
    } catch (e) {
      debugPrint('Error fetching version_control for Hornbill Services: $e');
    }

    if (url.isEmpty) {
      url = isIOS ? _defaultAppStoreUrl : _defaultPlayStoreUrl;
    }

    if (!isIOS) {
      final marketUri =
          Uri.parse('market://details?id=hornbill.services.nagaland');
      try {
        if (await canLaunchUrl(marketUri)) {
          await launchUrl(marketUri, mode: LaunchMode.externalApplication);
          return;
        }
      } catch (_) {}
    }

    final targetUri = Uri.parse(url);
    try {
      if (await canLaunchUrl(targetUri)) {
        await launchUrl(targetUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(targetUri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint('Could not launch store URL: $e');
    }
  }

  void _handleGetStarted() {
    if (widget.onFinish != null) {
      widget.onFinish!();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          onLoginSuccess: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
              (route) => false,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Dark Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),

          // Top Skip Button & Hero Headlines
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: _handleGetStarted,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Explore\nNagaland\nwith us.',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      fontSize: 54,
                      height: 1.1,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Stays · Cabs · Trips · Cafes',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Sheet Card
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: _handleGetStarted,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Want to enlist your business? ',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 13,
                          color: AppColors.navy,
                        ),
                      ),
                      GestureDetector(
                        onTap: _openHornbillServices,
                        child: const Text(
                          'Download Hornbill Services',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // Disclaimer Modal Popup
          if (_showDisclaimer)
            Container(
              color: Colors.black54,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Disclaimer',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Hornbill Festival app is not affiliated with any government entity in any form. The app is developed, maintained and owned only by NITI Technologies, India.\n\nThe app is only meant to highlight information about Nagaland, and all data in the app are sourced from public domains.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 13.5,
                        color: Color(0xFF4A4A4A),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _dismissDisclaimer,
                        child: const Text(
                          'I understand',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
