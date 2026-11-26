import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hornbill_festival/data/nagaland_data.dart';
import 'package:hornbill_festival/data/tourist_map_destinations.dart';
import 'package:hornbill_festival/screens/home/tourist_map_screen.dart';

void main() {
  testWidgets('TouristMapScreen renders curved header, title, filter pills, and no search or back button',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TouristMapScreen()));
    await tester.pump();

    // Verify title and subtitle in header
    expect(find.text('Nagaland Tourist Map'), findsOneWidget);
    expect(find.text('30 Iconic Spots • Google Maps'), findsOneWidget);

    // Verify Map / Sat toggle pill is white
    expect(find.text('Map'), findsOneWidget);
    final toggleFinder = find.ancestor(
      of: find.text('Map'),
      matching: find.byType(Container),
    );
    final Container container = tester.widget(toggleFinder.first);
    final BoxDecoration decoration = container.decoration as BoxDecoration;
    expect(decoration.color, Colors.white);

    // Verify filter pills ListView does not crop (uses Clip.none)
    final listViewFinder = find.byWidgetPredicate(
      (widget) => widget is ListView && widget.clipBehavior == Clip.none,
    );
    expect(listViewFinder, findsOneWidget);

    // Verify filter pills are present
    expect(find.textContaining('All Spots'), findsOneWidget);

    // Verify back button is removed
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);
    expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
    expect(find.byIcon(Icons.arrow_back), findsNothing);

    // Verify search TextField is removed
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('TouristMapScreen modal and header do not overflow on narrow screens',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(347, 700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: TouristMapScreen()));
    await tester.pump();

    // Verify header renders without overflow on narrow width
    expect(find.text('Nagaland Tourist Map'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);

    // Open first destination spot modal
    final state = tester.state(find.byType(TouristMapScreen)) as dynamic;
    final spot = TouristMapData.destinations.first;
    state.showDestinationDetailsSheet(spot);
    await tester.pumpAndSettle();

    // Verify modal elements render without RenderFlex overflow
    expect(find.text(spot.name), findsWidgets);
    expect(find.text(spot.category), findsWidgets);
    expect(find.text('Open in Google Maps'), findsOneWidget);

    // Verify coordinates are removed as requested
    expect(find.text('COORDINATES'), findsNothing);
    expect(find.text('Latitude:'), findsNothing);
    expect(find.text('Longitude:'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('TouristMapData.fromDistricts builds destinations from Firestore districts including Zunheboto',
      (WidgetTester tester) async {
    final spots = TouristMapData.fromDistricts(NagalandData.districts);
    expect(spots.length, greaterThanOrEqualTo(25));

    // Verify Zunheboto spots exist
    final zunhebotoSpots = spots.where((s) => s.district.toLowerCase().contains('zunheboto')).toList();
    expect(zunhebotoSpots.length, 6);
    expect(zunhebotoSpots.any((s) => s.name == 'Ghosu Bird Sanctuary'), isTrue);
    expect(zunhebotoSpots.any((s) => s.name == 'Sumi Baptist Church'), isTrue);
    expect(zunhebotoSpots.any((s) => s.name == 'Satoi Range'), isTrue);
    expect(zunhebotoSpots.any((s) => s.name == 'Lake Aizuto'), isTrue);
    expect(zunhebotoSpots.any((s) => s.name == 'Tizu Valley'), isTrue);
    expect(zunhebotoSpots.any((s) => s.name == 'Vishepu Village'), isTrue);
  });
}
