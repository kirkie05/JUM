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
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Surface Grey as per DESIGN.md
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Branding Header
                  Column(
                    children: [
                      const Text(
                        'JUM',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                          letterSpacing: -1.5,
                        ),
                      ),
                      const Gap(4),
                      const Text(
                        'Create your spiritual home.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          color: Color(0xFF6B7280), // Neutral Grey
                        ),
                      ),
                    ],
                  ),
                  
                  const Gap(32),
                  
                  // Sign Up Card
                  JumCard(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Gap(24),
                        if (!_codeSent) ...[
                          JumTextField(
                            label: 'FIRST NAME',
                            hint: 'Grace',
                            controller: _firstNameController,
                            prefix: const Icon(Icons.person_outline, color: Color(0xFF9CA3AF)),
                          ),
                          const Gap(16),
                          JumTextField(
                            label: 'LAST NAME',
                            hint: 'Peace',
                            controller: _lastNameController,
                            prefix: const Icon(Icons.person_outline, color: Color(0xFF9CA3AF)),
                          ),
                          const Gap(16),
                          JumTextField(
                            label: 'EMAIL ADDRESS',
                            hint: 'member@jum.org',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefix: const Icon(Icons.email_outlined, color: Color(0xFF9CA3AF)),
                          ),
                          const Gap(24),
                          ElevatedButton(
                            onPressed: _signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF000000), // Primary Black
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ] else ...[
                          Text(
                            'Enter the verification code sent to ${_emailController.text}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              color: Color(0xFF6B7280),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(24),
                          JumTextField(
                            label: 'VERIFICATION CODE',
                            hint: '••••••',
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            prefix: const Icon(Icons.lock_outline_rounded, color: Color(0xFF9CA3AF)),
                          ),
                          const Gap(24),
                          ElevatedButton(
                            onPressed: _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF000000),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Verify & Register',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                          const Gap(12),
                          TextButton(
                            onPressed: () => setState(() => _codeSent = false),
                            child: const Text(
                              'Go Back',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        
                        if (_errorMessage != null) ...[
                          const Gap(16),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  const Gap(24),
                  
                  // Already have an account Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/sign-in'),
                        child: const Text(
                          'Login here',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            color: Color(0xFF000000),
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
