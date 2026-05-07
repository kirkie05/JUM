import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/post_model.dart';

part 'community_repository.g.dart';

class CommunityRepository {
  final SupabaseClient _supabase;
  CommunityRepository(this._supabase);

  // Realtime stream of posts
  Stream<List<PostModel>> watchFeed(String churchId) {
    return _supabase
        .from('posts')
        .stream(primaryKey: ['id'])
        .eq('church_id', churchId)
        .order('created_at', ascending: false)
        .map((rows) => rows.map((row) => PostModel.fromJson(row)).toList());
  }

  Future<void> createPost({
    required String userId,
    required String churchId,
    required String body,
    String? mediaUrl,
    String? mediaType,
  }) async {
    await _supabase.from('posts').insert({
      'user_id': userId,
      'church_id': churchId,
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
        .from('post_likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', userId)
        .maybeSingle();
        
    if (existing != null) {
      await _supabase.from('post_likes')
          .delete().eq('post_id', postId).eq('user_id', userId);
          
      // Decrement logic (optimistic UI or let RPC handle, but prompt says update directly for now)
      final post = await _supabase.from('posts').select('likes_count').eq('id', postId).single();
      final currentLikes = post['likes_count'] as int;
      await _supabase.from('posts')
          .update({'likes_count': currentLikes - 1}).eq('id', postId);
    } else {
      await _supabase.from('post_likes').insert({'post_id': postId, 'user_id': userId});
      
      final post = await _supabase.from('posts').select('likes_count').eq('id', postId).single();
      final currentLikes = post['likes_count'] as int;
      await _supabase.from('posts')
          .update({'likes_count': currentLikes + 1}).eq('id', postId);
    }
  }

  Future<List<CommentModel>> fetchComments(String postId) async {
    final res = await _supabase
        .from('comments')
        .select('*, users(name, avatar_url)')
        .eq('post_id', postId)
        .order('created_at');
        
    return (res as List).map((row) {
      final user = row['users'] as Map<String, dynamic>?;
      return CommentModel.fromJson({
        ...row,
        'authorName': user?['name'],
        'authorAvatarUrl': user?['avatar_url'],
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
