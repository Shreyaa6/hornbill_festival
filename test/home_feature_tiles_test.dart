import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hornbill_festival/screens/home/home_dashboard_screen.dart';
import 'package:hornbill_festival/widgets/tourist_map_banner_tile.dart';

void main() {
  testWidgets('HomeDashboardScreen renders all 4 featured cards with custom background elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeDashboardScreen(),
        ),
      ),
    );
    await tester.pump();

    // Verify all 4 card titles
    expect(find.text('PHOTO CONTEST 2026'), findsOneWidget);
    expect(find.text('DISCOVER VIEWPOINT'), findsOneWidget);
    expect(find.text('TOURISM E-MAGAZINE'), findsOneWidget);
    expect(find.text('NAGALAND TOURIST MAP'), findsOneWidget);

    // Verify all 4 cards have CustomPaint background elements
    expect(find.byType(CustomPaint), findsWidgets);

    // Verify specific watermark icons exist
    expect(find.byIcon(Icons.photo_camera_rounded), findsOneWidget);
    expect(find.byIcon(Icons.landscape_rounded), findsOneWidget);
    expect(find.byIcon(Icons.auto_stories_rounded), findsOneWidget);
    expect(find.byIcon(Icons.explore_rounded), findsOneWidget);

    // Verify TouristMapBannerTile is present
    expect(find.byType(TouristMapBannerTile), findsOneWidget);
  });
}
