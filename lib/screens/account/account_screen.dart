import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/mock_user.dart';
import '../../services/app_config_service.dart';
import '../../widgets/dashed_border.dart';
import '../auth/login_screen.dart';
import '../common/app_webview_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  static const String shareContent =
      'Download Hornbill Festival: Find Homestays / Hotels, Destinations, Cabs, Places to Eat, Tour Guides and much more \n\n https://play.google.com/store/apps/details?id=hornbill.festival.nagaland';

  static const String privacyPolicyUrl =
      'https://nititechnologies.in/privacy-policy';
  static const String termsUrl =
      'https://nititechnologies.in/terms';

  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching URL $url: $e');
    }
  }

  /// Bottom sheet popup for Logout confirmation (matching filter dropdown UX)
  Future<void> _showLogoutBottomSheet(BuildContext context, MockUser mockUser) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top drag handle
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4FAF1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    size: 28,
                    color: Color(0xFF20B08D),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  'Log Out of Hornbill Festival?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                const Text(
                  'Are you sure you want to log out? You can sign in anytime with your email to access your bookings and queries.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 24),

                // Primary Log Out Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF20B08D),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      await mockUser.logout();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Logged out successfully'),
                            backgroundColor: Color(0xFF20B08D),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Bottom sheet popup for permanent Account Deletion (matching filter dropdown UX)
  Future<void> _showDeleteAccountBottomSheet(BuildContext context, MockUser mockUser) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top drag handle
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Danger Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    size: 30,
                    color: Color(0xFFE53935),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  'Delete Account Permanently?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFE53935),
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                const Text(
                  'This action will permanently delete your account, personal profile, and associated records directly from our servers. This cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 24),

                // Destructive Delete Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      await mockUser.deleteAccount();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Your account and profile data have been permanently deleted.'),
                            backgroundColor: Color(0xFFE53935),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Delete My Account',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Keep Account Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text(
                      'Keep My Account',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _shareApp(BuildContext context) async {
    try {
      await SharePlus.instance.share(ShareParams(
        text: shareContent,
      ));
    } catch (e) {
      debugPrint('Share API error: $e');
    }
  }

  Future<void> _rateOnPlaystore() async {
    const playStoreWebUrl = 'https://play.google.com/store/apps/details?id=hornbill.festival.nagaland';
    final marketUri = Uri.parse('market://details?id=hornbill.festival.nagaland');
    final webUri = Uri.parse(playStoreWebUrl);

    try {
      if (await canLaunchUrl(marketUri)) {
        await launchUrl(marketUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  void _openLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
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
                        onTap: () => _shareApp(context),
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

                      const Divider(height: 1, thickness: 1, color: Color(0xFFF1F3F5)),

                      // Privacy Policy
                      _buildActionRow(
                        label: 'Privacy Policy',
                        iconWidget: const Icon(
                          Icons.privacy_tip_outlined,
                          color: Color(0xFF20B08D),
                          size: 22,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AppWebViewScreen(
                                title: 'Privacy Policy',
                                subtitle: 'Privacy & Data Protection',
                                url: AppConfigService().privacyPolicyUrl,
                              ),
                            ),
                          );
                        },
                      ),

                      const Divider(height: 1, thickness: 1, color: Color(0xFFF1F3F5)),

                      // Terms & Conditions
                      _buildActionRow(
                        label: 'Terms & Conditions',
                        iconWidget: const Icon(
                          Icons.description_outlined,
                          color: Color(0xFF20B08D),
                          size: 22,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AppWebViewScreen(
                                title: 'Terms & Conditions',
                                subtitle: 'User Agreement & Policies',
                                url: AppConfigService().termsUrl,
                              ),
                            ),
                          );
                        },
                      ),

                      const Divider(height: 1, thickness: 1, color: Color(0xFFF1F3F5)),

                      // Logout
                      _buildActionRow(
                        label: 'Logout',
                        iconWidget: const Icon(
                          Icons.logout_rounded,
                          color: Color(0xFF20B08D),
                          size: 22,
                        ),
                        onTap: () {
                          if (loggedIn) {
                            _showLogoutBottomSheet(context, mockUser);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('You are currently not logged in'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),

                      // Delete Account (Apple Store & Google Play requirement)
                      if (loggedIn) ...[
                        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F3F5)),
                        _buildActionRow(
                          label: 'Delete Account',
                          isDestructive: true,
                          iconWidget: const Icon(
                            Icons.delete_forever_rounded,
                            color: Color(0xFFE53935),
                            size: 22,
                          ),
                          onTap: () => _showDeleteAccountBottomSheet(context, mockUser),
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
    bool isDestructive = false,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            // Rounded Container for Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDestructive ? const Color(0xFFFFEBEB) : const Color(0xFFD4FAF1),
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
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDestructive ? const Color(0xFFE53935) : const Color(0xFF1E293B),
                ),
              ),
            ),

            // Trailing Chevron
            Icon(
              Icons.chevron_right_rounded,
              color: isDestructive ? const Color(0xFFE53935) : const Color(0xFF20B08D),
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}
