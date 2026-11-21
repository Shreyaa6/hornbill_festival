import 'package:flutter/material.dart';
import 'home_dashboard_screen.dart';
import 'photo_contest_screen.dart';

class HomeFlowScreen extends StatefulWidget {
  final ValueChanged<int>? onSwitchTab;
  final ValueChanged<bool>? onHeaderVisibilityChanged;

  const HomeFlowScreen({
    super.key,
    this.onSwitchTab,
    this.onHeaderVisibilityChanged,
  });

  @override
  State<HomeFlowScreen> createState() => HomeFlowScreenState();
}

class HomeFlowScreenState extends State<HomeFlowScreen> {
  bool _isPhotoContestOpen = false;
  final GlobalKey<PhotoContestScreenState> _contestKey =
      GlobalKey<PhotoContestScreenState>();

  void openPhotoContest() {
    setState(() {
      _isPhotoContestOpen = true;
    });
    widget.onHeaderVisibilityChanged?.call(false);
  }

  void goBackToHome() {
    setState(() {
      _isPhotoContestOpen = false;
    });
    widget.onHeaderVisibilityChanged?.call(true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isPhotoContestOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isPhotoContestOpen) {
          if (_contestKey.currentState?.handleBack() == true) {
            return;
          }
          goBackToHome();
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _isPhotoContestOpen
            ? PhotoContestScreen(
                key: _contestKey,
                onBack: goBackToHome,
              )
            : HomeDashboardScreen(
                key: const ValueKey('home_dashboard_view'),
                onSwitchTab: widget.onSwitchTab,
                onOpenPhotoContest: openPhotoContest,
              ),
      ),
    );
  }
}
