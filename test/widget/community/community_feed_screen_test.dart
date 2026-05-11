import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jum/features/community/presentation/screens/community_feed_screen.dart';

void main() {
  group('CommunityFeedScreen Widget Tests', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    Future<void> pumpFeed(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MaterialApp(home: CommunityFeedScreen()));
    }

    testWidgets('Renders composer and feed content', (
      WidgetTester tester,
    ) async {
      await pumpFeed(tester);

      expect(find.text('Community Feed'), findsOneWidget);
      expect(find.text("What's on your mind right now?"), findsOneWidget);
      expect(find.text('Pastor Joseph'), findsOneWidget);
    });

    testWidgets('Creates a local post from the composer', (
      WidgetTester tester,
    ) async {
      await pumpFeed(tester);

      // Find the main composer text field
      final composerField = find.widgetWithText(TextField, "What's on your mind right now?");
      expect(composerField, findsOneWidget);

      await tester.enterText(composerField, 'This is a test post');
      await tester.tap(find.text('Post').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains('This is a test post'),
        ),
        findsOneWidget,
      );
      expect(find.text('You'), findsOneWidget);
    });

    testWidgets('Post action button is visible', (WidgetTester tester) async {
      await pumpFeed(tester);

      expect(find.text('Post'), findsOneWidget);
    });

    testWidgets('Toggles post like and bookmark status', (WidgetTester tester) async {
      await pumpFeed(tester);

      // Verify initial like count for first post is 142
      expect(find.text('142'), findsOneWidget);

      // Tap like button (with thumb_up_outlined icon)
      await tester.tap(find.byIcon(Icons.thumb_up_outlined).first);
      await tester.pumpAndSettle();

      // Verify like count increments to 143 and icon becomes thumb_up_rounded (now 2 exist, post 1 and post 2)
      expect(find.text('143'), findsOneWidget);
      expect(find.byIcon(Icons.thumb_up_rounded), findsNWidgets(2));

      // Tap like button again to unlike (tap the first one which is post 1)
      await tester.tap(find.byIcon(Icons.thumb_up_rounded).first);
      await tester.pumpAndSettle();

      // Verify like count decrements to 142
      expect(find.text('142'), findsOneWidget);

      // Verify initial bookmark count is 12
      expect(find.text('12'), findsOneWidget);

      // Tap bookmark button
      await tester.tap(find.byIcon(Icons.bookmark_outline_rounded).first);
      await tester.pumpAndSettle();

      // Verify bookmark count increments to 13 and icon becomes bookmark_rounded (now 2 exist, post 1 and post 2)
      expect(find.text('13'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_rounded), findsNWidgets(2));
    });

    testWidgets('Opens comments bottom sheet and adds a new comment', (WidgetTester tester) async {
      await pumpFeed(tester);

      // Find comment button for the first post (which has commentsCount = 2)
      final commentBtn = find.descendant(
        of: find.byType(ListView),
        matching: find.text('2'),
      );
      expect(commentBtn, findsOneWidget);

      // Tap to open bottom sheet
      await tester.tap(commentBtn);
      await tester.pumpAndSettle();

      // Verify comments bottom sheet is opened
      expect(find.text('Comments (2)'), findsOneWidget);
      expect(find.text('David Miller'), findsNWidgets(2));
      expect(find.text('Sarah Jenkins'), findsNWidgets(2));

      // Find the "Write a comment..." text field inside the bottom sheet
      final commentField = find.widgetWithText(TextField, 'Write a comment...');
      expect(commentField, findsOneWidget);

      // Enter a new comment
      await tester.enterText(commentField, 'What a wonderful message!');
      await tester.pump();

      // Find and tap the send icon button (the last one, inside the bottom sheet)
      final sendBtn = find.byIcon(Icons.send_rounded).last;
      expect(sendBtn, findsOneWidget);
      await tester.tap(sendBtn);
      await tester.pumpAndSettle();

      // Verify comment count updated in bottom sheet title
      expect(find.text('Comments (3)'), findsOneWidget);

      // Verify the new comment is displayed
      expect(find.text('What a wonderful message!'), findsOneWidget);

      // Close the bottom sheet
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify comment count is updated to 3 on the main feed post card
      expect(find.text('3'), findsOneWidget);
    });
  });
}
