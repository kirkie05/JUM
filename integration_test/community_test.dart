import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jum/features/community/data/models/post_model.dart';
import 'package:jum/features/community/data/providers/community_provider.dart';
import 'package:jum/features/community/presentation/screens/community_feed_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Community Integration Test - Renders post feed and opens CreatePostSheet on FAB tap', (WidgetTester tester) async {
    final mockPost = PostModel(
      id: 'post_123',
      userId: 'user_1',
      churchId: 'church_1',
      body: 'Welcome to Jesus Unhindered Ministry community!',
      likesCount: 15,
      createdAt: DateTime.now(),
      authorName: 'Pastor John',
      authorAvatarUrl: null,
      isLikedByMe: false,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          communityFeedProvider.overrideWith((ref) {
            return Stream.value([mockPost]);
          }),
        ],
        child: const MaterialApp(
          home: CommunityFeedScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify post card body and author name are rendered
    expect(find.text('Welcome to Jesus Unhindered Ministry community!'), findsOneWidget);
    expect(find.text('Pastor John'), findsOneWidget);

    // Tap Floating Action Button with label 'Post'
    final fabFinder = find.byType(FloatingActionButton);
    expect(fabFinder, findsOneWidget);
    await tester.tap(fabFinder);
    await tester.pumpAndSettle();

    // Verify the bottom sheet CreatePostSheet opens with title
    expect(find.text('Create Post'), findsOneWidget);
  });
}
