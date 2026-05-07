import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';

enum JumButtonVariant { primary, secondary, ghost }

class JumButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final JumButtonVariant variant;

  const JumButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.variant = JumButtonVariant.primary,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget buttonChild = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A0A0A)),
            ),
          )
        : Text(
            label,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          );

    ButtonStyle style;
    switch (variant) {
      case JumButtonVariant.primary:
        style = ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: const Color(0xFF0A0A0A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        );
        break;
      case JumButtonVariant.secondary:
        style = OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.accent, width: 1.5),
          foregroundColor: AppColors.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ).copyWith(
          // For outlined buttons when loading
          overlayColor: WidgetStateProperty.all(AppColors.accent.withOpacity(0.1)),
        );
        // Replace child progress indicator color for secondary button
        if (isLoading) {
          buttonChild = const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          );
        }
        break;
      case JumButtonVariant.ghost:
        style = TextButton.styleFrom(
          foregroundColor: AppColors.textMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        );
        if (isLoading) {
          buttonChild = const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textMuted),
            ),
          );
        }
        break;
    }

    Widget button;
    if (variant == JumButtonVariant.secondary) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: buttonChild,
      );
    } else if (variant == JumButtonVariant.ghost) {
      button = TextButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: buttonChild,
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: buttonChild,
      );
    }

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 52.0,
      child: button,
    );
  }
}
