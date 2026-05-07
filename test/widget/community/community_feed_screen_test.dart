import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jum/features/community/presentation/screens/community_feed_screen.dart';
import 'package:jum/features/community/data/models/post_model.dart';
import 'package:jum/features/community/data/providers/community_provider.dart';
import 'package:jum/shared/widgets/jum_shimmer.dart';
import 'package:jum/features/community/presentation/widgets/post_card.dart';

void main() {
  group('CommunityFeedScreen Widget Tests', () {
    testWidgets('Renders shimmer when loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            communityFeedProvider.overrideWith((ref) => const Stream.empty()),
          ],
          child: const MaterialApp(
            home: CommunityFeedScreen(),
          ),
        ),
      );

      // Verify shimmer list is rendered while loading
      expect(find.byType(JumShimmer), findsOneWidget);
    });

    testWidgets('Renders PostCard when data available', (WidgetTester tester) async {
      final mockPosts = [
        PostModel(
          id: 'post-1',
          userId: 'user-1',
          churchId: 'jum-church-1',
          body: 'This is a test post',
          likesCount: 5,
          createdAt: DateTime.now(),
          authorName: 'Jane Doe',
          authorAvatarUrl: null,
          isLikedByMe: false,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            communityFeedProvider.overrideWith((ref) => Stream.value(mockPosts)),
          ],
          child: const MaterialApp(
            home: CommunityFeedScreen(),
          ),
        ),
      );

      await tester.pump(); // Triggers the stream output update

      // Verify PostCard is rendered
      expect(find.byType(PostCard), findsOneWidget);
      expect(find.text('This is a test post'), findsOneWidget);
      expect(find.text('Jane Doe'), findsOneWidget);
    });

    testWidgets('FAB is visible', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            communityFeedProvider.overrideWith((ref) => const Stream.empty()),
          ],
          child: const MaterialApp(
            home: CommunityFeedScreen(),
          ),
        ),
      );

      // Verify FAB is visible with "Post" label
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Post'), findsOneWidget);
    });
  });
}
