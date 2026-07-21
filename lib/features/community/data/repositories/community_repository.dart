import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/post_model.dart';

part 'community_repository.g.dart';

class CommunityRepository {
  final SupabaseClient _supabase;
  CommunityRepository(this._supabase);

  // Realtime stream of posts with repost and group support
  Stream<List<PostModel>> watchFeed({String? groupId, String? currentUserId}) {
    final rawStream = _supabase
        .from('posts')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);

    return rawStream.asyncMap((rows) async {
      final filteredRows = rows.where((r) {
        if (groupId != null) {
          return r['group_id'] == groupId;
        } else {
          return r['group_id'] == null;
        }
      }).toList();

      if (filteredRows.isEmpty) return <PostModel>[];

      try {
        final userIds = filteredRows
            .map((r) => r['user_id'] as String?)
            .whereType<String>()
            .toSet()
            .toList();

        final List<dynamic>? profilesRes = userIds.isNotEmpty
            ? await _supabase
                .from('profiles')
                .select('id, name, avatar_url')
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

        // Fetch user's likes in this batch of posts
        final Set<String> likedPostIds = {};
        if (currentUserId != null) {
          final postIds = filteredRows.map((r) => r['id'] as String).toList();
          final List<dynamic> likesRes = await _supabase
              .from('likes')
              .select('post_id')
              .eq('user_id', currentUserId)
              .inFilter('post_id', postIds)
              .catchError((_) => <dynamic>[]);
          for (final row in likesRes) {
            if (row is Map) {
              likedPostIds.add(row['post_id'] as String);
            }
          }
        }

        // Fetch repost details
        final repostIds = filteredRows
            .map((r) => r['repost_of_id'] as String?)
            .whereType<String>()
            .toSet()
            .toList();

        final Map<String, PostModel> repostsMap = {};
        if (repostIds.isNotEmpty) {
          final List<dynamic> repostsRes = await _supabase
              .from('posts')
              .select('*, profiles(name, avatar_url)')
              .inFilter('id', repostIds)
              .catchError((_) => <dynamic>[]);
          for (final row in repostsRes) {
            if (row is Map) {
              final profile = row['profiles'] as Map<String, dynamic>?;
              final mapped = Map<String, dynamic>.from(row);
              mapped['author_name'] = profile?['name'] ?? 'Unknown Member';
              mapped['author_avatar_url'] = profile?['avatar_url'];
              mapped['likes_count'] ??= 0;
              repostsMap[row['id'] as String] = PostModel.fromJson(mapped);
            }
          }
        }

        return filteredRows.map((row) {
          final userId = row['user_id'] as String?;
          final profile = userId != null ? profilesMap[userId] : null;

          final mapped = Map<String, dynamic>.from(row);
          mapped['author_name'] = profile?['name'] ?? 'Unknown Member';
          mapped['author_avatar_url'] = profile?['avatar_url'];
          mapped['likes_count'] ??= 0;

          final postId = row['id'] as String;
          mapped['is_liked_by_me'] = likedPostIds.contains(postId);

          final repostOfId = row['repost_of_id'] as String?;
          if (repostOfId != null && repostsMap.containsKey(repostOfId)) {
            mapped['reposted_post'] = repostsMap[repostOfId]!.toJson();
          }

          return PostModel.fromJson(mapped);
        }).toList();
      } catch (e) {
        print('[COMMUNITY_REPO] Error joining profiles/reposts in feed stream: $e');
        return filteredRows.map((row) {
          final mapped = Map<String, dynamic>.from(row);
          mapped['likes_count'] ??= 0;
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
    String? repostOfId,
    String? groupId,
  }) async {
    await _supabase.from('posts').insert({
      'user_id': userId,
      'body': body,
      'media_url': mediaUrl,
      'media_type': mediaType,
      'repost_of_id': repostOfId,
      'group_id': groupId,
      'likes_count': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // Fetch list of all groups
  Future<List<Map<String, dynamic>>> fetchGroups() async {
    final res = await _supabase
        .from('groups')
        .select('*, group_members(user_id)');
    return (res as List).map((r) => Map<String, dynamic>.from(r)).toList();
  }

  // Create a new group
  Future<void> createGroup({
    required String name,
    required String description,
    required String leaderId,
    String? bannerUrl,
  }) async {
    // 1. Insert the group
    final newGroup = await _supabase
        .from('groups')
        .insert({
          'name': name,
          'description': description,
          'leader_id': leaderId,
          'banner_url': bannerUrl,
        })
        .select('id')
        .single();
    
    final groupId = newGroup['id'] as String;

    // 2. Automatically add leader/admin as a member
    await _supabase.from('group_members').insert({
      'group_id': groupId,
      'user_id': leaderId,
    });

    // 3. Create a corresponding conversation for group chat
    await _supabase.from('conversations').insert({
      'name': name,
      'is_group': true,
      'group_id': groupId,
    });
  }

  // Join group
  Future<void> joinGroup(String groupId, String userId) async {
    await _supabase.from('group_members').insert({
      'group_id': groupId,
      'user_id': userId,
    });
  }

  // Leave group
  Future<void> leaveGroup(String groupId, String userId) async {
    await _supabase.from('group_members')
        .delete()
        .eq('group_id', groupId)
        .eq('user_id', userId);
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
