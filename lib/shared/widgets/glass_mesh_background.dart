import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class GlassMeshBackground extends StatelessWidget {
  final Widget child;

  const GlassMeshBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background solid base
          Positioned.fill(
            child: Container(color: AppColors.background),
          ),

          // Top left soft white ambient orb
          Positioned(
            top: -size.height * 0.15,
            left: -size.width * 0.2,
            width: size.width * 0.8,
            height: size.width * 0.8,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x99FFFFFF), // Very bright white glow
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Bottom right subtle grey ambient orb
          Positioned(
            bottom: -size.height * 0.2,
            right: -size.width * 0.2,
            width: size.width * 0.9,
            height: size.width * 0.9,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x0F000000), // Very faint dark grey shadow glow
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Center left extremely faint grey ambient orb
          Positioned(
            top: size.height * 0.35,
            left: -size.width * 0.3,
            width: size.width * 0.7,
            height: size.width * 0.7,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x0A000000), // Barely visible charcoal glow
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content overlay
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

