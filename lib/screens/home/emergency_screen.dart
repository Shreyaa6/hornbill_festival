import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/firebase_service.dart';
import '../../theme/app_theme.dart';

class EmergencyScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final bool showBackButton;

  const EmergencyScreen({
    super.key,
    this.onBack,
    this.showBackButton = true,
  });

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  int _selectedTabIndex = 0; // 0: Police Stations, 1: Nearby Hospitals, 2: Tourist Police

  static const List<Map<String, String>> _defaultHelplines = [
    // Police Stations - Kohima
    {'category': 'police', 'district': 'Kohima', 'name': 'North Police Station', 'subtitle': 'Chumdemo Odyuo', 'phone': '8575045520'},
    {'category': 'police', 'district': 'Kohima', 'name': 'South Police Station', 'subtitle': 'Mulekhoyi C.', 'phone': '8575045515'},
    {'category': 'police', 'district': 'Kohima', 'name': 'Women Police Station', 'subtitle': 'Dziesengunuo Bio', 'phone': '7005986026'},
    {'category': 'police', 'district': 'Kohima', 'name': 'Police Control Room', 'subtitle': 'On-duty Officer', 'phone': '8575045515'},
    // Police Stations - Dimapur
    {'category': 'police', 'district': 'Dimapur', 'name': 'East Police Station', 'subtitle': 'Bendangwati', 'phone': '7085055020'},
    {'category': 'police', 'district': 'Dimapur', 'name': 'West Police Station', 'subtitle': 'L. Yanthithung', 'phone': '7085055023'},
    {'category': 'police', 'district': 'Dimapur', 'name': 'Women Police Station', 'subtitle': 'Tingbem Thomsong', 'phone': '7085055027'},
    {'category': 'police', 'district': 'Dimapur', 'name': 'Police Control Room', 'subtitle': 'On-duty Officer', 'phone': '3862228400'},
    // Nearby Hospitals - Kohima
    {'category': 'hospital', 'district': 'Kohima', 'name': 'Oking Hospital', 'subtitle': 'Phulbari, Opp. to Bandhan Bank', 'phone': '3702290080'},
    {'category': 'hospital', 'district': 'Kohima', 'name': 'Naga Hospital', 'subtitle': 'Hospital Colony, Kohima', 'phone': '8794805711'},
    {'category': 'hospital', 'district': 'Kohima', 'name': 'Kohimas Hospital', 'subtitle': 'Naga Bazaar, Kohima', 'phone': '03702243555'},
    // Nearby Hospitals - Dimapur
    {'category': 'hospital', 'district': 'Dimapur', 'name': 'Faith Hospital', 'subtitle': 'Old Sewak Road, Dhobinullah', 'phone': '9077747777'},
    {'category': 'hospital', 'district': 'Dimapur', 'name': 'Nikos Hospital', 'subtitle': 'Midland, Dimapur', 'phone': '3862248285'},
    {'category': 'hospital', 'district': 'Dimapur', 'name': 'Eden Medical Centre', 'subtitle': 'Near Sub Jail, Oriental Colony', 'phone': '8794289192'},
    {'category': 'hospital', 'district': 'Dimapur', 'name': 'Zion hospital', 'subtitle': 'Purana Bazar, Dimapur', 'phone': '9366451969'},
    // Tourist Police
    {'category': 'tourist_police', 'district': 'Kohima', 'name': 'Police Control Room', 'subtitle': 'On-duty Officer', 'phone': '112'},
  ];

  String _normalizeCategory(String raw) {
    final lower = raw.trim().toLowerCase();
    if (lower.contains('hospital') || lower.contains('medical')) return 'hospital';
    if (lower.contains('tourist')) return 'tourist_police';
    return 'police';
  }

  Future<void> _makeCall(String phoneNumber) async {
    String clean = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    // If it's a 10-digit number starting with STD code 370 or 3862, prefix with 0 so the dialer routes it as a landline
    if (clean.length == 10 && (clean.startsWith('370') || clean.startsWith('3862'))) {
      clean = '0$clean';
    }
    final uri = Uri.parse('tel:$clean');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    const headerColor = Color(0xFF003848);
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: headerColor,
      body: SafeArea(
        bottom: AppTheme.needsBottomSafeArea(context),
        child: Column(
          children: [
            // Deep Teal Top Header (matches Notifications / TaxisScreen style)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Helpline',
                      style: AppTextStyles.headerTitle,
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Police • Hospitals • Tourist Police',
                      style: AppTextStyles.headerSubtitle,
                    ),
                  ],
                ),
              ),
            ),

            // White Rounded Body Sheet
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 110 + bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 3 Category Tabs
                      Row(
                        children: [
                          _buildCategoryTab(
                            index: 0,
                            selectedAsset: 'assets/images/tile_police_white.png',
                            unselectedAsset: 'assets/images/tile_police_black.png',
                            fallbackIcon: Icons.shield_outlined,
                            label: 'Police\nStations',
                          ),
                          const SizedBox(width: 10),
                          _buildCategoryTab(
                            index: 1,
                            selectedAsset: 'assets/images/tile_hospital_white.png',
                            unselectedAsset: 'assets/images/tile_hospital_black.png',
                            fallbackIcon: Icons.local_hospital_outlined,
                            label: 'Nearby\nHospitals',
                          ),
                          const SizedBox(width: 10),
                          _buildCategoryTab(
                            index: 2,
                            selectedAsset: 'assets/images/tile_tourist_white.png',
                            unselectedAsset: 'assets/images/tile_tourist_black.png',
                            fallbackIcon: Icons.local_police_outlined,
                            label: 'Tourist\nPolice',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Live Helplines Stream from Firestore (with built-in fallback)
                      StreamBuilder<List<Map<String, dynamic>>>(
                        stream: FirebaseService().getEmergencyHelplines(),
                        builder: (context, snapshot) {
                          final rawList = (snapshot.hasData && snapshot.data!.isNotEmpty)
                              ? snapshot.data!
                              : _defaultHelplines;

                          final targetCat = _selectedTabIndex == 0
                              ? 'police'
                              : (_selectedTabIndex == 1 ? 'hospital' : 'tourist_police');

                          final filtered = rawList.where((item) {
                            final cat = _normalizeCategory((item['category'] ?? '').toString());
                            return cat == targetCat;
                          }).toList();

                          // Group by district while preserving order
                          final Map<String, List<Map<String, String>>> byDistrict = {};
                          for (final item in filtered) {
                            final district = (item['district'] ?? 'Kohima').toString().trim();
                            final key = district.isEmpty ? 'Other' : district;
                            byDistrict.putIfAbsent(key, () => []);
                            byDistrict[key]!.add({
                              'name': (item['name'] ?? '').toString(),
                              'subtitle': (item['subtitle'] ?? item['officer'] ?? item['address'] ?? '').toString(),
                              'phone': (item['phone'] ?? '').toString(),
                            });
                          }

                          if (byDistrict.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Text(
                                  'No helplines available in this category.',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            );
                          }

                          final isPolice = _selectedTabIndex != 1;
                          final entries = byDistrict.entries.toList();
                          return Column(
                            children: List.generate(entries.length, (idx) {
                              final entry = entries[idx];
                              return Padding(
                                padding: EdgeInsets.only(bottom: idx < entries.length - 1 ? 20 : 0),
                                child: _buildDistrictCard(
                                  district: entry.key,
                                  isPolice: isPolice,
                                  items: entry.value,
                                ),
                              );
                            }),
                          );
                        },
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

  Widget _buildCategoryTab({
    required int index,
    required String selectedAsset,
    required String unselectedAsset,
    required IconData fallbackIcon,
    required String label,
  }) {
    final isSelected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          height: 86,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF20B08D) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isSelected ? selectedAsset : unselectedAsset,
                height: 32,
                width: 32,
                fit: BoxFit.contain,
                color: isSelected ? Colors.white : null,
                errorBuilder: (context, error, stackTrace) => Icon(
                  fallbackIcon,
                  size: 28,
                  color: isSelected ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : const Color(0xFF1E293B),
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDistrictCard({
    required String district,
    required bool isPolice,
    required List<Map<String, String>> items,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final badgeWidth = totalWidth * 0.40;
        final rightGap = totalWidth * 0.10;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // District Slanted Badge positioned directly on top of the card's border (40% width, 10% gap from right)
            Padding(
              padding: EdgeInsets.only(right: rightGap),
              child: ClipPath(
                clipper: _SlantedBadgeClipper(),
                child: Container(
                  height: 24,
                  width: badgeWidth,
                  color: const Color(0xFF20B08D),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 14),
                  child: Text(
                    district,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Main White Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: List.generate(items.length, (idx) {
                  final item = items[idx];
                  final isLast = idx == items.length - 1;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      if (isPolice)
                                        Image.asset(
                                          'assets/images/tile_tourist_black.png',
                                          height: 18,
                                          width: 18,
                                          fit: BoxFit.contain,
                                        )
                                      else
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 18,
                                          color: Color(0xFF64748B),
                                        ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          item['subtitle'] ?? '',
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1E293B),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Outlined Call Button
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _makeCall(item['phone'] ?? ''),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFF20B08D),
                                    width: 1.2,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.call_outlined,
                                      size: 16,
                                      color: Color(0xFF20B08D),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Call',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF20B08D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isLast)
                        const Divider(
                          color: Color(0xFFF1F5F9),
                          thickness: 1,
                          height: 16,
                        ),
                    ],
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SlantedBadgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const slant = 18.0;
    const radius = 6.0;

    // Start at bottom-left
    path.moveTo(0, size.height);
    // Slant diagonally up-right towards rounded top-left curve
    path.lineTo(slant - 3.6, 4.8);
    // Smooth rounded top-left corner
    path.quadraticBezierTo(slant, 0, slant + 5.0, 0);
    // Straight across top to rounded corner
    path.lineTo(size.width - radius, 0);
    // Rounded top-right corner
    path.arcToPoint(
      Offset(size.width, radius),
      radius: const Radius.circular(radius),
      clockwise: true,
    );
    // Straight down to bottom-right
    path.lineTo(size.width, size.height);
    // Close back along bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
