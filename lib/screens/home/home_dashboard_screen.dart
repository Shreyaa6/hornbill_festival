import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/app_data.dart';
import '../../data/mock_user.dart';
import '../../services/firebase_service.dart';
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
                            final name = mockUser.isLoggedIn ? mockUser.name : "Guest";
                            final subtitle = mockUser.isLoggedIn ? 'Welcome back' : 'Welcome to Hornbill';
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hey $name 👋',
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22,
                                    color: Color(0xFF222222),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  subtitle,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    color: Color(0xFF888484),
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

              // Image Carousel with PAP Relaxation banner
              StreamBuilder<List<String>>(
                stream: FirebaseService().getCarouselBanners(),
                builder: (context, snapshot) {
                  final banners = snapshot.data ?? AppData.homeBanners;
                  final allBanners = [
                    'assets/images/pap_relaxation_banner.png',
                    ...banners,
                  ];
                  return CustomCarousel(
                    images: allBanners,
                    height: 165,
                    borderRadius: 16,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                  );
                },
              ),

              const SizedBox(height: 14),

              // Card 1: Photo Contest 2025
              GestureDetector(
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
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.asset(
                      'assets/images/card_photo_contest_ditto.png',
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Card 2: Discover Viewpoint
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DiscoverViewpointScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.asset(
                      'assets/images/card_viewpoint_ditto.png',
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Card 3: Nagaland Tourism e-Magazine Card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PdfViewerScreen(
                        title: "Nagaland Tourism e-Magazine",
                        pdfUrl: "https://tourism.nagaland.gov.in/emagazine.pdf",
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/nagaland_tourism.png',
                        height: 50,
                        width: 75,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Nagaland Tourism e-Magazine',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w800,
                                fontSize: 15.5,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              '2025 Edition [NEW]',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: Color(0xFF20B08D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Card 4: Google Maps Nagaland Tourist Map
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TouristMapScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4FAF1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Color(0xFF20B08D),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'GOOGLE MAPS',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                color: Color(0xFF64748B),
                                letterSpacing: 0.4,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Nagaland Tourist Map',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              '15 Iconic Spots [EXPLORE]',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w800,
                                fontSize: 12.5,
                                color: Color(0xFF20B08D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Color(0xFF20B08D),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.keyboard_double_arrow_right_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

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
                          label: '26th Hornbill\nFestival',
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
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
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
}
