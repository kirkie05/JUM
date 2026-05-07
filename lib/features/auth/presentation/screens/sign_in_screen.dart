import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../../core/services/clerk_compat.dart' as clerk;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../../../shared/widgets/jum_text_field.dart';
import '../../../../core/services/auth_service.dart';
import '../../data/providers/auth_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _codeSent = false;
  String? _errorMessage;

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Initiate Clerk email OTP sign in
      await clerk.Clerk.instance.signIn(
        strategy: clerk.Strategy.emailCode,
        identifier: email,
      );
      setState(() => _codeSent = true);
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    final code = _otpController.text.trim();
    if (code.isEmpty) {
      setState(() => _errorMessage = 'Please enter the verification code');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await clerk.Clerk.instance.verifySignIn(code: code);
      if (user != null) {
        await ref.read(authNotifierProvider.notifier).loadUser(user.id);
        
        if (!mounted) return;
        
        final supabaseUser = await ref
            .read(authServiceProvider)
            .fetchCurrentUser(user.id);
            
        if (!mounted) return;

        if (supabaseUser == null) {
          context.go('/onboarding');
        } else if (supabaseUser.churchId == null || supabaseUser.churchId.isEmpty) {
          context.go('/church-select');
        } else {
          context.go('/home');
        }
      } else {
        setState(() => _errorMessage = 'Verification failed');
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingXl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accent, width: 2.0),
                      ),
                      child: Text(
                        'JUM',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w900,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                  ),
                  const Gap(32),
                  Text(
                    'Welcome back',
                    style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(8),
                  Text(
                    'Sign in to continue your journey',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(32),
                  
                  // Clerk SDK Sign-In Widget or custom fallback interface
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingLg),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!_codeSent) ...[
                          JumTextField(
                            label: 'Email Address',
                            hint: 'email@example.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefix: const Icon(Icons.email_outlined, color: AppColors.textMuted),
                          ),
                          const Gap(16),
                          JumButton(
                            label: 'Send Verification Code',
                            isLoading: _isLoading,
                            isFullWidth: true,
                            onPressed: _sendOtp,
                          ),
                        ] else ...[
                          Text(
                            'Enter the 6-digit code sent to ${_emailController.text}',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(16),
                          JumTextField(
                            label: 'Verification Code',
                            hint: '123456',
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            prefix: const Icon(Icons.lock_outline_rounded, color: AppColors.textMuted),
                          ),
                          const Gap(16),
                          JumButton(
                            label: 'Verify & Sign In',
                            isLoading: _isLoading,
                            isFullWidth: true,
                            onPressed: _verifyOtp,
                          ),
                          const Gap(8),
                          TextButton(
                            onPressed: () => setState(() => _codeSent = false),
                            child: Text(
                              'Change Email',
                              style: TextStyle(color: AppColors.accent),
                            ),
                          ),
                        ],
                        if (_errorMessage != null) ...[
                          const Gap(12),
                          Text(
                            _errorMessage!,
                            style: AppTextStyles.caption.copyWith(color: AppColors.error),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      TextButton(
                        onPressed: () => context.go('/sign-up'),
                        child: Text(
                          'Sign up',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
