import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_card.dart';

// -------------------------------------------------------------
// ADMIN DASHBOARD SCREEN
// -------------------------------------------------------------
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'val': '1,420', 'label': 'Total Members', 'icon': Icons.people_outline},
      {'val': '\$42,500', 'label': 'Monthly Giving', 'icon': Icons.volunteer_activism_outlined},
      {'val': '380', 'label': 'Enrolled Students', 'icon': Icons.school_outlined},
      {'val': '14', 'label': 'Active Groups', 'icon': Icons.chat_bubble_outline},
    ];

    final activities = [
      {'text': 'Sarah Jenkins enrolled in Foundations of Faith Course', 'time': '10 mins ago'},
      {'text': 'Brother James contributed \$50.00 for Tithe', 'time': '1 hour ago'},
      {'text': 'Pastor Kingsley posted new Sermon: "Living Unhindered"', 'time': '2 hours ago'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Overview Stats',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            const Gap(12),
            // STATS GRID
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSizes.paddingMd,
                mainAxisSpacing: AppSizes.paddingMd,
                childAspectRatio: 1.3,
              ),
              itemCount: stats.length,
              itemBuilder: (context, index) {
                final stat = stats[index];
                return JumCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingMd),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(stat['icon'] as IconData, color: AppColors.accent, size: 24),
                        const Gap(8),
                        Text(
                          stat['val'] as String,
                          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                        ),
                        const Gap(4),
                        Text(
                          stat['label'] as String,
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Gap(28),
            Text(
              'Quick Actions',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            const Gap(12),
            // QUICK ACTIONS ROW
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(Icons.event_available, 'Create Event'),
                ),
                const Gap(12),
                Expanded(
                  child: _buildActionButton(Icons.playlist_add, 'Post Sermon'),
                ),
                const Gap(12),
                Expanded(
                  child: _buildActionButton(Icons.campaign, 'Broadcast'),
                ),
              ],
            ),
            const Gap(28),
            Text(
              'Recent System Activity',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            const Gap(12),
            // ACTIVITIES LIST
            JumCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                child: Column(
                  children: activities.map((activity) {
                    final isLast = activities.last == activity;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline, color: AppColors.accent, size: 18),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activity['text']!,
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                                  ),
                                  Text(
                                    activity['time']!,
                                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (!isLast) const Divider(color: AppColors.border, height: 24),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: JumCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Icon(icon, color: AppColors.accent, size: 24),
              const Gap(8),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
