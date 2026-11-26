import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/screens/home/hotels_screen.dart';

void main() {
  testWidgets('HotelsScreen non-selected pills are black, wishlist removed, call option present',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HotelsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify filter pills exist
    expect(find.text('All'), findsWidgets);
    expect(find.text('Hotel'), findsOneWidget);
    expect(find.text('Homestay'), findsOneWidget);

    // 2. Verify non-selected pills ('Hotel' and 'Homestay') have black text color
    final hotelTextFinder = find.text('Hotel');
    final hotelText = tester.widget<Text>(hotelTextFinder);
    expect(hotelText.style?.color, Colors.black);

    final homestayTextFinder = find.text('Homestay');
    final homestayText = tester.widget<Text>(homestayTextFinder);
    expect(homestayText.style?.color, Colors.black);

    // 3. Verify wishlist/favorite icons are completely removed from hotels screen
    expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
    expect(find.byIcon(Icons.favorite_rounded), findsNothing);
    expect(find.byIcon(Icons.favorite), findsNothing);

    // 4. Verify call icons are removed from hotel and resort cards
    expect(find.byIcon(Icons.phone_outlined), findsNothing);

    // 5. Verify zero RenderFlex overflows
    expect(tester.takeException(), isNull);
  });

  testWidgets('HotelsScreen featured resorts do not overflow on compact viewports or high text scale',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1.15)),
          child: HotelsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('HotelsScreen featured resorts remain visible when filters are changed',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HotelsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Featured Resorts is present by default
    expect(find.text('Featured Resorts'), findsOneWidget);
    expect(find.text('Rüdi Resort'), findsOneWidget);

    // 2. Tap 'Homestay' filter
    await tester.tap(find.text('Homestay'));
    await tester.pumpAndSettle();

    // 3. Featured Resorts still present and not filtered out!
    expect(find.text('Featured Resorts'), findsOneWidget);
    expect(find.text('Rüdi Resort'), findsOneWidget);
  });
}
