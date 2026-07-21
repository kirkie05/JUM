import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../../../shared/widgets/jum_shimmer.dart';
import '../../data/models/group_model.dart';
import '../../data/providers/groups_providers.dart';
import '../../data/repositories/groups_repository.dart';

class GroupsDirectoryScreen extends ConsumerStatefulWidget {
  const GroupsDirectoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GroupsDirectoryScreen> createState() => _GroupsDirectoryScreenState();
}

class _GroupsDirectoryScreenState extends ConsumerState<GroupsDirectoryScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the query to pass
    final queryParam = _searchQuery.isEmpty ? null : _searchQuery;
    final groupsAsync = ref.watch(groupsProvider(queryParam));
    final user = ref.watch(currentUserProvider).valueOrNull;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Groups', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
      ),
      floatingActionButton: user?.role == 'admin' 
          ? FloatingActionButton(
              onPressed: () => context.push('/groups/create'),
              backgroundColor: const Color(0xFF111827),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0), border: Border.all(color: const Color(0xFFE5E7EB))),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                  const Gap(12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() { _searchQuery = val; });
                      },
                      decoration: const InputDecoration(hintText: 'Search groups...', hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14), border: InputBorder.none, contentPadding: EdgeInsets.only(bottom: 4)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: groupsAsync.when(
              loading: () => JumShimmer.list(),
              error: (e, st) => Center(child: Text('Error loading groups: $e')),
              data: (groups) {
                if (groups.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.group_off, size: 64, color: Colors.black26),
                        Gap(16),
                        Text('No Groups Found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  itemCount: groups.length,
                  separatorBuilder: (_, __) => const Gap(24),
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return _buildGroupCard(context, group);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, GroupModel group) {
    return GestureDetector(
      onTap: () => context.push('/groups/${group.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (group.bannerUrl != null && group.bannerUrl!.isNotEmpty)
              AspectRatio(
                aspectRatio: 21 / 9,
                child: CachedNetworkImage(
                  imageUrl: group.bannerUrl!,
                  fit: BoxFit.cover,
                  placeholder: (c, url) => Container(color: const Color(0xFFF3F4F6)),
                  errorWidget: (c, url, e) => Container(color: Colors.grey[200], child: const Icon(Icons.image_not_supported, color: Colors.grey)),
                ),
              )
            else
               AspectRatio(
                aspectRatio: 21 / 9,
                child: Container(color: AppColors.primary.withOpacity(0.1), child: const Center(child: Icon(Icons.group, size: 40, color: AppColors.primary))),
              ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(group.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF111827)))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: group.visibility == 'open' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text(group.visibility.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: group.visibility == 'open' ? Colors.green : Colors.orange)),
                      ),
                    ],
                  ),
                  const Gap(8),
                  if (group.description != null) ...[
                    Text(group.description!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                    const Gap(12),
                  ],
                  Row(
                    children: [
                      const Icon(Icons.people_outline, size: 16, color: Color(0xFF6B7280)),
                      const Gap(6),
                      Text('${group.memberCount ?? 0} Members', style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                      const Spacer(),
                      if (group.leaderName != null) ...[
                        const Text('Led by ', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                        Text(group.leaderName!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
                      ]
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupDetailScreen extends ConsumerStatefulWidget {
  final String groupId;
  const GroupDetailScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen> {
  
  bool _isActionLoading = false;

  Future<void> _handleJoin(String userId, String visibility) async {
    setState(() => _isActionLoading = true);
    try {
      final repo = ref.read(groupsRepositoryProvider);
      if (visibility == 'open') {
        await repo.joinGroup(widget.groupId, userId);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Joined group successfully!')));
      } else {
        await repo.requestToJoin(widget.groupId, userId);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Join request sent!')));
      }
      ref.invalidate(groupMembersProvider(widget.groupId));
      ref.invalidate(groupJoinRequestsProvider(widget.groupId));
      ref.invalidate(userGroupsProvider);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isActionLoading = false);
    }
  }

  Future<void> _handleLeave(String userId) async {
    setState(() => _isActionLoading = true);
    try {
      final repo = ref.read(groupsRepositoryProvider);
      await repo.leaveGroup(widget.groupId, userId);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Left group successfully!')));
      ref.invalidate(groupMembersProvider(widget.groupId));
      ref.invalidate(userGroupsProvider);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isActionLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupAsync = ref.watch(groupDetailProvider(widget.groupId));
    final membersAsync = ref.watch(groupMembersProvider(widget.groupId));
    final announcementsAsync = ref.watch(groupAnnouncementsProvider(widget.groupId));
    final user = ref.watch(currentUserProvider).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => context.pop()),
        title: const Text('Group Details', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: groupAsync.when(
        loading: () => JumShimmer.card(height: 300),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (group) {
          
          bool isMember = false;
          bool isPendingRequest = false;
          String userRole = '';
          
          if (user != null) {
            // check if user is a member
            membersAsync.whenData((members) {
              final member = members.where((m) => m.userId == user.id).firstOrNull;
              if (member != null) {
                isMember = true;
                userRole = member.role;
              }
            });
            // check if pending request
            if (!isMember && group.visibility == 'private') {
               final requestsAsync = ref.watch(groupJoinRequestsProvider(widget.groupId));
               requestsAsync.whenData((requests) {
                 if (requests.any((r) => r.userId == user.id && r.status == 'pending')) {
                   isPendingRequest = true;
                 }
               });
            }
          }
          final isAdminOrLeader = userRole == 'admin' || userRole == 'leader' || (user != null && user.role == 'admin');

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (group.bannerUrl != null && group.bannerUrl!.isNotEmpty)
                  AspectRatio(
                    aspectRatio: 21 / 9,
                    child: CachedNetworkImage(imageUrl: group.bannerUrl!, fit: BoxFit.cover),
                  )
                else
                   AspectRatio(aspectRatio: 21 / 9, child: Container(color: AppColors.primary.withOpacity(0.1), child: const Center(child: Icon(Icons.group, size: 40, color: AppColors.primary)))),
                
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(group.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                          if (isAdminOrLeader)
                             IconButton(icon: const Icon(Icons.settings, color: Colors.black54), onPressed: () => context.push('/groups/${group.id}/admin'))
                        ],
                      ),
                      const Gap(16),
                      Text(group.description ?? 'No description.', style: const TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5)),
                      const Gap(24),
                      
                      // ACTION BUTTON
                      if (user == null)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please log in to join groups.')));
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                            child: const Text('Log in to Join'),
                          ),
                        )
                      else if (_isActionLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: isMember
                            ? OutlinedButton(
                                onPressed: () => _handleLeave(user.id),
                                child: const Text('Leave Group', style: TextStyle(color: Colors.red)),
                              )
                            : ElevatedButton(
                                onPressed: isPendingRequest ? null : () => _handleJoin(user.id, group.visibility),
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                                child: Text(isPendingRequest ? 'Request Pending' : (group.visibility == 'open' ? 'Join Group' : 'Request to Join')),
                              ),
                        ),
                            
                      if (isMember) ...[
                        const Gap(16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => context.push('/community/groups/chat/${group.id}?name=${Uri.encodeComponent(group.name)}'),
                                icon: const Icon(Icons.chat_bubble_outline),
                                label: const Text('Group Chat'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                            const Gap(12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => context.push('/community/groups/feed?id=${group.id}&name=${Uri.encodeComponent(group.name)}'),
                                icon: const Icon(Icons.dynamic_feed),
                                label: const Text('Group Feed'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(color: AppColors.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const Gap(32),
                      
                      // ANNOUNCEMENTS
                      if (isMember) ...[
                        const Text('Announcements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const Gap(12),
                        announcementsAsync.when(
                          loading: () => JumShimmer.list(count: 2),
                          error: (e, st) => Text('Error: $e'),
                          data: (announcements) {
                            if (announcements.isEmpty) return const Text('No announcements yet.', style: TextStyle(color: Colors.grey));
                            return Column(
                              children: announcements.map((a) => Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const Gap(4),
                                    Text(a.content, style: const TextStyle(color: Colors.black87)),
                                    const Gap(8),
                                    Text(DateFormat.yMMMd().format(a.createdAt), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                              )).toList(),
                            );
                          },
                        ),
                        const Gap(32),
                      ],
                      
                      // MEMBERS LIST
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Members', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Text('${group.memberCount ?? 0}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Gap(12),
                      membersAsync.when(
                        loading: () => JumShimmer.list(count: 3),
                        error: (e, st) => Text('Error: $e'),
                        data: (members) {
                          if (members.isEmpty) return const Text('No members.', style: TextStyle(color: Colors.grey));
                          return Column(
                            children: members.map((m) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundImage: m.userAvatarUrl != null ? NetworkImage(m.userAvatarUrl!) : null,
                                child: m.userAvatarUrl == null ? const Icon(Icons.person) : null,
                              ),
                              title: Text(m.userName ?? 'Unknown'),
                              subtitle: Text(m.role.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            )).toList(),
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
