import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Page Transitions Theme Configuration', () {
    test('AppTheme pageTransitionsTheme configures native iOS and Android builders', () {
      final theme = AppTheme.themeData;
      final builders = theme.pageTransitionsTheme.builders;

      expect(builders[TargetPlatform.iOS], isA<CupertinoPageTransitionsBuilder>());
      expect(builders[TargetPlatform.macOS], isA<CupertinoPageTransitionsBuilder>());
      expect(builders[TargetPlatform.android], isA<ZoomPageTransitionsBuilder>());
      expect(builders[TargetPlatform.windows], isA<ZoomPageTransitionsBuilder>());
      expect(builders[TargetPlatform.linux], isA<ZoomPageTransitionsBuilder>());
    });

    testWidgets('iOS platform supports interactive swipe back gesture', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      try {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Scaffold(
                            body: Center(child: Text('Second Page')),
                          ),
                        ),
                      );
                    },
                    child: const Text('Open Second Page'),
                  ),
                ),
              ),
            ),
          ),
        );

        // Tap to navigate to Second Page
        await tester.tap(find.text('Open Second Page'));
        await tester.pumpAndSettle();

        expect(find.text('Second Page'), findsOneWidget);

        // Perform left edge drag to simulate native iOS swipe-to-back (> 50% width to trigger pop)
        final gesture = await tester.startGesture(const Offset(5, 300));
        await gesture.moveBy(const Offset(500, 0));
        await gesture.up();
        await tester.pumpAndSettle();

        // Second Page should be dismissed, returning to first page
        expect(find.text('Second Page'), findsNothing);
        expect(find.text('Open Second Page'), findsOneWidget);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });
  });
}
