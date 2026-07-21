import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../models/group_model.dart';
import '../models/group_member_model.dart';
import '../models/group_join_request_model.dart';
import '../models/group_announcement_model.dart';
import '../repositories/groups_repository.dart';

final groupsRepositoryProvider = Provider<GroupsRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return GroupsRepository(client);
});

// A provider for searching/listing all active groups
final groupsProvider = FutureProvider.family<List<GroupModel>, String?>((ref, searchQuery) async {
  final repo = ref.watch(groupsRepositoryProvider);
  return repo.getGroups(searchQuery: searchQuery);
});

// A provider for getting a specific group
final groupDetailProvider = FutureProvider.family<GroupModel, String>((ref, groupId) async {
  final repo = ref.watch(groupsRepositoryProvider);
  return repo.getGroupById(groupId);
});

// A provider for listing members of a group
final groupMembersProvider = FutureProvider.family<List<GroupMemberModel>, String>((ref, groupId) async {
  final repo = ref.watch(groupsRepositoryProvider);
  return repo.getGroupMembers(groupId);
});

// A provider for user's own group memberships
final userGroupsProvider = FutureProvider<List<GroupMemberModel>>((ref) async {
  final repo = ref.watch(groupsRepositoryProvider);
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return [];
  return repo.getUserGroups(user.id);
});

// A provider for listing join requests for a group (leaders/admins only)
final groupJoinRequestsProvider = FutureProvider.family<List<GroupJoinRequestModel>, String>((ref, groupId) async {
  final repo = ref.watch(groupsRepositoryProvider);
  return repo.getJoinRequests(groupId);
});

// A provider for announcements in a group
final groupAnnouncementsProvider = FutureProvider.family<List<GroupAnnouncementModel>, String>((ref, groupId) async {
  final repo = ref.watch(groupsRepositoryProvider);
  return repo.getAnnouncements(groupId);
});
