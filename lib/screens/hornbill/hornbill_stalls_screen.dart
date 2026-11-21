import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/landmark.dart';
import '../../data/app_data.dart';

class HornbillStallsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const HornbillStallsScreen({super.key, this.onBack});

  @override
  State<HornbillStallsScreen> createState() => _HornbillStallsScreenState();
}

class _HornbillStallsScreenState extends State<HornbillStallsScreen> {
  String _selectedCategory = "Morungs";

  final List<String> _categories = [
    "Morungs",
    "Attractions",
    "Stalls",
    "ATMs",
  ];

  List<Landmark> get _filteredLandmarks {
    if (_selectedCategory == "Morungs") {
      return AppData.landmarks
          .where((l) => l.category.toLowerCase().contains("morung") || l.title.toLowerCase().contains("morung"))
          .toList();
    } else if (_selectedCategory == "Attractions") {
      return AppData.landmarks
          .where((l) => l.category.toLowerCase().contains("attraction") || l.category.toLowerCase().contains("landmark"))
          .toList();
    } else if (_selectedCategory == "Stalls") {
      return AppData.landmarks
          .where((l) => l.category.toLowerCase().contains("stall") || l.category.toLowerCase().contains("food"))
          .toList();
    } else {
      return AppData.landmarks
          .where((l) => l.category.toLowerCase().contains("atm") || l.category.toLowerCase().contains("finance"))
          .toList();
    }
  }

  Future<void> _navigateToLandmark(Landmark lm) async {
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${lm.latitude},${lm.longitude}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch maps');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;
    final topInset = MediaQuery.of(context).padding.top;
    final items = _filteredLandmarks;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Navy Header Container
          Container(
            color: const Color(0xFF00334E),
            padding: EdgeInsets.fromLTRB(16, topInset + 12, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Back Button & Title
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onBack ??
                          () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Locate Stalls',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 34, top: 2),
                  child: Text(
                    'Landmarks · Restrooms · Heritage',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Category Filter Pills
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = cat == _selectedCategory;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF20B08D) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 2-Column Grid
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      'No items in this category',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.fromLTRB(14, 16, 14, 120 + bottomInset),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildLandmarkCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandmarkCard(Landmark lm) {
    // Check if we have dedicated local image for landmark
    String? localAsset;
    final lower = lm.title.toLowerCase();
    if (lower.contains('angami')) {
      localAsset = 'assets/images/morung_angami.png';
    } else if (lower.contains('chakhesang')) {
      localAsset = 'assets/images/morung_chakhesang.png';
    } else if (lower.contains('chang')) {
      localAsset = 'assets/images/morung_chang.png';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECEFF1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: localAsset != null
                  ? Image.asset(localAsset, fit: BoxFit.cover)
                  : (lm.photo != null && lm.photo!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: lm.photo!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: const Color(0xFFF1F5F9),
                            child: const Center(
                              child: Icon(Icons.image_outlined, color: Color(0xFFCBD5E1), size: 36),
                            ),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: const Color(0xFFF1F5F9),
                            child: const Center(
                              child: Icon(Icons.image_outlined, color: Color(0xFFCBD5E1), size: 36),
                            ),
                          ),
                        )
                      : Container(
                          color: const Color(0xFFF1F5F9),
                          child: const Center(
                            child: Icon(Icons.image_outlined, color: Color(0xFFCBD5E1), size: 36),
                          ),
                        )),
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lm.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: Color(0xFF20B08D),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        '${lm.distanceKm.toStringAsFixed(1)}km away',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF20B08D),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Navigate to button
                SizedBox(
                  width: double.infinity,
                  height: 34,
                  child: ElevatedButton(
                    onPressed: () => _navigateToLandmark(lm),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF20B08D),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.navigation_outlined, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Navigate to',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
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
    );
  }
}
