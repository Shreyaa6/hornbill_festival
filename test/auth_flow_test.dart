import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hornbill_festival/screens/intro/app_intro_screen.dart';
import 'package:hornbill_festival/screens/auth/login_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'disclaimer_acknowledged': true});
  });

  testWidgets('AppIntroScreen Get Started button opens LoginScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppIntroScreen(),
      ),
    );
    await tester.pumpAndSettle();

    final getStartedBtn = find.text('Get Started');
    expect(getStartedBtn, findsOneWidget);

    await tester.tap(getStartedBtn);
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Continue as Guest'), findsOneWidget);
  });

  testWidgets('AppIntroScreen Download Hornbill Services button renders without underline and is tappable', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppIntroScreen(),
      ),
    );
    await tester.pumpAndSettle();

    final downloadBtn = find.text('Download Hornbill Services');
    expect(downloadBtn, findsOneWidget);

    final textWidget = tester.widget<Text>(downloadBtn);
    expect(textWidget.style?.decoration, isNot(TextDecoration.underline));

    // Tap to verify redirection handler executes without error
    await tester.tap(downloadBtn);
    await tester.pump();
  });
}
