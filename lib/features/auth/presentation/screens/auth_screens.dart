import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../../../shared/widgets/jum_text_field.dart';
import '../../../../shared/widgets/jum_avatar.dart';
import '../../../../shared/widgets/jum_card.dart';

// -------------------------------------------------------------
// SPLASH SCREEN
// -------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      context.go('/onboarding');
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

// -------------------------------------------------------------
// SIGN IN SCREEN
// -------------------------------------------------------------
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleSignIn() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _isLoading = false);
        context.go('/home');
      }
    });
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
                        border: Border.all(color: AppColors.accent, width: 1.5),
                      ),
                      child: Text(
                        'J',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const Gap(32),
                  Text(
                    'Welcome Back',
                    style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(8),
                  Text(
                    'Sign in to continue your spiritual journey',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(32),
                  JumTextField(
                    label: 'Email Address',
                    hint: 'enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefix: const Icon(Icons.email_outlined, color: AppColors.textMuted),
                  ),
                  const Gap(16),
                  JumTextField(
                    label: 'Password',
                    hint: '••••••••',
                    controller: _passwordController,
                    obscureText: true,
                    prefix: const Icon(Icons.lock_outline_rounded, color: AppColors.textMuted),
                  ),
                  const Gap(24),
                  JumButton(
                    label: 'Sign In',
                    isLoading: _isLoading,
                    isFullWidth: true,
                    onPressed: _handleSignIn,
                  ),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      TextButton(
                        onPressed: () => context.go('/sign-up'),
                        child: Text(
                          'Sign Up',
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

// -------------------------------------------------------------
// SIGN UP SCREEN
// -------------------------------------------------------------
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleSignUp() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _isLoading = false);
        context.go('/onboarding');
      }
    });
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
                        border: Border.all(color: AppColors.accent, width: 1.5),
                      ),
                      child: Text(
                        'J',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const Gap(32),
                  Text(
                    'Create Account',
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
                  JumTextField(
                    label: 'Full Name',
                    hint: 'your full name',
                    controller: _nameController,
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
                  JumTextField(
                    label: 'Password',
                    hint: '••••••••',
                    controller: _passwordController,
                    obscureText: true,
                    prefix: const Icon(Icons.lock_outline_rounded, color: AppColors.textMuted),
                  ),
                  const Gap(24),
                  JumButton(
                    label: 'Create Account',
                    isLoading: _isLoading,
                    isFullWidth: true,
                    onPressed: _handleSignUp,
                  ),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      TextButton(
                        onPressed: () => context.go('/sign-in'),
                        child: Text(
                          'Sign In',
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

// -------------------------------------------------------------
// ONBOARDING SCREEN
// -------------------------------------------------------------
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  final _nameController = TextEditingController(text: 'John Doe');
  final _phoneController = TextEditingController();
  final _searchController = TextEditingController();
  String _selectedChurch = '';
  int _currentPage = 0;

  final List<Map<String, String>> _churches = [
    {'name': 'JUM Lagos Headquarters', 'city': 'Lagos, Nigeria'},
    {'name': 'JUM Houston Campus', 'city': 'Houston, TX'},
    {'name': 'JUM London Grace Temple', 'city': 'London, UK'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg, vertical: AppSizes.paddingMd),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: const WormEffect(
                      activeDotColor: AppColors.accent,
                      dotColor: AppColors.border,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/home'),
                    child: Text(
                      'Skip',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Gap(24),
          const Center(
            child: Stack(
              children: [
                JumAvatar(
                  initials: 'JD',
                  size: 96.0,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.accent,
                    child: Icon(Icons.camera_alt, size: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const Gap(32),
          Text(
            'Complete Your Profile',
            style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          Text(
            'Help us personalize your ministry experience',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const Gap(32),
          JumTextField(
            label: 'Full Name',
            controller: _nameController,
            prefix: const Icon(Icons.person_outline, color: AppColors.textMuted),
          ),
          const Gap(16),
          JumTextField(
            label: 'Phone Number',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            prefix: const Icon(Icons.phone_outlined, color: AppColors.textMuted),
          ),
          const Gap(32),
          JumButton(
            label: 'Continue',
            isFullWidth: true,
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSizes.paddingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Your Church',
                style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                'Join a local campus to stay updated on events',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Gap(24),
              JumTextField(
                label: 'Search Campuses',
                controller: _searchController,
                prefix: const Icon(Icons.search, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingXl),
            itemCount: _churches.length,
            itemBuilder: (context, index) {
              final church = _churches[index];
              final isSelected = _selectedChurch == church['name'];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingMd),
                child: InkWell(
                  onTap: () => setState(() => _selectedChurch = church['name'] ?? ''),
                  child: JumCard(
                    borderColor: isSelected ? AppColors.accent : null,
                    borderWidth: isSelected ? 1.5 : null,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.church, color: AppColors.accent),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                church['name']!,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                church['city']!,
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: AppColors.accent),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSizes.paddingXl),
          child: Row(
            children: [
              Expanded(
                child: JumButton(
                  label: 'Skip',
                  variant: JumButtonVariant.ghost,
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
              const Gap(16),
              Expanded(
                child: JumButton(
                  label: 'Join Church',
                  onPressed: _selectedChurch.isEmpty
                      ? null
                      : () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Icon(
              Icons.stars_rounded,
              size: 96.0,
              color: AppColors.accent,
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
          const Gap(32),
          Text(
            'All Set, ${_nameController.text}!',
            style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          Text(
            'Your spiritual home is ready. Welcome to JUM Ministry!',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const Gap(48),
          JumButton(
            label: "Let's Go",
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// CHURCH SELECT SCREEN
// -------------------------------------------------------------
class ChurchSelectScreen extends StatefulWidget {
  const ChurchSelectScreen({Key? key}) : super(key: key);

  @override
  State<ChurchSelectScreen> createState() => _ChurchSelectScreenState();
}

class _ChurchSelectScreenState extends State<ChurchSelectScreen> {
  String _selectedChurch = '';

  final List<Map<String, String>> _churches = [
    {'name': 'JUM Lagos Headquarters', 'city': 'Lagos, Nigeria'},
    {'name': 'JUM Houston Campus', 'city': 'Houston, TX'},
    {'name': 'JUM London Grace Temple', 'city': 'London, UK'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Church'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Campus',
              style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
            ),
            const Gap(8),
            Text(
              'Please select your preferred campus location.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const Gap(32),
            Expanded(
              child: ListView.builder(
                itemCount: _churches.length,
                itemBuilder: (context, index) {
                  final church = _churches[index];
                  final isSelected = _selectedChurch == church['name'];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.paddingMd),
                    child: InkWell(
                      onTap: () => setState(() => _selectedChurch = church['name'] ?? ''),
                      child: JumCard(
                        borderColor: isSelected ? AppColors.accent : null,
                        borderWidth: isSelected ? 1.5 : null,
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: Icon(Icons.church, color: AppColors.accent),
                            ),
                            const Gap(16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    church['name']!,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    church['city']!,
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: AppColors.accent),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            JumButton(
              label: 'Save Campus',
              onPressed: _selectedChurch.isEmpty
                  ? null
                  : () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }
}
