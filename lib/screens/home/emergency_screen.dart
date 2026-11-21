import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/mock_user.dart';
import '../../widgets/app_header_bar.dart';

class EmergencyScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const EmergencyScreen({super.key, this.onBack});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  int _selectedTabIndex = 0; // 0: Police Stations, 1: Nearby Hospitals, 2: Tourist Police

  Future<void> _makeCall(String phoneNumber) async {
    final clean = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$clean');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mockUser = MockUser();
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Universal Header pinned at top
            AppHeaderBar(
              showBackButton: true,
              onBackTap: widget.onBack,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 100 + bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Greeting & Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedBuilder(
                              animation: mockUser,
                              builder: (context, _) {
                                final name = mockUser.isLoggedIn ? mockUser.name : "Test mk";
                                return Text(
                                  'Hey $name 👋',
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    color: Color(0xFF1E293B),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Emergency Helpline',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w900,
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 52,
                          width: 52,
                          decoration: const BoxDecoration(
                            color: Color(0xFF20B08D),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/user.png',
                              height: 52,
                              width: 52,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 3 Category Tabs
                    Row(
                      children: [
                        Expanded(
                          child: _buildCategoryTab(
                            index: 0,
                            icon: Icons.shield_outlined,
                            label: 'Police\nStations',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildCategoryTab(
                            index: 1,
                            icon: Icons.local_hospital_outlined,
                            label: 'Nearby\nHospitals',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildCategoryTab(
                            index: 2,
                            icon: Icons.local_police_outlined,
                            label: 'Tourist\nPolice',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Content based on tab
                    if (_selectedTabIndex == 0) ..._buildPoliceSection(),
                    if (_selectedTabIndex == 1) ..._buildHospitalsSection(),
                    if (_selectedTabIndex == 2) ..._buildTouristPoliceSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        height: 82,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF20B08D) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF20B08D) : const Color(0xFFF1F5F9),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? Colors.white : const Color(0xFF334155),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF334155),
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPoliceSection() {
    return [
      // Kohima Police
      _buildDistrictCard(
        district: 'Kohima',
        isPolice: true,
        items: [
          {'name': 'North Police Station', 'subtitle': 'Chumdemo Odyuo', 'phone': '03702222964'},
          {'name': 'South Police Station', 'subtitle': 'Mulekhoyi C.', 'phone': '03702244279'},
          {'name': 'Women Police Station', 'subtitle': 'Dziesengunuo Bio', 'phone': '03702245353'},
          {'name': 'Police Control Room', 'subtitle': 'On-duty Officer', 'phone': '112'},
        ],
      ),
      const SizedBox(height: 20),

      // Dimapur Police
      _buildDistrictCard(
        district: 'Dimapur',
        isPolice: true,
        items: [
          {'name': 'East Police Station', 'subtitle': 'Bendangwati', 'phone': '03862227633'},
          {'name': 'West Police Station', 'subtitle': 'L. Yanthithung', 'phone': '03862232649'},
          {'name': 'Women Police Station', 'subtitle': 'Tingbem Thomsong', 'phone': '03862248555'},
          {'name': 'Police Control Room', 'subtitle': 'On-duty Officer', 'phone': '100'},
        ],
      ),
    ];
  }

  List<Widget> _buildHospitalsSection() {
    return [
      // Kohima Hospitals
      _buildDistrictCard(
        district: 'Kohima',
        isPolice: false,
        items: [
          {'name': 'Oking Hospital', 'subtitle': 'Phulbari, Opp. to Bandhan Bank', 'phone': '03702290080'},
          {'name': 'Naga Hospital', 'subtitle': 'Hospital Colony, Kohima', 'phone': '03702222916'},
          {'name': 'Kohimas Hospital', 'subtitle': 'Naga Bazaar, Kohima', 'phone': '03702243555'},
        ],
      ),
      const SizedBox(height: 20),

      // Dimapur Hospitals
      _buildDistrictCard(
        district: 'Dimapur',
        isPolice: false,
        items: [
          {'name': 'Faith Hospital', 'subtitle': 'Old Sewak Road, Dhobinullah', 'phone': '03862230752'},
          {'name': 'Nikos Hospital', 'subtitle': 'Midland, Dimapur', 'phone': '03862242555'},
          {'name': 'Eden Medical Centre', 'subtitle': 'Near Sub Jail, Oriental Colony', 'phone': '03862241340'},
          {'name': 'Zion hospital', 'subtitle': 'Purana Bazar, Dimapur', 'phone': '03862241341'},
        ],
      ),
    ];
  }

  List<Widget> _buildTouristPoliceSection() {
    return [
      _buildDistrictCard(
        district: 'Kohima',
        isPolice: true,
        items: [
          {'name': 'Police Control Room', 'subtitle': 'On-duty Officer', 'phone': '112'},
        ],
      ),
    ];
  }

  Widget _buildDistrictCard({
    required String district,
    required bool isPolice,
    required List<Map<String, String>> items,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main White Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Column(
            children: List.generate(items.length, (idx) {
              final item = items[idx];
              final isLast = idx == items.length - 1;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'] ?? '',
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    isPolice
                                        ? Icons.local_police_outlined
                                        : Icons.location_on_outlined,
                                    size: 16,
                                    color: const Color(0xFF6B7280),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      item['subtitle'] ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Outlined Call Button
                        OutlinedButton.icon(
                          onPressed: () => _makeCall(item['phone'] ?? ''),
                          icon: const Icon(
                            Icons.phone_outlined,
                            size: 15,
                            color: Color(0xFF20B08D),
                          ),
                          label: const Text(
                            'Call',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF20B08D),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF20B08D),
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            minimumSize: const Size(74, 34),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    const Divider(color: Color(0xFFF1F5F9), thickness: 1),
                ],
              );
            }),
          ),
        ),

        // Slanted District Corner Tab on top right
        Positioned(
          top: -12,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: const BoxDecoration(
              color: Color(0xFF20B08D),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(6),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Text(
              district,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
