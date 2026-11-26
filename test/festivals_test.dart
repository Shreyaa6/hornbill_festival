import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/screens/culture/festivals_screen.dart';

void main() {
  group('Festivals Dynamic Firestore Integration Tests', () {
    test('TribalFestival.fromMap maps Firestore document correctly', () {
      final firestoreDoc = {
        'id': 'aoleang_festival',
        'festivalName': 'Aoleang Festival',
        'tribeName': 'Konyak',
        'serialno': 8,
        'image':
            'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FKonyak.png?alt=media&token=0cd2138d-fae5-4bb4-a520-488e08097907',
        'description':
            'Aoleang is the primary festival of the Konyak tribe, celebrated in the first week of April to mark the end of the old year and welcome the new one. It marks the arrival of spring and includes prayers for a bountiful harvest, accompanied by traditional dances, gun salutes, and grand feasting.',
      };

      final festival = TribalFestival.fromMap(firestoreDoc);

      expect(festival.id, 8);
      expect(festival.docId, 'aoleang_festival');
      expect(festival.festivalName, 'Aoleang Festival');
      expect(festival.tribe, 'Konyak');
      expect(festival.localAsset, 'assets/images/tribes/8_konyak.webp');
      expect(festival.networkUrl, firestoreDoc['image']);
      expect(festival.description, contains('primary festival of the Konyak tribe'));
    });

    testWidgets('FestivalsScreen renders header, subtitle and 18 tribal accordions',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FestivalsScreen(),
        ),
      );
      await tester.pump();

      // Verify title & subtitle
      expect(find.text('Festivals of Nagaland'), findsOneWidget);
      expect(find.text('18 Tribal Festivals'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);

      // Angami is expanded initially (#1)
      expect(find.text('Angami'), findsWidgets);
      expect(find.text('Sekrenyi Festival'), findsWidgets);
      expect(
        find.textContaining('Sekrenyi (or Phousanyi) is the main festival'),
        findsOneWidget,
      );

      // Tap on Ao to expand it (should close Angami and open Ao)
      expect(find.text('Ao'), findsOneWidget);
      await tester.ensureVisible(find.text('Ao'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ao'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Moatsü is an annual festival celebrated by the Ao Naga'),
        findsOneWidget,
      );
      // Angami was closed when Ao was opened (single-expansion accordion)
      expect(
        find.textContaining('Sekrenyi (or Phousanyi) is the main festival'),
        findsNothing,
      );

      // Verify greyish lazy loader placeholder (no circular loader)
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.image_outlined), findsWidgets);
    });
  });
}
