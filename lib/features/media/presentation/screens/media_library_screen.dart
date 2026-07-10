import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/jum_empty_state.dart';
import '../../../../shared/widgets/jum_error_state.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_shimmer.dart';
import '../../data/models/media_item.dart';
import '../../data/providers/media_provider.dart';

import 'media_player_screen.dart';

class MediaLibraryScreen extends ConsumerStatefulWidget {
  const MediaLibraryScreen({super.key});

  @override
  ConsumerState<MediaLibraryScreen> createState() => _MediaLibraryScreenState();
}

class _MediaLibraryScreenState extends ConsumerState<MediaLibraryScreen> {
  Future<void> _refresh() async {
    ref.invalidate(mediaFeedProvider);
  }

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(mediaFeedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Media Library',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh media',
            icon: const Icon(
              Icons.refresh_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: _refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColors.primary,
        child: feedAsync.when(
          data: (videos) {
            if (videos.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  JumEmptyState(
                    title: 'No Media Available',
                    subtitle: 'We could not find any videos at this time. Please check back later.',
                    icon: Icons.video_library_outlined,
                  ),
                ],
              );
            }

            final latestVideo = videos.isNotEmpty ? videos.first : null;
            final recentVideos = videos.length > 1 ? videos.skip(1).take(4).toList() : <MediaItem>[];
            final olderVideos = videos.length > 5 ? videos.skip(5).toList() : <MediaItem>[];

            return CustomScrollView(
              slivers: [
                if (latestVideo != null) ...[
                  const SliverToBoxAdapter(child: Gap(16)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Latest Sermon',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: Gap(12)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _FeaturedVideoCard(video: latestVideo),
                    ),
                  ),
                ],
                if (recentVideos.isNotEmpty) ...[
                  const SliverToBoxAdapter(child: Gap(32)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Recent Uploads',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: Gap(12)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _VideoListCard(video: recentVideos[index]),
                          );
                        },
                        childCount: recentVideos.length,
                      ),
                    ),
                  ),
                ],
                if (olderVideos.isNotEmpty) ...[
                  const SliverToBoxAdapter(child: Gap(16)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Older Videos',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: Gap(12)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _VideoListCard(video: olderVideos[index]),
                          );
                        },
                        childCount: olderVideos.length,
                      ),
                    ),
                  ),
                ],
                const SliverToBoxAdapter(child: Gap(32)),
              ],
            );
          },
          loading: () => const _MediaLibrarySkeleton(),
          error: (err, stack) => ListView(
            padding: const EdgeInsets.all(24),
            children: [
              JumErrorState(
                message: err.toString(),
                onRetry: _refresh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedVideoCard extends StatelessWidget {
  const _FeaturedVideoCard({required this.video});

  final MediaItem video;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final dateStr = video.publishedAt != null ? dateFormat.format(video.publishedAt!) : '';
    
    // Parse duration
    String durationStr = '';
    if (video.duration != null) {
      final seconds = int.tryParse(video.duration!) ?? 0;
      if (seconds > 0) {
        final d = Duration(seconds: seconds);
        durationStr = '${d.inHours > 0 ? '${d.inHours}:' : ''}${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Thumbnail
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: video.thumbnailUrl != null
                    ? CachedNetworkImage(
                        imageUrl: video.thumbnailUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => JumShimmer.card(),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.video_library, color: Colors.grey),
                        ),
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.video_library, color: Colors.grey),
                      ),
              ),
              if (durationStr.isNotEmpty)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      durationStr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (dateStr.isNotEmpty) ...[
                  Text(
                    dateStr,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(4),
                ],
                Text(
                  video.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (video.description != null && video.description!.isNotEmpty) ...[
                  const Gap(8),
                  Text(
                    video.description!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const Gap(16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MediaPlayerScreen(item: video),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                    label: const Text(
                      'Watch Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Standardization
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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

class _VideoListCard extends StatelessWidget {
  const _VideoListCard({required this.video});

  final MediaItem video;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final dateStr = video.publishedAt != null ? dateFormat.format(video.publishedAt!) : '';
    
    // Parse duration
    String durationStr = '';
    if (video.duration != null) {
      final seconds = int.tryParse(video.duration!) ?? 0;
      if (seconds > 0) {
        final d = Duration(seconds: seconds);
        durationStr = '${d.inHours > 0 ? '${d.inHours}:' : ''}${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';
      }
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaPlayerScreen(item: video),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            SizedBox(
              width: 140,
              height: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                    child: video.thumbnailUrl != null
                        ? CachedNetworkImage(
                            imageUrl: video.thumbnailUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => JumShimmer.card(),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.video_library, color: Colors.grey),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.video_library, color: Colors.grey),
                          ),
                  ),
                  if (durationStr.isNotEmpty)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          durationStr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(6),
                    if (video.description != null && video.description!.isNotEmpty) ...[
                      Text(
                        video.description!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(4),
                    ],
                    if (dateStr.isNotEmpty)
                      Text(
                        dateStr,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaLibrarySkeleton extends StatelessWidget {
  const _MediaLibrarySkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        JumShimmer(child: Container(height: 24, width: 140, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)))),
        const Gap(12),
        JumShimmer(child: Container(height: 200, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)))),
        const Gap(32),
        JumShimmer(child: Container(height: 20, width: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)))),
        const Gap(12),
        ...List.generate(4, (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              JumShimmer(child: Container(height: 100, width: 140, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)))),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    JumShimmer(child: Container(height: 16, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)))),
                    const Gap(8),
                    JumShimmer(child: Container(height: 16, width: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)))),
                    const Gap(8),
                    JumShimmer(child: Container(height: 12, width: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)))),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
