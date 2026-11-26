import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/nagaland_data.dart';
import '../../data/mock_user.dart';
import '../../services/firebase_service.dart';
import '../../widgets/tourist_map_banner_tile.dart';

class NagalandHomeScreen extends StatelessWidget {
  final ValueChanged<DistrictInfo> onSelectDistrict;

  const NagalandHomeScreen({
    super.key,
    required this.onSelectDistrict,
  });

  @override
  Widget build(BuildContext context) {
    final mockUser = MockUser();
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;

    // Offline fallback order if Firestore is empty/unreachable
    final orderedFallbackIds = [
      'kohima',
      'dimapur',
      'wokha',
      'zunheboto',
      'chumoukedima',
      'kiphire',
    ];
    final fallbackDistricts = orderedFallbackIds
        .map((id) => NagalandData.getDistrictById(id))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: StreamBuilder<List<DistrictInfo>>(
        stream: FirebaseService().getDestinations(),
        builder: (context, snapshot) {
          final districts = (snapshot.hasData && snapshot.data!.isNotEmpty)
              ? snapshot.data!
              : fallbackDistricts;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 120 + bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Greeting Header matching Home Page exactly
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
                                  const Text(
                                    'Explore Nagaland',
                                    style: TextStyle(
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
                const SizedBox(height: 12),

                // Google Maps Nagaland Tourist Map Banner (identical to Home Page)
                const TouristMapBannerTile(margin: EdgeInsets.symmetric(horizontal: 20)),
                const SizedBox(height: 20),

                // Section Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Destinations',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        '${districts.length} Districts',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Color(0xFF20B08D),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 2 Tiles in a Row Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: districts.length,
                    itemBuilder: (context, index) {
                      final district = districts[index];
                      return _buildGridCard(context, district);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridCard(BuildContext context, DistrictInfo district) {
    final imageAsset = district.cardAsset ?? district.heroAsset;
    final imageUrl = district.cardUrl ?? district.heroUrl;

    return GestureDetector(
      onTap: () => onSelectDistrict(district),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image (supports both Firestore URL & bundled asset)
              (imageUrl != null && imageUrl.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      memCacheWidth: 600,
                      fadeInDuration: const Duration(milliseconds: 120),
                      placeholder: (_, __) => Container(color: const Color(0xFF003848)),
                      errorWidget: (_, __, ___) => imageAsset.isNotEmpty
                          ? Image.asset(
                              imageAsset,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: const Color(0xFF003848)),
                            )
                          : Container(color: const Color(0xFF003848)),
                    )
                  : Image.asset(
                      imageAsset,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF003848),
                      ),
                    ),

              // Smooth Dark Gradient Overlay (matching Explore Cultures tiles)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.25),
                      Colors.black.withValues(alpha: 0.85),
                    ],
                    stops: const [0.2, 0.55, 1.0],
                  ),
                ),
              ),

              // Card Text Content & Action Pill (matching Explore Cultures tiles)
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      district.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${district.spots.length} Spots',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_double_arrow_right_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
