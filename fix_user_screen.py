import re

with open('lib/features/admin/presentation/screens/admin_screens.dart', 'r') as f:
    content = f.read()

# Change UserManagementScreen to ConsumerStatefulWidget
content = content.replace(
    "class UserManagementScreen extends StatefulWidget {",
    "class UserManagementScreen extends ConsumerStatefulWidget {"
)
content = content.replace(
    "State<UserManagementScreen> createState() => _UserManagementScreenState();",
    "ConsumerState<UserManagementScreen> createState() => _UserManagementScreenState();"
)
content = content.replace(
    "class _UserManagementScreenState extends State<UserManagementScreen> {",
    "class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {"
)

# Remove the hardcoded _usersList
mock_list_old = """  final List<Map<String, String>> _usersList = [
    {
      'name': 'Emmanuel Adebayo',
      'email': 'emmanuel@gmail.com',
      'role': 'Partner',
      'date': 'Joined Jan 2026',
    },
    {
      'name': 'Sarah Jenkins',
      'email': 'sarah.j@outlook.com',
      'role': 'Member',
      'date': 'Joined Feb 2026',
    },
    {
      'name': 'Pastor Kingsley',
      'email': 'kingsley@unhindered.org',
      'role': 'Pastor',
      'date': 'Joined Jul 2024',
    },
    {
      'name': 'Sister Ruth',
      'email': 'ruth@gmail.com',
      'role': 'Admin',
      'date': 'Joined Dec 2025',
    },
  ];"""

content = content.replace(mock_list_old, "")

# Find the _showRoleModifier signature
modifier_old = "void _showRoleModifier(BuildContext context, Map<String, String> user) {"
modifier_new = "void _showRoleModifier(BuildContext context, Map<String, dynamic> user) {"
content = content.replace(modifier_old, modifier_new)

# In the modifier logic, update the button actions
actions_old = """                  JumButton(
                    label: 'Assign Member Role',
                    isFullWidth: true,
                    variant: JumButtonVariant.secondary,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Gap(12),
                  JumButton(
                    label: 'Assign Admin Privileges',
                    isFullWidth: true,
                    onPressed: () => Navigator.pop(context),
                  ),"""
actions_new = """                  JumButton(
                    label: 'Assign Member Role',
                    isFullWidth: true,
                    variant: JumButtonVariant.secondary,
                    onPressed: () {
                      ref.read(adminUsersNotifierProvider.notifier).updateUserRole(user['id'], 'Member');
                      Navigator.pop(context);
                    },
                  ),
                  const Gap(12),
                  JumButton(
                    label: 'Assign Admin Privileges',
                    isFullWidth: true,
                    onPressed: () {
                      ref.read(adminUsersNotifierProvider.notifier).updateUserRole(user['id'], 'Admin');
                      Navigator.pop(context);
                    },
                  ),"""
content = content.replace(actions_old, actions_new)

# Replace the Expanded ListView builder
list_old = """                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final u = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
                        child: JumCard(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.paddingMd),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.surface2,
                                  child: Text(
                                    u['name']![0],
                                    style: AppTextStyles.h2.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const Gap(16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        u['name']!,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        u['email']!,
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const Gap(4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.accent.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: AppColors.accent,
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Text(
                                              u['role']!,
                                              style: AppTextStyles.overline.copyWith(
                                                color: AppColors.accent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const Gap(8),
                                          Text(
                                            u['date']!,
                                            style: AppTextStyles.overline.copyWith(
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.admin_panel_settings_outlined,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () => _showRoleModifier(context, u),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),"""

list_new = """                Expanded(
                  child: ref.watch(adminUsersProvider).when(
                    data: (users) {
                      final filtered = users.where((u) {
                        final q = _filterQuery.toLowerCase();
                        return (u['full_name'] ?? '').toLowerCase().contains(q) ||
                               (u['email'] ?? '').toLowerCase().contains(q);
                      }).toList();
                      
                      if (filtered.isEmpty) {
                        return Center(child: Text("No users found.", style: AppTextStyles.bodyMedium));
                      }
                      
                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final u = filtered[index];
                          final name = u['full_name'] ?? 'Unknown';
                          final email = u['email'] ?? 'No email';
                          final role = u['role'] ?? 'Member';
                          final dateStr = u['created_at'] != null ? u['created_at'].toString().split('T')[0] : '';
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
                            child: JumCard(
                              child: Padding(
                                padding: const EdgeInsets.all(AppSizes.paddingMd),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: AppColors.surface2,
                                      child: Text(
                                        name.isNotEmpty ? name[0] : '?',
                                        style: AppTextStyles.h2.copyWith(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    const Gap(16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: AppTextStyles.bodyMedium.copyWith(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            email,
                                            style: AppTextStyles.caption.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          const Gap(4),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.accent.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: AppColors.accent,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                child: Text(
                                                  role,
                                                  style: AppTextStyles.overline.copyWith(
                                                    color: AppColors.accent,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const Gap(8),
                                              Text(
                                                'Joined $dateStr',
                                                style: AppTextStyles.overline.copyWith(
                                                  color: AppColors.textMuted,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.admin_panel_settings_outlined,
                                        color: AppColors.textSecondary,
                                      ),
                                      onPressed: () {
                                        final userMap = {
                                          'id': u['id'],
                                          'name': name,
                                        };
                                        _showRoleModifier(context, userMap);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const JumShimmerList(itemCount: 4),
                    error: (err, _) => Center(child: Text("Error: $err", style: const TextStyle(color: Colors.red))),
                  ),
                ),"""

# Replace the filtered definition as well in the build method
filtered_old = """    final filtered = _usersList.where((u) {
      final q = _filterQuery.toLowerCase();
      return u['name']!.toLowerCase().contains(q) ||
          u['email']!.toLowerCase().contains(q);
    }).toList();"""
content = content.replace(filtered_old, "")

content = content.replace(list_old, list_new)

with open('lib/features/admin/presentation/screens/admin_screens.dart', 'w') as f:
    f.write(content)
