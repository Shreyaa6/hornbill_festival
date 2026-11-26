import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/nagaland_data.dart';
import '../../data/tourist_map_destinations.dart';
import '../../services/firebase_service.dart';
import '../../theme/app_theme.dart';

class TouristMapScreen extends StatefulWidget {
  const TouristMapScreen({super.key});

  @override
  State<TouristMapScreen> createState() => _TouristMapScreenState();
}

class _TouristMapScreenState extends State<TouristMapScreen> {
  final MapController _mapController = MapController();
  final ScrollController _cardsScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isSatMode = false;
  String _selectedDistrict = 'All Spots';
  String _searchQuery = '';
  TouristMapDestination? _selectedSpot;

  @override
  void initState() {
    super.initState();
    _selectedSpot = TouristMapData.destinations[0];
  }

  @override
  void dispose() {
    _cardsScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesDistrict(String spotDistrict, String filterDistrict) {
    if (filterDistrict == 'All Spots') return true;
    final s = spotDistrict.toLowerCase().replaceAll('ü', 'u').trim();
    final f = filterDistrict.toLowerCase().replaceAll('ü', 'u').trim();
    return s == f || s.contains(f) || f.contains(s);
  }

  List<TouristMapDestination> _getFilteredSpots(List<TouristMapDestination> allSpots) {
    return allSpots.where((spot) {
      final matchesDistrict = _matchesDistrict(spot.district, _selectedDistrict);
      final q = _searchQuery.toLowerCase().trim();
      final matchesSearch = q.isEmpty ||
          spot.name.toLowerCase().contains(q) ||
          spot.district.toLowerCase().contains(q) ||
          spot.category.toLowerCase().contains(q);

      return matchesDistrict && matchesSearch;
    }).toList();
  }

  int _countForDistrict(String district, List<TouristMapDestination> allSpots) {
    if (district == 'All Spots') {
      return allSpots.length;
    }
    return allSpots.where((s) => _matchesDistrict(s.district, district)).length;
  }

  void _selectSpot(TouristMapDestination spot,
      {bool openModal = false, List<TouristMapDestination>? currentSpots}) {
    setState(() {
      _selectedSpot = spot;
    });

    // Center map smoothly
    _mapController.move(LatLng(spot.lat, spot.lng), 13.0);

    // Scroll horizontal carousel
    final spots = currentSpots ?? TouristMapData.destinations;
    final index = spots.indexWhere((s) => s.id == spot.id);
    if (index != -1 && _cardsScrollController.hasClients) {
      _cardsScrollController.animateTo(
        index * 228.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }

    if (openModal) {
      _showDestinationDetailsSheet(spot);
    }
  }

  void _resetMapCenter() {
    _mapController.move(const LatLng(25.85, 94.15), 9.0);
  }

  Future<void> _openInGoogleMaps(TouristMapDestination spot) async {
    Uri? uri;
    if (spot.mapUrl != null && spot.mapUrl!.trim().isNotEmpty) {
      uri = Uri.tryParse(spot.mapUrl!.trim());
    }
    uri ??= Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${spot.lat},${spot.lng}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareDestination(TouristMapDestination spot) async {
    final mapLink = (spot.mapUrl != null && spot.mapUrl!.trim().isNotEmpty)
        ? spot.mapUrl!.trim()
        : 'https://www.google.com/maps/search/?api=1&query=${spot.lat},${spot.lng}';
    final text =
        '📍 ${spot.name} (${spot.district}, Nagaland)\n\n${spot.description}\n\nGoogle Maps: $mapLink';
    await SharePlus.instance.share(ShareParams(text: text));
  }

  Widget _buildSpotImage(TouristMapDestination spot,
      {double? height, double? width, BoxFit fit = BoxFit.cover}) {
    final hasNetwork =
        spot.imageUrl != null && spot.imageUrl!.trim().startsWith('http');
    if (hasNetwork) {
      return CachedNetworkImage(
        imageUrl: spot.imageUrl!.trim(),
        height: height,
        width: width,
        fit: fit,
        alignment: Alignment.center,
        placeholder: (context, url) => Container(
          height: height,
          width: width,
          color: const Color(0xFFF1F5F9),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF003848),
            ),
          ),
        ),
        errorWidget: (context, url, error) {
          if (spot.imageAsset.isNotEmpty) {
            return Image.asset(
              spot.imageAsset,
              height: height,
              width: width,
              fit: fit,
              alignment: Alignment.center,
              errorBuilder: (_, __, ___) => _buildPlaceholder(height, width),
            );
          }
          return _buildPlaceholder(height, width);
        },
      );
    }
    return Image.asset(
      spot.imageAsset,
      height: height,
      width: width,
      fit: fit,
      alignment: Alignment.center,
      errorBuilder: (_, __, ___) => _buildPlaceholder(height, width),
    );
  }

