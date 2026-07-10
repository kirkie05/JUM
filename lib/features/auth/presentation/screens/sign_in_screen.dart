import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../../../shared/widgets/jum_text_field.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/glass_mesh_background.dart';
import '../../../../core/services/supabase_service.dart';
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
      await ref.read(supabaseClientProvider).auth.signInWithOtp(email: email);
      setState(() => _codeSent = true);
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    final code = _otpController.text.trim();
    final email = _emailController.text.trim();
    if (code.isEmpty) {
      setState(() => _errorMessage = 'Please enter the verification code');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await ref.read(supabaseClientProvider).auth.verifyOTP(
            email: email,
            token: code,
            type: OtpType.magiclink,
          );
      
      if (res.session != null) {
        if (!mounted) return;
        // The auth_provider will auto load user via onAuthStateChange
        context.go('/home');
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
      backgroundColor: const Color(0xFFF9FAFB),
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
                        'Sign in to your spiritual community',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  
                  const Gap(32),
                  
                  JumCard(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!_codeSent) ...[
                          JumTextField(
                            label: 'EMAIL ADDRESS',
                            hint: 'name@example.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefix: const Icon(Icons.email_outlined, color: Color(0xFF9CA3AF)),
                          ),
                          const Gap(24),
                          ElevatedButton(
                            onPressed: _sendOtp,
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
                                    'Send Verification Code',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ] else ...[
                          Text(
                            'Enter the 6-digit code sent to ${_emailController.text}',
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
                                    'Verify & Sign In',
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
                              'Change Email',
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
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/sign-up'),
                        child: const Text(
                          'Join JUM',
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
                  
                  const Gap(24),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.verified_user_outlined, size: 16.0, color: Color(0xFF9CA3AF)),
                          Gap(4),
                          Text(
                            'Secure Login',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                      const Gap(24),
                      Row(
                        children: const [
                          Icon(Icons.auto_stories_outlined, size: 16.0, color: Color(0xFF9CA3AF)),
                          Gap(4),
                          Text(
                            'Grace & Peace',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
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
