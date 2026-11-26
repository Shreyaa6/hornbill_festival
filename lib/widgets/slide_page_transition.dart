import 'package:flutter/material.dart';

/// Provides a transition where:
/// - Opening: the new page slides in from the right over the current page.
/// - Exiting / Back: the current page slides out towards the right offscreen,
///   revealing the previous page underneath.
class SlidePageTransition extends StatelessWidget {
  final Widget child;
  final bool isBack;
  final Duration duration;

  const SlidePageTransition({
    super.key,
    required this.child,
    this.isBack = false,
    this.duration = const Duration(milliseconds: 280),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        // When going back, the exiting page (in previousChildren) is placed on top
        // so it slides off towards the right, revealing currentChild underneath.
        // When opening, currentChild is on top so it slides in from the right over previousChildren.
        final List<Widget> children = isBack
            ? [if (currentChild != null) currentChild, ...previousChildren]
            : [...previousChildren, if (currentChild != null) currentChild];
        return Stack(
          fit: StackFit.expand,
          children: children,
        );
      },
      transitionBuilder: (Widget child, Animation<double> animation) {
        final bool isIncoming = animation.status == AnimationStatus.forward;

        if (!isBack) {
          // OPENING: incoming child slides in from right (1.0 -> 0.0).
          // Previous child underneath stays still.
          if (isIncoming) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          } else {
            return child;
          }
        } else {
          // EXITING / GOING BACK:
          // Exiting child (outgoing, animation 1.0 -> 0.0) slides out towards the right (0.0 -> 1.0).
          // Returning child (incoming) stays still underneath.
          if (!isIncoming) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          } else {
            return child;
          }
        }
      },
      child: child,
    );
  }
}
