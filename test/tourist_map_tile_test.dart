import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hornbill_festival/widgets/tourist_map_banner_tile.dart';
import 'package:hornbill_festival/screens/home/home_dashboard_screen.dart';
import 'package:hornbill_festival/screens/nagaland/nagaland_home_screen.dart';

void main() {
  testWidgets('TouristMapBannerTile renders clean icon, title, and background elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TouristMapBannerTile(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('GOOGLE MAPS'), findsOneWidget);
    expect(find.text('NAGALAND TOURIST MAP'), findsOneWidget);
    expect(find.text('[30 ICONIC SPOTS]'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('HomeDashboardScreen displays TouristMapBannerTile',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeDashboardScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(TouristMapBannerTile), findsOneWidget);
  });

  testWidgets('NagalandHomeScreen displays TouristMapBannerTile',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NagalandHomeScreen(
            onSelectDistrict: (_) {},
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(TouristMapBannerTile), findsOneWidget);
  });
}
