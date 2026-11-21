import 'package:flutter/material.dart';

class CalendarEvent {
  final String title;
  final String month;
  final String days;
  final String year;
  final Color monthColor;
  final bool isConfirmed;
  final String tribe;
  final String tribeShort;
  final String location;
  final String dateRange;
  final String description;

  const CalendarEvent({
    required this.title,
    required this.month,
    required this.days,
    required this.year,
    required this.monthColor,
    required this.isConfirmed,
    required this.tribe,
    required this.tribeShort,
    required this.location,
    required this.dateRange,
    required this.description,
  });
}

class FestivalsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const FestivalsScreen({super.key, this.onBack});

  @override
  State<FestivalsScreen> createState() => _FestivalsScreenState();
}

class _FestivalsScreenState extends State<FestivalsScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0; // 0: All Events, 1: 2026 Schedule, 2: 2027 Festivals

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
      tribeShort: 'Tikhir',
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
      tribeShort: 'Zeliang',
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
      tribeShort: 'Kuki',
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
      tribeShort: 'Lotha',
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
      tribeShort: 'Sumi',
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
      tribeShort: 'Garo',
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
      tribeShort: 'Rengma',
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
      tribeShort: 'All Naga tribes',
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
      tribeShort: 'Chakhesang',
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
      tribeShort: 'Kuki',
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
      tribeShort: 'Kachari',
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
      tribeShort: 'Chang',
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
      tribeShort: 'Angami',
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
      tribeShort: 'Zeliang',
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
      tribeShort: 'Konyak',
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
      tribeShort: 'Phom',
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
      tribeShort: 'Ao',
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
      tribeShort: 'Sumi',
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
      tribeShort: 'Chang',
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
      tribeShort: 'Yimkhiung',
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
      tribeShort: 'Sangtam',
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
      tribeShort: 'Pochury',
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
      tribeShort: 'Kuki',
      location: 'Peren District',
      dateRange: '22 October 2027',
      description:
          'Khuving Kut is celebrated by the Kuki tribe to invoke blessings for agriculture and general welfare.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showEventDetailModal(CalendarEvent event) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Date Pill & Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2FAF4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 15,
                            color: Color(0xFF20B08D),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            event.dateRange,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00796B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Title: Festival Name
                Text(
                  event.title,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),

                // Chips Row: Tribe & Location
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2FAF4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.groups_outlined,
                            size: 16,
                            color: Color(0xFF20B08D),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            event.tribeShort,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00796B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                event.location,
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF475569),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // STATUS Label
                const Text(
                  'STATUS',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),

                // Status Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: event.isConfirmed
                        ? const Color(0xFFE2FAF4)
                        : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        event.isConfirmed ? Icons.check_circle : Icons.schedule,
                        size: 16,
                        color: event.isConfirmed
                            ? const Color(0xFF20B08D)
                            : const Color(0xFFD97706),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        event.isConfirmed
                            ? 'Confirmed ${event.year} Schedule'
                            : 'Usual Dates',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: event.isConfirmed
                              ? const Color(0xFF00796B)
                              : const Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // About Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ABOUT THE CELEBRATION',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF94A3B8),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 13.5,
                          height: 1.5,
                          color: Color(0xFF334155),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Got It Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF052B3B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Got It',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    // Filter events
    var list = _allEvents;
    if (_selectedFilterIndex == 1) {
      list = list.where((e) => e.year == '2026').toList();
    } else if (_selectedFilterIndex == 2) {
      list = list.where((e) => e.year == '2027').toList();
    }

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((e) {
        return e.title.toLowerCase().contains(query) ||
            e.tribe.toLowerCase().contains(query) ||
            e.location.toLowerCase().contains(query);
      }).toList();
    }

    // Group by Month Year
    final Map<String, List<CalendarEvent>> grouped = {};
    for (final event in list) {
      final key = '${_fullMonthName(event.month)} ${event.year}';
      grouped.putIfAbsent(key, () => []).add(event);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Circular back button
                  GestureDetector(
                    onTap: () {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        size: 26,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Center title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Cultural Calendar',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Nagaland Festivals 2026 – 2027',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Trailing "23" badge
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2FAF4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '23',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF00796B),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                children: [
                  // Gradient Banner Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF052B3B), Color(0xFF0A445C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pill Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 12,
                                color: Color(0xFF20B08D),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'OCT 2026 – OCT 2027   Official & Community List',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF20B08D),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Title
                        const Text(
                          'Nagaland Cultural Calendar',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Subtitle
                        const Text(
                          'Discover the vibrant tapestry of celebrations across all indigenous Naga tribes, including dates, tribal communities, and host locations.',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 12.5,
                            height: 1.4,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Search by festival, tribe, or District...',
                        hintStyle: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 13.5,
                          color: Color(0xFF94A3B8),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Filter Pills Row
                  Row(
                    children: [
                      // All Events (23)
                      GestureDetector(
                        onTap: () => setState(() => _selectedFilterIndex = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _selectedFilterIndex == 0
                                ? const Color(0xFF052B3B)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _selectedFilterIndex == 0
                                  ? const Color(0xFF052B3B)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            'All Events (23)',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: _selectedFilterIndex == 0
                                  ? Colors.white
                                  : const Color(0xFF334155),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // 2026 Schedule
                      GestureDetector(
                        onTap: () => setState(() => _selectedFilterIndex = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _selectedFilterIndex == 1
                                ? const Color(0xFF052B3B)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _selectedFilterIndex == 1
                                  ? const Color(0xFF052B3B)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 7,
                                width: 7,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF20B08D),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '2026 Schedule',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedFilterIndex == 1
                                      ? Colors.white
                                      : const Color(0xFF334155),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // 2027 Festivals
                      GestureDetector(
                        onTap: () => setState(() => _selectedFilterIndex = 2),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _selectedFilterIndex == 2
                                ? const Color(0xFF052B3B)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _selectedFilterIndex == 2
                                  ? const Color(0xFF052B3B)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 7,
                                width: 7,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF59E0B),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '2027 Festivals',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedFilterIndex == 2
                                      ? Colors.white
                                      : const Color(0xFF334155),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Month Sections
                  ...grouped.entries.map((entry) {
                    final monthName = entry.key;
                    final events = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Month Header Row
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12, top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 3.5,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF20B08D),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    monthName.toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1E293B),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${events.length} Celebration${events.length > 1 ? 's' : ''}',
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 12,
                                  color: Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Events Cards List
                        ...events.map((event) {
                          return GestureDetector(
                            onTap: () => _showEventDetailModal(event),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: const Color(0xFFF1F5F9)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Date Box on left
                                  Container(
                                    width: 60,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFFE2E8F0)),
                                    ),
                                    child: Column(
                                      children: [
                                        // Month Header Pill
                                        Container(
                                          width: double.infinity,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: event.monthColor,
                                            borderRadius: const BorderRadius.vertical(
                                              top: Radius.circular(11),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            event.month,
                                            style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 11,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        // Days
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              event.days,
                                              style: const TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Year
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 3),
                                          child: Text(
                                            event.year,
                                            style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 9.5,
                                              color: Color(0xFF94A3B8),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Center Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Confirmed badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2.5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: event.isConfirmed
                                                ? const Color(0xFFE2FAF4)
                                                : const Color(0xFFFEF3C7),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                event.isConfirmed
                                                    ? Icons.check_circle
                                                    : Icons.schedule,
                                                size: 11,
                                                color: event.isConfirmed
                                                    ? const Color(0xFF20B08D)
                                                    : const Color(0xFFD97706),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                event.isConfirmed
                                                    ? 'Confirmed'
                                                    : 'Usual Dates',
                                                style: TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: event.isConfirmed
                                                      ? const Color(0xFF00796B)
                                                      : const Color(0xFF92400E),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),

                                        // Title
                                        Text(
                                          event.title,
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),

                                        // Tribe
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.groups_outlined,
                                              size: 14,
                                              color: Color(0xFF64748B),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                event.tribe,
                                                style: const TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontSize: 12,
                                                  color: Color(0xFF64748B),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),

                                        // Location
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              size: 14,
                                              color: Color(0xFF64748B),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                event.location,
                                                style: const TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontSize: 12,
                                                  color: Color(0xFF94A3B8),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Trailing Button
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF20B08D),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.keyboard_double_arrow_right_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
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
