import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_avatar.dart';
import '../../../../shared/widgets/jum_card.dart';

// -------------------------------------------------------------
// PROFILE SCREEN
// -------------------------------------------------------------
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Profile',
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
            // USER CARD
            JumCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: Column(
                  children: [
                    const JumAvatar(
                      initials: 'JD',
                      size: 80.0,
                    ),
                    const Gap(16),
                    Text(
                      'John Doe',
                      style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    ),
                    const Gap(4),
                    Text(
                      'john.doe@example.com',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const Gap(12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.accent.withOpacity(0.4), width: 1.0),
                      ),
                      child: Text(
                        'Kingdom Partner',
                        style: AppTextStyles.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(24),
            // STATS ROW
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('4', 'Courses'),
                ),
                const Gap(12),
                Expanded(
                  child: _buildStatItem('12', 'Gifts'),
                ),
                const Gap(12),
                Expanded(
                  child: _buildStatItem('3', 'Events'),
                ),
              ],
            ),
            const Gap(24),
            Text(
              'Account Options',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            const Gap(12),
            // OPTIONS LIST
            JumCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                child: Column(
                  children: [
                    _buildOptionRow(Icons.person_outline, 'Personal Information', () {}),
                    const Divider(color: AppColors.border, height: 24),
                    SwitchListTile(
                      value: _pushNotifications,
                      onChanged: (val) => setState(() => _pushNotifications = val),
                      title: Text(
                        'Push Notifications',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                      activeColor: AppColors.accent,
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(Icons.notifications_outlined, color: AppColors.accent),
                    ),
                    const Divider(color: AppColors.border, height: 24),
                    _buildOptionRow(Icons.help_outline, 'Help & Support', () {}),
                    const Divider(color: AppColors.border, height: 24),
                    _buildOptionRow(Icons.security, 'Privacy Policy', () {}),
                    const Divider(color: AppColors.border, height: 24),
                    _buildOptionRow(Icons.logout, 'Sign Out', () => context.go('/sign-in'), isDestructive: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String val, String label) {
    return JumCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Column(
          children: [
            Text(
              val,
              style: AppTextStyles.h2.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
            ),
            const Gap(4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(icon, color: isDestructive ? AppColors.error : AppColors.accent),
            const Gap(16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDestructive ? AppColors.error : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (!isDestructive)
              const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
