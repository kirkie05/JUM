import 'package:flutter/material.dart';

class AppColors {
  // Primary palette
  static const primary      = Color(0xFF000000); // Primary Black
  static const primaryLight = Color(0xFF1B1B1B); // Soft Black
  static const accent       = Color(0xFF000000); // Monochromatic Black
  static const accentDark   = Color(0xFF1B1B1B);

  // Backgrounds
  static const background   = Color(0xFFF9F9F9); // Light Canvas Grey
  static const surface      = Color(0xFFFFFFFF); // White Surface / Cards
  static const surface2     = Color(0xFFEEEEEE); // Neutral container / Light grey fill

  // Text
  static const textPrimary   = Color(0xFF1A1C1C); // Near Black
  static const textSecondary = Color(0xFF585F6C); // Neutral Grey
  static const textMuted     = Color(0xFF7E7576); // Light Outline Grey

  // Semantic
  static const success = Color(0xFF43A047);
  static const error   = Color(0xFFBA1A1A); // Light mode error red
  static const warning = Color(0xFFFB8C00);
  static const info    = Color(0xFF1E88E5);

  // Border
  static const border  = Color(0xFFEEEEEE); // Subtle border
  static const divider = Color(0xFFF3F4F6); // Thin dividers
}
