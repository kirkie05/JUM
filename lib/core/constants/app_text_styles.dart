import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const fontFamily = 'Inter';

  static const display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.64,
    color: AppColors.textPrimary,
  );

  static const h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.24,
    color: AppColors.textPrimary,
  );

  static const h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const bodyMedium = body;

  static const caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static const overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.6,
    color: AppColors.textMuted,
  );
}
