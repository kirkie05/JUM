import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/providers/sermon_provider.dart';

class MiniPlayerBar extends ConsumerWidget {
  const MiniPlayerBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(sermonPlayerNotifierProvider);
    final notifier = ref.read(sermonPlayerNotifierProvider.notifier);

    if (playerState.sermon == null) {
      return const SizedBox.shrink();
    }

    final sermon = playerState.sermon!;
    final double progress = playerState.duration.inSeconds > 0
        ? playerState.position.inSeconds / playerState.duration.inSeconds
        : 0.0;

    return InkWell(
      onTap: () => context.push('/sermons/${sermon.id}'),
      child: Container(
        height: 64,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: Stack(
          children: [
            // Progress bar at the top of the container
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: AppColors.surface2,
                color: AppColors.accent,
                minHeight: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: sermon.thumbnailUrl,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                      errorWidget: (c, u, e) => Container(
                        height: 40,
                        width: 40,
                        color: AppColors.surface2,
                        child: const Icon(Icons.music_note_rounded, size: 20, color: AppColors.accent),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title + Speaker
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sermon.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          sermon.speaker,
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Play/Pause Icon
                  IconButton(
                    icon: Icon(
                      playerState.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: AppColors.accent,
                      size: 28,
                    ),
                    onPressed: () {
                      if (playerState.isPlaying) {
                        notifier.pause();
                      } else {
                        notifier.resume();
                      }
                    },
                  ),
                  // Close Icon
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    onPressed: () => notifier.stop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
