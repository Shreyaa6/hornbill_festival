import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/main.dart';

void main() {
  testWidgets('Hornbill App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HornbillApp());
    expect(find.byType(HornbillApp), findsOneWidget);

    // Advance time past the splash timer
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();
  });
}
