import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/screens/common/app_webview_screen.dart';

void main() {
  testWidgets('AppWebViewScreen renders deep teal curved header and no back button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppWebViewScreen(
          title: 'Privacy Policy',
          subtitle: 'Privacy & Data Protection',
          url: '',
        ),
      ),
    );

    // Verify title and subtitle rendered
    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('Privacy & Data Protection'), findsOneWidget);

    // Verify NO back button icon or button in the header
    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.byIcon(Icons.arrow_back_ios), findsNothing);
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);

    // Verify Scaffold background matches deep teal header color
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, const Color(0xFF003848));
  });
}
