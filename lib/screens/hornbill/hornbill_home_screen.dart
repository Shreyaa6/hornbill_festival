import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../home/pdf_viewer_screen.dart';
import '../../services/firebase_service.dart';

class HornbillHomeScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onOpenStalls;
  final VoidCallback? onOpenPrograms;
  final VoidCallback? onOpenEmergency;

  const HornbillHomeScreen({
    super.key,
    this.onBack,
    this.onOpenStalls,
    this.onOpenPrograms,
    this.onOpenEmergency,
  });

  @override
  State<HornbillHomeScreen> createState() => _HornbillHomeScreenState();
}

class _HornbillHomeScreenState extends State<HornbillHomeScreen> {
  final Set<int> _expandedDays = {1}; // Day 1 expanded by default
  final TextEditingController _searchController = TextEditingController();

  void _toggleDay(int day) {
    setState(() {
      if (_expandedDays.contains(day)) {
        _expandedDays.remove(day);
      } else {
        _expandedDays.add(day);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Complete 10 Days schedule data matching the official festival program
  final List<Map<String, dynamic>> _daysData = [
    {
      'day': 1,
      'date': '1st December',
      'title': 'Opening Ceremony',
      'events': [
        {'time': '9:00 AM', 'title': 'Launch of Kigwema Village Walk', 'icon': Icons.directions_walk_rounded, 'leftTime': true},
        {'time': '10:00 AM', 'title': 'Hornbill International Photo Fest', 'icon': Icons.camera_alt_outlined, 'leftTime': false},
        {'time': '10:00 AM', 'title': 'Kids Carnival', 'icon': Icons.child_care_rounded, 'leftTime': true},
        {'time': '10:00 AM', 'title': 'Inauguration of MYKI FEST', 'icon': Icons.favorite_border_rounded, 'leftTime': false},
        {'time': '10:00 AM', 'title': 'Peoples Festival, Kezhakeno', 'icon': Icons.celebration_outlined, 'leftTime': true},
        {'time': '3:00 PM', 'title': 'Inaugurations\nCraftscape, Hortiscape, Handloom & Handicrafts', 'icon': Icons.content_cut_rounded, 'leftTime': false},
        {'time': '3:00 PM', 'title': 'Artist Corner Launches', 'icon': Icons.music_note_rounded, 'leftTime': true},
        {'time': '4:00 PM', 'title': 'Opening Ceremony', 'icon': Icons.celebration_rounded, 'leftTime': false},
        {'time': '6:00 PM', 'title': 'Night Carnival\nVenues: BOC / New Secretariat Junction / Main Town / New Ministers Hill', 'icon': Icons.nightlife_rounded, 'leftTime': true},
      ],
    },
    {
      'day': 2,
      'date': '2nd December',
      'title': 'Cultural Shows',
      'events': [
        {'time': '10:00 AM', 'title': 'Traditional Cultural Performances (Main Arena)', 'icon': Icons.theater_comedy_outlined, 'leftTime': true},
        {'time': '10:00 AM', 'title': 'Craftscape & Hortiscape Exhibition', 'icon': Icons.brush_outlined, 'leftTime': false},
        {'time': '11:30 AM', 'title': 'Indigenous Games & Sports Showcase', 'icon': Icons.sports_martial_arts_rounded, 'leftTime': true},
        {'time': '2:00 PM', 'title': 'Cultural Troupe Presentations', 'icon': Icons.people_outline_rounded, 'leftTime': false},
        {'time': '5:00 PM', 'title': 'Hornbill Music Festival (Unity Plaza)', 'icon': Icons.audiotrack_rounded, 'leftTime': true},
        {'time': '6:00 PM', 'title': 'Night Carnival (Kohima Town)', 'icon': Icons.nightlife_rounded, 'leftTime': false},
      ],
    },
    {
      'day': 3,
      'date': '3rd December',
      'title': 'Cultural Shows',
      'events': [
        {'time': '9:00 AM', 'title': 'World War Walk', 'icon': Icons.directions_walk_rounded, 'leftTime': true},
        {'time': '10:00 AM', 'title': 'Exhibition of Art and Crafts', 'icon': Icons.palette_outlined, 'leftTime': false},
        {'time': '10:00 AM', 'title': 'Exhibition & Sales\nAgri Products, MSME', 'icon': Icons.shopping_bag_outlined, 'leftTime': true},
        {'time': '10:00 AM', 'title': 'Hornbill International Photo Fest', 'icon': Icons.camera_alt_outlined, 'leftTime': false},
        {'time': '10:00 AM', 'title': 'Kids Carnival (ImagiLAND)', 'icon': Icons.child_care_rounded, 'leftTime': true},
        {'time': '11:00 AM', 'title': 'Cultural Show', 'icon': Icons.theater_comedy_outlined, 'leftTime': false},
        {'time': '11:00 AM', 'title': 'Disability Pride Fair', 'icon': Icons.military_tech_outlined, 'leftTime': true},
        {'time': '1:00 PM', 'title': 'Stilt Bamboo Race', 'icon': Icons.directions_run_rounded, 'leftTime': false},
        {'time': '2:00 PM', 'title': 'Drum Tao Japan', 'icon': Icons.celebration_outlined, 'leftTime': true},
        {'time': '5:00 PM', 'title': 'Hornbill Music Festival', 'icon': Icons.music_note_rounded, 'leftTime': false},
        {'time': '6:00 PM', 'title': 'Night Carnival\nVenues: Main Town / BOC / New Secretariat Junction', 'icon': Icons.nightlife_rounded, 'leftTime': true},
        {'time': '06:30 PM', 'title': 'Handshake Concert\nAt: Dr. Imkongliba Ao Hall, Raj Bhavan', 'icon': Icons.favorite_border_rounded, 'leftTime': false},
      ],
    },
    {
      'day': 4,
      'date': '4th December',
      'title': 'Cultural Shows',
      'events': [
        {'time': '09:30 AM', 'title': 'Traditional Naga Wrestling Championship', 'icon': Icons.sports_martial_arts_rounded, 'leftTime': true},
        {'time': '10:00 AM', 'title': 'Cultural Shows (18 Tribes)', 'icon': Icons.theater_comedy_outlined, 'leftTime': false},
        {'time': '11:00 AM', 'title': 'Naga Chef Competition - Round 1', 'icon': Icons.restaurant_menu_rounded, 'leftTime': true},
        {'time': '01:00 PM', 'title': 'Naga King Chilli Eating Competition', 'icon': Icons.local_fire_department_outlined, 'leftTime': false},
        {'time': '05:00 PM', 'title': 'Hornbill Music Fest Rock Contest', 'icon': Icons.audiotrack_rounded, 'leftTime': true},
        {'time': '06:00 PM', 'title': 'Night Carnival (Kohima)', 'icon': Icons.nightlife_rounded, 'leftTime': false},
      ],
    },
    {
      'day': 5,
      'date': '5th December',
      'title': 'Cultural Shows',
      'events': [
        {'time': '10:00 AM', 'title': 'Cultural Shows (Northern & Eastern Tribes)', 'icon': Icons.theater_comedy_outlined, 'leftTime': true},
        {'time': '11:00 AM', 'title': 'Greased Bamboo Pole Climbing Challenge', 'icon': Icons.terrain_rounded, 'leftTime': false},
        {'time': '01:00 PM', 'title': 'Pork Fat Eating Challenge', 'icon': Icons.restaurant_rounded, 'leftTime': true},
        {'time': '05:00 PM', 'title': 'Hornbill Music Fest - National Bands', 'icon': Icons.music_note_rounded, 'leftTime': false},
        {'time': '06:00 PM', 'title': 'Night Carnival', 'icon': Icons.nightlife_rounded, 'leftTime': true},
      ],
    },
    {
      'day': 6,
      'date': '6th December',
      'title': 'Cultural Shows',
      'events': [
        {'time': '10:00 AM', 'title': 'Cultural Shows & Traditional Chants', 'icon': Icons.theater_comedy_outlined, 'leftTime': true},
        {'time': '11:30 AM', 'title': 'Traditional Fire Making Contest', 'icon': Icons.local_fire_department_rounded, 'leftTime': false},
        {'time': '01:30 PM', 'title': 'Naga Traditional Attire Showcase', 'icon': Icons.checkroom_rounded, 'leftTime': true},
        {'time': '05:00 PM', 'title': 'Hornbill Music Festival - International Acts', 'icon': Icons.audiotrack_rounded, 'leftTime': false},
        {'time': '06:00 PM', 'title': 'Night Carnival', 'icon': Icons.nightlife_rounded, 'leftTime': true},
      ],
    },
    {
      'day': 7,
      'date': '7th December',
      'title': 'Cultural Shows',
      'events': [
        {'time': '10:00 AM', 'title': 'Cultural Shows (Southern Tribes)', 'icon': Icons.theater_comedy_outlined, 'leftTime': true},
        {'time': '11:00 AM', 'title': 'Tribal Folk Drama & Storytelling', 'icon': Icons.menu_book_rounded, 'leftTime': false},
        {'time': '02:00 PM', 'title': 'Traditional Shotput & High Kick', 'icon': Icons.sports_kabaddi_rounded, 'leftTime': true},
        {'time': '05:00 PM', 'title': 'Hornbill Music Festival', 'icon': Icons.music_note_rounded, 'leftTime': false},
        {'time': '06:00 PM', 'title': 'Night Carnival', 'icon': Icons.nightlife_rounded, 'leftTime': true},
      ],
    },
    {
      'day': 8,
      'date': '8th December',
      'title': 'Cultural Shows',
      'events': [
        {'time': '10:00 AM', 'title': 'Cultural Extravaganza', 'icon': Icons.theater_comedy_outlined, 'leftTime': true},
        {'time': '11:30 AM', 'title': 'Traditional Martial Arts & Spear Throwing', 'icon': Icons.sports_martial_arts_rounded, 'leftTime': false},
        {'time': '02:00 PM', 'title': 'Hornbill Literature Fest', 'icon': Icons.menu_book_outlined, 'leftTime': true},
        {'time': '05:00 PM', 'title': 'Hornbill Music Festival - Regional Headliners', 'icon': Icons.audiotrack_rounded, 'leftTime': false},
        {'time': '06:00 PM', 'title': 'Night Carnival', 'icon': Icons.nightlife_rounded, 'leftTime': true},
      ],
    },
    {
      'day': 9,
      'date': '9th December',
      'title': 'Cultural Shows',
      'events': [
        {'time': '10:00 AM', 'title': 'Cultural Performances & Unity Dance', 'icon': Icons.theater_comedy_outlined, 'leftTime': true},
        {'time': '11:00 AM', 'title': 'Indigenous Toy Making & Top Spinning', 'icon': Icons.toys_outlined, 'leftTime': false},
        {'time': '02:00 PM', 'title': 'Hornbill Masterclasses & Art Walk', 'icon': Icons.brush_outlined, 'leftTime': true},
        {'time': '05:00 PM', 'title': 'Hornbill Music Festival - Grand Finale Stage', 'icon': Icons.music_note_rounded, 'leftTime': false},
        {'time': '06:00 PM', 'title': 'Night Carnival', 'icon': Icons.nightlife_rounded, 'leftTime': true},
      ],
    },
    {
      'day': 10,
      'date': '10th December',
      'title': 'Grand Finale & Closing Ceremony',
      'events': [
        {'time': '10:00 AM', 'title': 'Closing Cultural Synthesis', 'icon': Icons.theater_comedy_outlined, 'leftTime': true},
        {'time': '02:00 PM', 'title': 'Unity March & Final Preparations', 'icon': Icons.directions_walk_rounded, 'leftTime': false},
        {'time': '04:30 PM', 'title': 'Grand Finale & Closing Ceremony', 'icon': Icons.celebration_rounded, 'leftTime': true},
        {'time': '05:30 PM', 'title': 'Grand Bonfire Lighting & Unity Dance (All 18 Tribes)', 'icon': Icons.local_fire_department_rounded, 'leftTime': false},
        {'time': '06:30 PM', 'title': 'Farewell Night Carnival Celebration', 'icon': Icons.nightlife_rounded, 'leftTime': true},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Deep Navy Top Header Container
            Container(
              color: const Color(0xFF00334E),
              padding: EdgeInsets.fromLTRB(20, topInset + 14, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    '26th Hornbill',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'The Festival of Festivals',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      color: Color(0xFFE2E8F0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14.5,
                          color: Color(0xFF94A3B8),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF475569),
                          size: 22,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3 Quick Action Cards (Landmarks & Stalls, Programs & Events, Emergency Services)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFECEFF1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Landmarks & Stalls
                    Expanded(
                      child: _buildServiceButton(
                        imageAsset: 'assets/images/destination.png',
                        title: 'Landmarks\n& Stalls',
                        onTap: widget.onOpenStalls,
                      ),
                    ),
                    Container(height: 45, width: 1, color: const Color(0xFFF1F5F9)),

                    // Programs & Events
                    Expanded(
                      child: _buildServiceButton(
                        imageAsset: 'assets/images/trophy.png',
                        title: 'Programs &\nEvents',
                        onTap: widget.onOpenPrograms,
                      ),
                    ),
                    Container(height: 45, width: 1, color: const Color(0xFFF1F5F9)),

                    // Emergency Services
                    Expanded(
                      child: _buildServiceButton(
                        imageAsset: 'assets/images/siren.png',
                        title: 'Emergency\nServices',
                        onTap: widget.onOpenEmergency,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hornbill Elder Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/hornbill_elder_banner.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Days 1..10 Accordion List (Live Firestore Hornbill Schedule)
            Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 120 + bottomInset),
              child: StreamBuilder<Map<String, dynamic>?>(
                stream: FirebaseService().getHornbillSchedule(),
                builder: (context, snapshot) {
                  List<Map<String, dynamic>> days = _daysData;
                  if (snapshot.hasData && snapshot.data != null) {
                    final remoteData = snapshot.data!['data'] as List?;
                    if (remoteData != null && remoteData.isNotEmpty) {
                      days = remoteData.map((d) {
                        final m = Map<String, dynamic>.from(d as Map);
                        int tIdx = 0;
                        final timeline = (m['timeline'] as List?)?.map((t) {
                          final tMap = Map<String, dynamic>.from(t as Map);
                          final isLeft = (tIdx % 2 == 0);
                          tIdx++;
                          return {
                            'time': tMap['time']?.toString() ?? '',
                            'title': tMap['title']?.toString() ?? '',
                            'description': tMap['description']?.toString(),
                            'icon': tMap['icon'] ?? Icons.celebration_rounded,
                            'leftTime': isLeft,
                          };
                        }).toList() ?? [];
                        return {
                          'day': int.tryParse(m['day'].toString()) ?? 1,
                          'date': m['date']?.toString() ?? '',
                          'title': m['title']?.toString() ?? 'Cultural Shows',
                          'pdf': m['pdf']?.toString() ?? '',
                          'events': timeline.isNotEmpty ? timeline : [],
                        };
                      }).toList();
                    }
                  }

                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: days.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final dayInfo = days[index];
                      final dayNum = dayInfo['day'] as int;
                      final isExpanded = _expandedDays.contains(dayNum);

                      return _buildDayAccordion(
                        dayInfo: dayInfo,
                        isExpanded: isExpanded,
                        onToggle: () => _toggleDay(dayNum),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceButton({
    required String imageAsset,
    required String title,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 44,
            width: 44,
            child: Image.asset(
              imageAsset,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayAccordion({
    required Map<String, dynamic> dayInfo,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    final dayNum = (dayInfo['day'] is int)
        ? dayInfo['day'] as int
        : (int.tryParse(dayInfo['day'].toString()) ?? 1);
    final dateStr = dayInfo['date']?.toString() ?? '';
    final titleStr = dayInfo['title']?.toString() ?? '';
    final rawEvents = dayInfo['events'] as List? ?? [];
    final pdfUrl = (dayInfo['pdf'] != null && dayInfo['pdf'].toString().isNotEmpty)
        ? dayInfo['pdf'].toString()
        : 'https://nititechnologies.in/files/Day_$dayNum.pdf';

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
        children: [
          // Day Header
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Green Badge: "1 Day"
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF20B08D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayNum',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                        const Text(
                          'Day',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Date & Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateStr,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 12.5,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          titleStr,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF00334E),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chevron
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF00334E),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Vertical Timeline (when expanded)
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
              child: Column(
                children: [
                  // Timeline items
                  ...rawEvents.map((rawEvent) {
                    final event = Map<String, dynamic>.from(rawEvent as Map);
                    final isLeftTime = event['leftTime'] == true;
                    final timeStr = event['time']?.toString() ?? '';
                    final titleStr = event['title']?.toString() ?? '';
                    final dynamic iconVal = event['icon'];

                    return _buildTimelineItem(
                      time: timeStr,
                      title: titleStr,
                      icon: iconVal,
                      isLeftTime: isLeftTime,
                    );
                  }),
                  const SizedBox(height: 16),

                  // Day Complete Schedule Button
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PdfViewerScreen(
                            title: 'Day $dayNum Complete Schedule',
                            pdfUrl: pdfUrl,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_outward_rounded, size: 16, color: Color(0xFF00334E)),
                    label: Text(
                      'Day $dayNum: Complete Schedule ↗',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00334E),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String time,
    required String title,
    required dynamic icon,
    required bool isLeftTime,
  }) {
    // Time Pill Widget
    Widget timePill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE2FAF4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF20B08D).withValues(alpha: 0.3)),
      ),
      child: Text(
        time,
        style: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF126E57),
        ),
      ),
    );

    // Event Card Widget
    Widget eventCard = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1E293B),
          height: 1.3,
        ),
      ),
    );

    // Center Node Widget
    Widget centerNode = Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF20B08D), width: 1.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF20B08D).withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: _buildTimelineIcon(icon),
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Side
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: isLeftTime ? timePill : eventCard,
            ),
          ),

          // Central Timeline Column
          SizedBox(
            width: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(width: 2, color: const Color(0xFF20B08D).withValues(alpha: 0.35)),
                centerNode,
              ],
            ),
          ),

          // Right Side
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: isLeftTime ? eventCard : timePill,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineIcon(dynamic icon) {
    if (icon is String && icon.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: icon,
        width: 18,
        height: 18,
        fit: BoxFit.contain,
        color: const Color(0xFF20B08D),
        placeholder: (_, __) => const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFF20B08D)),
        ),
        errorWidget: (_, __, ___) => const Icon(
          Icons.celebration_rounded,
          size: 16,
          color: Color(0xFF20B08D),
        ),
      );
    } else if (icon is IconData) {
      return Icon(icon, size: 16, color: const Color(0xFF20B08D));
    } else {
      return const Icon(Icons.celebration_rounded, size: 16, color: Color(0xFF20B08D));
    }
  }
}
