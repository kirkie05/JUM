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
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/glass_mesh_background.dart';
import '../../data/providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _isLoading = false;
  bool _codeSent = false;
  String? _errorMessage;

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final firstName = _firstNameController.text.trim();
    
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email');
      return;
    }
    if (firstName.isEmpty) {
      setState(() => _errorMessage = 'Please enter your first name');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Initiate Clerk email OTP sign up
      await clerk.Clerk.instance.signUp(
        firstName: firstName,
        lastName: _lastNameController.text.trim(),
        emailAddress: email,
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
      final user = await clerk.Clerk.instance.verifySignUp(code: code);
      if (user != null) {
        await ref.read(authNotifierProvider.notifier).loadUser(user.id);
        
        if (!mounted) return;
        context.go('/onboarding');
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
    return GlassMeshBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.5),
                          color: Colors.white.withOpacity(0.06),
                        ),
                        child: Text(
                          'JUM',
                          style: AppTextStyles.h2.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 24.0,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                    const Gap(32),
                    Text(
                      'Create account',
                      style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(8),
                    Text(
                      'Join Jesus Unhindered Ministry today',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(32),
                    
                    JumCard(
                      padding: const EdgeInsets.all(AppSizes.paddingLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!_codeSent) ...[
                            JumTextField(
                              label: 'First Name',
                              hint: 'John',
                              controller: _firstNameController,
                              prefix: const Icon(Icons.person_outline, color: AppColors.textMuted),
                            ),
                            const Gap(16),
                            JumTextField(
                              label: 'Last Name',
                              hint: 'Doe',
                              controller: _lastNameController,
                              prefix: const Icon(Icons.person_outline, color: AppColors.textMuted),
                            ),
                            const Gap(16),
                            JumTextField(
                              label: 'Email Address',
                              hint: 'email@example.com',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefix: const Icon(Icons.email_outlined, color: AppColors.textMuted),
                            ),
                            const Gap(16),
                            JumButton(
                              label: 'Create Account',
                              isLoading: _isLoading,
                              isFullWidth: true,
                              onPressed: _signUp,
                            ),
                          ] else ...[
                            Text(
                              'Enter the verification code sent to ${_emailController.text}',
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
                              label: 'Verify & Register',
                              isLoading: _isLoading,
                              isFullWidth: true,
                              onPressed: _verifyOtp,
                            ),
                            const Gap(8),
                            TextButton(
                              onPressed: () => setState(() => _codeSent = false),
                              child: const Text(
                                'Go Back',
                                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
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
                          'Already have an account? ',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                        TextButton(
                          onPressed: () => context.go('/sign-in'),
                          child: Text(
                            'Sign in',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
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
      ),
    );
  }
}
