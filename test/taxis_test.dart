import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/data/taxis_data.dart';
import 'package:hornbill_festival/screens/home/taxis_screen.dart';
import 'package:hornbill_festival/screens/home/view_taxi_screen.dart';

void main() {
  group('Taxis UI Tests', () {
    test('TaxisData contains taxis', () {
      expect(TaxisData.allTaxis.isNotEmpty, true);
    });

    testWidgets('TaxisScreen renders 4-seater and 7-seater vehicle images',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TaxisScreen(),
        ),
      );
      await tester.pump();

      // Verify Book Taxis title
      expect(find.text('Book Taxis'), findsOneWidget);

      // Verify vehicle image assets exist for items
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('ViewTaxiScreen removes header taxi image and shows standalone license button',
        (tester) async {
      // Find a taxi with document
      final taxi = TaxisData.allTaxis.firstWhere(
        (t) => t.document.isNotEmpty,
        orElse: () => TaxisData.allTaxis.first,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ViewTaxiScreen(taxi: taxi),
        ),
      );
      await tester.pump();

      // Deep teal header with vehicle name and driver subtitle
      expect(find.text(taxi.vehicleName), findsWidgets);
      expect(
        find.textContaining(taxi.driverName),
        findsWidgets,
      );

      // Header taxi image is removed from ViewTaxiScreen
      expect(find.byType(Image), findsNothing);

      // No back button icon
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);

      // Star rating and Verified Driver Partner text removed; verified badge icon shown on avatar
      expect(find.text('Verified Driver Partner'), findsNothing);
      expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
      expect(find.textContaining('Call Driver: ${taxi.phone}'), findsOneWidget);

      // Driver Verification section title is removed
      expect(find.text('Driver Verification'), findsNothing);

      // Driving License / Partner ID button is displayed
      expect(find.text('Driving License / Partner ID'), findsOneWidget);

      // Districts Serving section
      expect(find.text('Districts Serving'), findsOneWidget);
    });
  });
}
