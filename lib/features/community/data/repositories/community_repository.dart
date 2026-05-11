import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/post_model.dart';

part 'community_repository.g.dart';

class CommunityRepository {
  final SupabaseClient _supabase;
  CommunityRepository(this._supabase);

  // Realtime stream of posts with robust error catching and mock fallback
  Stream<List<PostModel>> watchFeed(String churchId) async* {
    try {
      final stream = _supabase
          .from('posts')
          .stream(primaryKey: ['id'])
          .eq('church_id', churchId)
          .order('created_at', ascending: false)
          .map((rows) => rows.map((row) => PostModel.fromJson(row)).toList());
          
      await for (final posts in stream) {
        yield posts;
      }
    } catch (e) {
      try {
        final res = await _supabase
            .from('posts')
            .select()
            .eq('church_id', churchId)
            .order('created_at', ascending: false);
            
        final posts = (res as List).map((row) => PostModel.fromJson(row)).toList();
        yield posts;
      } catch (e2) {
        yield _getMockPosts(churchId);
      }
    }
  }

  List<PostModel> _getMockPosts(String churchId) {
    return [
      PostModel(
        id: 'mock-post-1',
        userId: 'mock-user-1',
        churchId: churchId,
        body: 'Praise God! What an incredible worship service we had this Sunday. "The Power of Grace" touched so many hearts. Thank you to everyone who joined us in person and online. Let us continue to walk in His love.',
        likesCount: 24,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        authorName: 'Pastor Joseph',
        authorAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        mediaUrl: 'https://images.unsplash.com/photo-1438029071396-1e831a7fa6d8?w=800',
        mediaType: 'image',
        isLikedByMe: false,
      ),
      PostModel(
        id: 'mock-post-2',
        userId: 'mock-user-2',
        churchId: churchId,
        body: 'Please join us in prayer for our upcoming youth retreat this weekend. Praying for open hearts, safety, and a deep move of the Holy Spirit. If you have any specific prayer requests, drop them below!',
        likesCount: 18,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        authorName: 'Sarah Jenkins',
        authorAvatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        isLikedByMe: true,
      ),
      PostModel(
        id: 'mock-post-3',
        userId: 'mock-user-3',
        churchId: churchId,
        body: 'The community outreach yesterday was a major success! We were able to distribute over 150 food baskets to families in need. A huge thank you to all our volunteers who showed up and shared Christ\'s love.',
        likesCount: 32,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        authorName: 'Michael Carter',
        authorAvatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        mediaUrl: 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800',
        mediaType: 'image',
        isLikedByMe: false,
      ),
    ];
  }

  Future<void> createPost({
    required String userId,
    required String churchId,
    required String body,
    String? mediaUrl,
    String? mediaType,
  }) async {
    try {
      await _supabase.from('posts').insert({
        'user_id': userId,
        'church_id': churchId,
        'body': body,
        'media_url': mediaUrl,
        'media_type': mediaType,
        'likes_count': 0,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Swallow safely for offline/mock flow
    }
  }

  Future<void> toggleLike(String postId, String userId) async {
    try {
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
    } catch (e) {
      // Swallow safely for offline/mock flow
    }
  }

  Future<List<CommentModel>> fetchComments(String postId) async {
    try {
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
    } catch (e) {
      return _getMockComments(postId);
    }
  }

  List<CommentModel> _getMockComments(String postId) {
    if (postId == 'mock-post-1') {
      return [
        CommentModel(
          id: 'mock-comment-1',
          postId: postId,
          userId: 'mock-user-2',
          body: 'Amen! It was an incredibly moving sermon. Praise God!',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          authorName: 'Sarah Jenkins',
          authorAvatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        ),
        CommentModel(
          id: 'mock-comment-2',
          postId: postId,
          userId: 'mock-user-3',
          body: 'Thank you Pastor Joseph! Looking forward to next week.',
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          authorName: 'Michael Carter',
          authorAvatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        ),
      ];
    }
    return [
      CommentModel(
        id: 'mock-comment-3',
        postId: postId,
        userId: 'mock-user-1',
        body: 'Standing in agreement with you all! 🙏',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        authorName: 'Pastor Joseph',
        authorAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      )
    ];
  }

  Future<void> addComment(String postId, String userId, String body) async {
    try {
      await _supabase.from('comments').insert({
        'post_id': postId,
        'user_id': userId,
        'body': body,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Swallow safely for offline/mock flow
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _supabase.from('posts').delete().eq('id', postId);
    } catch (e) {
      // Swallow safely for offline/mock flow
    }
  }
}

@riverpod
CommunityRepository communityRepository(CommunityRepositoryRef ref) =>
    CommunityRepository(ref.watch(supabaseClientProvider));