  Widget _buildPlaceholder(double? height, double? width) {
    return Container(
      height: height,
      width: width,
      color: const Color(0xFFF1F5F9),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        size: 40,
        color: Color(0xFF94A3B8),
      ),
    );
  }

  @visibleForTesting
  void showDestinationDetailsSheet(TouristMapDestination spot) {
    _showDestinationDetailsSheet(spot);
  }

  void _showDestinationDetailsSheet(TouristMapDestination spot) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(ctx),
          child: GestureDetector(
            onTap: () {},
            child: DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.35,
              maxChildSize: 0.75,
              builder: (ctx, scrollController) {
                final modalBottomInset = MediaQuery.of(ctx).padding.bottom > 0
                    ? MediaQuery.of(ctx).padding.bottom
                    : MediaQuery.of(ctx).viewPadding.bottom;
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: scrollController,
                        padding: EdgeInsets.only(bottom: 95 + modalBottomInset),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Full Bleed Top Hero Image
                            SizedBox(
                              height: 220,
                          width: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              _buildSpotImage(spot, fit: BoxFit.cover),
                              // Top Gradient Shadow for Action Controls
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                height: 75,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.35),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Share & Close Buttons
                              Positioned(
                                top: 14,
                                right: 14,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () => _shareDestination(spot),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.15),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.ios_share_rounded,
                                          size: 20,
                                          color: Color(0xFF003848),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => Navigator.pop(ctx),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.15),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.close_rounded,
                                          size: 22,
                                          color: Color(0xFF003848),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Content Area
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tags: Category & District (Wrap prevents horizontal overflow)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFBEB),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      spot.category,
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFD97706),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.location_on_rounded,
                                          size: 13,
                                          color: Color(0xFF64748B),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${spot.district} District',
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF475569),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Destination Title
                              Text(
                                spot.name,
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF003848),
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // 1. ADDRESS Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.pin_drop_rounded,
                                          size: 16,
                                          color: Color(0xFF003848),
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'ADDRESS',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF003848),
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      spot.address,
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF334155),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

                              if (spot.timing != null && spot.timing!.trim().isNotEmpty) ...[
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(
                                            Icons.access_time_rounded,
                                            size: 16,
                                            color: Color(0xFF003848),
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            'TIMINGS',
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF003848),
                                              letterSpacing: 0.6,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        spot.timing!,
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF334155),
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                              ],

                              // 3. ABOUT DESTINATION Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.info_outline_rounded,
                                          size: 16,
                                          color: Color(0xFF003848),
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'ABOUT DESTINATION',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF003848),
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      spot.description,
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF334155),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // 4. Highlight Tags
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: spot.tags.map((tag) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.auto_awesome,
                                          size: 13,
                                          color: Color(0xFF003848),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          tag,
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF334155),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Sticky CTA Button (Open in Google Maps)
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20 + modalBottomInset,
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => _openInGoogleMaps(spot),
                        icon: const Icon(
                          Icons.navigation_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text(
                          'Open in Google Maps',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          shadowColor:
                              const Color(0xFFF59E0B).withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  },
);
}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DistrictInfo>>(
      stream: FirebaseService().getDestinations(),
      builder: (context, snapshot) {
        final rawDistricts = (snapshot.hasData && snapshot.data!.isNotEmpty)
            ? snapshot.data!
            : NagalandData.districts;
        final districtFilters = <String>[
          'All Spots',
          ...rawDistricts
              .map((d) => d.name.trim())
              .where((name) => name.isNotEmpty)
              .toSet(),
        ];
        if (!districtFilters.contains(_selectedDistrict)) {
          _selectedDistrict = 'All Spots';
        }
        final allSpots = TouristMapData.fromDistricts(rawDistricts);
        final spots = _getFilteredSpots(allSpots);

        // Ensure a selected spot is active
        if (_selectedSpot == null || !allSpots.any((s) => s.id == _selectedSpot!.id)) {
          _selectedSpot = spots.isNotEmpty
              ? spots.first
              : (allSpots.isNotEmpty ? allSpots.first : null);
        }

        return Scaffold(
          backgroundColor: const Color(0xFF003848),
          body: SafeArea(
            bottom: AppTheme.needsBottomSafeArea(context),
            child: Column(
              children: [
                // 1. Dark Teal Top Header Row (Title & Map/Sat Toggler)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nagaland Tourist Map',
                              style: AppTextStyles.headerTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${allSpots.length} Iconic Spots • Google Maps',
                              style: AppTextStyles.headerSubtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Map Style Button (Map / Sat) - Solid white, keeping size same
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSatMode = !_isSatMode;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isSatMode
                                    ? Icons.public_rounded
                                    : Icons.map_outlined,
                                size: 15,
                                color: const Color(0xFF003848),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _isSatMode ? 'Sat' : 'Map',
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF003848),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. District Filter Chips
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: districtFilters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (ctx, idx) {
                        final dist = districtFilters[idx];
                        final isSelected = _selectedDistrict == dist;
                        final count = _countForDistrict(dist, allSpots);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDistrict = dist;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$dist ($count)',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w900
                                    : FontWeight.w600,
                                color: isSelected
                                    ? const Color(0xFF003848)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Curved Body Sheet with Map
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(28)),
                      child: RepaintBoundary(
                        child: Stack(
                          children: [
                            FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                initialCenter: const LatLng(25.85, 94.15),
                                initialZoom: 9.0,
                                minZoom: 6.0,
                                maxZoom: 18.0,
                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                                ),
                                onTap: (_, point) {
                                  TouristMapDestination? closest;
                                  double minDist = double.infinity;
                                  for (final s in spots) {
                                    final dLat = (s.lat - point.latitude).abs();
                                    final dLng = (s.lng - point.longitude).abs();
                                    final dist = dLat + dLng;
                                    if (dist < 0.04 && dist < minDist) {
                                      minDist = dist;
                                      closest = s;
                                    }
                                  }
                                  if (closest != null) {
                                    _selectSpot(closest, openModal: true, currentSpots: spots);
                                  }
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: _isSatMode
                                      ? 'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}'
                                      : 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                                  userAgentPackageName: 'hornbill.festival.nagaland',
                                ),
                                MarkerLayer(
                                  markers: spots.map((spot) {
                                    final isSelected = _selectedSpot?.id == spot.id;
                                    return Marker(
                                      point: LatLng(spot.lat, spot.lng),
                                      width: 140,
                                      height: 62,
                                      alignment: Alignment.topCenter,
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () => _selectSpot(spot, openModal: true, currentSpots: spots),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (isSelected)
                                                Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF0284C7),
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.white, width: 3),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(0xFF0284C7)
                                                            .withValues(alpha: 0.5),
                                                        blurRadius: 10,
                                                        spreadRadius: 3,
                                                      ),
                                                    ],
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: const Icon(
                                                    Icons.location_on_rounded,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                )
                                              else
                                                Container(
                                                  width: 26,
                                                  height: 26,
                                                  decoration: BoxDecoration(
                                                    color: spot.pinColor,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.white, width: 2),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withValues(alpha: 0.25),
                                                        blurRadius: 4,
                                                        offset: const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: const Icon(
                                                    Icons.location_on_rounded,
                                                    color: Colors.white,
                                                    size: 15,
                                                  ),
                                                ),
                                              const SizedBox(height: 2),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 7, vertical: 2.5),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? const Color(0xFF003848)
                                                      : const Color(0xFF1E293B)
                                                          .withValues(alpha: 0.9),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(alpha: 0.2),
                                                      blurRadius: 4,
                                                      offset: const Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  spot.name,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 9.5,
                                                    fontWeight: isSelected
                                                        ? FontWeight.w900
                                                        : FontWeight.w700,
                                                    color: isSelected
                                                        ? const Color(0xFF5EEAD4)
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),

                            // Re-center Target Button
                            Positioned(
                              top: 14,
                              right: 14,
                              child: GestureDetector(
                                onTap: _resetMapCenter,
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.my_location_rounded,
                                    size: 20,
                                    color: Color(0xFF003848),
                                  ),
                                ),
                              ),
                            ),

                            // Attribution tag
                            Positioned(
                              right: 8,
                              bottom: 195,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Leaflet | © Google Maps',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ),

                            // Bottom Horizontal Carousel
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 12,
                              height: 175,
                              child: ListView.separated(
                                controller: _cardsScrollController,
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: spots.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (ctx, idx) {
                                  final spot = spots[idx];
                                  final isSelected = _selectedSpot?.id == spot.id;

                                  return GestureDetector(
                                    onTap: () => _selectSpot(spot, openModal: true, currentSpots: spots),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: 216,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFF20B08D)
                                              : const Color(0xFFE2E8F0),
                                          width: isSelected ? 2 : 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: isSelected
                                                ? const Color(0xFF20B08D)
                                                    .withValues(alpha: 0.2)
                                                : Colors.black.withValues(alpha: 0.08),
                                            blurRadius: isSelected ? 12 : 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Image with top border radius
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.vertical(
                                                top: Radius.circular(16),
                                              ),
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  _buildSpotImage(spot, fit: BoxFit.cover),
                                                  // District pill tag on image
                                                  Positioned(
                                                    left: 10,
                                                    bottom: 8,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              horizontal: 8, vertical: 3),
                                                      decoration: BoxDecoration(
                                                        color: spot.pinColor,
                                                        borderRadius:
                                                            BorderRadius.circular(6),
                                                      ),
                                                      child: Text(
                                                        spot.district,
                                                        style: const TextStyle(
                                                          fontFamily: 'Lato',
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w800,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Content
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  spot.name,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 13.5,
                                                    fontWeight: FontWeight.w800,
                                                    color: Color(0xFF0F172A),
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  spot.category,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
}
