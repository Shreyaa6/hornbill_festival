import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornbill_festival/main.dart';
import 'package:hornbill_festival/theme/app_theme.dart';

void main() {
  test('System UI Overlay style has black/dark system info texts and icons throughout app', () {
    // Verify HornbillApp default overlay style
    const style = HornbillApp.defaultOverlayStyle;
    expect(style.statusBarIconBrightness, Brightness.dark,
        reason: 'Android status bar text and icons must be dark / black');
    expect(style.statusBarBrightness, Brightness.light,
        reason: 'iOS status bar text and icons must be dark / black');
    expect(style.statusBarColor, Colors.transparent);
    expect(style.systemNavigationBarColor, Colors.transparent,
        reason: 'Navigation bar is transparent for true native edge-to-edge');
    expect(style.systemNavigationBarIconBrightness, Brightness.dark);

    // Verify AppBarTheme system overlay style
    final appBarStyle = AppTheme.themeData.appBarTheme.systemOverlayStyle;
    expect(appBarStyle, isNotNull);
    expect(appBarStyle!.statusBarIconBrightness, Brightness.dark);
    expect(appBarStyle.statusBarBrightness, Brightness.light);
    expect(appBarStyle.systemNavigationBarColor, Colors.transparent);
  });

  testWidgets('HornbillApp embeds AnnotatedRegion with black status bar overlay', (WidgetTester tester) async {
    await tester.pumpWidget(const HornbillApp());
    await tester.pump();

    // Verify AnnotatedRegion is in the tree with defaultOverlayStyle
    final annotatedRegionFinder = find.byWidgetPredicate(
      (widget) =>
          widget is AnnotatedRegion<SystemUiOverlayStyle> &&
          widget.value.statusBarIconBrightness == Brightness.dark &&
          widget.value.statusBarBrightness == Brightness.light,
    );
    expect(annotatedRegionFinder, findsWidgets);

    // Clean up timers
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();
  });

  testWidgets('HornbillApp uses native transparent edge-to-edge without artificial widget scrims',
      (WidgetTester tester) async {
    // Test with bottom inset (e.g. 48dp on 3-button or 34dp on gesture navigation)
    tester.view.devicePixelRatio = 1.0;
    tester.view.padding = const FakeViewPadding(bottom: 34);
    tester.view.viewPadding = const FakeViewPadding(bottom: 34);
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPadding();
      tester.view.resetViewPadding();
    });

    await tester.pumpWidget(const HornbillApp());
    await tester.pump();

    // Verify NO artificial black system navigation bar scrim is injected into the tree
    final scrimFinder = find.byKey(const ValueKey('system_nav_bar_scrim'));
    expect(scrimFinder, findsNothing);

    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();
  });
}
