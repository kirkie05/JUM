import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/community_provider.dart';
import '../widgets/post_card.dart';
import '../../../../shared/widgets/jum_app_shell.dart';
import '../../../../shared/widgets/jum_app_bar.dart';
import '../../../../shared/widgets/jum_empty_state.dart';
import '../../../../shared/widgets/jum_error_state.dart';
import '../../../../shared/widgets/jum_shimmer.dart';
import '../../../../shared/widgets/jum_text_field.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class CommunityFeedScreen extends ConsumerWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: JumAppBar(
        title: 'Community',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Feed list
          ref.watch(communityFeedProvider).when(
                data: (posts) {
                  if (posts.isEmpty) {
                    return const JumEmptyState(
                      title: 'No posts yet',
                      subtitle: 'Be the first to share something',
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(AppSizes.paddingMd),
                    itemCount: posts.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.paddingMd),
                        child: PostCard(post: posts[i]),
                      );
                    },
                  );
                },
                loading: () => JumShimmer.list(count: 4),
                error: (e, _) => JumErrorState(
                  onRetry: () => ref.invalidate(communityFeedProvider),
                ),
              ),
          // FAB to create post
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.extended(
              onPressed: () => _showCreatePostSheet(context, ref),
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              label: const Text(
                'Post',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePostSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg)),
      ),
      builder: (context) => const CreatePostSheet(),
    );
  }
}

class CreatePostSheet extends ConsumerStatefulWidget {
  const CreatePostSheet({super.key});

  @override
  ConsumerState<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends ConsumerState<CreatePostSheet> {
  final _bodyController = TextEditingController();
  File? _mediaFile;

  void _submit() async {
    final body = _bodyController.text.trim();
    if (body.isEmpty && _mediaFile == null) return;
    
    await ref.read(createPostNotifierProvider.notifier).submit(
          body: body,
          mediaFile: _mediaFile,
        );
        
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(createPostNotifierProvider).isLoading;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.paddingMd,
        right: AppSizes.paddingMd,
        top: AppSizes.paddingMd,
        bottom: bottomInset + AppSizes.paddingMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Create Post',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMd),
          JumTextField(
            controller: _bodyController,
            label: 'Post Content',
            hint: 'Share something...',
          ),
          if (_mediaFile != null) ...[
            const SizedBox(height: AppSizes.paddingMd),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: Image.file(_mediaFile!, height: 150, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => setState(() => _mediaFile = null),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSizes.paddingMd),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image_rounded, color: AppColors.accent),
                onPressed: () {
                  // TODO: Implement image picker
                },
              ),
              const Spacer(),
              JumButton(
                label: 'Share',
                onPressed: isLoading ? null : _submit,
                isLoading: isLoading,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
