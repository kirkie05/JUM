import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/providers/groups_providers.dart';

class GroupAdminScreen extends ConsumerStatefulWidget {
  final String groupId;
  const GroupAdminScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  ConsumerState<GroupAdminScreen> createState() => _GroupAdminScreenState();
}

class _GroupAdminScreenState extends ConsumerState<GroupAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Group'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Join Requests'),
              Tab(text: 'Settings'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _JoinRequestsTab(groupId: widget.groupId),
            _SettingsTab(groupId: widget.groupId),
          ],
        ),
      ),
    );
  }
}

class _JoinRequestsTab extends ConsumerWidget {
  final String groupId;
  const _JoinRequestsTab({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(groupJoinRequestsProvider(groupId));
    return requestsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (requests) {
        if (requests.isEmpty) return const Center(child: Text('No pending requests.'));
        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(req.userName ?? 'Unknown'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () async {
                      await ref.read(groupsRepositoryProvider).updateJoinRequestStatus(req.id, 'approved');
                      await ref.read(groupsRepositoryProvider).joinGroup(groupId, req.userId);
                      ref.invalidate(groupJoinRequestsProvider(groupId));
                      ref.invalidate(groupMembersProvider(groupId));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () async {
                      await ref.read(groupsRepositoryProvider).updateJoinRequestStatus(req.id, 'rejected');
                      ref.invalidate(groupJoinRequestsProvider(groupId));
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SettingsTab extends ConsumerWidget {
  final String groupId;
  const _SettingsTab({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () => context.push('/groups/$groupId/edit'),
            child: const Text('Edit Group Details'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Create Announcement'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await ref.read(groupsRepositoryProvider).archiveGroup(groupId);
              context.pop();
              context.pop();
            },
            child: const Text('Archive Group'),
          ),
        ],
      ),
    );
  }
}
