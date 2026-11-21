import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/custom_bottom_bar.dart';

class TouristSpot {
  final String id;
  final String name;
  final String district;
  final String category;
  final String subtitle;
  final String image;
  final double xRatio; // Relative X on map (0.0 - 1.0)
  final double yRatio; // Relative Y on map (0.0 - 1.0)
  final Color pinColor;
  final double lat;
  final double lng;
  final String description;

  const TouristSpot({
    required this.id,
    required this.name,
    required this.district,
    required this.category,
    required this.subtitle,
    required this.image,
    required this.xRatio,
    required this.yRatio,
    required this.pinColor,
    required this.lat,
    required this.lng,
    required this.description,
  });
}

class TouristMapScreen extends StatefulWidget {
  const TouristMapScreen({super.key});

  @override
  State<TouristMapScreen> createState() => _TouristMapScreenState();
}

class _TouristMapScreenState extends State<TouristMapScreen> {
  bool _isGoogleMode = false; // Live mode by default as in screenshots 3-7
  bool _isSatMode = false;
  final bool _showSetupBanner = true;
  String _selectedCategory = 'All Places';
  String _searchQuery = '';
  TouristSpot? _selectedSpot;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _cardsScrollController = ScrollController();
  final TransformationController _mapTransformController =
      TransformationController();

  final List<String> _categories = [
    'All Places',
    'Heritage & History',
    'Nature & Treks',
    'Peaks',
    'Culture & Villages',
    'Viewpoints',
  ];

