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
        context.go('/sign-in');
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
      context.go('/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassMeshBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.5),
                  color: Colors.white.withOpacity(0.06),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.15),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'JUM',
                      style: AppTextStyles.h1.copyWith(
                        color: Colors.white,
                        fontSize: 52.0,
                        letterSpacing: 3.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Gap(8),
                    Container(
                      height: 2,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.85, 0.85)),
              const Gap(24),
              Text(
                'Jesus Unhindered Ministry',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ).animate(delay: 300.ms).fadeIn(duration: 800.ms).slideY(begin: 0.2),
              const Gap(8),
              Text(
                'Unleashing Faith Without Boundaries',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.0,
                ),
              ).animate(delay: 600.ms).fadeIn(duration: 800.ms).slideY(begin: 0.2),
            ],
          ),
        ),
      ),
    );
  }
}
