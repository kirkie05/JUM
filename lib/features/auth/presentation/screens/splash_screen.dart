import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../../../core/services/clerk_compat.dart' as clerk;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../shared/widgets/glass_mesh_background.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    try {
      final clerkUser = clerk.Clerk.instance.currentUser;
      if (clerkUser == null) {
        context.go('/welcome');
        return;
      }

      final supabaseUser = await ref
          .read(authServiceProvider)
          .fetchCurrentUser(clerkUser.id);

      if (!mounted) return;

      if (supabaseUser == null) {
        context.go('/onboarding');
      } else if (supabaseUser.churchId == null || supabaseUser.churchId.isEmpty) {
        context.go('/church-select');
      } else {
        context.go('/home');
      }
    } catch (e) {
      // Safe fallback in case Clerk is not fully initialized or configured
      debugPrint("Auth splash check failed: $e");
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // Pure Black as per Stitch body bg-primary
      body: Stack(
        children: [
          // Subtle Ambient Background Texture with glowing dark mesh gradient
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCRj4Hu3vLgycQ27Br_a0ikX-p_nMHUl3frmSd01v4_2iwiHOvxYIubUTivhWvAJ0eEkht4ova0-ai2HypDZU4U4Wh9--KJKJti56or_yL1OxAOa-3A5XosJljSR0bQrDNst70BZrRsfgx_qyN6KGuIKT4cwd-1cGnV2N2_TzeYN342J8jYA7duhcXQo30PtzrtGNimd-_xMF0Nm1XKAh9g5OeGZhI06ebXQJ--McjUN1_u1LJQfypk214gRwjY0aArlg55NRPH4Q',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF090C15), Color(0xFF1E1B4B), Color(0xFF000000)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Central Identity Cluster
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // JUM Logo
                Text(
                  'JUM',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 64.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -2.0,
                  ),
                ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.95, 0.95)),
                
                const Gap(8),
                
                // Subtitle
                Text(
                  'JESUS UNHINDERED MINISTRY',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9CA3AF), // gray-400
                    letterSpacing: 3.0,
                  ),
                ).animate(delay: 200.ms).fadeIn(duration: 800.ms).slideY(begin: 0.1),
                
                const Gap(32),
                
                // Shimmer Loading Line
                Container(
                  width: 48,
                  height: 1.5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(1),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      AnimatedBuilder(
                        animation: const AlwaysStoppedAnimation(0),
                        builder: (context, child) {
                          return Container(
                            width: 24,
                            height: 1.5,
                            color: Colors.white.withOpacity(0.6),
                          );
                        },
                      ).animate(onPlay: (controller) => controller.repeat())
                       .moveX(
                         begin: -24,
                         end: 48,
                         duration: 1500.ms,
                         curve: Curves.easeInOut,
                       ),
                    ],
                  ),
                ).animate(delay: 400.ms).fadeIn(duration: 800.ms),
                
                const Gap(16),
                
                // Loader Tagline
                Text(
                  'GRACE & PEACE',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.4),
                    letterSpacing: 2.0,
                  ),
                ).animate(delay: 600.ms).fadeIn(duration: 800.ms),
              ],
            ),
          ),
          
          // Footnote / Versioning
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.bottomAt(24.0) ?? const EdgeInsets.bottomRect(24.0) ?? const EdgeInsets.only(bottom: 24.0),
              child: Text(
                '© 2024 JUM GLOBAL',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563), // gray-600
                  letterSpacing: 0.5,
                ),
              ),
            ).animate(delay: 800.ms).fadeIn(duration: 800.ms),
          ),
        ],
      ),
    );
  }
}

