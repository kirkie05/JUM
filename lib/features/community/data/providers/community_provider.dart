import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/post_model.dart';
import '../repositories/community_repository.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../../../core/services/storage_service.dart';

part 'community_provider.g.dart';

@riverpod
Stream<List<PostModel>> communityFeed(CommunityFeedRef ref, {String? groupId}) {
  final currentUserId = ref.watch(currentUserProvider).value?.id;
  return ref.watch(communityRepositoryProvider).watchFeed(
    groupId: groupId,
    currentUserId: currentUserId,
  );
}

@riverpod
Future<List<CommentModel>> postComments(PostCommentsRef ref, String postId) {
  return ref.watch(communityRepositoryProvider).fetchComments(postId);
}

@riverpod
class CreatePostNotifier extends _$CreatePostNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> submit({required String body, File? mediaFile, String? mediaType, String? groupId}) async {
    state = const AsyncValue.loading();
    try {
      String? mediaUrl;
      if (mediaFile != null && mediaType != null) {
        mediaUrl = await ref.read(storageServiceProvider).uploadPostMedia(mediaFile, mediaType);
      }
      final user = ref.read(currentUserProvider).value;
      if (user == null) {
        throw Exception('User not logged in');
      }
      await ref.read(communityRepositoryProvider).createPost(
        userId: user.id,
        body: body,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        groupId: groupId,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
Future<List<Map<String, dynamic>>> groupsList(GroupsListRef ref) {
  return ref.watch(communityRepositoryProvider).fetchGroups();
}