  final List<TouristSpot> _allSpots = const [
    TouristSpot(
      id: 'cemetery',
      name: 'Kohima War Cemetery',
      district: 'Kohima',
      category: 'Heritage & History',
      subtitle: 'Kohima • Heritage & History',
      image: 'assets/images/tourist_map/thumb_cemetery.png',
      xRatio: 0.35,
      yRatio: 0.74,
      pinColor: Color(0xFFE11D48),
      lat: 25.6669,
      lng: 94.1037,
      description:
          'Memorial dedicated to soldiers of the 2nd British Division who died in the battle of Kohima in 1944.',
    ),
    TouristSpot(
      id: 'kachari',
      name: 'Kachari Ruins',
      district: 'Dimapur',
      category: 'Heritage & History',
      subtitle: 'Dimapur • Heritage & History',
      image: 'assets/images/tourist_map/card_kachari.png',
      xRatio: 0.16,
      yRatio: 0.69,
      pinColor: Color(0xFF8B5CF6),
      lat: 25.9080,
      lng: 93.7290,
      description:
          'Ancient medieval monolithic sandstone pillars constructed by the Dimasa Kachari Kingdom in the 10th century.',
    ),
    TouristSpot(
      id: 'dzukou',
      name: 'Dzukou Valley',
      district: 'Kohima',
      category: 'Nature & Treks',
      subtitle: 'Kohima • Nature & Treks',
      image: 'assets/images/tourist_map/thumb_dzukou.png',
      xRatio: 0.32,
      yRatio: 0.82,
      pinColor: Color(0xFF0D9488),
      lat: 25.5539,
      lng: 94.0753,
      description:
          'Famous valley of flowers bordering Nagaland and Manipur, revered for scenic rolling bamboo hillocks and trekking.',
    ),
    TouristSpot(
      id: 'saramati',
      name: 'Mount Saramati',
      district: 'Kiphire',
      category: 'Peaks',
      subtitle: 'Kiphire • Mountain Peaks',
      image: 'assets/images/tourist_map/thumb_saramati.png',
      xRatio: 0.82,
      yRatio: 0.52,
      pinColor: Color(0xFFF97316),
      lat: 25.7424,
      lng: 95.0312,
      description:
          'The highest mountain peak in Nagaland (3,841 m), rising above the surrounding mountains near Thanamir.',
    ),
    TouristSpot(
      id: 'doyang',
      name: 'Doyang Reservoir & Pangti',
      district: 'Wokha',
      category: 'Nature & Treks',
      subtitle: 'Wokha • Nature & Treks',
      image: 'assets/images/tourist_map/thumb_doyang.png',
      xRatio: 0.44,
      yRatio: 0.46,
      pinColor: Color(0xFF4F46E5),
      lat: 26.1524,
      lng: 94.2794,
      description:
          'Massive scenic reservoir and world-famous stopover for hundreds of thousands of migratory Amur Falcons.',
    ),
    TouristSpot(
      id: 'kisama',
      name: 'Naga Heritage Village, Kisama',
      district: 'Kohima',
      category: 'Culture & Villages',
      subtitle: 'Kohima • Culture & Festival',
      image: 'assets/images/tourist_map/thumb_kisama.png',
      xRatio: 0.38,
      yRatio: 0.77,
      pinColor: Color(0xFFD97706),
      lat: 25.6186,
      lng: 94.1167,
      description:
          'The official venue of the annual Hornbill Festival, featuring morungs of all recognized Naga tribes.',
    ),
    TouristSpot(
      id: 'khonoma',
      name: 'Khonoma Green Village',
      district: 'Kohima',
      category: 'Culture & Villages',
      subtitle: 'Kohima • Eco Village',
      image: 'assets/images/trip_nagaland.png',
      xRatio: 0.30,
      yRatio: 0.73,
      pinColor: Color(0xFF059669),
      lat: 25.6514,
      lng: 94.0194,
      description:
          "Asia's first green village, known for community wildlife conservation, alder-based jhum farming, and brave warriors.",
    ),
    TouristSpot(
      id: 'touphema',
      name: 'Touphema Tourist Village',
      district: 'Kohima',
      category: 'Culture & Villages',
      subtitle: 'Kohima • Cultural Village',
      image: 'assets/images/morung_angami.png',
      xRatio: 0.41,
      yRatio: 0.62,
      pinColor: Color(0xFF0891B2),
      lat: 25.8500,
      lng: 94.1500,
      description:
          'Community-run tourist village showcasing traditional Angami dwellings, local delicacies, and cultural heritage.',
    ),
    TouristSpot(
      id: 'triple_falls',
      name: 'Triple Falls',
      district: 'Dimapur',
      category: 'Nature & Treks',
      subtitle: 'Dimapur • Nature & Treks',
      image: 'assets/images/spot_zoological_park.png',
      xRatio: 0.20,
      yRatio: 0.63,
      pinColor: Color(0xFF7C3AED),
      lat: 25.8200,
      lng: 93.7700,
      description:
          'Three-tier cascading waterfall nestled inside Seithekima village, offering serene pools and trekking trails.',
    ),
    TouristSpot(
      id: 'shilloi',
      name: 'Shilloi Lake',
      district: 'Phek',
      category: 'Nature & Treks',
      subtitle: 'Phek • Scenic Lakes',
      image: 'assets/images/trip_northeast.png',
      xRatio: 0.68,
      yRatio: 0.66,
      pinColor: Color(0xFF0284C7),
      lat: 25.6980,
      lng: 94.7830,
      description:
          'Footprint-shaped natural lake revered by the Pochury tribe, shrouded in legends and serene alpine forests.',
    ),
    TouristSpot(
      id: 'mokokchung',
      name: 'Mokokchung Town & Longkhum',
      district: 'Mokokchung',
      category: 'Culture & Villages',
      subtitle: 'Mokokchung • Culture & Villages',
      image: 'assets/images/district_thumb_wokha.png',
      xRatio: 0.52,
      yRatio: 0.34,
      pinColor: Color(0xFF16A34A),
      lat: 26.3262,
      lng: 94.5218,
      description:
          'The cultural center of the Ao Nagas, with Longkhum eagle nest viewpoints and historical rhododendron hills.',
    ),
    TouristSpot(
      id: 'longwa',
      name: 'Mon & Longwa Village',
      district: 'Mon',
      category: 'Heritage & History',
      subtitle: 'Mon • Heritage & Culture',
      image: 'assets/images/morung_ao.png',
      xRatio: 0.74,
      yRatio: 0.22,
      pinColor: Color(0xFFBE123C),
      lat: 26.7441,
      lng: 95.0805,
      description:
          'Unique cross-border village straddling the India-Myanmar international boundary ruled by the hereditary Angh.',
    ),
    TouristSpot(
      id: 'benreu',
      name: 'Benreu Village & Mt Pauna',
      district: 'Peren',
      category: 'Peaks',
      subtitle: 'Peren • Eco Tourism & Peaks',
      image: 'assets/images/chumoukedima_hero.png',
      xRatio: 0.24,
      yRatio: 0.79,
      pinColor: Color(0xFFCA8A04),
      lat: 25.5300,
      lng: 93.8500,
      description:
          'Perched at 1,950 m on Mount Pauna, home to the Zeliang tribe and sanctuary for rare Blyth’s Tragopan.',
    ),
    TouristSpot(
      id: 'tiyi',
      name: 'Mount Tiyi Ridge',
      district: 'Wokha',
      category: 'Viewpoints',
      subtitle: 'Wokha • Viewpoints',
      image: 'assets/images/wokha_hero.png',
      xRatio: 0.46,
      yRatio: 0.49,
      pinColor: Color(0xFF0F766E),
      lat: 26.1000,
      lng: 94.2600,
      description:
          'Legendary mountain ridge of the Lothas offering 360-degree vistas across Assam plains and Doyang valley.',
    ),
    TouristSpot(
      id: 'japfu',
      name: 'Japfu Peak',
      district: 'Kohima',
      category: 'Peaks',
      subtitle: 'Kohima • Mountain Peaks',
      image: 'assets/images/spot_totsu_cliff.png',
      xRatio: 0.36,
      yRatio: 0.79,
      pinColor: Color(0xFFEA580C),
      lat: 25.5800,
      lng: 94.0900,
      description:
          'Second highest peak in Nagaland (3,048 m) home to the world record Guinness tallest Rhododendron tree.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedSpot = _allSpots[0];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cardsScrollController.dispose();
    _mapTransformController.dispose();
    super.dispose();
  }

  List<TouristSpot> get _filteredSpots {
    return _allSpots.where((spot) {
      final matchesCategory = _selectedCategory == 'All Places' ||
          spot.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          spot.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          spot.district.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _onSpotSelected(TouristSpot spot) {
    setState(() {
      _selectedSpot = spot;
    });

    // Scroll to matching card in horizontal carousel
    final index = _filteredSpots.indexWhere((s) => s.id == spot.id);
    if (index != -1 && _cardsScrollController.hasClients) {
      _cardsScrollController.animateTo(
        index * 240.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _resetMapTransform() {
    _mapTransformController.value = Matrix4.identity();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Centered on Nagaland'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _openExternalMap(TouristSpot spot) async {
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${spot.lat},${spot.lng}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showGoogleMapsSetupDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Key icon, Title, Subtitle, Close
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE6F9F5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.vpn_key_rounded,
                        color: Color(0xFF20B08D),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Google Maps API Setup',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF003848),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Google Cloud Package Whitelist',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12.5,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Blue Info Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBAE6FD)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.info_rounded,
                        color: Color(0xFF0284C7),
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Key AIzaSyD_...CJDk is configured. If native Google Maps displays a blank area, Google Cloud Console has an Android restriction allowing only app.joldipabo.nagaland.',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 12,
                            height: 1.4,
                            color: Color(0xFF0369A1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Whitelist Hornbill in Google Cloud Console:',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),

                // Field 1: Package Name
                const Text(
                  '1. Package Name (Application ID):',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'hornbill.festival.nagaland',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(const ClipboardData(
                              text: 'hornbill.festival.nagaland'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied Package Name!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.copy_rounded,
                          size: 18,
                          color: Color(0xFF20B08D),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Field 2: SHA-1
                const Text(
                  '2. SHA-1 Certificate Fingerprint:',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          '5E:8F:16:06:2E:A3:CD:2C:4A:0D:54:78:76:BA:A6:F3:8C:AB:F6:25',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(const ClipboardData(
                              text:
                                  '5E:8F:16:06:2E:A3:CD:2C:4A:0D:54:78:76:BA:A6:F3:8C:AB:F6:25'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied SHA-1 Fingerprint!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.copy_rounded,
                          size: 18,
                          color: Color(0xFF20B08D),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Steps
                const Text(
                  'Quick Steps:',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '1. Go to console.cloud.google.com → APIs & Services → Credentials\n'
                  '2. Select API Key (AIzaSyD_...)\n'
                  '3. Under Application restrictions → Android apps, click "+ Add an item"\n'
                  '4. Enter package name and SHA-1 above, then click Save.',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 11.5,
                    height: 1.5,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 20),

                // Switch to Live Interactive Map Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isGoogleMode = false;
                      });
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      'Switch to Live Interactive Map',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF20B08D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // 1. Top Header Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: Color(0xFF003848),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Title & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Nagaland Tourist Map',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF003848),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Explore 15 Iconic Destinations',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11.5,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Trailing Buttons Row
                      // Mode Button (Google / Live)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isGoogleMode = !_isGoogleMode;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: _isGoogleMode
                                ? const Color(0xFF003848)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _isGoogleMode
                                  ? const Text(
                                      'G',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.language_rounded,
                                      size: 14,
                                      color: Color(0xFF003848),
                                    ),
                              const SizedBox(width: 4),
                              Text(
                                _isGoogleMode ? 'Google' : 'Live',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: _isGoogleMode
                                      ? Colors.white
                                      : const Color(0xFF003848),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Map Style Button (Map / Sat)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSatMode = !_isSatMode;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isSatMode
                                    ? Icons.public_rounded
                                    : Icons.map_outlined,
                                size: 14,
                                color: const Color(0xFF003848),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isSatMode ? 'Sat' : 'Map',
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF003848),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Key Setup Button
                      GestureDetector(
                        onTap: _showGoogleMapsSetupDialog,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.vpn_key_outlined,
                            size: 16,
                            color: Color(0xFF003848),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Search Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 13,
                              color: Color(0xFF1E293B),
                            ),
                            decoration: const InputDecoration(
                              hintText:
                                  'Search destination, district (e.g. Kohima, Dzukou)...',
                              hintStyle: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // 3. Category Filter Chips
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 7),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (ctx, idx) {
                      final cat = _categories[idx];
                      final isSelected = _selectedCategory == cat;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF20B08D)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? null
                                : Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 4. Alert Banner (when in Google mode or notice visible)
                if (_isGoogleMode && _showSetupBanner)
                  GestureDetector(
                    onTap: _showGoogleMapsSetupDialog,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE6F9F5),
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: Color(0xFFB9F1E6),
                            width: 0.8,
                          ),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: Color(0xFF0D9488),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Google Maps active (Key AIzaSyD...). Tap for setup instructio...',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F766E),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: Color(0xFF0D9488),
                          ),
                        ],
                      ),
                    ),
                  ),

                // 5. Map Canvas Area
                Expanded(
                  child: Stack(
                    children: [
                      // Interactive Canvas
                      InteractiveViewer(
                        transformationController: _mapTransformController,
                        minScale: 0.7,
                        maxScale: 3.5,
                        boundaryMargin: const EdgeInsets.all(80),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final mapWidth = constraints.maxWidth;
                            final mapHeight = constraints.maxHeight;

                            return Container(
                              width: mapWidth,
                              height: mapHeight,
                              color: _isGoogleMode
                                  ? const Color(0xFF121212)
                                  : Colors.white,
                              child: Stack(
                                children: [
                                  // Map Background
                                  if (!_isGoogleMode)
                                    Positioned.fill(
                                      child: Image.asset(
                                        _isSatMode
                                            ? 'assets/images/tourist_map/nagaland_map_sat.jpg'
                                            : 'assets/images/tourist_map/nagaland_map_terrain.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  else if (_isSatMode)
                                    Positioned.fill(
                                      child: Image.asset(
                                        'assets/images/tourist_map/nagaland_map_sat.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                  // Place Markers on Map Canvas
                                  ..._filteredSpots.map((spot) {
                                    final posX = spot.xRatio * mapWidth;
                                    final posY = spot.yRatio * mapHeight;
                                    final isSpotSelected =
                                        _selectedSpot?.id == spot.id;

                                    return Positioned(
                                      left: posX - 28,
                                      top: posY - 48,
                                      child: GestureDetector(
                                        onTap: () => _onSpotSelected(spot),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Marker Pin Pinhead
                                            AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              padding: EdgeInsets.all(
                                                  isSpotSelected ? 5 : 4),
                                              decoration: BoxDecoration(
                                                color: spot.pinColor,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: isSpotSelected ? 3 : 2,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: isSpotSelected
                                                        ? spot.pinColor
                                                            .withValues(
                                                                alpha: 0.6)
                                                        : Colors.black38,
                                                    blurRadius: isSpotSelected
                                                        ? 10
                                                        : 4,
                                                    spreadRadius: isSpotSelected
                                                        ? 2
                                                        : 0,
                                                  ),
                                                ],
                                              ),
                                              child: Container(
                                                width: isSpotSelected ? 18 : 14,
                                                height:
                                                    isSpotSelected ? 18 : 14,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color: spot.pinColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Pin pointer tail
                                            ClipPath(
                                              clipper: _PinTailClipper(),
                                              child: Container(
                                                width: 8,
                                                height: 6,
                                                color: spot.pinColor,
                                              ),
                                            ),
                                            const SizedBox(height: 2),

                                            // Place / District Label Tag
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: isSpotSelected
                                                    ? spot.pinColor
                                                    : Colors.white
                                                        .withValues(alpha: 0.9),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 3,
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                spot.name.length > 14
                                                    ? spot.district
                                                    : spot.name,
                                                style: TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w800,
                                                  color: isSpotSelected
                                                      ? Colors.white
                                                      : const Color(0xFF1E293B),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Floating Locate / Center Button
                      Positioned(
                        top: 16,
                        right: 16,
                        child: GestureDetector(
                          onTap: _resetMapTransform,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.my_location_rounded,
                              color: Color(0xFF1E293B),
                              size: 22,
                            ),
                          ),
                        ),
                      ),

                      // 6. Bottom Horizontal Carousel of Destination Cards
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 96, // Floating directly above the bottom nav bar
                        child: SizedBox(
                          height: 185,
                          child: ListView.separated(
                            controller: _cardsScrollController,
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredSpots.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 14),
                            itemBuilder: (ctx, idx) {
                              final spot = _filteredSpots[idx];
                              final isSelected = _selectedSpot?.id == spot.id;

                              return GestureDetector(
                                onTap: () => _onSpotSelected(spot),
                                child: Container(
                                  width: 232,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: isSelected
                                        ? Border.all(
                                            color: const Color(0xFF20B08D),
                                            width: 2.2,
                                          )
                                        : Border.all(
                                            color: const Color(0xFFF1F5F9),
                                            width: 1,
                                          ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.12),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Image
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(18),
                                        ),
                                        child: Image.asset(
                                          spot.image,
                                          height: 108,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                            height: 108,
                                            color: const Color(0xFFF1F5F9),
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.image_outlined,
                                              color: Color(0xFF94A3B8),
                                              size: 32,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Details
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                spot.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color(0xFF0F172A),
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      spot.subtitle,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontSize: 11,
                                                        color:
                                                            Color(0xFF64748B),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        _openExternalMap(spot),
                                                    child: const Icon(
                                                      Icons.near_me_outlined,
                                                      size: 16,
                                                      color: Color(0xFF20B08D),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // 7. Floating Custom Bottom Navigation Bar
            CustomBottomBar(
              currentIndex: 3, // Nagaland tab active as seen in screenshots
              onTap: (index) {
                if (index == 0) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PinTailClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
