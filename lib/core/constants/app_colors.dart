import 'package:flutter/material.dart';

class AppColors {
  // Monochromatic Light Core Colors
  static const meshBg = Color(0xFFF9F9F9); // Light Gray canvas background
  static const meshGradient1 = Color(0xFFFFFFFF); // White glow
  static const meshGradient2 = Color(0xFFF3F4F6); // Soft light grey
  static const meshGradient3 = Color(0xFFE5E7EB); // Diffused outline grey

  // Glassmorphism Light Palette (High-fidelity frosted blurs)
  static const glassBg = Color(0xD9FFFFFF); // Translucent White glass (85% opacity)
  static const glassCardBg = Color(0xFFFFFFFF); // Solid White card background
  static const glassBorder = Color(0xFFE5E7EB); // Subtle light grey border
  static const glassBorderFocused = Color(0xFF000000); // Focused solid black border

  // Primary interactive accents (Monochromatic Black, Grey, White)
  static const primary      = Color(0xFF000000); // Pure Black primary action
  static const primaryLight = Color(0xFF1B1B1B); // Dark grey container fill
  static const accent       = Color(0xFF6B7280); // Neutral grey accent
  static const accentDark   = Color(0xFF4C4546); // Supporting text grey

  // Surface containers
  static const background   = Color(0xFFF9F9F9);
  static const surface      = Color(0xFFFFFFFF);
  static const surface2     = Color(0xFFF3F4F6);

  // Ultra high-contrast minimalist Text (strictly near black & charcoal)
  static const textPrimary   = Color(0xFF1A1C1C); // Near Black
  static const textSecondary = Color(0xFF4C4546); // Medium Charcoal Grey
  static const textMuted     = Color(0xFF7E7576); // Muted Outline Grey

  // Semantics
  static const success = Color(0xFF10B981); // Emerald Green
  static const error   = Color(0xFFEF4444); // Crimson Red
  static const warning = Color(0xFFF59E0B); // Amber Yellow
  static const info    = Color(0xFF3B82F6); // Soft Ocean Blue

  // Borders & Dividers
  static const border  = Color(0xFFE5E7EB);
  static const divider = Color(0xFFF3F4F6);
}

