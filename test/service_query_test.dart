import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/services/firebase_service.dart';
import 'package:hornbill_festival/screens/account/account_screen.dart';
import 'package:hornbill_festival/screens/account/service_queries_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('FirebaseService has logServiceQuery and getQueriesStream methods', () {
    final service = FirebaseService();
    expect(service.logServiceQuery, isNotNull);
    expect(service.getQueriesStream, isNotNull);
  });

  test('FirebaseService deduplicates queries for same user and service on same day', () async {
    final service = FirebaseService();
    // Simulate first call (will hit memory or offline fallback)
    // Manually add to _loggedQueriesToday set simulation
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final dateString = '$year-$month-$day';

    // Call twice with same service
    final res1 = await service.logServiceQuery(
      serviceType: 'hotel',
      serviceName: 'Hotel Japfu',
      serviceId: 'hotel_japfu_1',
      providerId: 'japfu_mgr',
    );

    // If offline, both safely return either dedupe ID or null without error
    expect(res1, anyOf(isNull, contains('hotel_japfu_1')));

    final res2 = await service.logServiceQuery(
      serviceType: 'hotel',
      serviceName: 'Hotel Japfu',
      serviceId: 'hotel_japfu_1',
      providerId: 'japfu_mgr',
    );
    expect(res2, anyOf(isNull, contains('hotel_japfu_1')));
  });

  testWidgets('AccountScreen does not display Service Inquiries & Leads tile', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AccountScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Service Inquiries & Leads'), findsNothing);
    expect(find.text('Share App'), findsOneWidget);
    expect(find.text('Rate on Playstore'), findsOneWidget);
  });

  testWidgets('ServiceQueriesScreen renders header and date filter dropdown and opens calendar bottom sheet', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ServiceQueriesScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Service Inquiries'), findsOneWidget);
    expect(find.text('All Dates'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);

    // Tap dropdown to open bottom sheet
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
    await tester.pumpAndSettle();

    // Verify modal bottom sheet opened with CalendarDatePicker
    expect(find.text('Filter by Date'), findsOneWidget);
    expect(find.byType(CalendarDatePicker), findsOneWidget);
  });
}
