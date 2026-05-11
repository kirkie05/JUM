import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../data/models/sermon_model.dart';

class SermonCard extends StatelessWidget {
  final SermonModel sermon;

  const SermonCard({
    Key? key,
    required this.sermon,
  }) : super(key: key);

  String _formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    } else {
      return '$m:${s.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return JumCard(
      onTap: () => context.push('/sermons/${sermon.id}'),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Thumbnail section with badge and icon overlays
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: sermon.thumbnailUrl,
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 110,
                    color: const Color(0xFF1F1F1F),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 110,
                    color: const Color(0xFF1F1F1F),
                    child: const Center(
                      child: Icon(Icons.movie_creation_outlined, color: Color(0xFF8E8E8E)),
                    ),
                  ),
                ),
                // Center icon overlay
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
                        ),
                        child: Icon(
                          sermon.type == 'video' ? Icons.play_arrow_rounded : Icons.waves_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                // Duration Badge top-right
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
                    ),
                    child: Text(
                      _formatDuration(sermon.durationSeconds),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content metadata padding
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sermon.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(4),
                Text(
                  sermon.speaker,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.0,
                    color: Color(0xFF8E8E8E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
