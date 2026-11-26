import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/screens/home/trips_screen.dart';

void main() {
  testWidgets('TripsScreen renders Explore Nagaland style tour cards with arrows and gradients',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TripsScreen(),
      ),
    );
    await tester.pump();

    // Verify Header
    expect(find.text('Explore Tours'), findsOneWidget);
    expect(find.text('Camping • Trekking • Tours'), findsOneWidget);

    // Verify Popular Destinations section
    expect(find.text('Popular Destinations'), findsOneWidget);

    // Verify Tour titles
    expect(find.text('Dzukou Valley Tour'), findsOneWidget);
    expect(find.text('Nagaland Tour'), findsOneWidget);

    // Scroll to see Northeast Tours
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pump();
    expect(find.text('Northeast Tours'), findsOneWidget);

    // Verify Old 'View' button is removed
    expect(find.text('View'), findsNothing);

    // Verify double arrow icon matching Explore Nagaland
    expect(find.byIcon(Icons.keyboard_double_arrow_right_rounded), findsWidgets);
  });
}
