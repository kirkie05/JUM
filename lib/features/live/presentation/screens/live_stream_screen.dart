import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_app_bar.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_empty_state.dart';
import '../../data/models/stream_model.dart';
import '../../data/providers/live_provider.dart';

class LiveStreamScreen extends ConsumerWidget {
  const LiveStreamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveStreamsAsync = ref.watch(liveStreamsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const JumAppBar(
        title: 'Live Streams',
        showBack: false,
      ),
      body: liveStreamsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error loading stream details: $err',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
        data: (streams) {
          // Identify any active streams
          final activeStream = streams.firstWhere(
            (s) => s.status == 'active',
            orElse: () => LiveStreamModel(
              id: '',
              churchId: '',
              muxStreamId: '',
              muxPlaybackId: '',
              title: '',
              status: '',
              scheduledAt: intlEpoch,
            ),
          );

          final upcomingStreams = streams.where((s) => s.status == 'idle').toList();

          if (activeStream.id.isEmpty && upcomingStreams.isEmpty) {
            return const JumEmptyState(
              title: 'No Live Streams Scheduled',
              subtitle: 'Check back later for upcoming church services, prayer sessions, and sermon broadcasts.',
              icon: Icons.live_tv_rounded,
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (activeStream.id.isNotEmpty) ...[
                    // High-fidelity featured live stream card
                    JumCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.circle, color: Colors.white, size: 8),
                                    Gap(6),
                                    Text(
                                      'LIVE NOW',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.wifi_tethering_rounded, color: AppColors.accent, size: 24),
                            ],
                          ),
                          const Gap(16),
                          Text(
                            activeStream.title,
                            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
                          ),
                          const Gap(8),
                          Text(
                            'Pastor Kingsley is preaching live. Join the congregation now for an interactive praise, worship, and sermon service.',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                          const Gap(20),
                          JumButton(
                            label: 'Join Stream',
                            onPressed: () => context.push('/live/${activeStream.id}'),
                            isFullWidth: true,
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),
                  ],

                  if (upcomingStreams.isNotEmpty) ...[
                    Text(
                      'Upcoming Streams',
                      style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    ),
                    const Gap(16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: upcomingStreams.length,
                      itemBuilder: (context, index) {
                        final upcoming = upcomingStreams[index];
                        final formattedTime = DateFormat('EEEE, MMM d • h:mm a').format(upcoming.scheduledAt);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: JumCard(
                            child: Row(
                              children: [
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface2,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.calendar_today_rounded, color: AppColors.accent),
                                ),
                                const Gap(16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        upcoming.title,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Gap(4),
                                      Text(
                                        formattedTime,
                                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.border, width: 0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Scheduled',
                                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          );
          },
        ),
    );
  }
}

// Fallback constant for orElse
final intlEpoch = DateTime.fromMillisecondsSinceEpoch(0);
