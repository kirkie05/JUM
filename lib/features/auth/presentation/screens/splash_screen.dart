import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../../../core/services/clerk_compat.dart' as clerk;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/auth_service.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent, width: 2.0),
              ),
              child: Text(
                'JUM',
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.accent,
                  fontSize: 48.0,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8)),
            const Gap(16),
            Text(
              'Jesus Unhindered Ministry',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 1.5,
              ),
            ).animate(delay: 400.ms).fadeIn(duration: 600.ms).slideY(begin: 0.3),
          ],
        ),
      ),
    );
  }
}
