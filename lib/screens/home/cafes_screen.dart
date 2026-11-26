import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/cafes_data.dart';
import '../../services/firebase_service.dart';
import '../../widgets/cafe_image.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../../theme/app_theme.dart';
import 'view_cafe_screen.dart';

class CafesScreen extends StatefulWidget {
  const CafesScreen({super.key});

  @override
  State<CafesScreen> createState() => _CafesScreenState();
}

class _CafesScreenState extends State<CafesScreen> {
  String _selectedDistrict = 'Kohima';
  String _selectedCuisine = 'All Cuisines';
  StreamSubscription? _cafesSub;

  final List<String> _districts = [
    'All Districts',
    'Chümoukedima',
    'Dimapur',
    'Kiphire',
    'Kohima',
    'Longleng',
    'Meluri',
    'Mokokchung',
    'Mon',
    'Niuland',
    'Noklak',
    'Peren',
    'Phek',
    'Shamator',
    'Tseminyü',
    'Tuensang',
    'Wokha',
    'Zünheboto',
  ];

  final List<String> _cuisines = [
    'All Cuisines',
    'Chinese / Korean Cuisines',
    'Continental',
    'Fast Food',
    'Naga Cuisines',
    'North Indian',
    'South Indian',
    'Vegetarian',
  ];

  void _showDistrictPicker() async {
    final selected = await showAppFilterBottomSheet(
      context: context,
      title: 'Select District',
      items: _districts,
      selectedItem: _selectedDistrict,
      sortAlphabetically: true,
    );
    if (selected != null && mounted) {
      setState(() {
        _selectedDistrict = selected;
      });
    }
  }

  void _showCuisinePicker() async {
    final selected = await showAppFilterBottomSheet(
      context: context,
      title: 'Select Cuisine',
      items: _cuisines,
      selectedItem: _selectedCuisine,
      sortAlphabetically: true,
    );
    if (selected != null && mounted) {
      setState(() {
        _selectedCuisine = selected;
      });
    }
  }

  final List<Map<String, dynamic>> _sampleCafes = CafesData.allCafes;

  List<Map<String, dynamic>> _firebaseCafes = [];

  @override
  void initState() {
    super.initState();
    _cafesSub = FirebaseService().getCafes().listen((cafes) {
      if (mounted && cafes.isNotEmpty) {
        setState(() {
          _firebaseCafes = cafes;
        });
      }
    }, onError: (e) {
      debugPrint('Error loading cafes from Firebase: $e');
    });
  }

  @override
  void dispose() {
    _cafesSub?.cancel();
    super.dispose();
  }

  bool _matchesDistrict(Map<String, dynamic> cafe, String selected) {
    if (selected.isEmpty || selected == 'All' || selected == 'All Districts') {
      return true;
    }
    final d = (cafe['district'] ?? '')
        .toString()
        .toLowerCase()
        .replaceAll('ü', 'u')
        .replaceAll(RegExp(r'[^a-z]'), '');
    final s = selected
        .toLowerCase()
        .replaceAll('ü', 'u')
        .replaceAll(RegExp(r'[^a-z]'), '');
    return d == s || d.contains(s) || s.contains(d);
  }

  bool _matchesCuisine(Map<String, dynamic> cafe, String selected) {
    if (selected.isEmpty || selected == 'All' || selected == 'All Cuisines') {
      return true;
    }
    final clean = selected.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    if (clean.contains('chinese') || clean.contains('korean')) {
      return cafe['isChinese'] == true;
    }
    if (clean.contains('continental')) {
      return cafe['isContinental'] == true;
    }
    if (clean.contains('fastfood')) {
      return cafe['isFastFood'] == true;
    }
    if (clean.contains('naga')) {
      return cafe['isNagaDishes'] == true;
    }
    if (clean.contains('northindian')) {
      return cafe['isNorthIndian'] == true;
    }
    if (clean.contains('southindian')) {
      return cafe['isSouthIndian'] == true;
    }
    if (clean.contains('veg')) {
      return cafe['isVegetarian'] == true;
    }
    if (cafe['cuisines'] is List) {
      return (cafe['cuisines'] as List).any((c) => c
          .toString()
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z]'), '')
          .contains(clean));
    }
    return false;
  }

  List<Map<String, dynamic>> get _cafesToDisplay {
    final list = _firebaseCafes.isNotEmpty ? _firebaseCafes : _sampleCafes;
    return list.where((cafe) {
      if (cafe['isActive'] != true) return false;
      if (!_matchesDistrict(cafe, _selectedDistrict)) return false;
      if (!_matchesCuisine(cafe, _selectedCuisine)) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;
    const headerColor = Color(0xFF003848);

    return Scaffold(
      backgroundColor: headerColor,
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title: Find Restros
                  const Text(
                    'Find Restros',
                    style: AppTextStyles.headerTitle,
                  ),
                  const SizedBox(height: 3),

                  // Subtitle
                  const Text(
                    'Restaurants • Cafes',
                    style: AppTextStyles.headerSubtitle,
                  ),
                  const SizedBox(height: 18),

                  // Two Dropdown Pills Side-by-Side
                  Row(
                    children: [
                      // District Dropdown
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _showDistrictPicker,
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedDistrict,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black87,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Cuisine Dropdown
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _showCuisinePicker,
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedCuisine,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black87,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // White Curved Body
            Expanded(
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(16, 22, 16, 100 + bottomInset),
                    children: [
                      Text(
                        'Find Restaurants in $_selectedDistrict',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_cafesToDisplay.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/empty.gif',
                                height: 220,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.restaurant_outlined,
                                  size: 64,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _selectedCuisine != 'All Cuisines'
                                    ? 'No $_selectedCuisine found in $_selectedDistrict'
                                    : 'No restaurants found in $_selectedDistrict',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      // Restaurant Cards List
                      ..._cafesToDisplay.map((cafe) {
                        final docId = cafe['docId']?.toString() ?? '';
                        final name = cafe['name'] ?? cafe['cafeName'] ?? '';
                        final location = cafe['location'] ?? cafe['address'] ?? '';
                        final localBanner = cafe['localBanner'] as String? ??
                            (docId.isNotEmpty ? 'assets/images/cafes/${docId}_banner.jpg' : null) ??
                            cafe['photoAsset'] as String?;
                        final photoUrl = cafe['photo'] as String?;

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewCafeScreen(
                                  cafe: cafe,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top Image
                                CafeImage(
                                  photoUrl: photoUrl,
                                  localAsset: localBanner,
                                  height: 155,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),

                                // Bottom Details: Name & Location
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 14,
                                            color: Color(0xFF6B7280),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              location,
                                              style: const TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 12,
                                                color: Color(0xFF6B7280),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
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
                      }),
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
