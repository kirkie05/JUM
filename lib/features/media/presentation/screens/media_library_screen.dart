import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/jum_empty_state.dart';
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
  String _activeFilter = 'All';
  final _filters = const ['All', 'Videos', 'Audio'];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width >= 1024
        ? 4
        : width >= 650
        ? 3
        : 1;
    final mediaAsync = ref.watch(mediaFeedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Media',
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
            onPressed: () => ref.invalidate(mediaFeedProvider),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
            child: Row(
              children: _filters.map((filter) {
                final selected = _activeFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: selected,
                    selectedColor: AppColors.accent,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      color: selected ? Colors.black : AppColors.textPrimary,
                    ),
                    onSelected: (_) => setState(() => _activeFilter = filter),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: mediaAsync.when(
              data: (items) {
                final filtered = items.where((item) {
                  if (_activeFilter == 'Videos') {
                    return item.type == MediaItemType.video;
                  }
                  if (_activeFilter == 'Audio') {
                    return item.type == MediaItemType.audio;
                  }
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return const JumEmptyState(
                    title: 'No Media Found',
                    subtitle: 'Check the channel URLs in admin and refresh.',
                    icon: Icons.video_library_rounded,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(mediaFeedProvider),
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: crossAxisCount == 1 ? 1.55 : 0.86,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _MediaItemCard(item: filtered[index]);
                    },
                  ),
                );
              },
              loading: () => const JumShimmerGrid(),
              error: (error, stack) => JumEmptyState(
                title: 'Unable to Load Media',
                subtitle: error.toString(),
                icon: Icons.cloud_off_rounded,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaItemCard extends StatelessWidget {
  const _MediaItemCard({required this.item});

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    final isVideo = item.type == MediaItemType.video;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _open(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (item.thumbnailUrl != null)
                    CachedNetworkImage(
                      imageUrl: item.thumbnailUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          _FallbackArt(isVideo: isVideo),
                    )
                  else
                    _FallbackArt(isVideo: isVideo),
                  Container(color: Colors.black.withValues(alpha: 0.28)),
                  Center(
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.68),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Icon(
                        isVideo
                            ? Icons.play_arrow_rounded
                            : Icons.graphic_eq_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _Badge(
                      label: item.isLive
                          ? 'LIVE'
                          : isVideo
                          ? 'VIDEO'
                          : 'AUDIO',
                      color: item.isLive ? AppColors.error : AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    _metaLine(item),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _metaLine(MediaItem item) {
    if (item.viewCount != null) {
      return '${item.viewCount} views';
    }
    if (item.isLive) return 'On air now';
    return '';
  }

  Future<void> _open(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaPlayerScreen(item: item),
      ),
    );
  }
}

class _FallbackArt extends StatelessWidget {
  const _FallbackArt({required this.isVideo});

  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface2,
      child: Icon(
        isVideo ? Icons.ondemand_video_rounded : Icons.radio_rounded,
        color: AppColors.textSecondary,
        size: 48,
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          color: Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class JumShimmerGrid extends StatelessWidget {
  const JumShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return JumShimmer(
      child: GridView.count(
        padding: const EdgeInsets.all(24),
        crossAxisCount: MediaQuery.sizeOf(context).width >= 650 ? 3 : 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.15,
        children: List.generate(
          6,
          (_) => Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
