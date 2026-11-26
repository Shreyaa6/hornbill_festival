import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hornbill_festival/models/tribe.dart';
import 'package:hornbill_festival/data/app_data.dart';
import 'package:hornbill_festival/services/offline_data_service.dart';
import 'package:hornbill_festival/screens/culture/tribes_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Tribes Integration & UI Tests', () {
    test('AppData has all 18 tribes', () {
      expect(AppData.tribes.length, 18);
      expect(AppData.tribes[0].name, 'Angami');
      expect(AppData.tribes[1].name, 'Ao');
      expect(AppData.tribes[2].name, 'Chakhesang');
      expect(AppData.tribes[3].name, 'Chang');
      expect(AppData.tribes[10].name, 'Phom');
      expect(AppData.tribes[10].docId, '0N9giBEPFtvXZxuCbwUF');
      expect(AppData.tribes[10].district, 'Longleng');
      expect(
        AppData.tribes[10].image,
        'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2Ftribe_phom_custom.jpg?alt=media&token=eaed4c61-c379-48c7-8864-6fd6201d7f22',
      );
      expect(AppData.tribes[17].name, 'Zeliang');
    });

    test('Tribe.fromMap parses Firestore document correctly', () {
      final firestoreDoc = {
        'createdAt': '2026-11-26T11:50:50.127Z',
        'description':
            'The Phom tribe lives in the Longleng district, celebrated for their historic log drum beating traditions, pottery, and spinning. They mark the arrival of spring with the vibrant Monyu festival, featuring traditional folk chants, rituals, and agricultural blessings.',
        'district': 'Longleng',
        'name': 'Phom',
        'photo':
            'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2Ftribe_phom_custom.jpg?alt=media&token=eaed4c61-c379-48c7-8864-6fd6201d7f22',
      };

      final tribe = Tribe.fromMap(firestoreDoc, '0N9giBEPFtvXZxuCbwUF');

      expect(tribe.id, 11); // Canonical ID for Phom
      expect(tribe.docId, '0N9giBEPFtvXZxuCbwUF');
      expect(tribe.name, 'Phom');
      expect(tribe.district, 'Longleng');
      expect(
        tribe.image,
        'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2Ftribe_phom_custom.jpg?alt=media&token=eaed4c61-c379-48c7-8864-6fd6201d7f22',
      );
      expect(tribe.createdAt, '2026-11-26T11:50:50.127Z');
      expect(tribe.description, contains('log drum beating'));
    });

    test('OfflineDataService streams bundled tribes when offline', () async {
      final tribes = await OfflineDataService().getCachedTribes();
      expect(tribes.length, 18);
      expect(tribes.any((t) => t.name == 'Phom'), isTrue);
    });

    testWidgets('TribesScreen renders accordion layout matching FestivalsScreen',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TribesScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Title & Subtitle
      expect(find.text('Tribes of Nagaland'), findsOneWidget);
      expect(find.text('18 Tribes'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);

      // Angami is expanded by default (#1)
      expect(find.text('Angami'), findsWidgets);
      expect(
        find.textContaining('Angami Tribe is based on Kohima district'),
        findsOneWidget,
      );

      // Other tribes are present as collapsed accordion headers
      expect(find.text('Ao'), findsOneWidget);
      expect(find.text('Chakhesang'), findsOneWidget);

      // Scroll to Phom and tap to expand
      await tester.ensureVisible(find.text('Phom'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Phom'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('The Phom tribe lives in the Longleng district'),
        findsOneWidget,
      );
      // Angami was closed when Phom was opened (single-expansion accordion)
      expect(
        find.textContaining('Angami Tribe is based on Kohima district'),
        findsNothing,
      );
    });
  });
}
