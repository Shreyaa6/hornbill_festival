import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';
import '../../models/landmark.dart';
import '../../models/stall.dart';
import '../../data/landmarks_data.dart';
import '../../data/stalls_data.dart';
import '../../services/firebase_service.dart';
import '../../theme/app_theme.dart';

class HornbillStallsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final String? initialCategory;

  const HornbillStallsScreen({super.key, this.onBack, this.initialCategory});

  @override
  State<HornbillStallsScreen> createState() => _HornbillStallsScreenState();
}

class _HornbillStallsScreenState extends State<HornbillStallsScreen> {
  late String _selectedCategory;
  bool _locationPermissionGranted = false;
  LatLng? _userLocation;
  final Distance _distanceCalc = const Distance();

  // Kisama Heritage Village main festival center coordinates
  static const LatLng _kisamaCenter = LatLng(25.6160, 94.1145);

  static const String _prefPermissionKey = 'hornbill_location_permission_granted';
  static const String _prefUserLatKey = 'hornbill_last_user_lat';
  static const String _prefUserLngKey = 'hornbill_last_user_lng';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? "Attractions";
    _requestNativeLocationPermission();
  }

  Future<void> _requestNativeLocationPermission() async {
    // 1. Check local preference cache for instant offline startup
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefGranted = prefs.getBool(_prefPermissionKey) ?? false;
      final cachedLat = prefs.getDouble(_prefUserLatKey);
      final cachedLng = prefs.getDouble(_prefUserLngKey);

      if (prefGranted && mounted) {
        setState(() {
          _locationPermissionGranted = true;
          if (cachedLat != null && cachedLng != null) {
            _userLocation = LatLng(cachedLat, cachedLng);
          } else {
            _userLocation = _kisamaCenter;
          }
        });
      }
    } catch (_) {}

    // 2. Request native system location permission directly
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      final isGranted = permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefPermissionKey, isGranted);

      if (!isGranted) {
        // If denied, leave it and ensure distances are not shown
        if (mounted) {
          setState(() {
            _locationPermissionGranted = false;
            _userLocation = null;
          });
        }
        return;
      }

      // Permission is granted
      if (mounted) {
        setState(() {
          _locationPermissionGranted = true;
        });
      }

      // 3. Immediately try last known position (fast, works offline without GPS lock delay)
      try {
        final lastPos = await Geolocator.getLastKnownPosition();
        if (lastPos != null && mounted) {
          final loc = LatLng(lastPos.latitude, lastPos.longitude);
          setState(() {
            _userLocation = loc;
          });
          await prefs.setDouble(_prefUserLatKey, loc.latitude);
          await prefs.setDouble(_prefUserLngKey, loc.longitude);
        }
      } catch (_) {}

      // 4. Fetch fresh current position and cache it
      try {
        final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
        if (isServiceEnabled) {
          final pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: Duration(seconds: 4),
            ),
          );
          if (mounted) {
            final loc = LatLng(pos.latitude, pos.longitude);
            setState(() {
              _userLocation = loc;
            });
            await prefs.setDouble(_prefUserLatKey, loc.latitude);
            await prefs.setDouble(_prefUserLngKey, loc.longitude);
          }
        }
      } catch (_) {}

      // 5. If userLocation still null, fallback to cached coordinates or Kisama center
      if (_userLocation == null && mounted) {
        final cachedLat = prefs.getDouble(_prefUserLatKey);
        final cachedLng = prefs.getDouble(_prefUserLngKey);
        setState(() {
          _userLocation = (cachedLat != null && cachedLng != null)
              ? LatLng(cachedLat, cachedLng)
              : _kisamaCenter;
        });
      }
    } catch (e) {
      debugPrint('Native location check: $e');
    }
  }

  String _formatDistance(double lat, double lng) {
    if (!_locationPermissionGranted || (lat == 0.0 && lng == 0.0)) {
      return '';
    }
    final loc = _userLocation ?? _kisamaCenter;
    final meters = _distanceCalc.as(LengthUnit.Meter, loc, LatLng(lat, lng));
    if (meters < 1000) {
      return '${meters.round()}m away';
    } else {
      final km = meters / 1000;
      return '${km.toStringAsFixed(1)}km away';
    }
  }

  @override
  void didUpdateWidget(HornbillStallsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != null &&
        widget.initialCategory != oldWidget.initialCategory) {
      _selectedCategory = widget.initialCategory!;
    }
  }

  final List<String> _categories = [
    "Attractions",
    "Stalls",
    "ATMs",
    "Landmarks",
    "Restrooms",
    "Morungs",
    "Medical",
  ];

  List<Landmark> _filterAndSort(List<Landmark> all) {
    List<Landmark> list;
    final catLower = _selectedCategory.toLowerCase();

    if (catLower == "morungs") {
      list = all
          .where((l) =>
              l.category.toLowerCase().contains("morung") ||
              l.title.toLowerCase().contains("morung"))
          .toList();
    } else if (catLower == "attractions") {
      list = all
          .where((l) =>
              l.category.toLowerCase().contains("attraction"))
          .toList();
    } else if (catLower == "stalls") {
      list = all
          .where((l) =>
              l.category.toLowerCase().contains("stall") ||
              l.category.toLowerCase().contains("food") ||
              l.title.toLowerCase().contains("stall") ||
              l.title.toLowerCase().contains("cafe") ||
              l.title.toLowerCase().contains("lounge"))
          .toList();
    } else if (catLower == "atms") {
      list = all
          .where((l) =>
              l.category.toLowerCase().contains("atm") ||
              l.category.toLowerCase().contains("finance") ||
              l.title.toLowerCase().contains("atm"))
          .toList();
    } else if (catLower == "restrooms") {
      list = all
          .where((l) =>
              l.category.toLowerCase().contains("restroom") ||
              l.title.toLowerCase().contains("toilet") ||
              l.title.toLowerCase().contains("urinal"))
          .toList();
    } else if (catLower == "medical") {
      list = all
          .where((l) =>
              l.category.toLowerCase().contains("medical") ||
              l.title.toLowerCase().contains("first aid") ||
              l.title.toLowerCase().contains("health") ||
              l.title.toLowerCase().contains("hospital"))
          .toList();
    } else {
      // "Landmarks"
      list = all
          .where((l) =>
              l.category.toLowerCase().contains("landmark") ||
              l.category.toLowerCase().contains("attraction"))
          .toList();
    }

    // When location permission is granted, sort by proximity; otherwise sort alphabetically
    if (_locationPermissionGranted) {
      list.sort((a, b) {
        if (!a.hasLocation && !b.hasLocation) {
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        }
        if (!a.hasLocation) return 1;
        if (!b.hasLocation) return -1;
        final distA = _distanceCalc.as(
            LengthUnit.Meter, _userLocation ?? _kisamaCenter, LatLng(a.latitude, a.longitude));
        final distB = _distanceCalc.as(
            LengthUnit.Meter, _userLocation ?? _kisamaCenter, LatLng(b.latitude, b.longitude));
        return distA.compareTo(distB);
      });
    } else {
      list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    }
    return list;
  }

  String _getCategoryHeaderTitle() {
    switch (_selectedCategory) {
      case "Attractions":
        return "Popular Attractions";
      case "Morungs":
        return "Heritage Morungs";
      case "Stalls":
        return "Festival Stalls";
      case "ATMs":
        return "Nearby ATMs";
      case "Restrooms":
        return "Restroom Facilities";
      case "Medical":
        return "Medical & First Aid";
      case "Landmarks":
      default:
        return "Heritage Landmarks";
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
    final canGoBack = widget.onBack != null || Navigator.canPop(context);

    return Scaffold(
      backgroundColor: const Color(0xFF003848),
      body: Column(
        children: [
          // Deep Teal/Navy Header Container
          Container(
            color: const Color(0xFF003848),
            padding: EdgeInsets.fromLTRB(0, topInset + 12, 0, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Locate Stalls',
                        style: AppTextStyles.headerTitle,
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Landmarks • Restrooms • Heritage',
                        style: AppTextStyles.headerSubtitle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Category Filter Pills (Horizontal Scroll - full edge-to-edge, uncropped)
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    clipBehavior: Clip.none,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF20B08D)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1E293B),
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

          // White Rounded Content Sheet
          Expanded(
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pinned Header inside Curved Sheet - protects top curve from scroll clipping
                    Container(
                      width: double.infinity,
                      color: const Color(0xFFF8FAFC),
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                      child: Text(
                        _getCategoryHeaderTitle(),
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _selectedCategory == "Stalls"
                          ? _buildStallsView(bottomInset)
                          : _selectedCategory == "ATMs"
                              ? _buildAtmsView(bottomInset)
                              : _selectedCategory == "Restrooms"
                                  ? _buildRestroomsView(bottomInset)
                                  : _selectedCategory == "Medical"
                                      ? _buildMedicalView(bottomInset)
                                      : _buildGridView(bottomInset),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(double bottomInset) {
    return StreamBuilder<List<Landmark>>(
      stream: FirebaseService().getLandmarksStream(),
      initialData: LandmarksData.allLandmarks,
      builder: (context, snapshot) {
        final allItems = snapshot.data ?? LandmarksData.allLandmarks;
        final items = _filterAndSort(allItems);

        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_off_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No landmarks in "$_selectedCategory"',
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
          );
        }

        return GridView.builder(
          padding: EdgeInsets.fromLTRB(16, 6, 16, 110 + bottomInset),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.76,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _buildLandmarkCard(items[index]);
          },
        );
      },
    );
  }

  Widget _buildAtmsView(double bottomInset) {
    return StreamBuilder<List<Landmark>>(
      stream: FirebaseService().getLandmarksStream(),
      initialData: LandmarksData.allLandmarks,
      builder: (context, snapshot) {
        final allItems = snapshot.data ?? LandmarksData.allLandmarks;
        final items = _filterAndSort(allItems);

        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.atm_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No ATMs found',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(16, 6, 16, 110 + bottomInset),
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF1F5F9),
          ),
          itemBuilder: (context, index) {
            final lm = items[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  // Mint green rounded square with number index
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2F5EC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF00796B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // ATM Title and Distance away (ONLY if location exists)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lm.title,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        if (lm.hasLocation) ...[
                          Builder(
                            builder: (context) {
                              final dist = _formatDistance(lm.latitude, lm.longitude);
                              final locLabel = dist.isNotEmpty
                                  ? dist
                                  : (lm.address != null && lm.address!.isNotEmpty
                                      ? lm.address!
                                      : '');
                              if (locLabel.isEmpty) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 15,
                                      color: Color(0xFF20B08D),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      locLabel,
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF20B08D),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Phone Button - ONLY if phone exists
                  if (lm.hasPhone) ...[
                    GestureDetector(
                      onTap: () => _makeCall(lm.phone!),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF20B08D),
                            width: 1.2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.phone_outlined,
                          color: Color(0xFF20B08D),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  // Circular Navigation Button - ONLY if location exists
                  if (lm.hasLocation)
                    GestureDetector(
                      onTap: () => _navigateToLandmark(lm),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF20B08D).withValues(alpha: 0.6),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.near_me_outlined,
                            color: Color(0xFF20B08D),
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRestroomsView(double bottomInset) {
    return StreamBuilder<List<Landmark>>(
      stream: FirebaseService().getLandmarksStream(),
      initialData: LandmarksData.allLandmarks,
      builder: (context, snapshot) {
        final allItems = snapshot.data ?? LandmarksData.allLandmarks;
        final items = _filterAndSort(allItems);

        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wc_rounded,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No restrooms found',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(16, 6, 16, 110 + bottomInset),
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF1F5F9),
          ),
          itemBuilder: (context, index) {
            final lm = items[index];
            final titleLower = lm.title.toLowerCase();
            IconData wcIcon = Icons.wc_rounded;
            if (titleLower.contains('disab') || titleLower.contains('access')) {
              wcIcon = Icons.accessible_rounded;
            } else if (titleLower.contains('urinal')) {
              wcIcon = Icons.male_rounded;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Mint green rounded square icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2F5EC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      wcIcon,
                      color: const Color(0xFF00796B),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Title & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lm.title,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        // Location row: ONLY if location/distance exists!
                        if (lm.hasLocation) ...[
                          Builder(
                            builder: (context) {
                              final dist = _formatDistance(lm.latitude, lm.longitude);
                              final locLabel = dist.isNotEmpty
                                  ? dist
                                  : (lm.address != null && lm.address!.isNotEmpty
                                      ? lm.address!
                                      : '');
                              if (locLabel.isEmpty) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 15,
                                      color: Color(0xFF20B08D),
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        locLabel,
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF20B08D),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Trailing: Phone Button (ONLY if phone exists)
                  if (lm.hasPhone) ...[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _makeCall(lm.phone!),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF20B08D),
                            width: 1.2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.phone_outlined,
                          color: Color(0xFF20B08D),
                          size: 19,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  // Trailing: Navigation Button (ONLY if location exists)
                  if (lm.hasLocation)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _navigateToLandmark(lm),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF20B08D).withValues(alpha: 0.6),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.near_me_outlined,
                          color: Color(0xFF20B08D),
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMedicalView(double bottomInset) {
    return StreamBuilder<List<Landmark>>(
      stream: FirebaseService().getLandmarksStream(),
      initialData: LandmarksData.allLandmarks,
      builder: (context, snapshot) {
        final allItems = snapshot.data ?? LandmarksData.allLandmarks;
        final items = _filterAndSort(allItems);

        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No medical services found',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(16, 6, 16, 110 + bottomInset),
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF1F5F9),
          ),
          itemBuilder: (context, index) {
            final lm = items[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Soft medical teal rounded square badge
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4FAF1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.medical_services_rounded,
                      color: Color(0xFF0D9488),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Title & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lm.title,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        // Location row: ONLY if location/distance exists!
                        if (lm.hasLocation) ...[
                          Builder(
                            builder: (context) {
                              final dist = _formatDistance(lm.latitude, lm.longitude);
                              final locLabel = dist.isNotEmpty
                                  ? dist
                                  : (lm.address != null && lm.address!.isNotEmpty
                                      ? lm.address!
                                      : '');
                              if (locLabel.isEmpty) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 15,
                                      color: Color(0xFF20B08D),
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        locLabel,
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF20B08D),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Trailing: Phone Button (ONLY if phone exists)
                  if (lm.hasPhone) ...[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _makeCall(lm.phone!),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF20B08D),
                            width: 1.2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.phone_outlined,
                          color: Color(0xFF20B08D),
                          size: 19,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  // Trailing: Navigation Button (ONLY if location exists)
                  if (lm.hasLocation)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _navigateToLandmark(lm),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF20B08D).withValues(alpha: 0.6),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.near_me_outlined,
                          color: Color(0xFF20B08D),
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStallsView(double bottomInset) {
    return StreamBuilder<List<Stall>>(
      stream: FirebaseService().getStallsStream(),
      initialData: StallsData.allStalls,
      builder: (context, snapshot) {
        final stalls = snapshot.data ?? StallsData.allStalls;

        if (stalls.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No stalls found',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(16, 6, 16, 110 + bottomInset),
          itemCount: stalls.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF1F5F9),
          ),
          itemBuilder: (context, index) {
            final stall = stalls[index];
            return _buildStallRow(stall);
          },
        );
      },
    );
  }

  Widget _buildStallRow(Stall stall) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Order Number Badge (Teal Rounded Square)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFD4FAF1),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              stall.order.toString(),
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF20B08D),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Stall Name and Owner Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stall.stallName,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Owner: ${stall.owner}',
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                if (stall.hasLocation) ...[
                  Builder(
                    builder: (context) {
                      final dist = _formatDistance(stall.latitude, stall.longitude);
                      final stallLoc = dist.isNotEmpty
                          ? (stall.location.isNotEmpty ? '${stall.location} • $dist' : dist)
                          : stall.location;
                      if (stallLoc.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 13,
                              color: Color(0xFF20B08D),
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                stallLoc,
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF20B08D),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Phone Call Button (Circular Teal Outline) - ONLY IF PHONE EXISTS
          if (stall.hasPhone)
            GestureDetector(
              onTap: () => _handleCall(stall),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF20B08D),
                    width: 1.2,
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.phone_outlined,
                  color: Color(0xFF20B08D),
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _makeCall(String phoneNumber, {Stall? stall}) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleanPhone.isEmpty) return;

    if (stall != null) {
      FirebaseService().logServiceQuery(
        serviceType: 'stall',
        serviceName: stall.stallName,
        serviceId: stall.id,
        providerId: stall.owner,
        providerPhone: cleanPhone,
        district: 'Kisama Heritage Village',
        action: 'call',
      );
    }

    final uri = Uri.parse('tel:$cleanPhone');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $uri');
    }
  }

  void _handleCall(Stall stall) {
    final phone = stall.phone.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No phone number listed for this stall'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (phone.contains('/')) {
      final numbers = phone
          .split('/')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      if (numbers.length > 1) {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (ctx) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stall.stallName,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Select a phone number to call:',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 13.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...numbers.map(
                    (numStr) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD4FAF1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.phone_outlined,
                          color: Color(0xFF20B08D),
                          size: 18,
                        ),
                      ),
                      title: Text(
                        numStr,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Color(0xFF94A3B8),
                      ),
                      onTap: () {
                        Navigator.pop(ctx);
                        _makeCall(numStr, stall: stall);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        return;
      }
    }

    _makeCall(phone, stall: stall);
  }

  static final Set<String> _knownLandmarkAssets = {
    '9j4wM8TpPgqB2j8JxcWR',
    'BJJik3mDgDodNfH5RNyi',
    'CdWbOwzAdEQ9Zm2TERuz',
    'ERpSPs2dq0WACToM38NW',
    'FXcJruZfqDgk3lqZpu02',
    'LEV7T6FlkW9x7gjyAbcD',
    'OHvLXsT78MLBIB6gyERb',
    'QAstsmxZ8PcJ1jPdzbPH',
    'StDsoUOyVSPU3pEihNFS',
    'YPYkMlcuqmLtUGwkgb9z',
    'eDvozVZaULCFocv3PiT8',
    'eH7SyxnFO4gtFGmYbizU',
    'gtMMuRn6lVhCDXEbKCo0',
    'jBqiGhuMvgD9628elj29',
    'jRjfd8QPeLPizmTkfHAo',
    'jgIOooW4FD1oqFe28ofM',
    'kArm2Y1Rcgy9JdKn3tlk',
    'lJVGu2Fm86fGr6FrS0C0',
    'p4952tBzaahjKJDsuzlL',
  };

  Widget _buildLandmarkCard(Landmark lm) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECEFF1), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image taking 54% of the card height
            Expanded(
              flex: 54,
              child: SizedBox(
                width: double.infinity,
                child: _buildCardImage(lm),
              ),
            ),

            // Card Content taking 46% of the card height
            Expanded(
              flex: 46,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lm.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Builder(
                          builder: (context) {
                            final dist = _formatDistance(lm.latitude, lm.longitude);
                            final locLabel = dist.isNotEmpty
                                ? dist
                                : (lm.address != null && lm.address!.isNotEmpty
                                    ? lm.address!
                                    : (lm.category.isNotEmpty
                                        ? '${lm.category} • Kisama'
                                        : 'Kisama Heritage'));
                            return Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 13,
                                  color: Color(0xFF20B08D),
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    locLabel,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF20B08D),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),

                    // Actions Row: Full width or phone + Navigate to
                    Row(
                      children: [
                        if (lm.hasPhone) ...[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _makeCall(lm.phone!),
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF20B08D),
                                  width: 1.2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.phone_outlined,
                                color: Color(0xFF20B08D),
                                size: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _navigateToLandmark(lm),
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF003848),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.near_me_rounded,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      'Navigate to',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardImage(Landmark lm) {
    // 1. Direct localAsset property on Landmark
    if (lm.localAsset != null && lm.localAsset!.isNotEmpty) {
      return Image.asset(
        lm.localAsset!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildNoImageBox(),
      );
    }

    // 2. Known local asset by landmark ID
    if (lm.id.isNotEmpty && _knownLandmarkAssets.contains(lm.id)) {
      return Image.asset(
        'assets/images/landmarks/${lm.id}.jpg',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildNoImageBox(),
      );
    }

    // 3. Known named morungs / attractions
    final lower = lm.title.toLowerCase();
    String? namedAsset;
    if (lower.contains('angami')) {
      namedAsset = 'assets/images/morung_angami.png';
    } else if (lower.contains('ao')) {
      namedAsset = 'assets/images/morung_ao.png';
    } else if (lower.contains('chakhesang')) {
      namedAsset = 'assets/images/morung_chakhesang.png';
    } else if (lower.contains('chang')) {
      namedAsset = 'assets/images/morung_chang.png';
    } else if (lower.contains('garo')) {
      namedAsset = 'assets/images/tribes/5_garo.webp';
    } else if (lower.contains('kachari')) {
      namedAsset = 'assets/images/tribes/6_kachari.webp';
    } else if (lower.contains('khiam')) {
      namedAsset = 'assets/images/tribes/7_khiamniungan.webp';
    } else if (lower.contains('konyak')) {
      namedAsset = 'assets/images/tribes/8_konyak.webp';
    } else if (lower.contains('kuki')) {
      namedAsset = 'assets/images/tribes/9_kuki.webp';
    } else if (lower.contains('lotha')) {
      namedAsset = 'assets/images/tribes/10_lotha.webp';
    } else if (lower.contains('phom')) {
      namedAsset = 'assets/images/tribes/11_phom.webp';
    } else if (lower.contains('pochury')) {
      namedAsset = 'assets/images/tribes/12_pochury.webp';
    } else if (lower.contains('rengma')) {
      namedAsset = 'assets/images/tribes/13_rengma.webp';
    } else if (lower.contains('sangtam')) {
      namedAsset = 'assets/images/tribes/14_sangtam.webp';
    } else if (lower.contains('sumi')) {
      namedAsset = 'assets/images/tribes/15_sumi.webp';
    } else if (lower.contains('tikhir')) {
      namedAsset = 'assets/images/tribes/16_tikhir.webp';
    } else if (lower.contains('yimkhiung') || lower.contains('yimkhuing')) {
      namedAsset = 'assets/images/tribes/17_yimkhiung.webp';
    } else if (lower.contains('zeliang')) {
      namedAsset = 'assets/images/tribes/18_zeliang.webp';
    } else if (lower.contains('bamboo hall')) {
      namedAsset = 'assets/images/attraction_bamboo_hall.png';
    } else if (lower.contains('handloom')) {
      namedAsset = 'assets/images/attraction_handloom.png';
    }

    if (namedAsset != null) {
      return Image.asset(
        namedAsset,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildNoImageBox(),
      );
    }

    // 4. Remote photo URL (with lazy loading placeholder and greyish fallback)
    final photoUrl = lm.photo?.trim();
    if (photoUrl != null &&
        photoUrl.isNotEmpty &&
        photoUrl.toLowerCase() != 'null') {
      final safeUrl = kIsWeb && photoUrl.startsWith('http')
          ? 'https://images.weserv.nl/?url=${Uri.encodeComponent(photoUrl)}'
          : photoUrl;
      return CachedNetworkImage(
        imageUrl: safeUrl,
        fit: BoxFit.cover,
        memCacheWidth: 600,
        fadeInDuration: const Duration(milliseconds: 120),
        placeholder: (_, __) => _buildLoadingImageBox(),
        errorWidget: (_, __, ___) => _buildNoImageBox(),
      );
    }

    // 5. No photo available: Clean greyish box
    return _buildNoImageBox();
  }

  Widget _buildLoadingImageBox() {
    return Container(
      color: const Color(0xFFF1F5F9),
    );
  }

  Widget _buildNoImageBox() {
    return Container(
      color: const Color(0xFFF1F5F9),
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            color: Color(0xFFCBD5E1),
            size: 30,
          ),
          SizedBox(height: 4),
          Text(
            'No photo available',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
