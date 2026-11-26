import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hornbill_festival/screens/home/photo_contest_screen.dart';

void main() {
  testWidgets('PhotoContestScreen renders curved header, title, filter and banner',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PhotoContestScreen()));
    await tester.pump();

    expect(find.text('Photo Contest'), findsOneWidget);
    expect(find.text('Hornbill Festival 2026 • 219 Photos'), findsOneWidget);
    expect(find.text('All Days'), findsOneWidget);
    expect(find.textContaining('AI Generated Photos'), findsOneWidget);
    expect(find.byIcon(Icons.shield_outlined), findsOneWidget);

    // Verify 'All Days' pill does not have tent or event icon
    expect(find.byIcon(Icons.event_note_rounded), findsNothing);
  });

  testWidgets('PhotoContestScreen voting, unvoting, and modal pop animations work smoothly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: PhotoContestScreen()));
    await tester.pumpAndSettle();

    // Verify cards are rendered
    expect(find.byType(ContestCard), findsWidgets);
    expect(find.text('Vote'), findsWidgets);

    // Tap first vote button to vote
    await tester.tap(find.text('Vote').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify voted state and toast
    expect(find.text('Voted'), findsWidgets);
    expect(find.text('Vote Counted'), findsOneWidget);

    // Tap voted button to unvote
    await tester.tap(find.text('Voted').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify unvoted state and toast
    expect(find.text('Vote Removed'), findsOneWidget);

    // Tap photo card to open preview modal
    await tester.tap(find.text('Tepuduho Benjamin').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify preview modal is open with Full Resolution badge
    expect(find.text('Full Resolution'), findsOneWidget);

    // Tap close button on preview
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Full Resolution'), findsNothing);

    // Wait for toast to dismiss so FAB + is visible
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    // Verify FAB + is present
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('PhotoContestScreen preview modal matches menu modal UI/UX with controlled size',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: PhotoContestScreen()));
    await tester.pumpAndSettle();

    // Tap on photo author name or card to open preview modal
    await tester.tap(find.text('Tepuduho Benjamin').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify backdrop filter blur exists
    expect(find.byType(BackdropFilter), findsWidgets);

    // Verify modal content: name, votes, date, vote button, and circular close icon
    expect(find.text('Tepuduho Benjamin'), findsWidgets);
    expect(find.textContaining('votes'), findsWidgets);
    expect(find.textContaining('Day'), findsWidgets);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    expect(find.text('Full Resolution'), findsOneWidget);

    // Verify voting directly from the modal
    await tester.tap(find.text('Vote').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Voted'), findsWidgets);

    // Tap circular close button to dismiss
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Full Resolution'), findsNothing);
  });

  testWidgets('Photo Contest vote increases count by exactly 1 and reflects Voted status',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: PhotoContestScreen()));
    await tester.pumpAndSettle();

    // The first card initially has 141 votes and button says 'Vote'
    expect(find.text('141'), findsOneWidget);
    expect(find.text('Vote'), findsWidgets);

    // Tap Vote
    await tester.tap(find.text('Vote').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Must be exactly 142 (NOT 143), and button status must be 'Voted'
    expect(find.text('142'), findsOneWidget);
    expect(find.text('141'), findsNothing);
    expect(find.text('143'), findsNothing);
    expect(find.text('Voted'), findsWidgets);
    expect(find.text('Vote Counted'), findsOneWidget);

    // Tap Voted to unvote
    await tester.tap(find.text('Voted').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Must be back to 141, and button status must be 'Vote'
    expect(find.text('141'), findsOneWidget);
    expect(find.text('142'), findsNothing);
    expect(find.text('Vote Removed'), findsOneWidget);
  });

  testWidgets('Photo submission confirmation modal shows auto-populated info with 0 votes and no edit fields',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final key = GlobalKey<PhotoContestScreenState>();
    await tester.pumpWidget(MaterialApp(home: PhotoContestScreen(key: key)));
    await tester.pumpAndSettle();

    // Create a dummy image file
    final tempDir = Directory.systemTemp.createTempSync();
    final dummyFile = File('${tempDir.path}/test_photo.jpg');
    dummyFile.writeAsBytesSync([0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00]);

    // Open confirmation modal directly
    key.currentState!.showConfirmPhotoModalForTesting(dummyFile);
    await tester.pumpAndSettle();

    // Verify confirmation modal contents
    expect(find.text('Confirm Photo Entry'), findsOneWidget);
    expect(find.text('Hornbill Festival Photo Contest'), findsWidgets);
    expect(find.text('Photographer'), findsOneWidget);
    expect(find.text('Date'), findsOneWidget);
    expect(find.text('Starting Votes'), findsOneWidget);
    expect(find.text('0 votes'), findsOneWidget);

    // Verify there are NO text fields or date change buttons
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Change'), findsNothing);

    // Verify action buttons
    expect(find.text('Submit Photo'), findsOneWidget);
    expect(find.text('Choose another photo'), findsOneWidget);

    // Clean up
    dummyFile.deleteSync();
    tempDir.deleteSync();
  });
}
