import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
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
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFF3F4F6),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // USER CARD
            JumCard(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuA2R0xtoVk7LZ762kWYKIk03hx_eCInPWYeRk_2RGMkBlHHsevyCSHI6wLUaiT3sqyCPYOEt5gRUfeiCzxD6n0EcSqTHCrzrzqK8uhGtBdVRt3k6SVPV7pq1U_O9lz7CrEYb0u9mTsMnowpeNf6tbXzG8GpAvDp5fFKRYoqRrv358yC-vnAE5rRafIG3v4bGiUAVXinsHJvuBsWjf4Imo9nKzaTZYf08-lGYj5nMgAo-5dUyaaCprEAKzbHuTsTr2jcnO7g_K7KEg',
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Color(0xFFEEEEEE),
                        child: Icon(Icons.person, size: 40.0, color: Colors.black),
                      ),
                    ),
                  ),
                  const Gap(16),
                  const Text(
                    'Emmanuel Adebayo',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Gap(4),
                  const Text(
                    'emmanuel.adebayo@jum.org',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const Gap(16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
                    ),
                    child: const Text(
                      'KINGDOM PARTNER',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
                color: Colors.black,
              ),
            ),
            const Gap(16),
            // OPTIONS LIST
            JumCard(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildOptionRow(Icons.person_outline, 'Personal Information', () {}),
                  const Divider(color: Color(0xFFF3F4F6), height: 16),
                  SwitchListTile(
                    value: _pushNotifications,
                    onChanged: (val) => setState(() => _pushNotifications = val),
                    title: const Text(
                      'Push Notifications',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    activeColor: Colors.black,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    secondary: const Icon(Icons.notifications_outlined, color: Colors.black),
                  ),
                  const Divider(color: Color(0xFFF3F4F6), height: 16),
                  _buildOptionRow(Icons.help_outline, 'Help & Support', () {}),
                  const Divider(color: Color(0xFFF3F4F6), height: 16),
                  _buildOptionRow(Icons.security, 'Privacy Policy', () {}),
                  const Divider(color: Color(0xFFF3F4F6), height: 16),
                  _buildOptionRow(Icons.logout, 'Sign Out', () => context.go('/sign-in'), isDestructive: true),
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
      child: Column(
        children: [
          Text(
            val,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Gap(4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.0,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: isDestructive ? Colors.redAccent : Colors.black),
            const Gap(16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.0,
                  color: isDestructive ? Colors.redAccent : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (!isDestructive)
              const Icon(Icons.chevron_right, size: 20.0, color: Color(0xFFD1D5DB)),
          ],
        ),
      ),
    );
  }
}
