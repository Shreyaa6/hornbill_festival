import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/hornbill_schedule_data.dart';
import '../../services/firebase_service.dart';
import '../home/pdf_viewer_screen.dart';
import '../home/emergency_screen.dart';
import 'hornbill_stalls_screen.dart';
import 'hornbill_programs_screen.dart';
import '../../theme/app_theme.dart';

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
  int? _expandedDay = 1; // Day 1 expanded by default

  void _toggleDay(int day) {
    setState(() {
      if (_expandedDay == day) {
        _expandedDay = null;
      } else {
        _expandedDay = day;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;
    const headerColor = Color(0xFF003848);

    return Scaffold(
      backgroundColor: headerColor,
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // Deep Navy Top Header (Matching Book Taxis, Cafes, etc.)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 14, 20, 18),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '27th Hornbill',
                      style: AppTextStyles.headerTitle,
                    ),
                    SizedBox(height: 3),
                    Text(
                      'The Festival of Festivals',
                      style: AppTextStyles.headerSubtitle,
                    ),
                  ],
                ),
              ),
            ),

            // White Rounded Body Sheet with Curve (Matching Book Taxis)
            Expanded(
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 120 + bottomInset),
                    children: [
                      // 3 Quick Action Distinct Tiles (Matching Home Dashboard)
                      Row(
                        children: [
                          Expanded(
                            child: _buildServiceCard(
                              label: 'Landmarks\n& Stalls',
                              iconAsset: 'assets/images/destination.png',
                              onTap: widget.onOpenStalls ??
                                  () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const HornbillStallsScreen(),
                                        ),
                                      ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildServiceCard(
                              label: 'Programs &\nEvents',
                              iconAsset: 'assets/images/trophy.png',
                              onTap: widget.onOpenPrograms ??
                                  () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const HornbillProgramsScreen(),
                                        ),
                                      ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildServiceCard(
                              label: 'Emergency\nServices',
                              iconAsset: 'assets/images/siren.png',
                              onTap: widget.onOpenEmergency ??
                                  () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const EmergencyScreen(),
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Days 1..10 Accordion List (Live Firestore Stream with Fallback)
                      StreamBuilder<Map<String, dynamic>?>(
                        stream: FirebaseService().getHornbillSchedule(),
                        builder: (context, snapshot) {
                          List<Map<String, dynamic>> days = HornbillScheduleData.days;
                          if (snapshot.hasData && snapshot.data != null) {
                            final remoteData = snapshot.data!['data'] as List?;
                            if (remoteData != null && remoteData.isNotEmpty) {
                              days = remoteData.map((d) {
                                final m = Map<String, dynamic>.from(d as Map);
                                final timeline = (m['timeline'] as List?)?.map((t) {
                                  final tMap = Map<String, dynamic>.from(t as Map);
                                  final iconUrl = tMap['icon']?.toString() ?? '';
                                  String localIcon = '';
                                  if (iconUrl.contains('%2F')) {
                                    final iconFile = iconUrl.split('%2F').last.split('?').first;
                                    localIcon = 'assets/images/icons/$iconFile';
                                  }
                                  return {
                                    'time': tMap['time']?.toString() ?? '',
                                    'title': tMap['title']?.toString() ?? '',
                                    'description': tMap['description']?.toString(),
                                    'icon': iconUrl,
                                    'localIcon': localIcon,
                                  };
                                }).toList() ?? [];

                                return {
                                  'day': int.tryParse(m['day'].toString()) ?? 1,
                                  'date': m['date']?.toString() ?? '',
                                  'title': m['title']?.toString() ?? 'Cultural Shows',
                                  'pdf': m['pdf']?.toString() ?? '',
                                  'timeline': timeline,
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
                              final events = (dayInfo['timeline'] as List?) ?? [];
                              final isExpanded = _expandedDay == dayNum;

                              return _buildDayAccordion(
                                dayInfo: dayInfo,
                                events: events,
                                isExpanded: isExpanded,
                                onToggle: () => _toggleDay(dayNum),
                              );
                            },
                          );
                        },
                      ),
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

  // Distinct Service Tile Widget (Matching Home Screen)
  Widget _buildServiceCard({
    required String label,
    required String iconAsset,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconAsset,
              height: 40,
              width: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayAccordion({
    required Map<String, dynamic> dayInfo,
    required List<dynamic> events,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    final dayNum = (dayInfo['day'] is int)
        ? dayInfo['day'] as int
        : (int.tryParse(dayInfo['day'].toString()) ?? 1);
    final dateStr = dayInfo['date']?.toString() ?? '';
    final titleStr = dayInfo['title']?.toString() ?? '';
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

                  // Double Arrow Chevron
                  Icon(
                    isExpanded
                        ? Icons.keyboard_double_arrow_up_rounded
                        : Icons.keyboard_double_arrow_down_rounded,
                    color: const Color(0xFF00334E),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Vertical Alternating Timeline (when expanded)
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
              child: Column(
                children: [
                  // Continuous linear line with timeline items
                  Stack(
                    children: [
                      // Continuous unbroken linear line running through the center
                      Positioned(
                        top: 20,
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 2.5,
                            color: const Color(0xFF5EEAD4),
                          ),
                        ),
                      ),

                      // Column of timeline events with clean gap between items
                      Column(
                        children: List.generate(events.length, (idx) {
                          final event = Map<String, dynamic>.from(events[idx] as Map);
                          final isLeftTime = (idx % 2 == 0);
                          final timeStr = event['time']?.toString() ?? '';
                          final titleStr = event['title']?.toString() ?? '';
                          final descStr = event['description']?.toString();
                          final dynamic iconVal = event['icon'];
                          final String? localIcon = event['localIcon']?.toString();

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: _buildTimelineItem(
                              time: timeStr,
                              title: titleStr,
                              description: descStr,
                              icon: iconVal,
                              localIcon: localIcon,
                              isLeftTime: isLeftTime,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Day Complete Schedule Button
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Day $dayNum: Complete Schedule ↗',
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF00334E),
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
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String time,
    required String title,
    String? description,
    required dynamic icon,
    String? localIcon,
    required bool isLeftTime,
  }) {
    // Time Pill Widget (Mint pill with border)
    Widget timePill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FBF7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF5EEAD4), width: 1.0),
      ),
      child: Text(
        time,
        style: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Color(0xFF0D9488),
        ),
      ),
    );

    // Event Card Widget (Rounded card with dark text and subtitle description)
    Widget eventCard = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              height: 1.25,
            ),
          ),
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              description,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
                height: 1.2,
              ),
            ),
          ],
        ],
      ),
    );

    // Center Node Widget (No boundary, just the icon enlarged on clean white circular mask)
    Widget centerNode = Container(
      height: 38,
      width: 38,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: _buildTimelineIcon(icon, localIcon: localIcon),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Side
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: isLeftTime ? timePill : eventCard,
          ),
        ),

        // Central Timeline Node (44 width)
        SizedBox(
          width: 44,
          child: Center(
            child: centerNode,
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
    );
  }

  Widget _buildTimelineIcon(dynamic icon, {String? localIcon}) {
    // If local asset is available, use it for instant, CORS-free loading
    if (localIcon != null && localIcon.isNotEmpty) {
      return Image.asset(
        localIcon,
        width: 32,
        height: 32,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _buildNetworkOrFallbackIcon(icon),
      );
    }
    return _buildNetworkOrFallbackIcon(icon);
  }

  Widget _buildNetworkOrFallbackIcon(dynamic icon) {
    if (icon is String && icon.startsWith('http')) {
      final webUrl = kIsWeb ? 'https://images.weserv.nl/?url=${Uri.encodeComponent(icon)}' : icon;
      return CachedNetworkImage(
        imageUrl: webUrl,
        width: 32,
        height: 32,
        fit: BoxFit.contain,
        memCacheWidth: 120,
        fadeInDuration: const Duration(milliseconds: 100),
        placeholder: (_, __) => const SizedBox(width: 32, height: 32),
        errorWidget: (_, __, ___) => const Icon(
          Icons.celebration_rounded,
          size: 26,
          color: Color(0xFF20B08D),
        ),
      );
    } else if (icon is IconData) {
      return Icon(icon, size: 26, color: const Color(0xFF20B08D));
    }
    return const Icon(Icons.celebration_rounded, size: 26, color: Color(0xFF20B08D));
  }
}
