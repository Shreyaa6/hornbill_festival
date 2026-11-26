import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/data/nagaland_data.dart';
import 'package:hornbill_festival/screens/nagaland/district_detail_screen.dart';

void main() {
  group('DistrictDetailScreen Accordion Tests', () {
    testWidgets('Spot accordions allow only one item open at a time (single expansion)',
        (tester) async {
      final district = NagalandData.districts.first; // Kohima with multiple spots

      await tester.pumpWidget(
        MaterialApp(
          home: DistrictDetailScreen(district: district),
        ),
      );
      await tester.pumpAndSettle();

      // Initially no spot is expanded
      expect(district.spots.length, greaterThan(1));
      final firstSpot = district.spots[0];
      final secondSpot = district.spots[1];

      // Tap first spot to expand
      await tester.ensureVisible(find.text(firstSpot.name));
      await tester.pumpAndSettle();
      await tester.tap(find.text(firstSpot.name));
      await tester.pumpAndSettle();

      // First spot description is visible
      expect(find.text(firstSpot.description), findsOneWidget);

      // Tap second spot to expand: should close first spot and open second
      await tester.ensureVisible(find.text(secondSpot.name));
      await tester.pumpAndSettle();
      await tester.tap(find.text(secondSpot.name));
      await tester.pumpAndSettle();

      // Second spot is open, first spot is closed
      expect(find.text(secondSpot.description), findsOneWidget);
      expect(find.text(firstSpot.description), findsNothing);

      // Tapping the second spot again collapses it
      await tester.ensureVisible(find.text(secondSpot.name));
      await tester.pumpAndSettle();
      await tester.tap(find.text(secondSpot.name));
      await tester.pumpAndSettle();
      expect(find.text(secondSpot.description), findsNothing);
    });
  });
}
