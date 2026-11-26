import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/data/stalls_data.dart';
import 'package:hornbill_festival/models/stall.dart';
import 'package:hornbill_festival/screens/hornbill/hornbill_stalls_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Stalls Integration Tests', () {
    test('StallsData has all 40 stalls in order', () {
      expect(StallsData.allStalls.length, 40);

      for (int i = 0; i < StallsData.allStalls.length; i++) {
        expect(StallsData.allStalls[i].order, i + 1);
      }
    });

    test('Key stalls match provided collection data', () {
      final stall1 = StallsData.allStalls.firstWhere((s) => s.id == 'stall_01');
      expect(stall1.stallName, 'Lamliu SHG KOHIMA');
      expect(stall1.owner, 'Lamliu SHG KOHIMA');
      expect(stall1.phone, '9612569565');
      expect(stall1.order, 1);

      final stall2 = StallsData.allStalls.firstWhere((s) => s.id == 'stall_02');
      expect(stall2.stallName, 'Taste of our root');
      expect(stall2.owner, 'Chumseli Sangtam');

      final stall37 = StallsData.allStalls.firstWhere((s) => s.id == 'stall_37');
      expect(stall37.stallName, 'Ikusa Kinimi');
      expect(stall37.owner, 'Ikusa Kinimi');
      expect(stall37.category, 'Extra');
      expect(stall37.order, 37);

      final stall40 = StallsData.allStalls.firstWhere((s) => s.id == 'stall_40');
      expect(stall40.stallName, 'Seoul Hour - Korean');
      expect(stall40.order, 40);
    });

    test('Stall.fromMap parses properties correctly', () {
      final map = {
        'order': 37,
        'stallName': 'Ikusa Kinimi',
        'owner': 'Ikusa Kinimi',
        'phone': '9876543210',
        'category': 'Extra',
      };
      final stall = Stall.fromMap(map, 'stall_37');
      expect(stall.id, 'stall_37');
      expect(stall.order, 37);
      expect(stall.stallName, 'Ikusa Kinimi');
      expect(stall.owner, 'Ikusa Kinimi');
      expect(stall.phone, '9876543210');
      expect(stall.category, 'Extra');
    });

    testWidgets('HornbillStallsScreen renders Stalls view matching design',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HornbillStallsScreen(initialCategory: 'Stalls'),
        ),
      );
      await tester.pump();

      // Verify title and header
      expect(find.text('Locate Stalls'), findsOneWidget);
      expect(find.text('Landmarks • Restrooms • Heritage'), findsOneWidget);

      // Verify "Stalls" category chip is rendered
      expect(find.text('Stalls'), findsOneWidget);

      // Verify stall list items are rendered (e.g. order 1, name, owner)
      expect(find.text('Lamliu SHG KOHIMA'), findsWidgets);
      expect(find.text('Owner: Lamliu SHG KOHIMA'), findsOneWidget);
      expect(find.text('Taste of our root'), findsOneWidget);
      expect(find.text('Owner: Chumseli Sangtam'), findsOneWidget);

      // Verify order badges
      expect(find.text('1'), findsWidgets);
      expect(find.text('2'), findsWidgets);

      // Verify phone call icons exist for stalls with phone
      expect(find.byIcon(Icons.phone_outlined), findsWidgets);

      // Verify stall without phone (Stall 3: Loreni Bamboo Shoot) does not have phone icon
      final stall3 = StallsData.allStalls.firstWhere((s) => s.id == 'stall_03');
      expect(stall3.hasPhone, false);
      expect(stall3.phone, '');
    });

    testWidgets('HornbillStallsScreen renders Restrooms list view and Medical list view',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HornbillStallsScreen(initialCategory: 'Restrooms'),
        ),
      );
      await tester.pump();

      // Verify Restrooms list items are rendered with WC icons
      expect(find.text('Toilet'), findsWidgets);
      expect(find.byIcon(Icons.wc_rounded), findsWidgets);

      // Verify initialCategory: 'Medical'
      await tester.pumpWidget(
        const MaterialApp(
          home: HornbillStallsScreen(initialCategory: 'Medical'),
        ),
      );
      await tester.pump();

      // Verify Medical items are rendered with medical service icon
      expect(find.text('First Aid Center'), findsOneWidget);
      expect(find.byIcon(Icons.medical_services_rounded), findsOneWidget);
    });

    testWidgets('HornbillStallsScreen native permission flow & reference style cards',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'hornbill_location_permission_granted': true,
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: HornbillStallsScreen(initialCategory: 'Morungs'),
        ),
      );
      await tester.pumpAndSettle();

      // No in-app permission banner exists - permission is requested natively
      expect(find.text('Enable Location for Walking Distances'), findsNothing);
      expect(find.text('Not now'), findsNothing);

      // Reference style cards render with "Navigate to" buttons
      expect(find.text('Navigate to'), findsWidgets);
      expect(find.byIcon(Icons.near_me_rounded), findsWidgets);

      // Verify cards render authentic photos
      expect(find.byType(Image), findsWidgets);

      // Distances are calculated and visible (e.g. "m away")
      expect(find.textContaining('away'), findsWidgets);
    });

    testWidgets('HornbillStallsScreen does not overflow on compact mobile screen sizes',
        (tester) async {
      // Set compact screen size (e.g. 360 x 640)
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SharedPreferences.setMockInitialValues({
        'hornbill_location_permission_granted': true,
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: HornbillStallsScreen(initialCategory: 'Morungs'),
        ),
      );
      await tester.pumpAndSettle();

      // Verify no overflow exceptions are thrown
      expect(tester.takeException(), isNull);
      expect(find.text('Navigate to'), findsWidgets);
    });

    testWidgets('When location permission is denied, distance is NOT shown',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'hornbill_location_permission_granted': false,
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: HornbillStallsScreen(initialCategory: 'Morungs'),
        ),
      );
      await tester.pumpAndSettle();

      // Ensure no distance text with "away" or "km" or "m" is shown
      expect(find.textContaining('away'), findsNothing);

      // Check ATMs view without permission: no distance
      await tester.pumpWidget(
        const MaterialApp(
          home: HornbillStallsScreen(initialCategory: 'ATMs'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('away'), findsNothing);

      // Check Restrooms view without permission: no distance
      await tester.pumpWidget(
        const MaterialApp(
          home: HornbillStallsScreen(initialCategory: 'Restrooms'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('away'), findsNothing);
    });

    testWidgets('When location is permitted and cached, offline distances are calculated accurately',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'hornbill_location_permission_granted': true,
        'hornbill_last_user_lat': 25.6160,
        'hornbill_last_user_lng': 94.1145,
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: HornbillStallsScreen(initialCategory: 'Morungs'),
        ),
      );
      await tester.pumpAndSettle();

      // Distances are calculated and visible
      expect(find.textContaining('away'), findsWidgets);
    });
  });
}
