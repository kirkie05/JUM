import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_avatar.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';

// -------------------------------------------------------------
// HOME SCREEN
// -------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 1. WELCOME BANNER
                JumCard(
                  backgroundColor: AppColors.surface,
                  borderColor: AppColors.border,
                  borderWidth: 1.0,
                  padding: const EdgeInsets.all(AppSizes.paddingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Grace & Peace, JUM Member',
                                style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                              ),
                              const Gap(6),
                              Text(
                                'May your day be filled with intentional reflection.',
                                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          const JumAvatar(
                            initials: 'JM',
                            size: AppSizes.avatarMd,
                          ),
                        ],
                      ),
                      const Gap(16),
                      const Divider(color: AppColors.divider, height: 1),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.church_outlined, color: AppColors.primary, size: 20),
                              const Gap(8),
                              Text(
                                'JUM Headquarters',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const Icon(Icons.verified_outlined, color: AppColors.primary, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(24),

                // 2. NEXT SERVICE CARD
                Text(
                  'NEXT SERVICE',
                  style: AppTextStyles.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),
                const Gap(8),
                JumCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Sunday Glory Service',
                                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'In Person',
                                style: AppTextStyles.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const Gap(12),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                            const Gap(8),
                            Text(
                              'Sunday, May 10 • 9:00 AM',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const Gap(8),
                        Row(
                          children: [
                            const Icon(Icons.place_outlined, size: 16, color: AppColors.textSecondary),
                            const Gap(8),
                            Text(
                              'Grace Temple, Main Sanctuary',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            Expanded(
                              child: JumButton(
                                label: 'Add to Calendar',
                                variant: JumButtonVariant.secondary,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(24),

                // 3. RECENT SERMONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RECENT SERMONS',
                      style: AppTextStyles.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                    TextButton(
                      onPressed: () => context.go('/home/media'),
                      child: Text(
                        'See all',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent),
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                SizedBox(
                  height: 190,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final titles = [
                        'The Path of Silence',
                        'Living Unhindered',
                        'The Kingdom Economy',
                        'Power of Faith',
                      ];
                      final speakers = [
                        'Rev. Elijah Thorne',
                        'Pastor Kingsley',
                        'Apostle David',
                        'Dr. Faith',
                      ];
                      return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12.0),
                        child: InkWell(
                          onTap: () => context.push('/sermons/sermon-$index'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.surface2,
                                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                                  border: Border.all(color: AppColors.border, width: 0.5),
                                ),
                                child: const Center(
                                  child: Icon(Icons.play_circle_fill, size: 36, color: AppColors.accent),
                                ),
                              ),
                              const Gap(8),
                              Text(
                                titles[index],
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Gap(4),
                              Text(
                                speakers[index],
                                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Gap(24),

                // 4. COMMUNITY PREVIEW / HIGHLIGHTS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'COMMUNITY HIGHLIGHTS',
                      style: AppTextStyles.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                    TextButton(
                      onPressed: () => context.go('/home/community'),
                      child: Text(
                        'View all',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent),
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                Column(
                  children: List.generate(2, (index) {
                    final titles = ['New Reading Plan', 'Holiday Outreach'];
                    final times = ['Active', 'Active'];
                    final contents = [
                      'Join 240 others in “The Wisdom of Ecclesiastes” 10-day journey.',
                      'Volunteer spots are now open for the Annual Winter Soup Kitchen.',
                    ];
                    final icons = [Icons.menu_book_outlined, Icons.volunteer_activism_outlined];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
                      child: JumCard(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.paddingMd),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppColors.surface2,
                                    radius: 18,
                                    child: Icon(icons[index], size: 16, color: AppColors.primary),
                                  ),
                                  const Gap(12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          titles[index],
                                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          times[index],
                                          style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 11.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(12),
                              Text(
                                contents[index],
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontSize: 13.5),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const Gap(32),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              onPressed: () => context.push('/home/give'),
              backgroundColor: AppColors.accent,
              child: const Icon(Icons.volunteer_activism, color: Colors.black),
            )
          : null,
    );
  }
}

// -------------------------------------------------------------
// MORE MENU SCREEN
// -------------------------------------------------------------
class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {'label': 'Gospel Army School', 'icon': Icons.school_outlined, 'route': '/school'},
      {'label': 'Holy Bible', 'icon': Icons.book_outlined, 'route': '/bible'},
      {'label': 'Upcoming Events', 'icon': Icons.event_note_outlined, 'route': '/events'},
      {'label': 'Messaging', 'icon': Icons.chat_bubble_outline_rounded, 'route': '/messaging'},
      {'label': 'Marketplace', 'icon': Icons.shopping_bag_outlined, 'route': '/marketplace'},
      {'label': 'Giving History', 'icon': Icons.history_edu_outlined, 'route': '/giving/history'},
      {'label': 'My Profile', 'icon': Icons.person_outline, 'route': '/profile'},
      {'label': 'Admin Dashboard', 'icon': Icons.admin_panel_settings_outlined, 'route': '/admin'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'More Menu',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSizes.paddingMd,
          mainAxisSpacing: AppSizes.paddingMd,
          childAspectRatio: 1.25,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return InkWell(
            onTap: () => context.push(item['route'] as String),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            child: JumCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      size: 32.0,
                      color: AppColors.accent,
                    ),
                    const Gap(12),
                    Text(
                      item['label'] as String,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
