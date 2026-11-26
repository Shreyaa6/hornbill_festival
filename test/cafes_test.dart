import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/screens/home/cafes_screen.dart';
import 'package:hornbill_festival/screens/home/view_cafe_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockCafe = {
    'name': 'The Heritage Cafe',
    'location': 'Kohima',
    'contact': '9876543210',
    'rating': '4.8',
    'description': 'A beautiful scenic cafe in Kohima.',
    'isNagaDishes': true,
    'isContinental': true,
    'cuisines': ['Naga Traditional', 'Continental', 'Beverages'],
    'photoUrl': null,
    'menuUrl': null,
  };

  testWidgets('ViewCafeScreen renders compact cuisines and opens menu modal on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ViewCafeScreen(cafe: mockCafe),
      ),
    );
    await tester.pump();

    // Verify cafe name and Cuisines Serving section exist
    expect(find.text('The Heritage Cafe'), findsOneWidget);
    expect(find.text('Cuisines Serving'), findsOneWidget);
    expect(find.text('Naga Cuisines'), findsOneWidget);
    expect(find.text('Continental'), findsOneWidget);

    // Verify Menu section and view tap hint
    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('Tap to view'), findsOneWidget);

    // Tap to view menu modal
    await tester.tap(find.text('Tap to view'));
    await tester.pumpAndSettle();

    // Verify modal is open with close cross button and blurred background
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.byType(BackdropFilter), findsWidgets);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    // Tap close cross button to dismiss
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    // Verify modal is dismissed
    expect(find.byType(Dialog), findsNothing);

    // Re-open and test dismissing by tapping outside the modal (barrier)
    await tester.tap(find.text('Tap to view'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);

    // Tap at top left outside dialog (barrier)
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('CafesScreen body is clipped by ClipRRect to prevent scrolling over header corners',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CafesScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify CafesScreen renders header and dropdowns
    expect(find.text('Find Restros'), findsOneWidget);
    expect(find.text('Restaurants • Cafes'), findsOneWidget);
    expect(find.text('Kohima'), findsOneWidget);
    expect(find.text('All Cuisines'), findsOneWidget);

    // Verify wishlist/favorite icons are removed from restro cards
    expect(find.byIcon(Icons.favorite), findsNothing);
    expect(find.byIcon(Icons.favorite_border), findsNothing);

    // Verify ClipRRect exists around the body sheet with 28 radius
    final clipRRectFinder = find.byWidgetPredicate((widget) {
      if (widget is ClipRRect) {
        final br = widget.borderRadius;
        return br is BorderRadius && br.topLeft == const Radius.circular(28) && br.topRight == const Radius.circular(28);
      }
      return false;
    });
    expect(clipRRectFinder, findsOneWidget);

    // Scroll list up to simulate user scrolling cards past the top edge
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Verify no exception or overflow occurred
    expect(tester.takeException(), isNull);
  });

  testWidgets('ViewCafeScreen renders 2-column grid when cafe has multiple menu images',
      (WidgetTester tester) async {
    final multiMenuCafe = {
      'name': 'Cafe Ozone',
      'location': 'Kohima',
      'contact': '9876543210',
      'menu': [
        'https://example.com/menu1.jpg',
        'https://example.com/menu2.jpg',
      ],
    };

    await tester.pumpWidget(
      MaterialApp(
        home: ViewCafeScreen(cafe: multiMenuCafe),
      ),
    );
    await tester.pump();

    // Verify '2 pages' badge and GridView are present
    expect(find.text('2 pages'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);

    // Verify Page 1 and Page 2 labels exist in grid
    expect(find.text('Page 1'), findsOneWidget);
    expect(find.text('Page 2'), findsOneWidget);

    // Scroll to Page 2 and tap to open modal
    await tester.ensureVisible(find.text('Page 2'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Page 2'));
    await tester.pumpAndSettle();

    // Verify dialog opened with PageView and '2 / 2' indicator
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('2 / 2'), findsOneWidget);

    // Close dialog
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
  });
}
