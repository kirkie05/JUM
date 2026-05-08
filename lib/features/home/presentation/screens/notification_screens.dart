import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
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
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Notifications',
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
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: _clearAll,
              child: const Text(
                'CLEAR ALL',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.0,
                ),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(24.0),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: JumCard(
                    padding: const EdgeInsets.all(16.0),
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
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    notification['time']!,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12.0,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(6),
                              Text(
                                notification['body']!,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.0,
                                  height: 1.4,
                                  color: Color(0xFF4B5563),
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
    );
  }

  Widget _buildIconContainer(String iconType) {
    IconData iconData;
    switch (iconType) {
      case 'play':
        iconData = Icons.play_circle_fill_outlined;
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
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F6),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 20, color: Colors.black),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.notifications_off_outlined, size: 48, color: Color(0xFF9CA3AF)),
          Gap(12),
          Text(
            'All caught up!',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Gap(4),
          Text(
            'You have no new notifications.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.0,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
