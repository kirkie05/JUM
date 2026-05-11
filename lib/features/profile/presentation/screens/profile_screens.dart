import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/jum_app_bar.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';

// -------------------------------------------------------------
// PROFILE SCREEN
// -------------------------------------------------------------
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const JumAppBar(
        title: 'My Profile',
        showBack: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // USER CARD - Premium Monochromatic Frosted Glassmorphism
            JumCard(
              padding: const EdgeInsets.all(24.0),
              backgroundColor: AppColors.surface,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border, width: 2.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(45.0),
                      child: Image.network(
                        'https://picsum.photos/seed/emmanuel/200/200',
                        width: 90.0,
                        height: 90.0,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                          radius: 45.0,
                          backgroundColor: AppColors.surface2,
                          child: Icon(Icons.person_rounded, size: 45.0, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  const Text(
                    'Emmanuel Adebayo',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Gap(4),
                  const Text(
                    'emmanuel.adebayo@jum.org',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Gap(16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: AppColors.border, width: 1.0),
                    ),
                    child: const Text(
                      'KINGDOM PARTNER',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
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
            const Gap(32),
            const Text(
              'Account Options',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const Gap(16),
            // OPTIONS LIST
            JumCard(
              padding: const EdgeInsets.all(8.0),
              backgroundColor: AppColors.surface,
              child: Column(
                children: [
                  _buildOptionRow(
                    Icons.person_outline_rounded,
                    'Personal Information',
                    'Edit name, email and phone number',
                    () => context.push('/profile/edit'),
                  ),
                  const Divider(color: AppColors.divider, height: 1),
                  _buildOptionRow(
                    Icons.settings_outlined,
                    'Settings & Preferences',
                    'Notification, system theme and alerts',
                    () => context.push('/profile/settings'),
                  ),
                  const Divider(color: AppColors.divider, height: 1),
                  _buildOptionRow(
                    Icons.help_outline_rounded,
                    'Help & Support',
                    'FAQs, support ticket, and contact us',
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Support ticket system opening...'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                  ),
                  const Divider(color: AppColors.divider, height: 1),
                  _buildOptionRow(
                    Icons.logout_rounded,
                    'Sign Out',
                    'Safely sign out from JUM application',
                    () => context.go('/sign-in'),
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String val, String label) {
    return JumCard(
      padding: const EdgeInsets.all(16.0),
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          Text(
            val,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const Gap(4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.0,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: isDestructive ? const Color(0xFFFEF2F2) : AppColors.surface2,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Icon(
                icon,
                color: isDestructive ? AppColors.error : AppColors.primary,
                size: 22.0,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.0,
                      color: isDestructive ? AppColors.error : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      color: isDestructive ? AppColors.error.withOpacity(0.7) : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (!isDestructive)
              const Icon(Icons.chevron_right_rounded, size: 20.0, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// EDIT PROFILE SCREEN
// -------------------------------------------------------------
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Emmanuel Adebayo');
  final _emailController = TextEditingController(text: 'emmanuel.adebayo@jum.org');
  final _phoneController = TextEditingController(text: '+234 812 345 6789');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const JumAppBar(
        title: 'Edit Profile',
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar selector
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border, width: 3.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(55.0),
                        child: Image.network(
                          'https://picsum.photos/seed/emmanuel/200/200',
                          width: 110.0,
                          height: 110.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(32),
              JumCard(
                padding: const EdgeInsets.all(24.0),
                backgroundColor: AppColors.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel('FULL NAME'),
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15.0),
                      decoration: _buildInputDecoration('Enter your full name', Icons.person_outline_rounded),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                    ),
                    const Gap(20),
                    _buildInputLabel('EMAIL ADDRESS'),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15.0),
                      decoration: _buildInputDecoration('Enter your email address', Icons.mail_outline_rounded),
                      validator: (value) => value == null || !value.contains('@') ? 'Please enter a valid email' : null,
                    ),
                    const Gap(20),
                    _buildInputLabel('PHONE NUMBER'),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15.0),
                      decoration: _buildInputDecoration('Enter your phone number', Icons.phone_android_rounded),
                    ),
                  ],
                ),
              ),
              const Gap(32),
              JumButton(
                label: 'Save Changes',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    context.pop();
                  }
                },
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.textMuted),
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14.0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      filled: true,
      fillColor: AppColors.surface2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.border, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.border, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}

// -------------------------------------------------------------
// SETTINGS SCREEN
// -------------------------------------------------------------
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailUpdates = true;
  bool _streamAlerts = true;
  bool _highContrast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const JumAppBar(
        title: 'Settings',
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionHeader('NOTIFICATION PREFERENCES'),
            const Gap(12),
            JumCard(
              padding: const EdgeInsets.all(8.0),
              backgroundColor: AppColors.surface,
              child: Column(
                children: [
                  _buildToggleRow(
                    'Push Notifications',
                    'Receive real-time alerts on your device',
                    _pushNotifications,
                    (val) => setState(() => _pushNotifications = val),
                  ),
                  const Divider(color: AppColors.divider, height: 1),
                  _buildToggleRow(
                    'Email Updates',
                    'Weekly summary of church newsletters and sermons',
                    _emailUpdates,
                    (val) => setState(() => _emailUpdates = val),
                  ),
                  const Divider(color: AppColors.divider, height: 1),
                  _buildToggleRow(
                    'Stream Alerts',
                    'Get notified when JUM streams go Live',
                    _streamAlerts,
                    (val) => setState(() => _streamAlerts = val),
                  ),
                ],
              ),
            ),
            const Gap(32),
            _buildSectionHeader('ACCESSIBILITY'),
            const Gap(12),
            JumCard(
              padding: const EdgeInsets.all(8.0),
              backgroundColor: AppColors.surface,
              child: Column(
                children: [
                  _buildToggleRow(
                    'High Contrast Mode',
                    'Enable maximum readability across layouts',
                    _highContrast,
                    (val) => setState(() => _highContrast = val),
                  ),
                ],
              ),
            ),
            const Gap(32),
            _buildSectionHeader('ABOUT JUM'),
            const Gap(12),
            JumCard(
              padding: const EdgeInsets.all(8.0),
              backgroundColor: AppColors.surface,
              child: Column(
                children: [
                  _buildNavigationRow('Terms of Service', () {
                    _showInfoDialog('Terms of Service', 'Welcome to Jesus Unhindered Ministry (JUM). By accessing our app, you agree to preach the gospel to all nations, participate in community fellowship, and adhere to our respectful communication guidelines.');
                  }),
                  const Divider(color: AppColors.divider, height: 1),
                  _buildNavigationRow('Privacy Policy', () {
                    _showInfoDialog('Privacy Policy', 'Your privacy is extremely important to us. We securely store registration details, and never share your prayer requests, chat messages, or personal info with any third party.');
                  }),
                  const Divider(color: AppColors.divider, height: 1),
                  _buildNavigationRow('App Version', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('JUM Ministry v2.1.0 • Up to Date')),
                    );
                  }, trailingText: 'v2.1.0'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildToggleRow(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Gap(4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.0,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRow(String title, VoidCallback onTap, {String? trailingText}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Row(
              children: [
                if (trailingText != null) ...[
                  Text(
                    trailingText,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Gap(8),
                ],
                const Icon(Icons.chevron_right_rounded, size: 20.0, color: AppColors.textMuted),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(String title, String body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        content: Text(
          body,
          style: const TextStyle(
            fontFamily: 'Inter',
            color: AppColors.textPrimary,
            fontSize: 14.0,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
