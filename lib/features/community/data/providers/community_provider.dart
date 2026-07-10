import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/post_model.dart';
import '../repositories/community_repository.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../../../core/services/storage_service.dart';

part 'community_provider.g.dart';

@riverpod
Stream<List<PostModel>> communityFeed(CommunityFeedRef ref) {
  return ref.watch(communityRepositoryProvider).watchFeed();
}

@riverpod
Future<List<CommentModel>> postComments(PostCommentsRef ref, String postId) {
  return ref.watch(communityRepositoryProvider).fetchComments(postId);
}

@riverpod
class CreatePostNotifier extends _$CreatePostNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> submit({required String body, File? mediaFile}) async {
    state = const AsyncValue.loading();
    try {
      String? mediaUrl;
      if (mediaFile != null) {
        // Upload to Supabase Storage
        mediaUrl = await ref.read(storageServiceProvider).uploadPostMedia(mediaFile);
      }
      final user = ref.read(currentUserProvider).value;
      if (user == null) {
        throw Exception('User not logged in');
      }
      await ref.read(communityRepositoryProvider).createPost(
        userId: user.id,
        body: body,
        mediaUrl: mediaUrl,
        mediaType: mediaFile != null ? 'image' : null,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
