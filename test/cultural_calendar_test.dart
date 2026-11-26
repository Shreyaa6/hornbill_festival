import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/screens/culture/cultural_calendar_screen.dart';
import 'package:hornbill_festival/theme/app_theme.dart';

void main() {
  testWidgets('CulturalCalendarScreen renders deep teal curved header, standard tokens, no search bar, and double arrow icons',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CulturalCalendarScreen()));
    await tester.pump();

    // Verify title and subtitle with standard AppTextStyles tokens
    final titleFinder = find.text('Cultural Calendar');
    expect(titleFinder, findsOneWidget);
    final Text titleWidget = tester.widget(titleFinder);
    expect(titleWidget.style, AppTextStyles.headerTitle);

    final subtitleFinder = find.text('Nagaland Festivals 2026 – 2027');
    expect(subtitleFinder, findsOneWidget);
    final Text subtitleWidget = tester.widget(subtitleFinder);
    expect(subtitleWidget.style, AppTextStyles.headerSubtitle);

    // Verify Scaffold deep teal background
    final scaffoldFinder = find.byType(Scaffold);
    expect(scaffoldFinder, findsOneWidget);
    final Scaffold scaffold = tester.widget(scaffoldFinder);
    expect(scaffold.backgroundColor, const Color(0xFF003848));

    // Verify no back buttons in header
    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);
    expect(find.byIcon(Icons.chevron_left_rounded), findsNothing);

    // Verify search bar is removed
    expect(find.byType(TextField), findsNothing);

    // Verify filter pills row with Clip.none (no cropping)
    final filterListFinder = find.byWidgetPredicate(
      (widget) => widget is ListView && widget.clipBehavior == Clip.none,
    );
    expect(filterListFinder, findsOneWidget);
    expect(find.textContaining('All Events'), findsOneWidget);
    expect(find.text('2026 Schedule'), findsOneWidget);
    expect(find.text('2027 Festivals'), findsOneWidget);

    // Verify double arrow right icons on cards
    expect(find.byIcon(Icons.keyboard_double_arrow_right_rounded), findsWidgets);

    // Verify initial festival events are rendered with compact cards, vector calendar tiles, and status label chips
    expect(find.text('Tsonglak-Nyi'), findsOneWidget);
    expect(find.text('OCT'), findsWidgets);
    expect(find.text('9-12'), findsOneWidget);
    expect(find.textContaining('Tikhir'), findsWidgets);
    // Verified: Confirmed status is rendered as a clean label chip
    expect(find.text('CONFIRMED'), findsWidgets);
    expect(find.textContaining('[CONFIRMED •'), findsNothing);
    // Verified: No cramped 3D calendar images on event cards
    expect(
      find.byWidgetPredicate(
        (w) => w is Image && w.image is AssetImage && (w.image as AssetImage).assetName.contains('calendar_3d'),
      ),
      findsNothing,
    );
    expect(find.text('Chega Gadi'), findsOneWidget);
  });

  testWidgets('CulturalCalendarScreen filter pills switch properly between schedules',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CulturalCalendarScreen()));
    await tester.pump();

    // Tap 2027 Festivals filter
    await tester.tap(find.text('2027 Festivals'));
    await tester.pump();

    // Verify only 2027 events are shown (Tsonglak-Nyi is 2026, Sukrunye is 2027)
    expect(find.text('Tsonglak-Nyi'), findsNothing);
    expect(find.text('Sukrunye'), findsOneWidget);

    // Tap 2026 Schedule filter
    await tester.tap(find.text('2026 Schedule'));
    await tester.pump();

    // Verify 2026 events return and 2027 events are hidden
    expect(find.text('Tsonglak-Nyi'), findsOneWidget);
    expect(find.text('Sukrunye'), findsNothing);
  });

  testWidgets('CulturalCalendarScreen opens bottom sheet modal on festival tap without overflow on narrow screens',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(340, 700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: CulturalCalendarScreen()));
    await tester.pump();

    // Tap the first festival card (Tsonglak-Nyi)
    await tester.tap(find.text('Tsonglak-Nyi'));
    await tester.pumpAndSettle();

    // Verify bottom sheet modal opened
    expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    // Verify no hero image in modal
    expect(
      find.descendant(
        of: find.byType(DraggableScrollableSheet),
        matching: find.byType(Image),
      ),
      findsNothing,
    );
    expect(find.text('DATES & SCHEDULE'), findsOneWidget);
    expect(find.text('COMMUNITY & LOCATION'), findsOneWidget);
    expect(find.text('ABOUT THE CELEBRATION'), findsOneWidget);
    expect(find.text('Share Festival Details'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    // Close modal
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(DraggableScrollableSheet), findsNothing);
  });

  test('CalendarEvent.fromMap and toMap serialize and deserialize Firestore data properly', () {
    final firestoreData = {
      'title': 'Tsonglak-Nyi',
      'month': 'OCT',
      'days': '9-12',
      'year': '2026',
      'monthColor': '#20B08D',
      'isConfirmed': true,
      'tribe': 'Tikhir Tribe',
      'tribeShort': 'Tikhir',
      'location': 'Tikhir Areas',
      'dateRange': '9 to 12 October 2026',
      'description': 'Tsonglak-Nyi festival description.',
      'order': 1,
    };

    final event = CalendarEvent.fromMap(firestoreData, 'tsonglak_nyi_2026');

    expect(event.id, 'tsonglak_nyi_2026');
    expect(event.title, 'Tsonglak-Nyi');
    expect(event.month, 'OCT');
    expect(event.days, '9-12');
    expect(event.year, '2026');
    expect(event.monthColor, const Color(0xFF20B08D));
    expect(event.isConfirmed, isTrue);
    expect(event.tribe, 'Tikhir Tribe');
    expect(event.tribeShort, 'Tikhir');
    expect(event.location, 'Tikhir Areas');
    expect(event.dateRange, '9 to 12 October 2026');
    expect(event.description, 'Tsonglak-Nyi festival description.');
    expect(event.order, 1);

    final map = event.toMap();
    expect(map['title'], 'Tsonglak-Nyi');
    expect(map['year'], '2026');
    expect(map['isConfirmed'], isTrue);
    expect(map['monthColor'], '#20b08d');
  });
}
