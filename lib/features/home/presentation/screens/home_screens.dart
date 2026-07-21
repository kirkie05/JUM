import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_avatar.dart';
import '../../../../features/auth/data/providers/auth_provider.dart';
import '../../../../features/sermons/data/providers/sermon_provider.dart';
import '../../../../features/events/data/providers/events_provider.dart';
import '../../../../features/media/data/providers/media_provider.dart';
import '../../../../features/media/data/models/media_item.dart';
import '../../../../features/media/presentation/screens/media_player_screen.dart';
import '../../../../features/community/data/providers/community_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../shared/widgets/jum_empty_state.dart';
import '../../../../shared/widgets/jum_error_state.dart';
import '../../../../shared/widgets/jum_shimmer.dart';
import '../../../bible/data/providers/reading_plan_providers.dart';
import '../../../bible/data/models/bible_reading_plan_engine.dart';
import '../../../bible/data/providers/bible_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.valueOrNull;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Surface background
      appBar: null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Greeting Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${user?.firstName ?? 'Friend'}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Gap(4),
                        const Text(
                          'May your day be filled with intentional reflection.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/logo/Jum Logo Black.png',
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              const Gap(24),

              // Latest Sermon
              const Text(
                'Latest Sermon',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Gap(16),

              // Featured Sermon Card
              ref
                  .watch(latestMediaVideoProvider)
                  .when(
                    data: (mediaItem) {
                      if (mediaItem == null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: JumEmptyState(
                            title: 'No sermons available',
                            subtitle: 'Please check back later for new messages!',
                            icon: Icons.video_library_outlined,
                            actionLabel: 'Retry',
                            onAction: () => ref.invalidate(latestMediaVideoProvider),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () => context.push('/media/player', extra: mediaItem),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        mediaItem.thumbnailUrl ?? '',
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Container(color: Colors.grey[200]),
                                      ),
                                      Center(
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mediaItem.title,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Gap(8),
                                    if (mediaItem.publishedAt != null)
                                      Text(
                                        mediaItem.publishedAt!
                                            .toIso8601String()
                                            .split('T')
                                            .first,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12.0,
                                          color: Colors.grey,
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
                    loading: () => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: JumShimmer.card(height: 220),
                    ),
                    error: (err, stack) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: JumErrorState(
                        message: 'Failed to load latest sermon.',
                        onRetry: () => ref.invalidate(latestMediaVideoProvider),
                      ),
                    ),
                  ),

              const Gap(32),

              // Upcoming Events
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/events'),
                    child: const Text(
                      'VIEW ALL',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const Gap(16),

              ref
                  .watch(upcomingEventsProvider)
                  .when(
                    data: (events) {
                      if (events.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: JumEmptyState(
                            title: 'No upcoming events',
                            subtitle: 'Please check back later for exciting updates!',
                            icon: Icons.calendar_month_outlined,
                          ),
                        );
                      }
                      return SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            return GestureDetector(
                              onTap: () => context.push('/events/${event.id}'),
                              child: Container(
                                width: 280,
                                margin: const EdgeInsets.only(right: 16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 120,
                                      child: Image.network(
                                        event.coverUrl.isNotEmpty
                                            ? event.coverUrl
                                            : 'https://placehold.co/600x400/png',
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Container(color: Colors.grey[200]),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.title,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const Gap(8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                              const Gap(4),
                                              Text(
                                                event.date
                                                    .toIso8601String()
                                                    .split('T')
                                                    .first,
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 12.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
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
                    },
                    loading: () => SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return JumShimmer(
                            child: Container(
                              width: 280,
                              margin: const EdgeInsets.only(right: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    error: (err, stack) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: JumErrorState(
                        message: 'We had trouble loading upcoming events. Please try again.',
                        onRetry: () => ref.invalidate(upcomingEventsProvider),
                      ),
                    ),
                  ),

              const Gap(32),

              // More Section
              const Text(
                'More',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Gap(16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.5,
                children: [
                  _buildActionCard(
                    context,
                    title: 'Gospel Army',
                    icon: Icons.school_rounded,
                    color: const Color(0xFF6366F1), // indigo
                    onTap: () => context.push('/gospel_army'),
                  ),

                  _buildActionCard(
                    context,
                    title: 'Bible',
                    icon: Icons.menu_book_rounded,
                    color: const Color(0xFFF59E0B), // amber
                    onTap: () => context.go('/home/bible'),
                  ),
                  _buildActionCard(
                    context,
                    title: 'Events',
                    icon: Icons.event_rounded,
                    color: const Color(0xFFEF4444), // red
                    onTap: () => context.push('/events'),
                  ),
                ],
              ),

              const Gap(32),

              // Today's Bible Reading Section
              const Text(
                'Today\'s Bible Reading',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Gap(16),

              ref.watch(readingPlanStateProvider).when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                    error: (err, _) => const SizedBox.shrink(),
                    data: (planState) {
                      final nextRead = planState.nextReading;
                      final isPlanDone = planState.completedDays.length == 365;

                      return JumCard(
                        onTap: () => context.push('/bible/reading-plan'),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Today\'s Reading',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                if (!isPlanDone)
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF6B7280)),
                                      const Gap(4),
                                      Text(
                                        '${nextRead.estimatedReadingTimeMinutes} MINS',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const Gap(8),
                            Text(
                              isPlanDone ? 'Well done, good and faithful servant!' : nextRead.title,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            if (!isPlanDone) ...[
                              const Gap(16),
                              JumButton(
                                label: 'Continue Reading',
                                onPressed: () => context.push('/bible/reading-plan'),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),

              const Gap(32),

              // Community Highlights
              const Text(
                'Community Highlights',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const Gap(16),

              ref.watch(communityFeedProvider(groupId: null)).when(
                data: (posts) {
                  if (posts.isEmpty) {
                    return const JumEmptyState(
                      title: 'No community activity',
                      subtitle: 'Be the first to share a moment!',
                      icon: Icons.people_outline,
                    );
                  }
                  final latestPost = posts.first;
                  return JumCard(
                    onTap: () => context.push('/community'),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        JumAvatar(
                          imageUrl: latestPost.authorAvatarUrl,
                          initials: latestPost.authorName?.isNotEmpty == true ? latestPost.authorName![0] : 'U',
                          size: 48.0,
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                latestPost.authorName ?? 'Community Member',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                latestPost.body,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.0,
                                  color: Color(0xFF6B7280),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Gap(8),
                              Row(
                                children: const [
                                  Text(
                                    'VIEW POST',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Gap(4),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 16.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => JumShimmer.listTile(),
                error: (err, stack) => const SizedBox(), // Hide if stream fails silently
              ),

              const Gap(16),

              JumCard(
                onTap: () => context.push('/forms'),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.connect_without_contact_outlined,
                        color: Colors.black,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Connect & Share',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Gap(4),
                          const Text(
                            'Submit prayer requests, share testimonies, register as a new member, or send feedback to our team.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const Gap(8),
                          Row(
                            children: const [
                              Text(
                                'SHARE WITH US',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Gap(4),
                              Icon(
                                Icons.chevron_right,
                                size: 16.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.0),
            ),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sectionHeaderColor = isDark ? Colors.white70 : AppColors.textSecondary;
    final rowBgColor = isDark ? const Color(0xFF131A22) : Colors.white;
    final rowBorderColor = isDark ? Colors.white10 : Colors.grey.shade100;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0C0F14) : const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF131A22) : Colors.white,
        elevation: 0,
        title: Text(
          'More Menu',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: isDark ? Colors.white10 : const Color(0xFFF3F4F6),
            height: 1.0,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        children: [
          _buildSectionHeader('MINISTRY & OUTREACH', sectionHeaderColor),
          const Gap(10),
          _buildGroup(
            isDark: isDark,
            rowBgColor: rowBgColor,
            rowBorderColor: rowBorderColor,
            children: [
              _buildRow(
                context,
                label: 'Online Giving',
                icon: Icons.volunteer_activism_rounded,
                iconColor: const Color(0xFFE53E3E),
                route: '/home/give',
              ),
              _buildRow(
                context,
                label: 'Upcoming Events',
                icon: Icons.event_note_rounded,
                iconColor: const Color(0xFF3182CE),
                route: '/events',
              ),

            ],
          ),
          const Gap(28),
          
          _buildSectionHeader('SPIRITUAL GROWTH', sectionHeaderColor),
          const Gap(10),
          _buildGroup(
            isDark: isDark,
            rowBgColor: rowBgColor,
            rowBorderColor: rowBorderColor,
            children: [
              _buildRow(
                context,
                label: 'Holy Bible',
                icon: Icons.menu_book_rounded,
                iconColor: const Color(0xFF38A169),
                route: '/bible',
              ),
              _buildRow(
                context,
                label: 'Gospel Army',
                icon: Icons.school_rounded,
                iconColor: const Color(0xFF805AD5),
                route: '/gospel_army',
              ),
            ],
          ),
          const Gap(28),
          
          _buildSectionHeader('CONNECT & ACCOUNT', sectionHeaderColor),
          const Gap(10),
          _buildGroup(
            isDark: isDark,
            rowBgColor: rowBgColor,
            rowBorderColor: rowBorderColor,
            children: [
              _buildRow(
                context,
                label: 'Messaging',
                icon: Icons.chat_bubble_rounded,
                iconColor: const Color(0xFF319795),
                route: '/messaging',
              ),
              _buildRow(
                context,
                label: 'My Profile',
                icon: Icons.person_rounded,
                iconColor: const Color(0xFF4A5568),
                route: '/profile',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11.0,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildGroup({
    required bool isDark,
    required Color rowBgColor,
    required Color rowBorderColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: rowBgColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: rowBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Divider(
              color: rowBorderColor,
              height: 1,
              thickness: 1,
              indent: 56,
            );
          }
          return children[index ~/ 2];
        }),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color iconColor,
    required String route,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: () => context.push(route),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Icon(
                icon,
                size: 20.0,
                color: iconColor,
              ),
            ),
            const Gap(14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.0,
              color: isDark ? Colors.white30 : Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
