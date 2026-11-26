import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/calendar_event.dart';
import '../../services/firebase_service.dart';
import '../../theme/app_theme.dart';

export '../../models/calendar_event.dart';

class CulturalCalendarScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const CulturalCalendarScreen({super.key, this.onBack});

  @override
  State<CulturalCalendarScreen> createState() => _CulturalCalendarScreenState();
}

class _CulturalCalendarScreenState extends State<CulturalCalendarScreen> {
  int _selectedFilterIndex = 0; // 0: All Events, 1: 2026 Schedule, 2: 2027 Festivals

  @override
  void initState() {
    super.initState();
    // Auto-seed to Firestore collection 'cultural_calendar' if empty so user can manage it on Firebase
    FirebaseService().seedCulturalCalendarIfEmpty(_allEvents);
  }

  final List<CalendarEvent> _allEvents = const [
    // OCTOBER 2026
    CalendarEvent(
      title: 'Tsonglak-Nyi',
      month: 'OCT',
      days: '9-12',
      year: '2026',
      monthColor: Color(0xFF20B08D),
      isConfirmed: true,
      tribe: 'Tikhir Tribe',
      location: 'Tikhir Areas',
      dateRange: '9 to 12 October 2026',
      description:
          'Tsonglak-Nyi is the premier harvest and thanksgiving festival of the Tikhir tribe, celebrated with traditional songs, cultural dances, rituals of unity, and invoking blessings for bountiful harvests and peace.',
    ),
    CalendarEvent(
      title: 'Chega Gadi',
      month: 'OCT',
      days: '30-31',
      year: '2026',
      monthColor: Color(0xFF0284C7),
      isConfirmed: true,
      tribe: 'Zeliang Tribe',
      location: 'Peren District and Zeliang Areas',
      dateRange: '30 to 31 October 2026',
      description:
          'Chega Gadi is an important traditional festival of the Zeliang community celebrated with feasting, purification rituals, and community games before the harvest.',
    ),

    // NOVEMBER 2026
    CalendarEvent(
      title: 'Chavang Kut',
      month: 'NOV',
      days: '1',
      year: '2026',
      monthColor: Color(0xFFD97706),
      isConfirmed: true,
      tribe: 'Kuki Tribe',
      location: 'Kuki settlements, including Peren D...',
      dateRange: '1 November 2026',
      description:
          'Chavang Kut is an autumn post-harvest festival celebrated by the Kuki community, marked by songs, dances, and sharing food in gratitude for a bountiful harvest.',
    ),
    CalendarEvent(
      title: 'Tokhu Emong',
      month: 'NOV',
      days: '6-7',
      year: '2026',
      monthColor: Color(0xFFE11D48),
      isConfirmed: true,
      tribe: 'Lotha Tribe',
      location: 'Wokha District',
      dateRange: '6 to 7 November 2026',
      description:
          'Tokhu Emong is the premier post-harvest festival of the Lothas. It is a festival of thanksgiving, forgiveness, and renewal of ties, with traditional songs and community feasts.',
    ),
    CalendarEvent(
      title: 'Ahuna',
      month: 'NOV',
      days: '14-15',
      year: '2026',
      monthColor: Color(0xFF7C3AED),
      isConfirmed: true,
      tribe: 'Sumi Tribe',
      location: 'Zunheboto and Sumi Areas',
      dateRange: '14 to 15 November 2026',
      description:
          'Ahuna is the post-harvest festival of the Sumi Nagas, celebrating the harvest of first crops cooked in freshly cut bamboo stalks accompanied by traditional rituals.',
    ),
    CalendarEvent(
      title: 'Wangala',
      month: 'NOV',
      days: '21',
      year: '2026',
      monthColor: Color(0xFF059669),
      isConfirmed: true,
      tribe: 'Garo Tribe',
      location: 'Dimapur',
      dateRange: '21 November 2026',
      description:
          'Wangala is the post-harvest festival of the Garos, also known as the 100 Drums Festival, offering prayers and thanksgiving to Misi Saljong, the deity of fertility.',
    ),
    CalendarEvent(
      title: 'Ngada',
      month: 'NOV',
      days: '27-28',
      year: '2026',
      monthColor: Color(0xFFEA580C),
      isConfirmed: true,
      tribe: 'Rengma Tribe',
      location: 'Tseminyu District',
      dateRange: '27 to 28 November 2026',
      description:
          'Ngada is the premier post-harvest festival of the Rengmas celebrated over several days with peace agreements, cleaning the village, feasting, and folk dances.',
    ),

    // DECEMBER 2026
    CalendarEvent(
      title: 'Hornbill Festival',
      month: 'DEC',
      days: '1-10',
      year: '2026',
      monthColor: Color(0xFFDC2626),
      isConfirmed: true,
      tribe: 'All Naga tribes Tribe',
      location: 'Naga Heritage Village, Kisama, near...',
      dateRange: '1 to 10 December 2026',
      description:
          'The Festival of Festivals showcasing the rich, vibrant cultural heritage, folk music, warrior dances, crafts, cuisines, and traditions of all indigenous tribes of Nagaland.',
    ),

    // JANUARY 2027
    CalendarEvent(
      title: 'Sukrunye',
      month: 'JAN',
      days: '15',
      year: '2027',
      monthColor: Color(0xFF0284C7),
      isConfirmed: false,
      tribe: 'Chakhesang Tribe',
      location: 'Phek District and Chakhesang Areas',
      dateRange: '15 January 2027',
      description:
          'Sukrunye is the main festival of the Chakhesangs, celebrated to purify the youth, sanctify village households, and seek divine blessings for health and prosperity.',
    ),
    CalendarEvent(
      title: 'Mimkut',
      month: 'JAN',
      days: '17',
      year: '2027',
      monthColor: Color(0xFFD97706),
      isConfirmed: false,
      tribe: 'Kuki Tribe',
      location: 'Athibung, Peren District, and Kuki s...',
      dateRange: '17 January 2027',
      description:
          'Mimkut is celebrated by the Kuki tribe dedicated to the departed souls, expressing gratitude for harvest and seeking blessings for the upcoming agricultural cycle.',
    ),
    CalendarEvent(
      title: 'Bishu',
      month: 'JAN',
      days: '27',
      year: '2027',
      monthColor: Color(0xFF059669),
      isConfirmed: false,
      tribe: 'Kachari Tribe',
      location: 'Dimapur and Kachari settlements',
      dateRange: '27 January 2027',
      description:
          'Bishu is the harvest and new year festival of the Kacharis, celebrated with joyous drumming, traditional Baisugu dances, and community feasting.',
    ),
    CalendarEvent(
      title: 'Poang Lum',
      month: 'JAN',
      days: '13',
      year: '2027',
      monthColor: Color(0xFFE11D48),
      isConfirmed: false,
      tribe: 'Chang Tribe',
      location: 'Tuensang District',
      dateRange: '13 January 2027',
      description:
          'Poang Lum is a post-harvest winter festival of the Changs symbolizing peace, trading, and friendship among villages.',
    ),

    // FEBRUARY 2027
    CalendarEvent(
      title: 'Sekrenyi',
      month: 'FEB',
      days: '25',
      year: '2027',
      monthColor: Color(0xFFDC2626),
      isConfirmed: false,
      tribe: 'Angami Tribe',
      location: 'Kohima and Angami villages',
      dateRange: '25 February 2027',
      description:
          'Sekrenyi, also known as Phousanyi, is the festival of purification and sanctification of body and soul among the Angamis, marked by rituals and community feasts.',
    ),

    // MARCH 2027
    CalendarEvent(
      title: 'Mileinyi',
      month: 'MAR',
      days: '10-11',
      year: '2027',
      monthColor: Color(0xFF0284C7),
      isConfirmed: false,
      tribe: 'Zeliang Tribe',
      location: 'Jalukie and Zeliang Areas',
      dateRange: '10 to 11 March 2027',
      description:
          'Mileinyi is a festival of games, sports, wrestling, and community bonding celebrated by the Zeliang community as winter ends.',
    ),

    // APRIL 2027
    CalendarEvent(
      title: 'Aoleang Monyu',
      month: 'APR',
      days: '1-3',
      year: '2027',
      monthColor: Color(0xFFDC2626),
      isConfirmed: false,
      tribe: 'Konyak Tribe',
      location: 'Mon District and Konyak villages',
      dateRange: '1 to 3 April 2027',
      description:
          'Aoleang is the biggest festival of the Konyaks, marking the welcoming of spring and praying for a fruitful new agricultural season with songs and warrior dances.',
    ),
    CalendarEvent(
      title: 'Monyu',
      month: 'APR',
      days: '4-5',
      year: '2027',
      monthColor: Color(0xFF7C3AED),
      isConfirmed: false,
      tribe: 'Phom Tribe',
      location: 'Longleng District',
      dateRange: '4 to 5 April 2027',
      description:
          'Monyu is the traditional spring festival of the Phom tribe marking the conclusion of winter and commencement of sowing seeds.',
    ),
    CalendarEvent(
      title: 'Moatsu',
      month: 'MAY',
      days: '1-3',
      year: '2027',
      monthColor: Color(0xFF059669),
      isConfirmed: false,
      tribe: 'Ao Tribe',
      location: 'Mokokchung District',
      dateRange: '1 to 3 May 2027',
      description:
          'Moatsu Mong is celebrated by the Ao tribe in early May after clearing and sowing the jhum fields, marked by singing and traditional dances.',
    ),
    CalendarEvent(
      title: 'Tuluni',
      month: 'JUL',
      days: '8',
      year: '2027',
      monthColor: Color(0xFF20B08D),
      isConfirmed: false,
      tribe: 'Sumi Tribe',
      location: 'Zunheboto District',
      dateRange: '8 July 2027',
      description:
          'Tuluni is celebrated to welcome a bountiful harvest, betrothal celebrations, and joyous community sharing of rice beer and food.',
    ),
    CalendarEvent(
      title: 'Naknyulum',
      month: 'JUL',
      days: '29-31',
      year: '2027',
      monthColor: Color(0xFFEA580C),
      isConfirmed: false,
      tribe: 'Chang Tribe',
      location: 'Tuensang District',
      dateRange: '29 to 31 July 2027',
      description:
          'Naknyulum is celebrated by the Chang community with musical instruments like the kongto, celebrating friendship and joy.',
    ),
    CalendarEvent(
      title: 'Metemneo',
      month: 'AUG',
      days: '8',
      year: '2027',
      monthColor: Color(0xFF0284C7),
      isConfirmed: false,
      tribe: 'Yimkhiung Tribe',
      location: 'Shamator & Kiphire',
      dateRange: '8 August 2027',
      description:
          'Metemneo is celebrated after the harvest of millet, offering prayers for the deceased and blessings for infants.',
    ),
    CalendarEvent(
      title: 'Amongmong',
      month: 'SEP',
      days: '3',
      year: '2027',
      monthColor: Color(0xFFD97706),
      isConfirmed: false,
      tribe: 'Sangtam Tribe',
      location: 'Kiphire District',
      dateRange: '3 September 2027',
      description:
          'Amongmong is the premier harvest festival of the Sangtams, seeking blessings for a peaceful life and prosperity.',
    ),
    CalendarEvent(
      title: 'Yemshe',
      month: 'OCT',
      days: '5',
      year: '2027',
      monthColor: Color(0xFF20B08D),
      isConfirmed: false,
      tribe: 'Pochury Tribe',
      location: 'Meluri & Phek Areas',
      dateRange: '5 October 2027',
      description:
          'Yemshe is the grand harvest festival of the Pochury tribe, welcoming the newly harvested crops with joyous traditional celebrations.',
    ),
    CalendarEvent(
      title: 'Khuving Kut',
      month: 'OCT',
      days: '22',
      year: '2027',
      monthColor: Color(0xFF7C3AED),
      isConfirmed: false,
      tribe: 'Kuki Tribe',
      location: 'Peren District',
      dateRange: '22 October 2027',
      description:
          'Khuving Kut is celebrated by the Kuki tribe to invoke blessings for agriculture and general welfare.',
    ),
  ];

