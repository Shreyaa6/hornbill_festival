import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/app_data.dart';
import '../../data/mock_user.dart';
import '../../services/firebase_service.dart';
import '../../services/push_notification_service.dart';
import '../../widgets/custom_carousel.dart';
import 'hotels_screen.dart';
import 'trips_screen.dart';
import 'taxis_screen.dart';
import 'cafes_screen.dart';
import 'tour_guides_screen.dart';
import 'emergency_screen.dart';
import 'notifications_screen.dart';
import 'photo_contest_screen.dart';
import 'pdf_viewer_screen.dart';
import 'discover_viewpoint_screen.dart';
import 'tourist_map_screen.dart';
import '../../widgets/tourist_map_banner_tile.dart';


class HomeDashboardScreen extends StatelessWidget {
  final ValueChanged<int>? onSwitchTab;
  final VoidCallback? onOpenPhotoContest;

  const HomeDashboardScreen({
    super.key,
    this.onSwitchTab,
    this.onOpenPhotoContest,
  });

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mockUser = MockUser();
    if (mockUser.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PushNotificationService().requestPermissionAndSubscribe();
      });
    }
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 130 + bottomInset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Hey {user} / Welcome Back + Profile
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedBuilder(
                          animation: mockUser,
                          builder: (context, _) {
                            final name = mockUser.isLoggedIn
                                ? mockUser.name
                                : (mockUser.name.isNotEmpty && mockUser.name != "Guest User"
                                    ? mockUser.name
                                    : "Guest");
                            final subtitle = mockUser.isLoggedIn ? 'Welcome back' : 'Welcome to Hornbill';
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hey $name 👋',
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  subtitle,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        'assets/images/user.png',
                        height: 52,
                        width: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),

              // Image Carousel
              StreamBuilder<List<String>>(
                stream: FirebaseService().getCarouselBanners(),
                builder: (context, snapshot) {
                  final banners = snapshot.data ?? AppData.homeBanners;
                  return CustomCarousel(
                    images: banners,
                    aspectRatio: 16 / 9,
                    borderRadius: 16,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                  );
                },
              ),

              const SizedBox(height: 14),

              // Card 1: Photo Contest 2026
              _buildHomeFeatureCard(
                context: context,
                iconAsset: 'assets/images/logo.png',
                eyebrow: 'HORNBILL FESTIVAL',
                title: 'PHOTO CONTEST 2026',
                actionLabel: '[PARTICIPATE]',
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Color(0xFFFFFBEB)],
                ),
                backgroundPainter: const _PhotoContestBackgroundPainter(),
                watermarkIcon: Icons.photo_camera_rounded,
                watermarkColor: const Color(0xFFD97706),
                actionColor: const Color(0xFFD97706),
                onTap: () {
                  if (onOpenPhotoContest != null) {
                    onOpenPhotoContest!();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PhotoContestScreen(),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 12),

              // Card 2: Discover Viewpoint
              _buildHomeFeatureCard(
                context: context,
                iconAsset: 'assets/images/destination.png',
                eyebrow: 'EXPLORE NAGALAND',
                title: 'DISCOVER VIEWPOINT',
                actionLabel: '[SUBMIT NEW SPOT]',
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Color(0xFFF0F9FF)],
                ),
                backgroundPainter: const _ViewpointBackgroundPainter(),
                watermarkIcon: Icons.landscape_rounded,
                watermarkColor: const Color(0xFF0284C7),
                actionColor: const Color(0xFF0284C7),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DiscoverViewpointScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // Card 3: Nagaland Tourism e-Magazine Card
              _buildHomeFeatureCard(
                context: context,
                iconAsset: 'assets/images/nagaland_tourism.png',
                eyebrow: 'NAGALAND TOURISM',
                title: 'TOURISM E-MAGAZINE',
                actionLabel: '[2026 EDITION]',
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Color(0xFFF6F8FB)],
                ),
                backgroundPainter: const _MagazineBackgroundPainter(),
                watermarkIcon: Icons.auto_stories_rounded,
                watermarkColor: const Color(0xFF003848),
                actionColor: const Color(0xFF0D9488),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PdfViewerScreen(
                        title: "Nagaland Tourism e-Magazine",
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // Card 4: Google Maps Nagaland Tourist Map
              const TouristMapBannerTile(),

              const SizedBox(height: 24),

              // Popular Services Header with Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/destination.png',
                      height: 26,
                      width: 26,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Popular Services',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Color(0xFF222222),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 3x3 Grid of 9 Popular Services
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Row 1
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildServiceCard(
                          context: context,
                          label: 'Hotels &\nHomestays',
                          iconAsset: 'assets/images/hotel.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HotelsScreen(),
                              ),
                            );
                          },
                        ),
                        _buildServiceCard(
                          context: context,
                          label: 'Tour\nPlanners',
                          iconAsset: 'assets/images/trips.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TripsScreen(),
                              ),
                            );
                          },
                        ),
                        _buildServiceCard(
                          context: context,
                          label: 'Book\nTaxi',
                          iconAsset: 'assets/images/taxi.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TaxisScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Row 2
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildServiceCard(
                          context: context,
                          label: 'Places To\nEat',
                          iconAsset: 'assets/images/ramen.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CafesScreen(),
                              ),
                            );
                          },
                        ),
                        _buildServiceCard(
                          context: context,
                          label: '27th Hornbill\nFestival',
                          iconAsset: 'assets/images/hornbill.png',
                          onTap: () {
                            if (onSwitchTab != null) {
                              onSwitchTab!(2);
                            }
                          },
                        ),
                        _buildServiceCard(
                          context: context,
                          label: 'Inner Line\nPermit',
                          iconAsset: 'assets/images/certificate.png',
                          onTap: () {
                            _launchUrl('https://ilp.nagaland.gov.in');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Row 3
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildServiceCard(
                          context: context,
                          label: 'Tour\nGuides',
                          iconAsset: 'assets/images/man.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TourGuidesScreen(),
                              ),
                            );
                          },
                        ),
                        _buildServiceCard(
                          context: context,
                          label: 'Emergency\nServices',
                          iconAsset: 'assets/images/siren.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EmergencyScreen(),
                              ),
                            );
                          },
                        ),
                        _buildServiceCard(
                          context: context,
                          label: 'Important\nNotices',
                          iconAsset: 'assets/images/announcement.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required String label,
    required String iconAsset,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 32 - 20) / 3,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFECECEC), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconAsset,
                height: 48,
                width: 48,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeFeatureCard({
    required BuildContext context,
    required String iconAsset,
    required String eyebrow,
    required String title,
    required String actionLabel,
    required VoidCallback onTap,
    Gradient? gradient,
    CustomPainter? backgroundPainter,
    IconData? watermarkIcon,
    Color? watermarkColor,
    Color? actionColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Custom Background Element (Painter)
            if (backgroundPainter != null)
              Positioned.fill(
                child: CustomPaint(
                  painter: backgroundPainter,
                ),
              ),

            // Subtle Watermark Icon in background
            if (watermarkIcon != null)
              Positioned(
                right: -8,
                bottom: -10,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.045,
                    child: Icon(
                      watermarkIcon,
                      size: 88,
                      color: watermarkColor ?? const Color(0xFF003848),
                    ),
                  ),
                ),
              ),

            // Foreground Content with InkWell
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onTap,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      // Left Icon / Emblem
                      SizedBox(
                        width: 58,
                        height: 52,
                        child: Image.asset(
                          iconAsset,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Center Text (Eyebrow, Title, Action Tag)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              eyebrow,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                letterSpacing: 0.6,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w900,
                                fontSize: 17,
                                letterSpacing: -0.3,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              actionLabel,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w800,
                                fontSize: 12.5,
                                color: actionColor ?? const Color(0xFF0D9488),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Subtle viewfinder & camera frame background elements for Photo Contest tile
class _PhotoContestBackgroundPainter extends CustomPainter {
  const _PhotoContestBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: 0.09)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    // Viewfinder bracket (top-right corner of camera frame)
    final bx = size.width * 0.88;
    final by = size.height * 0.28;
    const blen = 16.0;
    final path1 = Path()
      ..moveTo(bx - blen, by)
      ..lineTo(bx, by)
      ..lineTo(bx, by + blen);
    canvas.drawPath(path1, strokePaint);

    // Viewfinder bracket (bottom-right corner)
    final by2 = size.height * 0.72;
    final path2 = Path()
      ..moveTo(bx, by2 - blen)
      ..lineTo(bx, by2)
      ..lineTo(bx - blen, by2);
    canvas.drawPath(path2, strokePaint);

    // Center focal point / crosshair
    final fx = size.width * 0.78;
    final fy = size.height * 0.50;
    final crossPaint = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(fx - 6, fy), Offset(fx + 6, fy), crossPaint);
    canvas.drawLine(Offset(fx, fy - 6), Offset(fx, fy + 6), crossPaint);

    // Soft focus circle
    final circlePaint = Paint()
      ..color = const Color(0xFFD97706).withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(Offset(fx, fy), 18, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Subtle mountain ridge & summit waypoint background elements for Discover Viewpoint tile
class _ViewpointBackgroundPainter extends CustomPainter {
  const _ViewpointBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final ridgePaint = Paint()
      ..color = const Color(0xFF0284C7).withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    // Mountain ridge 1 (foreground ridge)
    final path1 = Path();
    path1.moveTo(size.width * 0.52, size.height);
    path1.lineTo(size.width * 0.68, size.height * 0.38);
    path1.lineTo(size.width * 0.78, size.height * 0.58);
    path1.lineTo(size.width * 0.90, size.height * 0.28);
    path1.lineTo(size.width, size.height * 0.52);
    canvas.drawPath(path1, ridgePaint);

    // Distant mountain ridge 2
    final ridgePaint2 = Paint()
      ..color = const Color(0xFF0D9488).withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;
    final path2 = Path();
    path2.moveTo(size.width * 0.60, size.height);
    path2.lineTo(size.width * 0.76, size.height * 0.44);
    path2.lineTo(size.width * 0.85, size.height * 0.62);
    path2.lineTo(size.width, size.height * 0.36);
    canvas.drawPath(path2, ridgePaint2);

    // Peak marker / glowing summit star
    final sunPaint = Paint()
      ..color = const Color(0xFF0284C7).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width * 0.90, size.height * 0.28), 2.5, sunPaint);

    final ringPaint = Paint()
      ..color = const Color(0xFF0284C7).withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(
        Offset(size.width * 0.90, size.height * 0.28), 6.0, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Subtle editorial open booklet & column layout background elements for Tourism e-Magazine tile
class _MagazineBackgroundPainter extends CustomPainter {
  const _MagazineBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final pagePaint = Paint()
      ..color = const Color(0xFF003848).withValues(alpha: 0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    // Editorial open booklet curves (curved pages)
    final path1 = Path();
    path1.moveTo(size.width * 0.65, size.height * 0.20);
    path1.cubicTo(
      size.width * 0.76,
      size.height * 0.16,
      size.width * 0.86,
      size.height * 0.28,
      size.width * 0.96,
      size.height * 0.24,
    );
    canvas.drawPath(path1, pagePaint);

    final path2 = Path();
    path2.moveTo(size.width * 0.65, size.height * 0.82);
    path2.cubicTo(
      size.width * 0.76,
      size.height * 0.78,
      size.width * 0.86,
      size.height * 0.90,
      size.width * 0.96,
      size.height * 0.86,
    );
    canvas.drawPath(path2, pagePaint);

    // Spine line
    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.20),
      Offset(size.width * 0.65, size.height * 0.82),
      pagePaint,
    );

    // Subtle editorial column lines
    final linePaint = Paint()
      ..color = const Color(0xFF003848).withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    for (int i = 0; i < 3; i++) {
      final y = size.height * (0.38 + i * 0.12);
      canvas.drawLine(
        Offset(size.width * 0.72, y),
        Offset(size.width * 0.92, y),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
