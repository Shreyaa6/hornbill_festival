import 'package:flutter/material.dart';
import '../../data/mock_user.dart';
import 'festivals_screen.dart';
import 'tribes_screen.dart';
import 'cultural_calendar_screen.dart';

class CulturesFlowScreen extends StatelessWidget {
  final ValueChanged<bool>? onHeaderVisibilityChanged;

  const CulturesFlowScreen({super.key, this.onHeaderVisibilityChanged});

  void _openFestivals(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FestivalsScreen(),
      ),
    );
  }

  void _openTribes(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TribesScreen(),
      ),
    );
  }

  void _openCalendar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CulturalCalendarScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CulturesScreen(
      key: const ValueKey('cultures_main_view'),
      onOpenFestivals: () => _openFestivals(context),
      onOpenTribes: () => _openTribes(context),
      onOpenCalendar: () => _openCalendar(context),
    );
  }
}

class CulturesScreen extends StatelessWidget {
  final VoidCallback? onOpenFestivals;
  final VoidCallback? onOpenTribes;
  final VoidCallback? onOpenCalendar;

  const CulturesScreen({
    super.key,
    this.onOpenFestivals,
    this.onOpenTribes,
    this.onOpenCalendar,
  });

  @override
  Widget build(BuildContext context) {
    final mockUser = MockUser();
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 100 + bottomInset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Greeting Header
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
                        final name = mockUser.isLoggedIn
                            ? mockUser.name
                            : (mockUser.name.isNotEmpty && mockUser.name != "Guest User"
                                ? mockUser.name
                                : "Guest");
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
                      'Explore Cultures',
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

            // Two Large Side-by-Side Cards (Festivals & Tribes)
            Row(
              children: [
                // Festivals Card
                _buildCultureTile(
                  title: 'Festivals',
                  subtitle: '18 Festivals',
                  imageAsset: 'assets/images/tile_festivals.jpg',
                  onTap: () {
                    if (onOpenFestivals != null) {
                      onOpenFestivals!();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FestivalsScreen(),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(width: 14),

                // Tribes Card
                _buildCultureTile(
                  title: 'Tribes',
                  subtitle: '18 Tribes',
                  imageAsset: 'assets/images/tile_tribes.jpg',
                  onTap: () {
                    if (onOpenTribes != null) {
                      onOpenTribes!();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TribesScreen(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Nagaland Heritage: Cultural Calendar Card (styled matching Home Page feature cards)
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Color(0xFFFBF8F2),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Background Elements: Calendar grid & sparkle accents
                    Positioned.fill(
                      child: CustomPaint(
                        painter: const _CulturalCalendarTileBackgroundPainter(),
                      ),
                    ),

                    // Background Elements: Subtle Calendar Watermark Icon
                    Positioned(
                      right: -8,
                      bottom: -10,
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: 0.045,
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            size: 88,
                            color: Color(0xFF003848),
                          ),
                        ),
                      ),
                    ),

                    // Foreground Content with InkWell
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          if (onOpenCalendar != null) {
                            onOpenCalendar!();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CulturalCalendarScreen(),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              // Clean 3D Calendar Icon with transparent background
                              SizedBox(
                                width: 58,
                                height: 52,
                                child: Image.asset(
                                  'assets/images/calendar_3d_icon.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Center Text (Eyebrow, Title, Action Tag)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'NAGALAND HERITAGE',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11,
                                        letterSpacing: 0.6,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'CULTURAL CALENDAR',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17,
                                        letterSpacing: -0.3,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      '[VIEW 2026 CALENDAR]',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12.5,
                                        color: Color(0xFF0D9488),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildCultureTile({
    required String title,
    required String subtitle,
    required String imageAsset,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Authentic Background Image
                Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF003848),
                  ),
                ),

                // Smooth Dark Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.25),
                        Colors.black.withValues(alpha: 0.85),
                      ],
                      stops: const [0.2, 0.55, 1.0],
                    ),
                  ),
                ),

                // Card Text Content & Action Pill
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_double_arrow_right_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Subtle calendar month grid and event accents for the Cultural Calendar tile
class _CulturalCalendarTileBackgroundPainter extends CustomPainter {
  const _CulturalCalendarTileBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFD97706).withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;

    // Mini calendar outline in background
    final left = size.width * 0.72;
    final top = size.height * 0.22;
    final w = size.width * 0.22;
    final h = size.height * 0.58;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, w, h),
        const Radius.circular(8),
      ),
      gridPaint,
    );

    // Header divider line
    canvas.drawLine(
      Offset(left, top + h * 0.32),
      Offset(left + w, top + h * 0.32),
      gridPaint,
    );

    // Subtle date dots
    final dotPaint = Paint()
      ..color = const Color(0xFFD97706).withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    for (int r = 0; r < 2; r++) {
      for (int c = 0; c < 3; c++) {
        final cx = left + w * 0.22 + c * (w * 0.28);
        final cy = top + h * 0.52 + r * (h * 0.25);
        canvas.drawCircle(Offset(cx, cy), 1.8, dotPaint);
      }
    }

    // Celebration sparkle / diamond
    final sparklePaint = Paint()
      ..color = const Color(0xFF20B08D).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final sx = size.width * 0.64;
    final sy = size.height * 0.40;
    const slen = 5.0;
    canvas.drawLine(Offset(sx - slen, sy), Offset(sx + slen, sy), sparklePaint);
    canvas.drawLine(Offset(sx, sy - slen), Offset(sx, sy + slen), sparklePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
