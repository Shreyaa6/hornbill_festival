import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/screens/home/notifications_screen.dart';

void main() {
  group('NotificationsScreen Tests', () {
    testWidgets('NotificationsScreen renders curved deep teal header matching TaxisScreen',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationsScreen(),
        ),
      );
      await tester.pump();

      // Verify Deep Teal header and title & subtitle matching TaxisScreen
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Updates • Circulars • Alerts'), findsOneWidget);

      // Verify Search Pill with search icon
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Search notifications...'), findsOneWidget);

      // Verify notification items rendered with title and dates
      expect(find.textContaining('Advent Christmas'), findsWidgets);
      expect(find.text('Recent Updates'), findsOneWidget);

      // Verify keyboard double arrow icons
      expect(find.byIcon(Icons.keyboard_double_arrow_right_rounded), findsWidgets);
    });

    testWidgets('NotificationsScreen search filtering works correctly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationsScreen(),
        ),
      );
      await tester.pump();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Wrestling');
      await tester.pump();

      // Only wrestling notification should match
      expect(find.textContaining('Waga Wrestling'), findsNothing);
      expect(find.textContaining('Naga Wrestling'), findsOneWidget);

      // Clear search
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();

      // All notifications visible again
      expect(find.textContaining('Advent Christmas'), findsWidgets);
    });

    testWidgets('NotificationsScreen does not render back icon (matches TaxisScreen)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationsScreen(),
        ),
      );
      await tester.pump();

      // Verify no back icon is rendered, matching TaxisScreen header style
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    test('parseNotificationDate parses various date formats accurately', () {
      expect(parseNotificationDate('7th December, 2026'), DateTime(2026, 12, 7));
      expect(parseNotificationDate('1st January, 2025'), DateTime(2025, 1, 1));
      expect(parseNotificationDate('2nd February, 2025'), DateTime(2025, 2, 2));
      expect(parseNotificationDate('3rd March, 2025'), DateTime(2025, 3, 3));
      expect(parseNotificationDate('December 7, 2024'), DateTime(2024, 12, 7));
      expect(parseNotificationDate('2026-11-24T17:34:31Z'), DateTime.utc(2026, 11, 24, 17, 34, 31));
      expect(parseNotificationDate(DateTime(2026, 10, 20)), DateTime(2026, 10, 20));
      expect(parseNotificationDate(null), isNull);
      expect(parseNotificationDate(''), isNull);
    });

    testWidgets('NotificationsScreen renders notifications in most recent date order by default',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationsScreen(),
        ),
      );
      await tester.pump();

      // Find all Text widgets displaying notification dates
      // Default dates are 7th December, 2026; 7th December, 2024; 6th December, 2024; etc.
      final dateFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            (widget.data?.contains('2026') == true ||
             widget.data?.contains('2024') == true),
      );

      final dateTexts = tester.widgetList<Text>(dateFinder).map((w) => w.data!).toList();
      expect(dateTexts.isNotEmpty, isTrue);

      // Verify that parsed dates are in strictly descending order (most recent first)
      DateTime? prevDate;
      for (final dtStr in dateTexts) {
        final dt = parseNotificationDate(dtStr);
        if (dt != null) {
          if (prevDate != null) {
            expect(dt.isBefore(prevDate) || dt.isAtSameMomentAs(prevDate), isTrue,
                reason: '$dt should be on or before $prevDate');
          }
          prevDate = dt;
        }
      }
    });
  });
}
