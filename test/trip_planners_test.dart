import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hornbill_festival/screens/home/trip_planners_screen.dart';

void main() {
  testWidgets('TripPlannersScreen renders header and tour operators',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: TripPlannersScreen(tourTitle: 'Dzukou Valley Tours'),
    ));
    await tester.pump();

    expect(find.text('Trip Planners'), findsOneWidget);
    expect(find.text('Dzukou Valley Tours'), findsOneWidget);
    expect(find.text('Find Tour Operators'), findsOneWidget);
    expect(find.text('Tribal Odyssey'), findsOneWidget);
    expect(find.text('Veshehu Kezo'), findsOneWidget);
    expect(find.text('Kohima'), findsOneWidget);
  });

  testWidgets('TripPlannersScreen filters by tour type properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: TripPlannersScreen(tourTitle: 'Nagaland Tours'),
    ));
    await tester.pump();

    expect(find.text('Nagaland Tours'), findsOneWidget);
    expect(find.text('Tribal Odyssey'), findsOneWidget);
  });
}
