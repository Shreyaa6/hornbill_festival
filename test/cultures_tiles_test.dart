import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hornbill_festival/screens/culture/cultures_screen.dart';

void main() {
  testWidgets('CulturesScreen renders updated tiles, arrows, and cultural calendar card',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CulturesScreen(),
      ),
    );
    await tester.pump();

    // Verify Festivals and Tribes tiles exist
    expect(find.text('Festivals'), findsOneWidget);
    expect(find.text('Tribes'), findsOneWidget);

    // Verify 'Explore' button has been removed from both cards
    expect(find.text('Explore'), findsNothing);

    // Verify double arrow icons are present for the tiles
    expect(find.byIcon(Icons.keyboard_double_arrow_right_rounded), findsWidgets);

    // Verify Cultural Calendar tile matching Home page cards
    expect(find.text('NAGALAND HERITAGE'), findsOneWidget);
    expect(find.text('CULTURAL CALENDAR'), findsOneWidget);
    expect(find.text('[VIEW 2026 CALENDAR]'), findsOneWidget);

    // Verify background watermark and custom painter on Cultural Calendar card
    expect(find.byIcon(Icons.calendar_month_rounded), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
