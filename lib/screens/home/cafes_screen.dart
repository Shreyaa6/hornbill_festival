import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import 'view_cafe_screen.dart';

class CafesScreen extends StatefulWidget {
  const CafesScreen({super.key});

  @override
  State<CafesScreen> createState() => _CafesScreenState();
}

class _CafesScreenState extends State<CafesScreen> {
  String _selectedDistrict = 'Kohima';
  String _selectedCuisine = 'Naga';
  StreamSubscription? _cafesSub;

  final List<String> _districts = [
    'Kohima',
    'Kiphire',
    'Chümoukedima',
    'Dimapur',
    'Longleng',
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
    'Naga Cuisines',
    'Vegetarian',
    'Fast Food',
    'North Indian',
    'South Indian',
    'Chinese / Korean Cuisines',
    'Continental',
  ];

  final Set<String> _favorites = {};

  final List<Map<String, dynamic>> _sampleCafes = [
    {
      'id': 'vivid_lounge',
      'name': 'Vivid Lounge',
      'location': 'Supply Colony P.R Hill,Near B.O.C Junction',
      'district': 'Kohima',
      'phone': '9366308061',
      'photoAsset': 'assets/images/cafe_vivid_lounge.png',
      'cuisines': ['Fast Food', 'Continental', 'Chinese / Korean Cuisines'],
    },
    {
      'id': 'morung_kitchen',
      'name': 'The Morung Kitchen',
      'location': 'Midland, Opp Oking Hospital',
      'district': 'Kohima',
      'phone': '8794123456',
      'photoAsset': 'assets/images/cafe_morung_kitchen.png',
      'cuisines': ['Naga Cuisines', 'North Indian'],
    },
    {
      'id': 'diner_rush',
      'name': 'Diner Rush',
      'location': 'Highschool Junction, Kohima',
      'district': 'Kohima',
      'phone': '8974567890',
      'photoAsset': 'assets/images/cafe_diner_rush.png',
      'cuisines': ['Fast Food', 'Continental'],
    },
    {
      'id': 'oakland_boutique',
      'name': 'Oakland Boutique',
      'location': 'Dr Neilhouzhu Kire Building',
      'district': 'Kohima',
      'phone': '9436123456',
      'photoAsset': 'assets/images/cafe_oakland_boutique.png',
      'cuisines': ['Continental', 'Vegetarian'],
    },
    {
      'id': 'axone_kitchen',
      'name': 'Axone Kitchen',
      'location': 'CY Complex, Opp. Rengma Church , Nagaland',
      'district': 'Kohima',
      'phone': '6009516476',
      'photoAsset': 'assets/images/cafe_axone_banner.png',
      'menuAsset': 'assets/images/cafe_axone_menu.png',
      'cuisines': ['Naga Cuisines', 'Vegetarian Only', 'Fast Food'],
    },
  ];

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

  List<Map<String, dynamic>> get _cafesToDisplay {
    if (_firebaseCafes.isNotEmpty) {
      return _firebaseCafes;
    }
    return _sampleCafes;
  }

  @override
  Widget build(BuildContext context) {
    const headerColor = Color(0xFF003848);

    return Scaffold(
      backgroundColor: headerColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title: Find Restros
                  const Text(
                    'Find Restros',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Subtitle
                  const Text(
                    'Restaurants • Cafes',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Two Dropdown Pills Side-by-Side
                  Row(
                    children: [
                      // District Dropdown
                      Expanded(
                        child: PopupMenuButton<String>(
                          offset: const Offset(0, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          onSelected: (val) {
                            setState(() => _selectedDistrict = val);
                          },
                          itemBuilder: (context) {
                            return _districts.map((d) {
                              return PopupMenuItem(
                                value: d,
                                child: Text(
                                  d,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList();
                          },
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
                        child: PopupMenuButton<String>(
                          offset: const Offset(0, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          onSelected: (val) {
                            setState(() => _selectedCuisine = val);
                          },
                          itemBuilder: (context) {
                            return _cuisines.map((c) {
                              return PopupMenuItem(
                                value: c,
                                child: Text(
                                  c,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList();
                          },
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
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                  children: [
                    // Section Title: "Find Restaurants in Kohima"
                    Text(
                      'Find Restaurants in $_selectedDistrict',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Restaurant Cards List
                    ..._cafesToDisplay.map((cafe) {
                      final id = cafe['id']?.toString() ?? cafe['cafeID'] ?? '';
                      final isFav = _favorites.contains(id);
                      final name = cafe['name'] ?? cafe['cafeName'] ?? '';
                      final location = cafe['location'] ?? cafe['address'] ?? '';
                      final photo = cafe['photoAsset'] as String?;
                      final photoUrl = cafe['photo'] as String?;

                      return Container(
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
                            // Top Image with Heart Icon
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                  child: photo != null
                                      ? Image.asset(
                                          photo,
                                          height: 155,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                                height: 155,
                                                color: Colors.grey.shade200,
                                                child: const Icon(
                                                  Icons.restaurant,
                                                  size: 48,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                        )
                                      : photoUrl != null
                                          ? Image.network(
                                              photoUrl,
                                              height: 155,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Container(
                                                    height: 155,
                                                    color: Colors.grey.shade200,
                                                  ),
                                            )
                                          : Container(
                                              height: 155,
                                              color: Colors.grey.shade200,
                                            ),
                                ),
                                // Heart Icon Button
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isFav) {
                                          _favorites.remove(id);
                                        } else {
                                          _favorites.add(id);
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.85),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 20,
                                        color: isFav
                                            ? const Color(0xFFE11D48)
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Bottom Details: Name, Location & View Button
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Left info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  const SizedBox(width: 12),

                                  // View Button
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ViewCafeScreen(
                                            cafe: cafe,
                                          ),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color(0xFF20B08D),
                                        width: 1.2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 8,
                                      ),
                                      minimumSize: const Size(70, 36),
                                    ),
                                    child: const Text(
                                      'View',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF20B08D),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
