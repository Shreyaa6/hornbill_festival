import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/screens/home/discover_viewpoint_screen.dart';

void main() {
  testWidgets('DiscoverViewpointScreen renders curved deep teal header matching TaxisScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DiscoverViewpointScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title and Subtitle in curved header
    expect(find.text('Discover Viewpoint'), findsOneWidget);
    expect(find.text('Unveil Hidden Gems of Nagaland'), findsOneWidget);

    // Verify back button is NOT present in the header (matches TaxisScreen & NotificationsScreen)
    expect(find.byIcon(Icons.arrow_back), findsNothing);

    // Verify Info Banner
    expect(find.text('Found a New Viewpoint?'), findsOneWidget);
    expect(find.text('Explorer Initiative'), findsOneWidget);

    // Verify Form Fields
    expect(find.text('Venue Photos *'), findsOneWidget);
    expect(find.text('Upload Photo'), findsOneWidget);
    expect(find.text('Venue / Place Name *'), findsOneWidget);
    expect(find.text('Nearest Town or Village *'), findsOneWidget);
    expect(find.text('District*'), findsOneWidget);
    expect(find.text('Submit Viewpoint'), findsOneWidget);
  });

  testWidgets('DiscoverViewpointScreen upload photo button opens bottom sheet modal',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DiscoverViewpointScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap upload photo box
    await tester.tap(find.text('Upload Photo'));
    await tester.pumpAndSettle();

    // Verify modal bottom sheet opens with Gallery and Camera options
    expect(find.text('Upload Viewpoint Photo'), findsOneWidget);
    expect(find.text('Choose from Gallery'), findsOneWidget);
    expect(find.text('Take a Photo'), findsOneWidget);
  });
}
