import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/post_model.dart';

part 'community_repository.g.dart';

class CommunityRepository {
  final SupabaseClient _supabase;
  CommunityRepository(this._supabase);

  // Realtime stream of posts
  Stream<List<PostModel>> watchFeed() {
    final rawStream = _supabase
        .from('posts')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);

    return rawStream.asyncMap((rows) async {
      if (rows.isEmpty) return <PostModel>[];

      try {
        final userIds = rows
            .map((r) => r['user_id'] as String?)
            .whereType<String>()
            .toSet()
            .toList();

        final List<dynamic>? profilesRes = userIds.isNotEmpty
            ? await _supabase
                .from('profiles')
                .select('id, name, full_name, avatar_url')
                .inFilter('id', userIds)
                .catchError((_) => <dynamic>[]) // Suppress RLS errors on profiles
            : null;

        final Map<String, Map<String, dynamic>> profilesMap = {};
        if (profilesRes != null) {
          for (final row in profilesRes) {
            if (row is Map) {
              profilesMap[row['id'] as String] = Map<String, dynamic>.from(row);
            }
          }
        }

        return rows.map((row) {
          final userId = row['user_id'] as String?;
          final profile = userId != null ? profilesMap[userId] : null;

          final mapped = Map<String, dynamic>.from(row);
          mapped['author_name'] = profile?['name'] ?? profile?['full_name'] ?? 'Unknown Member';
          mapped['author_avatar_url'] = profile?['avatar_url'];
          mapped['likes_count'] ??= 0; // Prevent null exception

          return PostModel.fromJson(mapped);
        }).toList();
      } catch (e) {
        print('[COMMUNITY_REPO] Error joining profiles in feed stream: $e');
        return rows.map((row) {
          final mapped = Map<String, dynamic>.from(row);
          mapped['likes_count'] ??= 0; // Prevent null exception
          mapped['author_name'] = 'Unknown Member';
          return PostModel.fromJson(mapped);
        }).toList();
      }
    });
  }

  Future<void> createPost({
    required String userId,
    required String body,
    String? mediaUrl,
    String? mediaType,
  }) async {
    await _supabase.from('posts').insert({
      'user_id': userId,
      'body': body,
      'media_url': mediaUrl,
      'media_type': mediaType,
      'likes_count': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> toggleLike(String postId, String userId) async {
    // Check if already liked
    final existing = await _supabase
        .from('likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', userId)
        .maybeSingle();
        
    if (existing != null) {
      await _supabase.from('likes')
          .delete().eq('post_id', postId).eq('user_id', userId);
    } else {
      await _supabase.from('likes').insert({'post_id': postId, 'user_id': userId});
    }
  }

  Future<List<CommentModel>> fetchComments(String postId) async {
    final res = await _supabase
        .from('comments')
        .select('*, profiles(name, avatar_url)')
        .eq('post_id', postId)
        .order('created_at');
        
    return (res as List).map((row) {
      final profile = row['profiles'] as Map<String, dynamic>?;
      return CommentModel.fromJson({
        ...row,
        'authorName': profile?['name'] ?? 'Unknown Member',
        'authorAvatarUrl': profile?['avatar_url'],
      });
    }).toList();
  }

  Future<void> addComment(String postId, String userId, String body) async {
    await _supabase.from('comments').insert({
      'post_id': postId,
      'user_id': userId,
      'body': body,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deletePost(String postId) async {
    await _supabase.from('posts').delete().eq('id', postId);
  }
}

@riverpod
CommunityRepository communityRepository(CommunityRepositoryRef ref) =>
    CommunityRepository(ref.watch(supabaseClientProvider));
