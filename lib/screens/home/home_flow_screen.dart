import 'package:flutter/material.dart';
import 'home_dashboard_screen.dart';
import 'photo_contest_screen.dart';

class HomeFlowScreen extends StatelessWidget {
  final ValueChanged<int>? onSwitchTab;
  final ValueChanged<bool>? onHeaderVisibilityChanged;

  const HomeFlowScreen({
    super.key,
    this.onSwitchTab,
    this.onHeaderVisibilityChanged,
  });

  void _openPhotoContest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PhotoContestScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomeDashboardScreen(
      key: const ValueKey('home_dashboard_view'),
      onSwitchTab: onSwitchTab,
      onOpenPhotoContest: () => _openPhotoContest(context),
    );
  }
}
