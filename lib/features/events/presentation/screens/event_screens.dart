import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../data/models/event_model.dart';
import '../../data/providers/events_provider.dart';


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
class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;
  const EventDetailScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  bool _isSaved = false;
  bool _isRegistered = false;

  @override
  Widget build(BuildContext context) {
    // Determine details dynamically or fallback to Unhindered Awakening
    final String title = widget.eventId == 'event-2' 
        ? 'Youth Grace Summit 2026' 
        : widget.eventId == 'event-3' 
            ? 'Couples Prayer Breakfast' 
            : 'Unhindered: The Modern Spiritual Awakening';
            
    final String category = widget.eventId == 'event-2' 
        ? 'Summit' 
        : widget.eventId == 'event-3' 
            ? 'Prayer' 
            : 'Conference';

    final String dateStr = widget.eventId == 'event-2' 
        ? 'Saturday, May 23, 2026' 
        : widget.eventId == 'event-3' 
            ? 'Saturday, May 30, 2026' 
            : 'Saturday, Oct 24, 2026';

    final String timeStr = widget.eventId == 'event-2' 
        ? '10:00 AM — 04:00 PM EST' 
        : widget.eventId == 'event-3' 
            ? '08:30 AM — 11:30 AM EST' 
            : '09:00 AM — 04:00 PM EST';

    final String locationName = widget.eventId == 'event-2' 
        ? 'Houston Campus Hall A' 
        : widget.eventId == 'event-3' 
            ? 'London Grace Fellowship' 
            : 'The Sanctuary Hall';

    final String locationAddress = widget.eventId == 'event-2' 
        ? 'Houston, Texas' 
        : widget.eventId == 'event-3' 
            ? 'London, UK' 
            : 'Downtown District, NYC';

    final String description = widget.eventId == 'event-2'
        ? 'A power-packed weekend of empowerment, career development, panel sessions, and deep spiritual infilling designed for the next generation of leaders.'
        : widget.eventId == 'event-3'
            ? 'An intimate fellowship breakfast for couples to align in prayers, receive counsel on marriage, and connect with other families in a grace-filled environment.'
            : 'Join us for a transformative experience designed to strip away the noise of modern life. Unhindered is more than just a conference; it’s a space for deep reflection, scripture, and communal worship.\n\nThis year, we focus on the "Aesthetic of Silence," exploring how minimal distractions lead to maximum spiritual clarity. We have curated a day of focused sessions, quiet meditation, and powerful teachings from leading voices in our ministry.';

    final String priceStr = widget.eventId == 'event-2' 
        ? '\$50.00' 
        : widget.eventId == 'event-3' 
            ? '\$75.00' 
            : '\$45.00';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Events',
          style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sharing link copied to clipboard!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: const NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCUZzPfyo0UbfVvQOeUgAk0JLHe_q9TNtodwZZm_DmUXYBjAD8Algw3tk-DaRnazCs2OKK2lVydfWSN2mfVYnD1SJNo_9NRLNf6J6j4IR_sgkXHLKXSSYBRx5QfpSBb8EnpOFahpyNs82qMtHLx6QVoR5z_fR-vafZg2_r2xKeyhFqRvCXJWTj0w0HssXMn9E3iFersMWe_NewtfjgcRdEwC_InxwccCv6jm5t_rvOH7mxeeNzW6wGxHin94JsZLdIPoLZ8Y6IjFA',
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section: Title and Key Visual
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  category.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const Gap(12),
            Text(
              title,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 28.0,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            const Gap(24),

            // Bento Grid: Date & Time Card
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DATE & TIME',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMuted,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              dateStr,
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              timeStr,
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 14.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.textMuted,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  const Divider(color: AppColors.border, height: 1),
                  const Gap(16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to system calendar!'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                          ),
                          child: const Text(
                            'Add to Calendar',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reminders configured.'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                          ),
                          child: const Text(
                            'Notify Me',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(16),

            // Bento Grid: Location Block
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDLPuT2bgsg-HQyCxCJG-iPsqDJIOkTuPqIcZb2KRqaxz0zqrtwhXjWnSHOZlgRuF5VOt2Cb2ny5ZvrZv3NiioUEWvjtRn0FKoE6NG4tWwHvC5nHSkpXFyV-Ec-dx3hth0XlhnM1cBz9wLhC6EZuSk3Bj_vhHwgQVmVIR6A9l2Q1L29G_19_1rhBJ37yImMDuKGbuzUFCgVtD6p4NpUvfoEU3fSVs1EPAWVqHmCy4CcpijEVxK5Wjl0vDfNgdqj3KfP2w-LE_48GA',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.15),
                      child: const Center(
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'LOCATION',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMuted,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          locationName,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          locationAddress,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 14.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),

            // Description Section
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About the Event',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Gap(12),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14.0,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),

            // Keynote Speakers List
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Keynote Speakers',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  children: [
                    _buildSpeakerItem(
                      'Dr. Elias Thorne',
                      'Theology & Art',
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCAbkmM8yYPd4-mkRIuC4elsXAh1HbJ5aaV29EVSHIl2focZ9LLJhAC4BoidBxbduHn_TVYlNHlTKxLJcE1qdW-Ck_sAyvXjDfStPXjEqN8VzT8XYbELqxkk_n0YmwJ2zCrMx46O7expBoCVGUVjdU_G0FQdzoOVO0L77C6vr_Vwi9dIoxY2C3Ct_SVu4F5beajfK6EPAjN7LV9x-oDevw-K57SiXfO-TAV5leGnFJiR8Kr_wuW7S_VigZX3XTwYnD0X8ptXv9Wbw',
                    ),
                    _buildSpeakerItem(
                      'Sarah Jenkins',
                      'Worship Lead',
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuC0tKu0dE8QSt0t4t0LLvaUvZZUuc5VjEFC42NXrAOV8vwBjF4JkY93-USGtoiywwss4ERLNYyIxFFqWjkZzkNcc40NitDPIKQrAF8TCXHiKqXKl4MbMxxV-e93oZhzr2NT1C3syRqbaLYHiTvvuqx3sGZWs_DRvAUR8pXUQyuBTTKGrnTUlv4ifC9r3koe85uQ5IqW48l9KxFERCSOWtQeYxwLm8SVNYy75JYsubWJIPptdgfYfKnDBe0Arkz5JAuvEVghYtrjvg',
                    ),
                    _buildSpeakerItem(
                      'Markus Vane',
                      'Community Director',
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBMqKA6pCb-PBNSKTrvSACrZCPbh8SKBGqpJ9N2uuULh_c6O2qig5-bDvlmVs8lqP0Omsxumb0WNZsYTlzKZSUpBCgNNWe5v-pg9Uv9aO3fE69S8iTPG3PN3JNzZSsImY-8GihtOrmr8kBcFkGxCBHXd0QHlD_MAP9om_BPeQYorcv3rzXvGQovcyq65xqMf3Dgd0Oj0OS4yIJpp8x3HGGfAQS2q1toK4wQp9o_cYCvXWSvgUrlZj71i6moFBM01RedrdsThtCWFw',
                    ),
                    _buildSpeakerItem(
                      'Elena Rossi',
                      'Scripture Specialist',
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuClYsdTfZhxme4biCsaItJWbsGsKW_KHUT9vjFJEcfQHfnMoe5E7KgluxTEGTc4BuTrkuGVhH86ltH2B4TGg_3X68RsMcg4jBQ633-446kzCPkf-4ZFkIE9KQubOwJjHOz5blVXud-m2kUHbmq1XdLqdMS0ET_xLN_D7tcIhKfMsjOWfZEvtgyKV7cjFuHtz7Bhj2_M-uuRSc8053rnsiM162zar1iL5i5tSX5ollqKztt1FOKWwDAvK3u_HptOAmAFZUulClWRmQ',
                    ),
                  ],
                ),
              ],
            ),
            const Gap(100), // Spacing for floating bottom bar
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.85),
          border: const Border(
            top: BorderSide(color: AppColors.border, width: 1.0),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PRICE',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      priceStr,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const Gap(24),
                Expanded(
                  child: JumButton(
                    label: _isRegistered ? 'RSVPD (Cancel RSVP)' : 'Register Now',
                    variant: _isRegistered ? JumButtonVariant.secondary : JumButtonVariant.primary,
                    onPressed: () {
                      setState(() {
                        _isRegistered = !_isRegistered;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isRegistered ? 'RSVP created successfully!' : 'RSVP cancelled successfully.',
                          ),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                  ),
                ),
                const Gap(12),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSaved = !_isSaved;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Icon(
                      _isSaved ? Icons.favorite : Icons.favorite_border,
                      color: _isSaved ? AppColors.error : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeakerItem(String name, String role, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const Gap(12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(4),
          Text(
            role,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 12.0,
              color: AppColors.textMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// TICKET QR CODE SCREEN
// -------------------------------------------------------------
class TicketQrScreen extends StatelessWidget {
  final String eventId;
  const TicketQrScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Ticket'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            JumCard(
              backgroundColor: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'UNHINDERED WORSHIP NIGHT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Gap(8),
                    const Text(
                      'Friday, May 15, 2026 • 6:00 PM',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Gap(24),
                    const Divider(color: AppColors.border, thickness: 1.0),
                    const Gap(24),
                    // High-fidelity Simulated QR Code
                    Container(
                      width: 200,
                      height: 200,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: AppColors.border, width: 1.0),
                      ),
                      child: CustomPaint(
                        painter: QRPainter(),
                      ),
                    ),
                    const Gap(24),
                    const Text(
                      'TICKET ID: JUM-9921-884',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Gap(24),
                    const Divider(color: AppColors.border, thickness: 1.0),
                    const Gap(24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTicketMeta('NAME', 'Emmanuel Adebayo'),
                        _buildTicketMeta('SEAT', 'General Admission'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Gap(24),
            JumButton(
              label: 'Add to Apple Wallet',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Added to Apple Wallet successfully!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
            const Gap(12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                padding: const EdgeInsets.symmetric(vertical: 14.0),
              ),
              child: const Text(
                'Share Ticket',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketMeta(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            letterSpacing: 1.0,
          ),
        ),
        const Gap(4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class QRPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Outer corner finder patterns
    _drawFinderPattern(canvas, 0, 0, paint);
    _drawFinderPattern(canvas, size.width - 40, 0, paint);
    _drawFinderPattern(canvas, 0, size.height - 40, paint);

    // Random QR code module pixels
    final r = java_like_random(42);
    for (double y = 48; y < size.height - 12; y += 12) {
      for (double x = 12; x < size.width - 12; x += 12) {
        if (x < 48 && y < 48) continue;
        if (x > size.width - 48 && y < 48) continue;
        if (x < 48 && y > size.height - 48) continue;
        if (r() > 0.4) {
          canvas.drawRect(Rect.fromLTWH(x, y, 8, 8), paint);
        }
      }
    }
  }

  void _drawFinderPattern(Canvas canvas, double x, double y, Paint paint) {
    canvas.drawRect(Rect.fromLTWH(x, y, 40, 40), paint);
    canvas.drawRect(Rect.fromLTWH(x + 6, y + 6, 28, 28), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(x + 12, y + 12, 16, 16), paint);
  }

  double Function() java_like_random(int seed) {
    int s = seed;
    return () {
      s = (s * 1103515245 + 12345) & 0x7fffffff;
      return s / 2147483647.0;
    };
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
