import re

with open('lib/features/admin/presentation/screens/admin_screens.dart', 'r') as f:
    content = f.read()

# DepartmentsListScreen
content = content.replace(
    "class DepartmentsListScreen extends StatelessWidget {",
    "class DepartmentsListScreen extends ConsumerWidget {"
)
content = content.replace(
    "  Widget build(BuildContext context) {",
    "  Widget build(BuildContext context, WidgetRef ref) {"
)

dept_old = """    final departments = [
      {
        'name': 'Ushering Unit',
        'leader': 'Sister Grace',
        'volunteers': '24 Volunteers',
        'schedule': 'Sundays 6:30 AM',
        'icon': Icons.supervised_user_circle_outlined,
      },
      {
        'name': 'Levites Choir',
        'leader': 'Brother Caleb',
        'volunteers': '18 Volunteers',
        'schedule': 'Saturdays 4:00 PM',
        'icon': Icons.music_note_outlined,
      },
      {
        'name': 'Media & Streaming',
        'leader': 'Brother David',
        'volunteers': '12 Volunteers',
        'schedule': 'Wednesdays 5:30 PM',
        'icon': Icons.video_camera_back_outlined,
      },
      {
        'name': 'Youth Fellowship',
        'leader': 'Brother Joshua',
        'volunteers': '45 Volunteers',
        'schedule': 'Fridays 6:00 PM',
        'icon': Icons.groups_outlined,
      },
    ];"""

dept_list_old = """      body: ListView.builder(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final dept = departments[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: JumCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.surface2,
                          child: Icon(
                            dept['icon'] as IconData,
                            color: AppColors.accent,
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dept['name'] as String,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Leader: ${dept['leader']}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            dept['volunteers'] as String,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Meeting: ${dept['schedule']}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const _VolunteerListModal(),
                            );
                          },
                          child: Text(
                            'Manage Roster',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),"""

dept_list_new = """      body: ref.watch(adminDepartmentsProvider).when(
        data: (departments) {
          if (departments.isEmpty) return const Center(child: Text('No departments found.'));
          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final dept = departments[index];
              final name = dept['name'] ?? 'Unnamed';
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: JumCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: AppColors.surface2,
                              child: Icon(
                                Icons.groups,
                                color: AppColors.accent,
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Leader: Unknown',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                'Manage',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
        error: (err, _) => Center(child: Text('Error: $err')),
      ),"""

content = content.replace(dept_old, "")
content = content.replace(dept_list_old, dept_list_new)


# AdminEventsScreen
content = content.replace(
    "class AdminEventsScreen extends StatelessWidget {",
    "class AdminEventsScreen extends ConsumerWidget {"
)

events_old = """    final events = [
      {
        'title': 'Anointing Service',
        'date': 'Next Sunday, 9:00 AM',
        'status': 'Published',
        'color': AppColors.success,
      },
      {
        'title': 'Youth Conference 2026',
        'date': 'Aug 15 - Aug 17',
        'status': 'Draft',
        'color': AppColors.warning,
      },
      {
        'title': 'Leadership Retreat',
        'date': 'Sep 5, 2026',
        'status': 'Published',
        'color': AppColors.success,
      },
    ];"""

events_list_old = """      body: ListView.builder(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return _AdminListTile(
            title: event['title'] as String,
            subtitle: event['date'] as String,
            icon: Icons.event_outlined,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (event['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: event['color'] as Color, width: 0.5),
              ),
              child: Text(
                event['status'] as String,
                style: AppTextStyles.caption.copyWith(
                  color: event['color'] as Color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),"""

events_list_new = """      body: ref.watch(adminEventsProvider).when(
        data: (events) {
          if (events.isEmpty) return const Center(child: Text('No events found.'));
          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _AdminListTile(
                title: event['title'] ?? 'Untitled Event',
                subtitle: event['date'] ?? 'No date',
                icon: Icons.event_outlined,
                trailing: const Icon(Icons.chevron_right),
              );
            },
          );
        },
        loading: () => const JumShimmerList(),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),"""

content = content.replace(events_old, "")
content = content.replace(events_list_old, events_list_new)


# AdminGivingScreen
content = content.replace(
    "class AdminGivingScreen extends StatelessWidget {",
    "class AdminGivingScreen extends ConsumerWidget {"
)

gifts_old = """    final gifts = [
      {
        'name': 'Brother Emmanuel',
        'amount': '\\$150.00',
        'cat': 'Tithe',
        'date': 'Today, 10:45 AM',
      },
      {
        'name': 'Sister Sarah',
        'amount': '\\$50.00',
        'cat': 'Offering',
        'date': 'Yesterday, 8:00 AM',
      },
      {
        'name': 'Anonymous',
        'amount': '\\$500.00',
        'cat': 'Building Fund',
        'date': 'May 1, 2026',
      },
    ];"""

gifts_list_old = """      body: ListView.builder(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          final gift = gifts[index];
          return _AdminListTile(
            title: '${gift['name']} - ${gift['amount']}',
            subtitle: '${gift['cat']} • ${gift['date']}',
            icon: Icons.volunteer_activism_outlined,
          );
        },
      ),"""

gifts_list_new = """      body: ref.watch(adminDonationsProvider).when(
        data: (gifts) {
          if (gifts.isEmpty) return const Center(child: Text('No donations found.'));
          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final gift = gifts[index];
              final amount = gift['amount'] ?? 0;
              final cat = gift['category'] ?? '';
              final name = gift['profiles']?['full_name'] ?? 'Anonymous';
              final date = gift['created_at'] != null ? gift['created_at'].toString().split('T')[0] : '';
              return _AdminListTile(
                title: '$name - \\$${amount}',
                subtitle: '$cat • $date',
                icon: Icons.volunteer_activism_outlined,
              );
            },
          );
        },
        loading: () => const JumShimmerList(),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),"""

content = content.replace(gifts_old, "")
content = content.replace(gifts_list_old, gifts_list_new)

with open('lib/features/admin/presentation/screens/admin_screens.dart', 'w') as f:
    f.write(content)