  Future<void> _shareEvent(CalendarEvent event) async {
    final statusStr = event.isConfirmed ? 'Confirmed Dates' : 'Tentative Dates';
    final shareText = '''
${event.title} (${event.year})
📅 Date: ${event.dateRange}
📍 Location: ${event.location}
👥 Tribe: ${event.tribe}
Status: $statusStr

About the Celebration:
${event.description}

Explore the Nagaland Cultural Calendar on the Hornbill Festival App!
'''.trim();
    await SharePlus.instance.share(ShareParams(text: shareText, subject: event.title));
  }

  @visibleForTesting
  void showEventDetailModal(CalendarEvent event) {
    _showEventDetailModal(event);
  }

  void _showEventDetailModal(CalendarEvent event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(ctx),
          child: GestureDetector(
            onTap: () {},
            child: DraggableScrollableSheet(
              initialChildSize: 0.72,
              minChildSize: 0.35,
              maxChildSize: 0.88,
              builder: (ctx, scrollController) {
                final modalBottomInset = MediaQuery.of(ctx).padding.bottom > 0
                    ? MediaQuery.of(ctx).padding.bottom
                    : MediaQuery.of(ctx).viewPadding.bottom;

                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: scrollController,
                        padding: EdgeInsets.only(bottom: 95 + modalBottomInset),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Drag Handle
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 12, bottom: 4),
                                width: 38,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCBD5E1),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),

                            // Top Header Bar (Status on left, Share & Close on right)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Left Solid Status Chip
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                                    decoration: BoxDecoration(
                                      color: event.isConfirmed
                                          ? const Color(0xFF16A34A)
                                          : const Color(0xFFD97706),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Text(
                                      event.isConfirmed ? 'CONFIRMED' : 'TENTATIVE',
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),

                                  // Right Action Buttons (Matching styling for both Share & Close)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () => _shareEvent(event),
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFF1F5F9),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.ios_share_rounded,
                                            size: 18,
                                            color: Color(0xFF003848),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () => Navigator.pop(ctx),
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFF1F5F9),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.close_rounded,
                                            size: 20,
                                            color: Color(0xFF003848),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Main Details Body
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Festival Title
                                  Text(
                                    event.title,
                                    style: const TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF0F172A),
                                      letterSpacing: -0.4,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  // Tribe Subtitle with Clean Slate Community Icon
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.groups_rounded,
                                        size: 16,
                                        color: Color(0xFF64748B),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          '${event.tribe}  •  Nagaland Heritage',
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF475569),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Two-Colored Unified Quick Details Panel (Deep Teal + Slate)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFFF1F5F9)),
                                    ),
                                    child: Column(
                                      children: [
                                        // Row 1: DATES & SCHEDULE
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF003848).withValues(alpha: 0.08),
                                                shape: BoxShape.circle,
                                              ),
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.event_available_rounded,
                                                size: 18,
                                                color: Color(0xFF003848),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'DATES & SCHEDULE',
                                                    style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontSize: 10.5,
                                                      fontWeight: FontWeight.w900,
                                                      letterSpacing: 0.6,
                                                      color: Color(0xFF64748B),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    event.dateRange.isNotEmpty ? event.dateRange : '${event.month} ${event.days}, ${event.year}',
                                                    style: const TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontSize: 14.5,
                                                      fontWeight: FontWeight.w800,
                                                      color: Color(0xFF0F172A),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (event.location.isNotEmpty) ...[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            child: Divider(height: 1, color: const Color(0xFFE2E8F0).withValues(alpha: 0.7)),
                                          ),
                                          // Row 2: COMMUNITY & LOCATION
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF003848).withValues(alpha: 0.08),
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                child: const Icon(
                                                  Icons.location_on_rounded,
                                                  size: 18,
                                                  color: Color(0xFF003848),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'COMMUNITY & LOCATION',
                                                      style: TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontSize: 10.5,
                                                        fontWeight: FontWeight.w900,
                                                        letterSpacing: 0.6,
                                                        color: Color(0xFF64748B),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      event.location,
                                                      style: const TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700,
                                                        color: Color(0xFF0F172A),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // ABOUT THE CELEBRATION (Editorial flow without gray box enclosure)
                                  const Text(
                                    'ABOUT THE CELEBRATION',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF003848),
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    event.description,
                                    style: const TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF334155),
                                      height: 1.6,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                  const SizedBox(height: 18),

                                  // Highlight Tags Wrap
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      event.tribe,
                                      event.year,
                                      'Nagaland Festival',
                                      _fullMonthName(event.month),
                                    ].map((tag) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          tag,
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF475569),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom Sticky CTA Button (Share Festival Details)
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 20 + modalBottomInset,
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () => _shareEvent(event),
                            icon: const Icon(
                              Icons.ios_share_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: const Text(
                              'Share Festival Details',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF003848),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: const Color(0xFF003848).withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CalendarEvent>>(
      stream: FirebaseService().getCulturalCalendarEvents(),
      builder: (context, snapshot) {
        final allEvents = (snapshot.hasData && snapshot.data!.isNotEmpty)
            ? snapshot.data!
            : _allEvents;

        // Filter events by selected tab
        var list = allEvents;
        if (_selectedFilterIndex == 1) {
          list = list.where((e) => e.year == '2026').toList();
        } else if (_selectedFilterIndex == 2) {
          list = list.where((e) => e.year == '2027').toList();
        }

        // Group by Month Year
        final Map<String, List<CalendarEvent>> grouped = {};
        for (final event in list) {
          final key = '${_fullMonthName(event.month)} ${event.year}';
          grouped.putIfAbsent(key, () => []).add(event);
        }

        return Scaffold(
          backgroundColor: const Color(0xFF003848),
          body: SafeArea(
            bottom: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Deep Teal Top Header (Strictly left-aligned to match all screens)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                  child: SizedBox(
                    width: double.infinity,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cultural Calendar',
                          style: AppTextStyles.headerTitle,
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Nagaland Festivals 2026 – 2027',
                          style: AppTextStyles.headerSubtitle,
                        ),
                      ],
                    ),
                  ),
                ),

                // Horizontal Filter Pills (Edge-to-edge scrollable with no clipping)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildFilterPill(
                          title: 'All Events (${allEvents.length})',
                          isSelected: _selectedFilterIndex == 0,
                          onTap: () => setState(() => _selectedFilterIndex = 0),
                        ),
                    const SizedBox(width: 8),
                    _buildFilterPill(
                      title: '2026 Schedule',
                      isSelected: _selectedFilterIndex == 1,
                      onTap: () => setState(() => _selectedFilterIndex = 1),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterPill(
                      title: '2027 Festivals',
                      isSelected: _selectedFilterIndex == 2,
                      onTap: () => setState(() => _selectedFilterIndex = 2),
                    ),
                  ],
                ),
              ),
            ),

            // White Rounded Body Sheet
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  child: grouped.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE2E8F0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.event_busy_rounded,
                                    size: 32,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'No Festivals Found',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'No festival events scheduled for this selection.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 13.5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                          itemCount: grouped.keys.length,
                          itemBuilder: (context, groupIndex) {
                            final monthKey = grouped.keys.elementAt(groupIndex);
                            final events = grouped[monthKey]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Month Section Header
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF003848),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          monthKey.toUpperCase(),
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 11,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${events.length} ${events.length == 1 ? 'festival' : 'festivals'}',
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Event Cards (Compact height with clean vector calendar date tile)
                                ...events.map((event) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.03),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(16),
                                        onTap: () => _showEventDetailModal(event),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              // Crisp Vector Calendar Date Tile
                                              Container(
                                                width: 50,
                                                height: 52,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFF8FAFC),
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: event.monthColor.withValues(alpha: 0.35),
                                                    width: 1.2,
                                                  ),
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                child: Column(
                                                  children: [
                                                    // Top Month Strip (Distinct Cultural Color)
                                                    Container(
                                                      height: 19,
                                                      width: double.infinity,
                                                      color: event.monthColor,
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        event.month.toUpperCase(),
                                                        style: const TextStyle(
                                                          fontFamily: 'Lato',
                                                          fontSize: 9.5,
                                                          fontWeight: FontWeight.w900,
                                                          color: Colors.white,
                                                          letterSpacing: 0.6,
                                                          height: 1.0,
                                                        ),
                                                      ),
                                                    ),
                                                    // Day Number Pad
                                                    Expanded(
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 2),
                                                          child: FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            child: Text(
                                                              event.days,
                                                              style: const TextStyle(
                                                                fontFamily: 'Lato',
                                                                fontSize: 14.5,
                                                                fontWeight: FontWeight.w900,
                                                                color: Color(0xFF0F172A),
                                                                height: 1.0,
                                                                letterSpacing: -0.3,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 12),

                                              // Middle Details: Festival Title & Subtitle
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      event.title,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontWeight: FontWeight.w900,
                                                        fontSize: 15.5,
                                                        letterSpacing: -0.2,
                                                        color: Color(0xFF0F172A),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      event.location.isNotEmpty
                                                          ? '${event.tribe} • ${event.location}'
                                                          : event.tribe,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                        color: Color(0xFF64748B),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),

                                              // Right: Status Chip & Double Arrow
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                                    decoration: BoxDecoration(
                                                      color: event.isConfirmed
                                                          ? const Color(0xFF16A34A)
                                                          : const Color(0xFFD97706),
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Text(
                                                      event.isConfirmed ? 'CONFIRMED' : 'TENTATIVE',
                                                      style: const TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontSize: 8.5,
                                                        fontWeight: FontWeight.w900,
                                                        color: Colors.white,
                                                        letterSpacing: 0.4,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Icon(
                                                    Icons.keyboard_double_arrow_right_rounded,
                                                    size: 16,
                                                    color: event.monthColor,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 4),
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
  },
);
  }

  Widget _buildFilterPill({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? const Color(0xFF003848) : Colors.white,
          ),
        ),
      ),
    );
  }

  String _fullMonthName(String abbrev) {
    switch (abbrev) {
      case 'OCT':
        return 'October';
      case 'NOV':
        return 'November';
      case 'DEC':
        return 'December';
      case 'JAN':
        return 'January';
      case 'FEB':
        return 'February';
      case 'MAR':
        return 'March';
      case 'APR':
        return 'April';
      case 'MAY':
        return 'May';
      case 'JUL':
        return 'July';
      case 'AUG':
        return 'August';
      case 'SEP':
        return 'September';
      default:
        return abbrev;
    }
  }
}
