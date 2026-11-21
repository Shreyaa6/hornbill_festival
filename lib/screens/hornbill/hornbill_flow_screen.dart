import 'package:flutter/material.dart';
import 'hornbill_intro_screen.dart';
import 'hornbill_home_screen.dart';
import 'hornbill_stalls_screen.dart';
import 'hornbill_programs_screen.dart';
import '../home/emergency_screen.dart';

enum HornbillSubPage {
  intro,
  home,
  stalls,
  programs,
  emergency,
}

class HornbillFlowScreen extends StatefulWidget {
  final VoidCallback? onBackToHomeTab;

  const HornbillFlowScreen({super.key, this.onBackToHomeTab});

  @override
  State<HornbillFlowScreen> createState() => HornbillFlowScreenState();
}

class HornbillFlowScreenState extends State<HornbillFlowScreen> {
  HornbillSubPage _currentPage = HornbillSubPage.intro;

  void openHome() {
    setState(() {
      _currentPage = HornbillSubPage.home;
    });
  }

  void openStalls() {
    setState(() {
      _currentPage = HornbillSubPage.stalls;
    });
  }

  void openPrograms() {
    setState(() {
      _currentPage = HornbillSubPage.programs;
    });
  }

  void openEmergency() {
    setState(() {
      _currentPage = HornbillSubPage.emergency;
    });
  }

  void goBackToHome() {
    setState(() {
      _currentPage = HornbillSubPage.home;
    });
  }

  void goBackToIntro() {
    setState(() {
      _currentPage = HornbillSubPage.intro;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentPage == HornbillSubPage.intro,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (_currentPage == HornbillSubPage.home) {
            goBackToIntro();
          } else if (_currentPage != HornbillSubPage.intro) {
            goBackToHome();
          }
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: switch (_currentPage) {
          HornbillSubPage.intro => HornbillIntroScreen(
              key: const ValueKey('hornbill_intro_view'),
              onEnter: openHome,
            ),
          HornbillSubPage.home => HornbillHomeScreen(
              key: const ValueKey('hornbill_home_view'),
              onBack: goBackToIntro,
              onOpenStalls: openStalls,
              onOpenPrograms: openPrograms,
              onOpenEmergency: openEmergency,
            ),
          HornbillSubPage.stalls => HornbillStallsScreen(
              key: const ValueKey('hornbill_stalls_view'),
              onBack: goBackToHome,
            ),
          HornbillSubPage.programs => HornbillProgramsScreen(
              key: const ValueKey('hornbill_programs_view'),
              onBack: goBackToHome,
            ),
          HornbillSubPage.emergency => EmergencyScreen(
              key: const ValueKey('hornbill_emergency_view'),
              onBack: goBackToHome,
            ),
        },
      ),
    );
  }
}
