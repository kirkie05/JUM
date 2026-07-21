import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/group_model.dart';
import '../models/group_member_model.dart';
import '../models/group_join_request_model.dart';
import '../models/group_announcement_model.dart';

class GroupsRepository {
  final SupabaseClient _supabase;

  GroupsRepository(this._supabase);

  // --- Groups ---

  Future<List<GroupModel>> getGroups({String? searchQuery}) async {
    var query = _supabase.from('groups').select('*, leader:profiles!groups_leader_id_fkey(name, avatar_url), member_count:group_members(count)');
    
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('name', '%$searchQuery%');
    }
    
    final response = await query.order('name');
    return response.map((json) {
      final map = Map<String, dynamic>.from(json);
      // Map the extra fields
      if (map['leader'] != null) {
         map['leader_name'] = map['leader']['name'];
      }
      if (map['member_count'] is List && map['member_count'].isNotEmpty) {
         map['member_count'] = map['member_count'][0]['count'];
      }
      return GroupModel.fromJson(map);
    }).toList();
  }

  Future<GroupModel> getGroupById(String groupId) async {
    final response = await _supabase.from('groups').select('*, leader:profiles!groups_leader_id_fkey(name, avatar_url), member_count:group_members(count)').eq('id', groupId).single();
    final map = Map<String, dynamic>.from(response);
    if (map['leader'] != null) {
       map['leader_name'] = map['leader']['name'];
    }
    if (map['member_count'] is List && map['member_count'].isNotEmpty) {
       map['member_count'] = map['member_count'][0]['count'];
    }
    return GroupModel.fromJson(map);
  }

  Future<GroupModel> createGroup(Map<String, dynamic> data) async {
    final response = await _supabase.from('groups').insert(data).select().single();
    return GroupModel.fromJson(response);
  }

  Future<GroupModel> updateGroup(String groupId, Map<String, dynamic> data) async {
    data['updated_at'] = DateTime.now().toIso8601String();
    final response = await _supabase.from('groups').update(data).eq('id', groupId).select().single();
    return GroupModel.fromJson(response);
  }

  Future<void> archiveGroup(String groupId) async {
    await updateGroup(groupId, {'is_active': false});
  }

  // --- Members ---

  Future<List<GroupMemberModel>> getGroupMembers(String groupId) async {
    final response = await _supabase.from('group_members').select('*, profiles(name, avatar_url)').eq('group_id', groupId).order('joined_at');
    return response.map((json) => GroupMemberModel.fromJson(json)).toList();
  }
  
  Future<List<GroupMemberModel>> getUserGroups(String userId) async {
    final response = await _supabase.from('group_members').select('*, groups(*, leader:profiles!groups_leader_id_fkey(name, avatar_url))').eq('user_id', userId);
    return response.map((json) => GroupMemberModel.fromJson(json)).toList();
  }

  Future<void> joinGroup(String groupId, String userId, {String role = 'member'}) async {
    await _supabase.from('group_members').insert({
      'group_id': groupId,
      'user_id': userId,
      'role': role,
    });
  }

  Future<void> leaveGroup(String groupId, String userId) async {
    await _supabase.from('group_members').delete().eq('group_id', groupId).eq('user_id', userId);
  }

  // --- Join Requests ---

  Future<List<GroupJoinRequestModel>> getJoinRequests(String groupId) async {
    final response = await _supabase.from('group_join_requests').select('*, profiles(name, avatar_url)').eq('group_id', groupId).eq('status', 'pending').order('requested_at');
    return response.map((json) => GroupJoinRequestModel.fromJson(json)).toList();
  }

  Future<void> requestToJoin(String groupId, String userId) async {
    await _supabase.from('group_join_requests').insert({
      'group_id': groupId,
      'user_id': userId,
    });
  }

  Future<void> updateJoinRequestStatus(String requestId, String status) async {
    await _supabase.from('group_join_requests').update({
      'status': status,
      'resolved_at': DateTime.now().toIso8601String(),
    }).eq('id', requestId);
  }

  // --- Announcements ---

  Future<List<GroupAnnouncementModel>> getAnnouncements(String groupId) async {
    final response = await _supabase.from('group_announcements').select('*, profiles(name, avatar_url)').eq('group_id', groupId).order('created_at', ascending: false);
    return response.map((json) => GroupAnnouncementModel.fromJson(json)).toList();
  }

  Future<void> createAnnouncement(Map<String, dynamic> data) async {
    await _supabase.from('group_announcements').insert(data);
  }
}
