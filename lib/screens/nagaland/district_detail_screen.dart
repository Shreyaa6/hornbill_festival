import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/nagaland_data.dart';
import '../../widgets/custom_bottom_bar.dart';

class DistrictDetailScreen extends StatefulWidget {
  final DistrictInfo district;
  final VoidCallback? onBack;

  const DistrictDetailScreen({
    super.key,
    required this.district,
    this.onBack,
  });

  @override
  State<DistrictDetailScreen> createState() => _DistrictDetailScreenState();
}

class _DistrictDetailScreenState extends State<DistrictDetailScreen> {
  // Track currently expanded spot (single-expansion accordion)
  int? _expandedSpotIndex;

  void _toggleSpot(int index) {
    setState(() {
      if (_expandedSpotIndex == index) {
        _expandedSpotIndex = null;
      } else {
        _expandedSpotIndex = index;
      }
    });
  }

  Future<void> _openGoogleMaps(TouristSpot spot) async {
    final customUrl = spot.mapUrl?.trim();
    final uri = (customUrl != null && customUrl.startsWith('http'))
        ? Uri.parse(customUrl)
        : Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent('${spot.name}, ${widget.district.name}, Nagaland')}',
          );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch Google Maps for ${spot.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final district = widget.district;
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Banner Image with Back Button
                SizedBox(
                  height: 250 + topInset,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: (district.heroUrl != null && district.heroUrl!.isNotEmpty)
                            ? CachedNetworkImage(
                                imageUrl: district.heroUrl!,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                memCacheWidth: 900,
                                fadeInDuration: const Duration(milliseconds: 120),
                                placeholder: (_, __) => Container(
                                  height: 250 + topInset,
                                  color: const Color(0xFF003848),
                                ),
                                errorWidget: (_, __, ___) => district.heroAsset.isNotEmpty
                                    ? Image.asset(
                                        district.heroAsset,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                        errorBuilder: (_, __, ___) => Container(
                                          height: 250 + topInset,
                                          color: const Color(0xFF003848),
                                        ),
                                      )
                                    : Container(
                                        height: 250 + topInset,
                                        color: const Color(0xFF003848),
                                      ),
                              )
                            : Image.asset(
                                district.heroAsset,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 250 + topInset,
                                  color: const Color(0xFF003848),
                                ),
                              ),
                      ),
                      // Circular Back Button `<` anchored to the Hero Banner
                      Positioned(
                        top: topInset + 12,
                        left: 16,
                        child: GestureDetector(
                          onTap: widget.onBack ??
                              () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              },
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.16),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.chevron_left_rounded,
                              color: Color(0xFF003848),
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Overlapping White Rounded Body Sheet
                Transform.translate(
                  offset: const Offset(0, -28),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    padding:
                        EdgeInsets.fromLTRB(20, 24, 20, 110 + bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // District Title
                        Text(
                          district.displayName,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Thin Divider
                        const Divider(
                          color: Color(0xFFF1F5F9),
                          height: 24,
                          thickness: 1,
                        ),
                        const SizedBox(height: 8),

                        // Section: Details
                        if (district.resolvedDetails.isNotEmpty) ...[
                          const Text(
                            'Details',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Dynamic Details Row from Firestore `details` array
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: district.resolvedDetails
                                .map(
                                  (detail) => Expanded(
                                    child: _buildDetailItem(
                                      iconName: detail.icon,
                                      title: detail.text,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 14),

                          // Thin Divider
                          const Divider(
                            color: Color(0xFFF1F5F9),
                            height: 24,
                            thickness: 1,
                          ),
                          const SizedBox(height: 8),
                        ],

                        // Section: Tourist Spots
                        const Text(
                          'Tourist Spots',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // List of Accordion Spots
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: district.spots.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final spot = district.spots[index];
                            final isExpanded = _expandedSpotIndex == index;

                            return _buildSpotAccordion(
                              index: index + 1,
                              spot: spot,
                              isExpanded: isExpanded,
                              onToggle: () => _toggleSpot(index),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Custom Bottom Navigation Bar
          CustomBottomBar(
            currentIndex: 3, // Nagaland tab active as seen in screenshots
            onTap: (index) {
              if (index != 3) {
                widget.onBack?.call();
              }
            },
          ),
        ],
      ),
    ),
  );
  }

  IconData _resolveDetailIcon(String iconName) {
    switch (iconName.trim().toLowerCase()) {
      case 'distance':
      case 'near_me':
      case 'directions_car':
      case 'car':
        return Icons.near_me_outlined;
      case 'bus':
      case 'transport':
      case 'directions_bus':
        return Icons.directions_bus_outlined;
      case 'flight':
      case 'airport':
        return Icons.flight_outlined;
      case 'train':
        return Icons.train_outlined;
      case 'stay':
      case 'hotel':
      case 'home':
      case 'homestay':
        return Icons.hotel_outlined;
      case 'time':
      case 'timing':
      case 'schedule':
        return Icons.schedule_outlined;
      case 'location':
      case 'map':
      case 'pin':
        return Icons.location_on_outlined;
      default:
        return Icons.info_outline_rounded;
    }
  }

  Widget _buildDetailItem({
    required String iconName,
    required String title,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconName.startsWith('http')
            ? CachedNetworkImage(
                imageUrl: iconName,
                height: 28,
                width: 32,
                fit: BoxFit.contain,
                memCacheWidth: 96,
                errorWidget: (_, __, ___) => const Icon(
                  Icons.info_outline_rounded,
                  size: 28,
                  color: Color(0xFF20B08D),
                ),
              )
            : Icon(
                _resolveDetailIcon(iconName),
                size: 28,
                color: const Color(0xFF20B08D),
              ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            height: 1.25,
          ),
        ),
      ],
    );
  }

  Widget _buildSpotAccordion({
    required int index,
    required TouristSpot spot,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clickable Header Bar
            InkWell(
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Green Number Badge
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFF20B08D),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$index',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Spot Title & Optional Timing Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            spot.name,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF003848),
                            ),
                          ),
                          if (spot.timing != null && spot.timing!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              spot.timing!,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Trailing Chevron Icon (Double Chevron Up when expanded, Double Chevron Down when collapsed)
                    Icon(
                      isExpanded
                          ? Icons.keyboard_double_arrow_up_rounded
                          : Icons.keyboard_double_arrow_down_rounded,
                      color: const Color(0xFF003848),
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),

            // Expanded Body: Photo, Description, and Open in Google Maps Button
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Spot Photo (if available — supports both remote imageUrl & local imageAsset)
                    if ((spot.imageUrl != null && spot.imageUrl!.isNotEmpty) ||
                        (spot.imageAsset != null && spot.imageAsset!.isNotEmpty)) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: (spot.imageUrl != null && spot.imageUrl!.isNotEmpty)
                            ? CachedNetworkImage(
                                imageUrl: spot.imageUrl!,
                                height: 185,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                memCacheWidth: 800,
                                fadeInDuration: const Duration(milliseconds: 120),
                                placeholder: (_, __) => Container(
                                  height: 185,
                                  color: const Color(0xFFF1F5F9),
                                ),
                                errorWidget: (_, __, ___) =>
                                    (spot.imageAsset != null && spot.imageAsset!.isNotEmpty)
                                        ? Image.asset(
                                            spot.imageAsset!,
                                            height: 185,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              height: 185,
                                              color: const Color(0xFFF1F5F9),
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.image_outlined,
                                                size: 32,
                                                color: Color(0xFF94A3B8),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 185,
                                            color: const Color(0xFFF1F5F9),
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.image_outlined,
                                              size: 32,
                                              color: Color(0xFF94A3B8),
                                            ),
                                          ),
                              )
                            : Image.asset(
                                spot.imageAsset!,
                                height: 185,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 185,
                                  color: const Color(0xFFF1F5F9),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.image_outlined,
                                    size: 32,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Spot Description
                    Text(
                      spot.description,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 13.5,
                        height: 1.45,
                        color: Color(0xFF334155),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Open in Google Maps Button
                    GestureDetector(
                      onTap: () => _openGoogleMaps(spot),
                      child: Container(
                        width: double.infinity,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF20B08D),
                            width: 1.2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Open in Google Maps',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF20B08D),
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.north_east_rounded,
                              size: 16,
                              color: Color(0xFF20B08D),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
