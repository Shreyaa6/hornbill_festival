import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/main.dart';

void main() {
  testWidgets('Hornbill App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HornbillApp());

    // Verify that the title or app is rendered.
    expect(find.byType(HornbillApp), findsOneWidget);
  });
}
