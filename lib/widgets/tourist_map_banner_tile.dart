import 'package:flutter/material.dart';
import '../screens/home/tourist_map_screen.dart';

class TouristMapBannerTile extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;

  const TouristMapBannerTile({
    super.key,
    this.margin = const EdgeInsets.symmetric(horizontal: 18),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFF6FAF8),
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
            // Background Elements: Topo contour curves & waypoint trail
            Positioned.fill(
              child: CustomPaint(
                painter: const _TouristMapTileBackgroundPainter(),
              ),
            ),

            // Background Elements: Subtle Compass / Navigation watermark
            Positioned(
              right: -8,
              bottom: -10,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.045,
                  child: const Icon(
                    Icons.explore_rounded,
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
                onTap: onTap ??
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TouristMapScreen(),
                        ),
                      );
                    },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      // Left Clean Google Maps Icon
                      SizedBox(
                        width: 58,
                        height: 52,
                        child: Image.asset(
                          'assets/images/card_map_icon_clean.png',
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
                              'GOOGLE MAPS',
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
                              'NAGALAND TOURIST MAP',
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
                              '[30 ICONIC SPOTS]',
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
    );
  }
}

class _TouristMapTileBackgroundPainter extends CustomPainter {
  const _TouristMapTileBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final contourPaint = Paint()
      ..color = const Color(0xFF0D9488).withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    // Contour curve 1
    final path1 = Path();
    path1.moveTo(size.width * 0.52, 0);
    path1.cubicTo(
      size.width * 0.65,
      size.height * 0.45,
      size.width * 0.82,
      size.height * 0.20,
      size.width,
      size.height * 0.65,
    );
    canvas.drawPath(path1, contourPaint);

    // Contour curve 2
    final path2 = Path();
    path2.moveTo(size.width * 0.62, 0);
    path2.cubicTo(
      size.width * 0.74,
      size.height * 0.58,
      size.width * 0.88,
      size.height * 0.35,
      size.width,
      size.height * 0.95,
    );
    canvas.drawPath(path2, contourPaint);

    // Subtle expedition waypoint dots
    final dotPaint = Paint()
      ..color = const Color(0xFF003848).withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(size.width * 0.73, size.height * 0.72), 2.2, dotPaint);
    canvas.drawCircle(
        Offset(size.width * 0.81, size.height * 0.54), 2.2, dotPaint);
    canvas.drawCircle(
        Offset(size.width * 0.89, size.height * 0.42), 2.2, dotPaint);

    // Small waypoint target ring
    final ringPaint = Paint()
      ..color = const Color(0xFF0D9488).withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawCircle(
        Offset(size.width * 0.89, size.height * 0.42), 5.0, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
