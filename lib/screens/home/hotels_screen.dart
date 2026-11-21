import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/hotel.dart';
import 'view_hotel_screen.dart';

class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  String _selectedDistrict = "All";
  String _selectedCategory = "All"; // "All", "Hotel", "Homestay"

  final List<String> _districts = [
    "All",
    "Kohima",
    "Dimapur",
    "Chümoukedima",
    "Wokha",
    "Mokokchung",
    "Mon",
    "Phek",
    "Tuensang",
    "Zünheboto",
    "Kiphire",
    "Longleng",
    "Peren",
    "Noklak",
    "Shamator",
    "Tseminyü",
    "Niuland",
    "Meluri",
  ];

  final List<Hotel> _resorts = [
    Hotel(
      id: "resort_1",
      name: "Zone Naithu",
      type: "Resort",
      district: "Chümoukedima",
      address: "7th Mile, Chumukedima",
      rating: 4.8,
      price: 7000,
      strikethroughPrice: 8500,
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/hotels%2FZoneNiathu_3158079.jpg?alt=media&token=f90b1ad0-d8cb-474c-8182-3531b790d0b0",
      phone: "7005305794",
      isFeatured: true,
      roomsAvailable: true,
      facilities: ["Free Wifi", "Fooding", "Pool", "AC Rooms", "24x7 Power", "Parking", "Fridge"],
    ),
    Hotel(
      id: "resort_2",
      name: "Rüdi Resort",
      type: "Resort",
      district: "Kohima",
      address: "Chedema Dzüü Bridge, Phek Road, NH29",
      rating: 4.7,
      price: 5500,
      strikethroughPrice: 7000,
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/hotels%2Fbdheje_3434964.jpg?alt=media&token=f4e710f3-9c58-40d0-9072-aca49bcae351",
      phone: "6909790114",
      isFeatured: true,
      roomsAvailable: true,
      facilities: ["Free Wifi", "Fooding", "Pool", "AC Rooms", "24x7 Power", "Parking", "Fridge"],
    ),
  ];

  final List<Hotel> _allStays = [
    Hotel(
      id: "stay_1",
      name: "Hotel Lavisto",
      type: "Hotel",
      district: "Kohima",
      address: "Opposite to War cemetery midland, Kohima",
      rating: 4.6,
      price: 4500,
      strikethroughPrice: 5500,
      image: "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1c/68/01/9c/hotel-lavisto.jpg?w=600&h=-1&s=1",
      phone: "6909931832",
      isFeatured: false,
      roomsAvailable: true,
      facilities: ["Free Wifi", "Fooding", "AC Rooms", "24x7 Power", "Parking", "Fridge"],
    ),
    Hotel(
      id: "stay_2",
      name: "Crescent international hotel",
      type: "Hotel",
      district: "Kohima",
      address: "Near Old NST Main Town , Kohima",
      rating: 4.5,
      price: 3800,
      strikethroughPrice: 4800,
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/hotels%2FCrescentinternationalhotel_2456488.jpg?alt=media&token=48f29ea1-93c6-43b9-a2e6-a0833a6ad031",
      phone: "7005570252",
      isFeatured: false,
      roomsAvailable: true,
      facilities: ["Free Wifi", "Fooding", "AC Rooms", "24x7 Power", "Parking"],
    ),
    Hotel(
      id: "stay_3",
      name: "Hotel Ariel",
      type: "Hotel",
      district: "Kohima",
      address: "Near ITI office, High School Road, Kohima 797001, Nagaland , Kohima",
      rating: 4.4,
      price: 3200,
      strikethroughPrice: 4000,
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/hotels%2FHotelAriel_8151246.jpg?alt=media&token=7737d91e-355b-426b-8716-e4210d5ec423",
      phone: "8798029129",
      isFeatured: false,
      roomsAvailable: true,
      facilities: ["Free Wifi", "Fooding", "24x7 Power", "Parking"],
    ),
    Hotel(
      id: "stay_4",
      name: "MY RETREAT",
      type: "Homestay",
      district: "Kohima",
      address: "ISBT kohima , rutsa model village , T.Khel, KOHIMA",
      rating: 4.8,
      price: 2500,
      strikethroughPrice: 3200,
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/hotels%2FMYRETREAT_8065099.jpg?alt=media&token=185e921b-02db-432a-bd12-fbf1e2e925c4",
      phone: "8118925326",
      isFeatured: false,
      roomsAvailable: true,
      facilities: ["Free Wifi", "Fooding", "24x7 Power", "Parking", "Fridge"],
    ),
    Hotel(
      id: "stay_5",
      name: "The Sanctuary",
      type: "Homestay",
      district: "Kohima",
      address: "Jail colony, near kiwi store xl",
      rating: 4.5,
      price: 2200,
      strikethroughPrice: 2800,
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/hotels%2FTheSanctuary_3518529.jpg?alt=media&token=7aa296c0-1d40-44e6-acca-def4e52ec67b",
      phone: "8794943986",
      isFeatured: false,
      roomsAvailable: true,
      facilities: ["Free Wifi", "Fooding", "24x7 Power"],
    ),
    Hotel(
      id: "stay_6",
      name: "Grace Guest House",
      type: "Homestay",
      district: "Kohima",
      address: "Officers' Hill, Near Hotel Eden",
      rating: 4.6,
      price: 2000,
      strikethroughPrice: 2600,
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/hotels%2FGraceGuestHouse_7312109.jpg?alt=media&token=85185e88-14f9-4789-932b-85b20acbc43d",
      phone: "7005305794",
      isFeatured: false,
      roomsAvailable: true,
      facilities: ["Free Wifi", "Fridge", "Parking"],
    ),
    Hotel(
      id: "stay_7",
      name: "Megoki Homestay",
      type: "Homestay",
      district: "Kohima",
      address: "Khonoma Village",
      rating: 4.7,
      price: 1800,
      strikethroughPrice: 2400,
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/hotels%2FMegokihomestay_4003266.jpg?alt=media&token=1098d744-7906-4750-a1c4-39ab22e22b3b",
      phone: "7005305981",
      isFeatured: false,
      roomsAvailable: true,
      facilities: ["Fooding", "Parking", "Fridge"],
    ),
  ];

  void _showDistrictPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Text(
                'Select District',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _districts.length,
                  itemBuilder: (context, idx) {
                    final d = _districts[idx];
                    final isSel = (_selectedDistrict == d) || (d == "All" && _selectedDistrict == "All");
                    return ListTile(
                      title: Text(
                        d == "All" ? "Any district" : d,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                          color: isSel ? const Color(0xFF20B08D) : const Color(0xFF1E293B),
                        ),
                      ),
                      trailing: isSel
                          ? const Icon(Icons.check, color: Color(0xFF20B08D))
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedDistrict = d;
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter stays
    final filteredStays = _allStays.where((s) {
      final matchesDistrict = _selectedDistrict == "All" ||
          s.district.toLowerCase() == _selectedDistrict.toLowerCase();
      if (!matchesDistrict) return false;

      if (_selectedCategory == "Hotel") {
        return s.type.toLowerCase() == "hotel";
      } else if (_selectedCategory == "Homestay") {
        return s.type.toLowerCase() == "homestay" || s.type.toLowerCase() == "guest house";
      }
      return true;
    }).toList();

    final sectionTitle = _selectedCategory == "Hotel"
        ? "Hotel"
        : (_selectedCategory == "Homestay" ? "Guest House" : "Hotels / Homestays");

    final promoBanner = _selectedCategory == "Hotel"
        ? 'assets/images/stays_promo_blue.png'
        : 'assets/images/homestay_promo_green.png';

    return Scaffold(
      backgroundColor: const Color(0xFF003848),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Dark Teal Top Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore Stays',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w900,
                              fontSize: 28,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Hotels • Homestays • Resorts',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
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
                  Row(
                    children: [
                      _buildFilterPill("All"),
                      const SizedBox(width: 10),
                      _buildFilterPill("Hotel"),
                      const SizedBox(width: 10),
                      _buildFilterPill("Homestay"),
                    ],
                  ),
                ],
              ),
            ),

            // White Rounded Body Sheet
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Promo Banner
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            promoBanner,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Section 1: Featured Resorts
                        Row(
                          children: const [
                            Icon(Icons.local_fire_department_rounded, color: Color(0xFF1E293B), size: 24),
                            SizedBox(width: 6),
                            Text(
                              'Featured Resorts',
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

                        // Horizontal Resorts Carousel
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _resorts.length,
                            itemBuilder: (context, index) {
                              final resort = _resorts[index];
                              return _buildHorizontalResortCard(resort);
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Section 2: Hotel / Homestay / Guest House
                        Row(
                          children: [
                            const Icon(Icons.local_fire_department_rounded, color: Color(0xFF1E293B), size: 24),
                            const SizedBox(width: 6),
                            Text(
                              sectionTitle,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Vertical List of Stays
                        ...filteredStays.map((stay) => _buildVerticalStayCard(stay)),
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
  }

  Widget _buildFilterPill(String label) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD4FAF1) : Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 14.5,
            color: isSelected ? const Color(0xFF20B08D) : const Color(0xFF1E293B),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalResortCard(Hotel resort) {
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
        width: 230,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEBEBEB)),
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
            // Image with heart badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: resort.image,
                    height: 135,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.grey.shade200),
                    errorWidget: (_, __, ___) => Container(color: Colors.grey.shade300),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: Color(0xFF64748B),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
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
                      fontSize: 15.5,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Color(0xFF94A3B8), size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          resort.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 12,
                            color: Color(0xFF64748B),
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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEBEBEB)),
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: stay.image,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.grey.shade200),
                    errorWidget: (_, __, ___) => Container(color: Colors.grey.shade300),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: Color(0xFF64748B),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stay.name,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      fontSize: 16.5,
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
                          stay.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 13,
                            color: Color(0xFF64748B),
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
