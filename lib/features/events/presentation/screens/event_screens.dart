import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';

// -------------------------------------------------------------
// EVENT LIST SCREEN
// -------------------------------------------------------------
class EventListScreen extends StatefulWidget {
  const EventListScreen({Key? key}) : super(key: key);

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  String _selectedMonth = 'May 2026';

  final List<Map<String, String>> _events = [
    {
      'id': 'event-1',
      'title': 'Unhindered Worship Night',
      'date': 'Friday, May 15',
      'time': '6:00 PM',
      'location': 'Lagos HQ Main Sanctuary',
      'category': 'Worship',
    },
    {
      'id': 'event-2',
      'title': 'Youth Grace Summit 2026',
      'date': 'Saturday, May 23',
      'time': '10:00 AM',
      'location': 'Houston Campus Hall A',
      'category': 'Summit',
    },
    {
      'id': 'event-3',
      'title': 'Couples Prayer Breakfast',
      'date': 'Saturday, May 30',
      'time': '8:30 AM',
      'location': 'London Grace Fellowship',
      'category': 'Prayer',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Upcoming Events',
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
            // MONTH PICKER ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedMonth,
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_month, color: AppColors.accent),
                  onPressed: () {},
                ),
              ],
            ),
            const Gap(16),
            ..._events.map((event) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingMd),
                child: InkWell(
                  onTap: () => context.push('/events/${event['id']}'),
                  child: JumCard(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  event['category']!,
                                  style: AppTextStyles.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                                  const Gap(4),
                                  Text(
                                    event['time']!,
                                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Gap(12),
                          Text(
                            event['title']!,
                            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                          ),
                          const Gap(12),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                              const Gap(8),
                              Text(
                                event['date']!,
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          const Gap(4),
                          Row(
                            children: [
                              const Icon(Icons.place_outlined, size: 14, color: AppColors.textSecondary),
                              const Gap(8),
                              Expanded(
                                child: Text(
                                  event['location']!,
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const Gap(16),
                          const JumButton(
                            label: 'View Event Details',
                            isFullWidth: true,
                            onPressed: null, // Disabled in preview list but clickable
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// EVENT DETAIL SCREEN
// -------------------------------------------------------------
class EventDetailScreen extends StatefulWidget {
  final String eventId;
  const EventDetailScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isRegistered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: const Center(
                child: Icon(Icons.festival, size: 64, color: AppColors.accent),
              ),
            ),
            const Gap(24),
            Text(
              'Unhindered Worship Night',
              style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            const Gap(12),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.accent, size: 16),
                const Gap(8),
                Text(
                  'Friday, May 15 • 6:00 PM',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
            const Gap(8),
            Row(
              children: [
                const Icon(Icons.place_outlined, color: AppColors.accent, size: 16),
                const Gap(8),
                Text(
                  'Lagos HQ Main Sanctuary',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
            const Gap(24),
            Text(
              'About the Event',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            Text(
              'Join us for a transformational night of pure, unhindered praise, worship, and spiritual renewal. Come with an open heart to receive.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const Gap(32),
            JumButton(
              label: _isRegistered ? 'Successfully Registered (Cancel RSVP)' : 'Register for Event',
              variant: _isRegistered ? JumButtonVariant.secondary : JumButtonVariant.primary,
              isFullWidth: true,
              onPressed: () {
                setState(() => _isRegistered = !_isRegistered);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_isRegistered ? 'Registered successfully!' : 'RSVP cancelled.'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
