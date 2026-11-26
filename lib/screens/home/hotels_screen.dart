import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/hotel.dart';
import '../../data/hotels_data.dart';
import '../../services/firebase_service.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../theme/app_theme.dart';
import 'view_hotel_screen.dart';

class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  String _selectedDistrict = "All";
  String _selectedCategory = "All"; // "All", "Hotel", "Homestay"
  final ScrollController _scrollController = ScrollController();
  int _displayedCount = 8;
  bool _isLoadingMore = false;
  int _totalStaysCount = 0;

  Future<void> _makeCall(String phoneNumber) async {
    final clean = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (clean.isEmpty) return;
    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 250) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_isLoadingMore) return;
    if (_displayedCount >= _totalStaysCount) return;

    setState(() {
      _isLoadingMore = true;
    });

    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) {
        setState(() {
          _displayedCount = (_displayedCount + 8).clamp(0, _totalStaysCount);
          _isLoadingMore = false;
        });
      }
    });
  }

  final List<String> _districts = [
    "All",
    "Chümoukedima",
    "Dimapur",
    "Kiphire",
    "Kohima",
    "Longleng",
    "Meluri",
    "Mokokchung",
    "Mon",
    "Niuland",
    "Noklak",
    "Peren",
    "Phek",
    "Shamator",
    "Tseminyü",
    "Tuensang",
    "Wokha",
    "Zünheboto",
  ];

  void _showDistrictPicker() async {
    final selected = await showAppFilterBottomSheet(
      context: context,
      title: 'Select District',
      items: _districts,
      selectedItem: _selectedDistrict,
      displayLabel: (d) => d == "All" ? "Any district" : d,
      sortAlphabetically: true,
    );
    if (selected != null && mounted) {
      setState(() {
        _selectedDistrict = selected;
        _displayedCount = 8;
      });
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    }
  }

  Widget _buildCardImage(Hotel hotel, {required double height}) {
    final assetPath = 'assets/images/hotels/${hotel.id}.jpg';
    return Image.asset(
      assetPath,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        final photo = (hotel.photoUrl != null && hotel.photoUrl!.isNotEmpty)
            ? hotel.photoUrl!
            : (hotel.image.startsWith('http') ? hotel.image : '');

        if (photo.isNotEmpty) {
          return CachedNetworkImage(
            imageUrl: photo,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
            memCacheWidth: 600,
            placeholder: (_, __) => _buildPlaceholder(height),
            errorWidget: (_, __, ___) => _buildPlaceholder(height),
          );
        }

        final fallbackAsset = hotel.image.startsWith('assets/') ? hotel.image : '';
        if (fallbackAsset.isNotEmpty) {
          return Image.asset(
            fallbackAsset,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholder(height),
          );
        }

        return _buildPlaceholder(height);
      },
    );
  }

  Widget _buildPlaceholder(double height) {
    return Container(
      height: height,
      color: const Color(0xFFE2E8F0),
      alignment: Alignment.center,
      child: const Icon(Icons.hotel_rounded, color: Color(0xFF94A3B8), size: 36),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sectionTitle = _selectedCategory == "Hotel"
        ? "Hotels"
        : (_selectedCategory == "Homestay" ? "Homestays & Guest Houses" : "Hotels / Homestays");

    return Scaffold(
      backgroundColor: const Color(0xFF003848),
      body: Stack(
        children: [
          SafeArea(
            bottom: AppTheme.needsBottomSafeArea(context),
            child: Column(
              children: [
            // Dark Teal Top Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore Stays',
                        style: AppTextStyles.headerTitle,
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Hotels • Homestays • Resorts',
                        style: AppTextStyles.headerSubtitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // District Dropdown Pill
                  GestureDetector(
                    onTap: _showDistrictPicker,
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDistrict == "All" ? "Any district" : _selectedDistrict,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF64748B),
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Filter Pills: All | Hotel | Homestay
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    child: Row(
                      children: [
                        _buildFilterPill("All"),
                        const SizedBox(width: 10),
                        _buildFilterPill("Hotel"),
                        const SizedBox(width: 10),
                        _buildFilterPill("Homestay"),
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
                  child: StreamBuilder<List<Hotel>>(
                    stream: FirebaseService().getHotels(),
                    builder: (context, snapshot) {
                      final allLoaded = snapshot.hasData
                          ? snapshot.data!
                          : HotelsData.allHotels;

                      bool isResort(Hotel s) {
                        final type = s.type.toLowerCase();
                        final name = s.name.toLowerCase();
                        return s.isFeatured ||
                            type.contains('resort') ||
                            name.contains('resort') ||
                            name.contains('rudi') ||
                            name.contains('rüdi') ||
                            s.id == 'TugCrwLHmkLAtw6x90Vj';
                      }

                      // Featured Resorts: ALWAYS SHOW ALL RESORTS across all districts and categories
                      final resorts = allLoaded.where(isResort).toList();

                      // Guarantee all standard resorts from HotelsData are present
                      for (final fallbackResort in HotelsData.allHotels.where(isResort)) {
                        final alreadyPresent = resorts.any((r) =>
                            r.id == fallbackResort.id ||
                            r.name.toLowerCase() == fallbackResort.name.toLowerCase());
                        if (!alreadyPresent) {
                          resorts.add(fallbackResort);
                        }
                      }

                      // Filter regular stays for the "All Stays" list by district and category
                      final filteredStays = allLoaded.where((s) {
                        if (isResort(s)) return false;

                        // District Filter
                        if (_selectedDistrict != "All" &&
                            s.district.toLowerCase() != _selectedDistrict.toLowerCase()) {
                          return false;
                        }

                        // Category Filter (Hotel / Homestay)
                        if (_selectedCategory == "Hotel") {
                          return s.type.toLowerCase() == "hotel";
                        } else if (_selectedCategory == "Homestay") {
                          return s.type.toLowerCase() == "homestay" ||
                              s.type.toLowerCase() == "guest house";
                        }
                        return true;
                      }).toList();

                      // Update total stays count for incremental loading
                      _totalStaysCount = filteredStays.length;
                      final visibleCount =
                          _displayedCount.clamp(0, filteredStays.length);

                      return CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 20),
                          ),

                          // Section 1: Featured Resorts
                          if (resorts.isNotEmpty) ...[
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.local_fire_department_rounded,
                                        color: Color(0xFF1E293B), size: 24),
                                    const SizedBox(width: 6),
                                    const Expanded(
                                      child: Text(
                                        'Featured Resorts',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 14),
                            ),

                            // Smooth Full-Bleed Horizontal Resorts Strip (no side clipping)
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: 206,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  clipBehavior: Clip.none,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  itemCount: resorts.length,
                                  itemBuilder: (context, index) {
                                    return _buildHorizontalResortCard(
                                        resorts[index]);
                                  },
                                ),
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 14),
                            ),
                          ],

                          // Section 2: Hotel / Homestay / Guest House Header
                          SliverToBoxAdapter(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  const Icon(
                                      Icons.local_fire_department_rounded,
                                      color: Color(0xFF1E293B),
                                      size: 24),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      sectionTitle,
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 14),
                          ),

                          // Section 2: Virtualized Lazy List of Stays (incremental load)
                          if (filteredStays.isEmpty)
                            SliverToBoxAdapter(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 40, horizontal: 16),
                                alignment: Alignment.center,
                                child: const Text(
                                  'No stays found for this selection.\nTry picking "Any district" or another category.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            )
                          else
                            SliverPadding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (index < visibleCount) {
                                      return _buildVerticalStayCard(
                                          filteredStays[index]);
                                    }

                                    // Auto-trigger load more when bottom loader is reached
                                    if (!_isLoadingMore &&
                                        visibleCount < filteredStays.length) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback(
                                              (_) => _loadMore());
                                    }

                                    return const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Color(0xFF20B08D),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: visibleCount +
                                      (visibleCount < filteredStays.length ||
                                              _isLoadingMore
                                          ? 1
                                          : 0),
                                ),
                              ),
                            ),

                          // Bottom spacing for bottom bar
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 120),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Custom Bottom Navigation Bar
      CustomBottomBar(
        currentIndex: 0,
        onTap: (index) {
          Navigator.pop(context);
        },
      ),
    ],
  ),
);
  }

  Widget _buildFilterPill(String label) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
          _displayedCount = 8;
        });
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      },
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5CD1B4) : Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
            fontSize: 14.5,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalResortCard(Hotel resort) {
    final town = resort.town ?? '';
    final locationText = resort.address.isNotEmpty
        ? (town.isNotEmpty && !resort.address.contains(town)
            ? '${resort.address} , $town'
            : resort.address)
        : resort.district;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewHotelScreen(hotel: resort),
          ),
        );
      },
      child: Container(
        width: 255,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCardImage(resort, height: 130),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resort.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: Color(0xFF94A3B8), size: 13),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          locationText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
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
  }

  Widget _buildVerticalStayCard(Hotel stay) {
    final town = stay.town ?? '';
    final locationText = stay.address.isNotEmpty
        ? (town.isNotEmpty && !stay.address.contains(town)
            ? '${stay.address} , $town'
            : stay.address)
        : stay.district;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewHotelScreen(hotel: stay),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardImage(stay, height: 185),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stay.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Color(0xFF94A3B8), size: 15),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          locationText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
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
  }
}
