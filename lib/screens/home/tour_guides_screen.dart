import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/firebase_service.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../../theme/app_theme.dart';

class TourGuidesScreen extends StatefulWidget {
  final String? tourTitle;

  const TourGuidesScreen({super.key, this.tourTitle});

  @override
  State<TourGuidesScreen> createState() => _TourGuidesScreenState();
}

class _TourGuidesScreenState extends State<TourGuidesScreen> {
  String _selectedDistrict = 'Kohima';

  final List<String> _districts = [
    'Chümoukedima',
    'Dimapur',
    'Kiphire',
    'Kohima',
    'Longleng',
    'Meluri',
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

  void _showDistrictPicker() async {
    final selected = await showAppFilterBottomSheet(
      context: context,
      title: 'Select District',
      items: _districts,
      selectedItem: _selectedDistrict,
      sortAlphabetically: true,
    );
    if (selected != null && mounted) {
      setState(() {
        _selectedDistrict = selected;
      });
    }
  }

  final List<Map<String, dynamic>> _fallbackGuides = const [
    {
      "docId": "60jkRQRoCHohOrrWkx04",
      "guideID": "xoePgE0fGuWcTydAz9HoipMYBZH3",
      "fullName": "Kikru Victor",
      "address": "Nagabazar colony",
      "district": "Kohima",
      "phoneNumber": "9366636963",
      "document":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/id_cards%2FKikruVictor_NTA_ID_6429112?alt=media&token=aa90b52b-6bda-4f79-ab89-d2b72bca1829",
      "isActive": true,
      "created_at": "29th November, 2024",
    },
    {
      "businessName": "Abode Venture",
      "fullName": "Abode Venture",
      "address": "NagaBazar Colony, Kohima",
      "district": "Kohima",
      "phoneNumber": "7005638258",
      "photo":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tour_operators%2Fadobe_ventures.jpg?alt=media&token=5dba499d-436f-45ec-a734-c9db631b5a7c",
    },
    {
      "businessName": "Tribal Odyssey",
      "fullName": "Tribal Odyssey",
      "address": "Midland, Dimapur",
      "district": "Dimapur",
      "phoneNumber": "9862568055",
      "photo":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tour_operators%2FTribalOdyssey_5206592.jpg?alt=media&token=3eec8465-b35a-49cf-9de1-bc4984c441b4",
    },
    {
      "businessName": "Sheanghah Travels",
      "fullName": "Sheanghah Travels",
      "address": "Sheanghah Chingnyu Village, Mon Nagaland",
      "district": "Mon",
      "phoneNumber": "6009174657",
      "photo":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tour_operators%2FSheanghahTravels_4319983.jpg?alt=media&token=1715fdae-7c50-4b61-bfe7-b00ede4833d4",
    },
  ];

  bool _matchesDistrict(String itemDistrict, String selected) {
    final cleanItem =
        itemDistrict.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    final cleanSelected =
        selected.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    if (cleanSelected.isEmpty || cleanSelected == 'all') return true;
    return cleanItem == cleanSelected ||
        cleanItem.contains(cleanSelected) ||
        cleanSelected.contains(cleanItem);
  }

  Future<void> _makeCall(String phoneNumber, {Map<String, dynamic>? guide}) async {
    final clean = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (clean.isEmpty) return;

    if (guide != null) {
      final name = guide["fullName"] ?? guide["businessName"] ?? guide["name"] ?? "Tour Guide";
      final guideId = guide["guideID"] ?? guide["docId"] ?? guide["id"];
      FirebaseService().logServiceQuery(
        serviceType: 'tour_guide',
        serviceName: name.toString(),
        serviceId: (guide["docId"] ?? guide["id"] ?? guideId ?? "").toString(),
        providerId: guide["guideID"]?.toString(),
        providerPhone: clean,
        district: guide["district"]?.toString(),
        action: 'call',
      );
    }

    final uri = Uri.parse('tel:$clean');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    const headerColor = Color(0xFF003848);

    return Scaffold(
      backgroundColor: headerColor,
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // Deep Teal Top Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title: Tour Guides
                  const Text(
                    'Tour Guides',
                    style: AppTextStyles.headerTitle,
                  ),
                  const SizedBox(height: 3),

                  // Subtitle: NTA Approved
                  const Text(
                    'NTA Approved',
                    style: AppTextStyles.headerSubtitle,
                  ),
                  const SizedBox(height: 16),

                  // District Dropdown Pill
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _showDistrictPicker,
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
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: FirebaseService().getTourGuides(),
                  builder: (context, snapshot) {
                    List<Map<String, dynamic>> allGuides;
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      allGuides = snapshot.data!;
                    } else {
                      allGuides = _fallbackGuides;
                    }

                    final guidesForDistrict = allGuides.where((guide) {
                      if (guide['isActive'] != true) return false;
                      final dist = guide['district']?.toString() ?? '';
                      return _matchesDistrict(dist, _selectedDistrict);
                    }).toList();

                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF20B08D),
                        ),
                      );
                    }

                    if (guidesForDistrict.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/empty.gif',
                              height: 240,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No tour guides found in $_selectedDistrict',
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
                      children: [
                        Text(
                          'Find Tour Guides in $_selectedDistrict',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...guidesForDistrict
                            .map((guide) => _buildOperatorItem(guide)),
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
    );
  }

  Widget _buildOperatorItem(Map<String, dynamic> op) {
    final name = op["fullName"] ?? op["businessName"] ?? op["name"] ?? "Tour Guide";
    final address = op["address"]?.toString().trim().isNotEmpty == true
        ? op["address"].toString().trim()
        : (op["district"] ?? "Nagaland");
    final phone = op["phoneNumber"] ?? op["phone"] ?? "";

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
          // Verified Guide Avatar with Tick Mark Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F8F3),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFF0D9488),
                  size: 28,
                ),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  padding: const EdgeInsets.all(1.5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: Color(0xFF20B08D),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  address,
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
          if (phone.toString().isNotEmpty)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _makeCall(phone.toString(), guide: op),
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
