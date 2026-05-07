import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';

class JumAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double size;
  final bool showOnlineIndicator;

  const JumAvatar({
    Key? key,
    this.imageUrl,
    required this.initials,
    this.size = AppSizes.avatarMd,
    this.showOnlineIndicator = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget avatarWidget;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarWidget = ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.surface2,
            child: const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 1.5, valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent)),
              ),
            ),
          ),
          errorWidget: (context, url, error) => _buildInitialsAvatar(),
        ),
      );
    } else {
      avatarWidget = _buildInitialsAvatar();
    }

    if (showOnlineIndicator) {
      final dotSize = size * 0.25;
      return Stack(
        children: [
          avatarWidget,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 1.5),
              ),
            ),
          ),
        ],
      );
    }

    return avatarWidget;
  }

  Widget _buildInitialsAvatar() {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: size * 0.35,
            fontWeight: FontWeight.w600,
            color: AppColors.accent,
          ),
        ),
      ),
    );
  }
}
