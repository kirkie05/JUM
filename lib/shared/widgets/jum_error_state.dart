import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import 'jum_button.dart';

class JumErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;

  const JumErrorState({
    Key? key,
    required this.onRetry,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48.0,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSizes.paddingMd),
            Text(
              message ?? AppStrings.errorGeneric,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingLg),
            JumButton(
              label: AppStrings.retry,
              onPressed: onRetry,
              variant: JumButtonVariant.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
