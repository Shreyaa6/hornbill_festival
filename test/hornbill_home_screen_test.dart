import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/screens/hornbill/hornbill_home_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HornbillHomeScreen Tests', () {
    testWidgets('HornbillHomeScreen renders 27th Hornbill header and no back button',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HornbillHomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify header title and subtitle
      expect(find.text('27th Hornbill'), findsOneWidget);
      expect(find.text('The Festival of Festivals'), findsOneWidget);

      // Verify back button is NOT rendered
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);

      // Verify quick action tiles
      expect(find.text('Landmarks\n& Stalls'), findsOneWidget);
      expect(find.text('Programs &\nEvents'), findsOneWidget);
      expect(find.text('Emergency\nServices'), findsOneWidget);

      // Verify event schedule day cards exist
      expect(find.textContaining('Day 1'), findsWidgets);
    });
  });
}
