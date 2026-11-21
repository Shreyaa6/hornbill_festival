import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/mock_user.dart';
import '../../widgets/dashed_border.dart';
import '../auth/login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  void _shareApp() {
    SharePlus.instance.share(ShareParams(
      text:
          'Download Hornbill Festival: Find Homestays / Hotels, Destinations, Cabs, Places to Eat, Tour Guides and much more\n\nhttps://play.google.com/store/apps/details?id=hornbill.festival.nagaland',
    ));
  }

  void _rateOnPlaystore() {
    _launchUrl('https://play.google.com/store/apps/details?id=hornbill.festival.nagaland');
  }

  void _openLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _confirmLogout(BuildContext context, MockUser mockUser) {
    if (!mockUser.isLoggedIn) {
      _openLogin(context);
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 14,
            color: Color(0xFF475569),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              mockUser.logout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.w800,
                color: Color(0xFFE53935),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mockUser = MockUser();
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 120 + bottomInset),
        child: Column(
          children: [
            // User Profile Card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFECECEC), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AnimatedBuilder(
                animation: mockUser,
                builder: (context, _) {
                  final bool loggedIn = mockUser.isLoggedIn;
                  final name = loggedIn
                      ? (mockUser.name.isNotEmpty ? mockUser.name : "Hornbill User")
                      : "Guest User";
                  final email = loggedIn
                      ? (mockUser.email.isNotEmpty ? mockUser.email : "")
                      : "Tap to Log In / Register";

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: loggedIn ? null : () => _openLogin(context),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // User Avatar Image
                        ClipOval(
                          child: Image.asset(
                            'assets/images/user.png',
                            height: 76,
                            width: 76,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 18),

                        // Name and Email Box
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 23,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Dashed Mint Email Container
                              DashedBorder(
                                color: const Color(0xFF20B08D),
                                backgroundColor: const Color(0xFFD4FAF1),
                                borderRadius: 12.0,
                                dashLength: 4.5,
                                dashGap: 3.5,
                                strokeWidth: 1.2,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Text(
                                  email,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1EA884),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Actions Group Card
            AnimatedBuilder(
              animation: mockUser,
              builder: (context, _) {
                final bool loggedIn = mockUser.isLoggedIn;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFECECEC), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // If NOT logged in, show Log In / Register button
                      if (!loggedIn) ...[
                        _buildActionRow(
                          label: 'Log In / Register',
                          iconWidget: const Icon(
                            Icons.login_rounded,
                            color: Color(0xFF20B08D),
                            size: 22,
                          ),
                          onTap: () => _openLogin(context),
                        ),
                        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F3F5)),
                      ],

                      // Share App
                      _buildActionRow(
                        label: 'Share App',
                        iconWidget: const Icon(
                          Icons.share_outlined,
                          color: Color(0xFF20B08D),
                          size: 22,
                        ),
                        onTap: _shareApp,
                      ),

                      const Divider(height: 1, thickness: 1, color: Color(0xFFF1F3F5)),

                      // Rate on Playstore
                      _buildActionRow(
                        label: 'Rate on Playstore',
                        iconWidget: Image.asset(
                          'assets/images/playstore_clean.png',
                          height: 22,
                          width: 22,
                          fit: BoxFit.contain,
                        ),
                        onTap: _rateOnPlaystore,
                      ),

                      // If logged in, show Logout button
                      if (loggedIn) ...[
                        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F3F5)),
                        _buildActionRow(
                          label: 'Logout',
                          iconWidget: const Icon(
                            Icons.logout_rounded,
                            color: Color(0xFF20B08D),
                            size: 22,
                          ),
                          onTap: () => _confirmLogout(context, mockUser),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow({
    required String label,
    required Widget iconWidget,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            // Light Mint Rounded Container for Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFD4FAF1),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: iconWidget,
            ),
            const SizedBox(width: 16),

            // Action Label
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),

            // Trailing Teal Chevron
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF20B08D),
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}
