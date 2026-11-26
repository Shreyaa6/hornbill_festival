import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'trip_planners_screen.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<Map<String, dynamic>> _trips = [
    {
      "id": "1",
      "title": "Dzukou Valley Tour",
      "subtitle": "Camping • Trekking • Bonfire",
      "image": "assets/images/trip_dzukou.png",
      "plannerSubtitle": "Dzukou Valley Tours",
    },
    {
      "id": "2",
      "title": "Nagaland Tour",
      "subtitle": "Sightseeing • Off-Roading",
      "image": "assets/images/trip_nagaland.png",
      "plannerSubtitle": "Nagaland Tours",
    },
    {
      "id": "3",
      "title": "Northeast Tours",
      "subtitle": "Camping • Trekking",
      "image": "assets/images/trip_northeast.png",
      "plannerSubtitle": "Northeast Tours",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _trips.where((t) {
      if (_searchQuery.isEmpty) return true;
      return t["title"].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t["subtitle"].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF003848),
      body: SafeArea(
        bottom: AppTheme.needsBottomSafeArea(context),
        child: Column(
          children: [
            // Deep Teal Top Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore Tours',
                        style: AppTextStyles.headerTitle,
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Camping • Trekking • Tours',
                        style: AppTextStyles.headerSubtitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search Bar Pill
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val.trim();
                              });
                            },
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 15,
                              color: Color(0xFF1E293B),
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 15,
                                color: Color(0xFF94A3B8),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // White Rounded Body Sheet
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 22, 16, 120),
                    children: [
                      // Section Title
                      Row(
                        children: const [
                          Icon(Icons.local_fire_department_rounded, color: Color(0xFF1E293B), size: 24),
                          SizedBox(width: 6),
                          Text(
                            'Popular Destinations',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Trips Cards
                      ...filtered.map((trip) => _buildTripCard(trip)),
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

  Widget _buildTripCard(Map<String, dynamic> trip) {
    return Container(
      height: 185,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TripPlannersScreen(
                  tourTitle: trip["plannerSubtitle"] ?? trip["title"],
                ),
              ),
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.asset(
                trip["image"],
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              // Multi-stop gradient overlay matching Explore Nagaland
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 90,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.35),
                        Colors.black.withValues(alpha: 0.88),
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),
              ),
              // Tour Info matching Explore Nagaland
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      trip["title"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            trip["subtitle"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.white70,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
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
