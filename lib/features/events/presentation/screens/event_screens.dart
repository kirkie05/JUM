import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as calendar_pkg;
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../../../shared/widgets/jum_shimmer.dart';
import '../../data/models/event_model.dart';
import '../../data/providers/events_provider.dart';
import '../widgets/calendar_view.dart';

final eventDetailProvider = FutureProvider.family<EventModel?, String>((ref, id) async {
  return ref.watch(eventsRepositoryProvider).fetchEvent(id);
});

class EventListScreen extends ConsumerStatefulWidget {
  const EventListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends ConsumerState<EventListScreen> {
  String _activeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(upcomingEventsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Events', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
        actions: [
          eventsAsync.when(
            data: (events) => IconButton(
              icon: const Icon(Icons.calendar_today_outlined, color: Colors.black87, size: 20),
              onPressed: () {
                showDialog(context: context, builder: (ctx) => CalendarView(events: events));
              },
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(radius: 14, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=33')),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0), border: Border.all(color: const Color(0xFFE5E7EB))),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                  Gap(12),
                  Expanded(
                    child: TextField(decoration: InputDecoration(hintText: 'Search for events...', hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14), border: InputBorder.none, contentPadding: EdgeInsets.only(bottom: 4))),
                  ),
                ],
              ),
            ),
          ),
          const Gap(8),
          Expanded(
            child: eventsAsync.when(
              loading: () => JumShimmer.list(),
              error: (e, st) => Center(child: Text('Error loading events: $e')),
              data: (events) {
                if (events.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.event_busy, size: 64, color: Colors.black26),
                        Gap(16),
                        Text('No Upcoming Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
                        Gap(8),
                        Text('Check back later for more events.', style: TextStyle(color: Colors.black45)),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const Gap(24),
                  itemBuilder: (context, index) {
                    return _buildEventCard(context, events[index], index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, EventModel event, int index) {
    final monthFormat = DateFormat('MMM').format(event.date).toUpperCase();
    final dayFormat = DateFormat('dd').format(event.date);
    final dayOfWeek = DateFormat('EEEE').format(event.date);
    final timeFormat = DateFormat('h:mm a').format(event.date);
    final isOutlined = index % 2 == 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: event.coverUrl,
                  fit: BoxFit.cover,
                  placeholder: (c, url) => Container(color: const Color(0xFFF3F4F6)),
                  errorWidget: (c, url, e) => Container(color: Colors.grey[200], child: const Icon(Icons.image_not_supported, color: Colors.grey)),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(0.1), Colors.transparent])),
                ),
              ),
              Positioned(
                top: 16, right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
                  child: Text('$monthFormat $dayFormat', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5, color: Colors.black)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.2, color: Color(0xFF111827))),
                const Gap(12),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF6B7280)),
                    const Gap(8),
                    Text('$dayOfWeek • $timeFormat', style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
                  ],
                ),
                const Gap(6),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 16, color: Color(0xFF6B7280)),
                    const Gap(6),
                    Expanded(child: Text(event.location, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const Gap(20),
                SizedBox(
                  width: double.infinity, height: 48,
                  child: ElevatedButton(
                    onPressed: () => context.push('/events/${event.id}'),
                    style: ElevatedButton.styleFrom(
                      elevation: 0, backgroundColor: isOutlined ? Colors.transparent : Colors.black, foregroundColor: isOutlined ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: isOutlined ? const BorderSide(color: Color(0xFFD1D5DB), width: 1) : BorderSide.none),
                    ),
                    child: const Text('View', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;
  const EventDetailScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider).valueOrNull;
      if (user != null) {
        ref.read(rsvpNotifierProvider.notifier).loadRsvp(user.id, widget.eventId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    final rsvpState = ref.watch(rsvpNotifierProvider);
    final userRsvps = rsvpState.valueOrNull ?? {};
    final key = user != null ? '${user.id}-${widget.eventId}' : '';
    final isRegistered = user != null && userRsvps.containsKey(key);

    final eventAsync = ref.watch(eventDetailProvider(widget.eventId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => context.pop()),
        title: Text('Events', style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_isSaved ? Icons.favorite : Icons.favorite_border, color: _isSaved ? AppColors.error : AppColors.textPrimary),
            onPressed: () => setState(() => _isSaved = !_isSaved),
          ),
          IconButton(icon: const Icon(Icons.share, color: AppColors.textPrimary), onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sharing link copied!'), backgroundColor: AppColors.success));
          }),
        ],
      ),
      body: eventAsync.when(
        loading: () => Padding(
          padding: const EdgeInsets.all(24.0),
          child: JumShimmer.card(height: 300),
        ),
        error: (e, st) => Center(child: Text('Error loading event details: $e')),
        data: (event) {
          if (event == null) {
            return const Center(child: Text('Event not found.'));
          }
          final dateStr = DateFormat('EEEE, MMM d, yyyy').format(event.date);
          final timeStr = DateFormat('h:mm a').format(event.date);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(100)),
                    child: const Text('EVENT', style: TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 10.0, fontWeight: FontWeight.w600, letterSpacing: 2.0, color: AppColors.textPrimary)),
                  ),
                ),
                const Gap(12),
                Text(event.title, style: const TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 28.0, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.2)),
                const Gap(24),
                Container(
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16.0), border: Border.all(color: AppColors.border), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 16, offset: const Offset(0, 4))]),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('DATE & TIME', style: TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 10.0, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 1.5)),
                                const Gap(8),
                                Text(dateStr, style: const TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 20.0, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                const Gap(4),
                                Text(timeStr, style: const TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 14.0, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          Container(padding: const EdgeInsets.all(12.0), decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle), child: const Icon(Icons.calendar_today_outlined, color: AppColors.textMuted, size: 24)),
                        ],
                      ),
                      const Gap(20), const Divider(color: AppColors.border, height: 1), const Gap(16),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                try {
                                  final calendarEvent = calendar_pkg.Event(title: event.title, description: event.description ?? '', location: event.location, startDate: event.date, endDate: event.date.add(const Duration(hours: 4)), allDay: false);
                                  calendar_pkg.Add2Calendar.addEvent2Cal(calendarEvent);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open calendar: $e')));
                                }
                              },
                              style: TextButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), padding: const EdgeInsets.symmetric(vertical: 12.0)),
                              child: const Text('Add to Calendar', style: TextStyle(fontFamily: AppTextStyles.fontFamily, fontWeight: FontWeight.w600, color: Colors.white)),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event notifications activated!'), backgroundColor: AppColors.success));
                              },
                              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), padding: const EdgeInsets.symmetric(vertical: 12.0)),
                              child: const Text('Notify Me', style: TextStyle(fontFamily: AppTextStyles.fontFamily, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                GestureDetector(
                  onTap: () async {
                    final query = Uri.encodeComponent(event.location);
                    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
                    try {
                      if (await canLaunchUrl(url)) { await launchUrl(url, mode: LaunchMode.externalApplication); }
                    } catch (_) {}
                  },
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16.0), border: Border.all(color: AppColors.border)),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(height: 140, width: double.infinity, decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(event.coverUrl), fit: BoxFit.cover)), child: Container(color: Colors.black.withOpacity(0.15), child: const Center(child: Icon(Icons.location_on, color: AppColors.primary, size: 40.0)))),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('LOCATION', style: TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 10.0, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 1.5)),
                                  Text('TAP TO OPEN MAP', style: TextStyle(fontSize: 9.0, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                ],
                              ),
                              const Gap(8),
                              Text(event.location, style: const TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 18.0, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(24),
                Container(
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16.0), border: Border.all(color: AppColors.border)),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('About the Event', style: TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 18.0, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const Gap(12),
                      Text(event.description ?? 'No description available.', style: const TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 14.0, color: AppColors.textSecondary, height: 1.6)),
                    ],
                  ),
                ),
                const Gap(40),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TicketQrScreen extends StatelessWidget {
  final String eventId;
  const TicketQrScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Your Ticket'), backgroundColor: Colors.transparent, elevation: 0),
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
                    const Text('UNHINDERED WORSHIP NIGHT', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Inter', fontSize: 18.0, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: 0.5)),
                    const Gap(8),
                    const Text('Friday, May 15, 2026 • 6:00 PM', style: TextStyle(fontFamily: 'Inter', fontSize: 13.0, color: AppColors.textSecondary)),
                    const Gap(24),
                    const Divider(color: AppColors.border, thickness: 1.0),
                    const Gap(24),
                    Container(width: 200, height: 200, padding: const EdgeInsets.all(12.0), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.0), border: Border.all(color: AppColors.border, width: 1.0)), child: CustomPaint(painter: QRPainter())),
                    const Gap(24),
                    const Text('TICKET ID: JUM-9921-884', style: TextStyle(fontFamily: 'Inter', fontSize: 12.0, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 1.5)),
                    const Gap(24),
                    const Divider(color: AppColors.border, thickness: 1.0),
                    const Gap(24),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_buildTicketMeta('NAME', 'Member'), _buildTicketMeta('SEAT', 'General Admission')]),
                  ],
                ),
              ),
            ),
            const Gap(24),
            JumButton(label: 'Add to Apple Wallet', onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to Apple Wallet successfully!'), backgroundColor: AppColors.success))),
            const Gap(12),
            OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), padding: const EdgeInsets.symmetric(vertical: 14.0)), child: const Text('Share Ticket', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketMeta(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 10.0, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 1.0)), const Gap(4), Text(value, style: const TextStyle(fontFamily: 'Inter', fontSize: 14.0, fontWeight: FontWeight.bold, color: AppColors.textPrimary))]);
  }
}

class QRPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black..style = PaintingStyle.fill;
    _drawFinderPattern(canvas, 0, 0, paint);
    _drawFinderPattern(canvas, size.width - 40, 0, paint);
    _drawFinderPattern(canvas, 0, size.height - 40, paint);
    final r = java_like_random(42);
    for (double y = 48; y < size.height - 12; y += 12) {
      for (double x = 12; x < size.width - 12; x += 12) {
        if (x < 48 && y < 48) continue;
        if (x > size.width - 48 && y < 48) continue;
        if (x < 48 && y > size.height - 48) continue;
        if (r() > 0.4) canvas.drawRect(Rect.fromLTWH(x, y, 8, 8), paint);
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
    return () { s = (s * 1103515245 + 12345) & 0x7fffffff; return s / 2147483647.0; };
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
