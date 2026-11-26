import 'package:flutter/material.dart';
import 'hornbill_intro_screen.dart';
import 'hornbill_home_screen.dart';

class HornbillFlowScreen extends StatelessWidget {
  final VoidCallback? onBackToHomeTab;

  const HornbillFlowScreen({super.key, this.onBackToHomeTab});

  void _openHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HornbillHomeScreen(
          onBack: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HornbillIntroScreen(
      onEnter: () => _openHome(context),
    );
  }
}
