import 'package:flutter/material.dart';
import '../../data/nagaland_data.dart';
import '../../data/mock_user.dart';
import '../home/tourist_map_screen.dart';

class NagalandHomeScreen extends StatefulWidget {
  final ValueChanged<DistrictInfo> onSelectDistrict;

  const NagalandHomeScreen({
    super.key,
    required this.onSelectDistrict,
  });

  @override
  State<NagalandHomeScreen> createState() => _NagalandHomeScreenState();
}

class _NagalandHomeScreenState extends State<NagalandHomeScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mockUser = MockUser();
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;

    // Filter districts by query if active
    final allDistricts = NagalandData.districts;
    final filteredDistricts = _searchQuery.isEmpty
        ? allDistricts
        : allDistricts.where((d) {
            return d.name.toLowerCase().contains(_searchQuery) ||
                d.displayName.toLowerCase().contains(_searchQuery) ||
                d.spots.any((s) => s.name.toLowerCase().contains(_searchQuery));
          }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 120 + bottomInset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Greeting Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedBuilder(
                        animation: mockUser,
                        builder: (context, _) {
                          final name = mockUser.isLoggedIn ? mockUser.name : "Guest";
                          return Text(
                            'Hey $name 👋',
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              color: Color(0xFF1E293B),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Explore Nagaland',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Color(0xFF1E293B),
                        ),
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
            const SizedBox(height: 16),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14.5,
                      color: Color(0xFF94A3B8),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF475569),
                      size: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Google Maps Nagaland Tourist Map Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TouristMapScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4FAF1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.map_outlined,
                          color: Color(0xFF20B08D),
                          size: 26,
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
                                fontSize: 15.5,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '15 Iconic Attractions • Navigate & Details',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
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
            ),
            const SizedBox(height: 18),

            // Horizontal Compact District Cards (Kohima, Dimapur, Wokha, Zunheboto, ...)
            SizedBox(
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                children: [
                  _buildCompactCard(
                    districtId: 'kohima',
                    label: 'Kohima',
                    imageAsset: 'assets/images/district_thumb_kohima.png',
                    hasBakedInText: true,
                  ),
                  const SizedBox(width: 12),
                  _buildCompactCard(
                    districtId: 'dimapur',
                    label: 'Dimapur',
                    isPlaceholderGray: true,
                  ),
                  const SizedBox(width: 12),
                  _buildCompactCard(
                    districtId: 'wokha',
                    label: 'Wokha',
                    imageAsset: 'assets/images/district_thumb_wokha.png',
                    hasBakedInText: true,
                  ),
                  const SizedBox(width: 12),
                  _buildCompactCard(
                    districtId: 'zunheboto',
                    label: "Z'boto",
                    imageAsset: 'assets/images/district_thumb_zunheboto.png',
                  ),
                  const SizedBox(width: 12),
                  _buildCompactCard(
                    districtId: 'mokokchung',
                    label: 'Mokokchung',
                    imageAsset: 'assets/images/district_thumb_wokha.png',
                  ),
                  const SizedBox(width: 12),
                  _buildCompactCard(
                    districtId: 'phek',
                    label: 'Phek',
                    imageAsset: 'assets/images/district_thumb_kohima.png',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Vertical List of Featured Large District Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: _searchQuery.isEmpty
                    ? [
                        // Chümoukedima Large Card
                        _buildFeaturedLargeCard(
                          districtId: 'chumoukedima',
                          displayName: 'CHÜMOUKEDIMA',
                          imageAsset: 'assets/images/district_card_chumoukedima.png',
                        ),
                        const SizedBox(height: 16),

                        // Kiphire Large Card
                        _buildFeaturedLargeCard(
                          districtId: 'kiphire',
                          displayName: 'Kiphire',
                          imageAsset: 'assets/images/district_card_kiphire.png',
                        ),
                        const SizedBox(height: 16),

                        // Wokha Large Card
                        _buildFeaturedLargeCard(
                          districtId: 'wokha',
                          displayName: 'Wokha',
                          imageAsset: 'assets/images/wokha_hero.png',
                          hasOverlayTitle: true,
                        ),
                      ]
                    : filteredDistricts.map((district) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildFeaturedLargeCard(
                            districtId: district.id,
                            displayName: district.displayName,
                            imageAsset: district.cardAsset ?? district.heroAsset,
                            hasOverlayTitle: district.id != 'chumoukedima' && district.id != 'kiphire',
                          ),
                        );
                      }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard({
    required String districtId,
    required String label,
    String? imageAsset,
    bool isPlaceholderGray = false,
    bool hasBakedInText = false,
  }) {
    return GestureDetector(
      onTap: () {
        final district = NagalandData.getDistrictById(districtId);
        widget.onSelectDistrict(district);
      },
      child: Container(
        width: 110,
        height: 130,
        decoration: BoxDecoration(
          color: isPlaceholderGray ? const Color(0xFFC0C0C0) : Colors.black12,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (!isPlaceholderGray && imageAsset != null)
              Image.asset(
                imageAsset,
                fit: BoxFit.cover,
              ),

            // Gradient shadow and District Label only if text is not baked in
            if (!hasBakedInText) ...[
              if (!isPlaceholderGray)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.65),
                        ],
                      ),
                    ),
                  ),
                ),

              // District Label
              Positioned(
                left: 8,
                right: 8,
                bottom: 10,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(0, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedLargeCard({
    required String districtId,
    required String displayName,
    required String imageAsset,
    bool hasOverlayTitle = false,
  }) {
    return GestureDetector(
      onTap: () {
        final district = NagalandData.getDistrictById(districtId);
        widget.onSelectDistrict(district);
      },
      child: Container(
        width: double.infinity,
        height: 195,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imageAsset,
              fit: BoxFit.cover,
            ),

            // If the image doesn't already have the dark bottom strip, render it
            if (hasOverlayTitle)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 42,
                  color: Colors.black.withValues(alpha: 0.55),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    displayName,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
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
