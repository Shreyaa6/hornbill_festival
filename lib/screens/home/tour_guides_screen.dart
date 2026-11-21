import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class TourGuidesScreen extends StatefulWidget {
  final String? tourTitle;

  const TourGuidesScreen({super.key, this.tourTitle});

  @override
  State<TourGuidesScreen> createState() => _TourGuidesScreenState();
}

class _TourGuidesScreenState extends State<TourGuidesScreen> {
  String _selectedDistrict = 'Kohima';

  final List<String> _districts = [
    'Dimapur / Chumoukedima',
    'Kiphire',
    'Kohima',
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

  final List<Map<String, dynamic>> _allOperators = const [
    {
      "businessName": "Abode Venture",
      "address": "NagaBazar Colony, Kohima",
      "district": "Dimapur / Chumoukedima",
      "phoneNumber": "7005638258",
      "photo":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tour_operators%2Fadobe_ventures.jpg?alt=media&token=5dba499d-436f-45ec-a734-c9db631b5a7c",
    },
    {
      "businessName": "Tribal Odyssey",
      "address": "Kohima, Kohima",
      "district": "Dimapur / Chumoukedima",
      "phoneNumber": "9862568055",
      "photo":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tour_operators%2FTribalOdyssey_5206592.jpg?alt=media&token=3eec8465-b35a-49cf-9de1-bc4984c441b4",
    },
    {
      "businessName": "Sheanghah Travels",
      "address": "Sheanghah Chingnyu Village, Mon Nagaland",
      "district": "Mon",
      "phoneNumber": "6009174657",
      "photo":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tour_operators%2FSheanghahTravels_4319983.jpg?alt=media&token=1715fdae-7c50-4b61-bfe7-b00ede4833d4",
    },
  ];

  Future<void> _makeCall(String phoneNumber) async {
    final clean = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$clean');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    const headerColor = Color(0xFF003848);
    final operatorsForDistrict = _allOperators
        .where((op) => op['district'] == _selectedDistrict)
        .toList();

    return Scaffold(
      backgroundColor: headerColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Deep Teal Top Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title: Tour Guides
                  const Text(
                    'Tour Guides',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Subtitle: NTA Approved
                  const Text(
                    'NTA Approved',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // District Dropdown Pill
                  PopupMenuButton<String>(
                    offset: const Offset(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onSelected: (val) {
                      setState(() => _selectedDistrict = val);
                    },
                    itemBuilder: (context) {
                      return _districts.map((d) {
                        final isSel = d == _selectedDistrict;
                        return PopupMenuItem(
                          value: d,
                          child: Container(
                            color: isSel ? const Color(0xFFF1F5F9) : Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              d,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14,
                                fontWeight:
                                    isSel ? FontWeight.w800 : FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList();
                    },
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
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
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
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
                ],
              ),
            ),

            // White Rounded Body Sheet
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: operatorsForDistrict.isEmpty
                    ? Center(
                        child: Image.asset(
                          'assets/images/empty.gif',
                          height: 280,
                          fit: BoxFit.contain,
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
                        children: [
                          Text(
                            'Find Tour Operators in $_selectedDistrict',
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...operatorsForDistrict
                              .map((op) => _buildOperatorItem(op)),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatorItem(Map<String, dynamic> op) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 0.8),
        ),
      ),
      child: Row(
        children: [
          // Circular Logo
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: op["photo"],
              height: 52,
              width: 52,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                height: 52,
                width: 52,
                color: Colors.grey.shade200,
                child: const Icon(Icons.business, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  op["businessName"],
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  op["address"],
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Circular Call Button
          GestureDetector(
            onTap: () => _makeCall(op["phoneNumber"]),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF20B08D), width: 1.2),
              ),
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
}
