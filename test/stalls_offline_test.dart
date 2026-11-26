import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/data/landmarks_data.dart';
import 'package:hornbill_festival/data/stalls_data.dart';
import 'package:hornbill_festival/screens/hornbill/hornbill_stalls_screen.dart';
import 'package:hornbill_festival/services/offline_data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Hornbill Stalls & Landmarks Offline Verification Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({
        'hornbill_location_permission_granted': true,
        'hornbill_last_user_lat': 25.6160,
        'hornbill_last_user_lng': 94.1145,
      });
    });

    test('OfflineDataService provides bundled seed data when offline', () async {
      final offlineService = OfflineDataService();
      final landmarks = await offlineService.getCachedLandmarks();
      expect(landmarks.length, LandmarksData.allLandmarks.length);
      expect(landmarks.length, 59);

      final stalls = await offlineService.getCachedStalls();
      expect(stalls.length, StallsData.allStalls.length);
      expect(stalls.length, 40);
    });

    testWidgets('HornbillStallsScreen renders Stalls view offline without network',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HornbillStallsScreen(initialCategory: 'Stalls'),
        ),
      );
      await tester.pump();

      // Verify title & subtitle
      expect(find.text('Locate Stalls'), findsOneWidget);
      expect(find.text('Landmarks • Restrooms • Heritage'), findsOneWidget);

      // Verify first stall from bundled seed data
      expect(find.text('Lamliu SHG KOHIMA'), findsWidgets);
      expect(find.text('Owner: Lamliu SHG KOHIMA'), findsOneWidget);

      // Verify order badge
      expect(find.text('1'), findsWidgets);

      // Verify call button exists
      expect(find.byIcon(Icons.phone_outlined), findsWidgets);
    });

    testWidgets('HornbillStallsScreen renders Morungs view offline with distances',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HornbillStallsScreen(initialCategory: 'Morungs'),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Morungs are displayed
      expect(find.text('Heritage Morungs'), findsOneWidget);
      expect(find.textContaining('Morung'), findsWidgets);
      expect(find.text('Navigate to'), findsWidgets);

      // Verify distance tags are computed locally using LatLng
      expect(find.textContaining('away'), findsWidgets);
    });

    testWidgets('HornbillStallsScreen renders Restrooms and ATMs offline',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HornbillStallsScreen(initialCategory: 'Restrooms'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Restroom Facilities'), findsOneWidget);
      expect(find.textContaining('Toilet'), findsWidgets);

      await tester.pumpWidget(
        const MaterialApp(
          home: HornbillStallsScreen(initialCategory: 'ATMs'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Nearby ATMs'), findsOneWidget);
      expect(find.text('ATM'), findsWidgets);
    });

    testWidgets('Category chips switch seamlessly without throwing errors when offline',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HornbillStallsScreen(initialCategory: 'Attractions'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Popular Attractions'), findsOneWidget);

      // Tap Stalls chip
      await tester.tap(find.text('Stalls'));
      await tester.pumpAndSettle();

      expect(find.text('Lamliu SHG KOHIMA'), findsWidgets);

      // Tap ATMs chip
      await tester.tap(find.text('ATMs'));
      await tester.pumpAndSettle();

      expect(find.text('Nearby ATMs'), findsOneWidget);
      expect(find.text('ATM'), findsWidgets);

      // Take exception: must be null (no crash or unhandled error)
      expect(tester.takeException(), isNull);
    });
  });
}
