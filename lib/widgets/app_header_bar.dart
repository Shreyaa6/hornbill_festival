import 'package:flutter/material.dart';
import '../screens/home/notifications_screen.dart';

class AppHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onBackTap;

  const AppHeaderBar({
    super.key,
    this.showBackButton = false,
    this.onNotificationTap,
    this.onBackTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF0F0F0),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: (optional Back) + Hornbill Logo + Nagaland Tourism Logo
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showBackButton) ...[
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF222222)),
                  onPressed: onBackTap ??
                      () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                ),
                const SizedBox(width: 4),
              ],
              Image.asset(
                'assets/images/logo.png',
                height: 42,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Image.asset(
                'assets/images/nagaland_tourism.png',
                height: 34,
                fit: BoxFit.contain,
              ),
            ],
          ),

          // Right side: Green notification bell button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onNotificationTap ??
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
            child: Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF20B08D),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF20B08D).withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
