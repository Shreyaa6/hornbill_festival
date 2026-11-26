import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_bottom_bar.dart';
import '../widgets/app_header_bar.dart';
import '../services/app_config_service.dart';
import 'home/home_flow_screen.dart';
import 'home/notifications_screen.dart';
import 'culture/cultures_screen.dart';
import 'hornbill/hornbill_flow_screen.dart';
import 'nagaland/nagaland_flow_screen.dart';
import 'account/account_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;
  bool _showHomeHeader = true;
  bool _showCultureHeader = true;
  bool _showNagalandHeader = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLiveUpdate();
    });
  }

  void _checkLiveUpdate() async {
    try {
      final config = await AppConfigService().fetchConfig();
      if (!mounted) return;
      if (config.isUpdateAvailable(
        currentVersion: AppConfigService.currentAndroidVersion,
        currentAndroidBuild: AppConfigService.currentAndroidBuild,
      )) {
        AppConfigService().showUpdateScreen(context, isMandatory: true);
      }
    } catch (_) {}
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotificationsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool shouldShowHeader;
    if (_currentIndex == 0) {
      shouldShowHeader = _showHomeHeader;
    } else if (_currentIndex == 1) {
      shouldShowHeader = _showCultureHeader;
    } else if (_currentIndex == 2) {
      shouldShowHeader = false;
    } else if (_currentIndex == 3) {
      shouldShowHeader = _showNagalandHeader;
    } else {
      shouldShowHeader = true;
    }

    final Color scaffoldBg;
    if (_currentIndex == 2) {
      scaffoldBg = const Color(0xFFF8FAFC);
    } else {
      scaffoldBg = const Color(0xFFF6F6F6);
    }

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        top: shouldShowHeader,
        bottom: AppTheme.needsBottomSafeArea(context),
        child: Column(
          children: [
            // Universal Header pinned at top when not on a hero banner screen
            if (shouldShowHeader)
              AppHeaderBar(
                onNotificationTap: _openNotifications,
              ),

            // Active Tab + Floating Bottom Navigation Bar
            Expanded(
              child: Stack(
                children: [
                  IndexedStack(
                    index: _currentIndex,
                    children: [
                      HomeFlowScreen(
                        onSwitchTab: _onTabTapped,
                        onHeaderVisibilityChanged: (visible) {
                          setState(() {
                            _showHomeHeader = visible;
                          });
                        },
                      ),
                      CulturesFlowScreen(
                        onHeaderVisibilityChanged: (visible) {
                          setState(() {
                            _showCultureHeader = visible;
                          });
                        },
                      ),
                      const HornbillFlowScreen(),
                      NagalandFlowScreen(
                        onHeaderVisibilityChanged: (visible) {
                          setState(() {
                            _showNagalandHeader = visible;
                          });
                        },
                      ),
                      const AccountScreen(),
                    ],
                  ),

                  // Floating Bottom Navigation Bar
                  CustomBottomBar(
                    currentIndex: _currentIndex,
                    onTap: _onTabTapped,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
