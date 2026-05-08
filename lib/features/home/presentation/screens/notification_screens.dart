import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, String>> _notifications = [
    {
      'title': 'New Sermon Uploaded',
      'body': '“The Path of Silence” by Rev. Elijah Thorne is now available for listening.',
      'time': '2 hours ago',
      'icon': 'play',
    },
    {
      'title': 'Upcoming Service Reminder',
      'body': 'Sunday Glory Service starts in 24 hours at Grace Temple. Prepare your heart.',
      'time': '1 day ago',
      'icon': 'church',
    },
    {
      'title': 'Prayer Request Approved',
      'body': 'Your prayer request “Healing for Grandma” has been assigned to a prayer warrior.',
      'time': '2 days ago',
      'icon': 'favorite',
    },
    {
      'title': 'New Course Available',
      'body': 'Join 240 others in “The Wisdom of Ecclesiastes” 10-day study journey.',
      'time': '3 days ago',
      'icon': 'school',
    },
  ];

  void _clearAll() {
    setState(() {
      _notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: _clearAll,
              child: const Text(
                'Clear All',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: _notifications.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: JumCard(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildIconContainer(notification['icon']!),
                          const Gap(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification['title']!,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      notification['time']!,
                                      style: AppTextStyles.caption.copyWith(
                                        fontSize: 11.0,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(6),
                                Text(
                                  notification['body']!,
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 13.5,
                                    height: 1.4,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildIconContainer(String iconType) {
    IconData iconData;
    switch (iconType) {
      case 'play':
        iconData = Icons.play_circle_fill;
        break;
      case 'church':
        iconData = Icons.church_outlined;
        break;
      case 'favorite':
        iconData = Icons.favorite_border_rounded;
        break;
      case 'school':
        iconData = Icons.school_outlined;
        break;
      default:
        iconData = Icons.notifications_none_rounded;
    }

    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.surface2,
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 20, color: AppColors.primary),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_off_outlined, size: 48, color: AppColors.textMuted),
          const Gap(12),
          Text(
            'All caught up!',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const Gap(4),
          Text(
            'You have no new notifications.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
