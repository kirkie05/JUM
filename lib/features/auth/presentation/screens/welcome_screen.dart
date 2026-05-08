import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Surface Grey as per DESIGN.md
      body: Stack(
        children: [
          // Background Decorative Blur Element
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE5E7EB).withOpacity(0.3), // Soft grey glow
              ),
            ),
          ),
          
          // Top Left Identity Badge
          Positioned(
            top: 48.0,
            left: 24.0,
            child: Row(
              children: [
                const Text(
                  'JUM',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                    letterSpacing: -1.0,
                  ),
                ),
                const Gap(4),
                Container(
                  width: 4.0,
                  height: 4.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 600.ms),
          ),

          // Main Content Canvas
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon Anchor (Raven / Dove in soft rounded container)
                    Container(
                      width: 64.0,
                      height: 64.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFE5E7EB), // outline-variant
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.church_outlined,
                          size: 32.0,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

                    const Gap(32),

                    // Branding & Typography
                    const Text(
                      'Jesus Unhindered Ministry',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                        letterSpacing: -1.5,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ).animate(delay: 200.ms).fadeIn(duration: 800.ms).slideY(begin: 0.1),

                    const Gap(16),

                    const Text(
                      'A distraction-free space for spiritual growth, scripture reflection, and community fellowship.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280), // Neutral Grey
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ).animate(delay: 400.ms).fadeIn(duration: 800.ms).slideY(begin: 0.1),

                    const Gap(40),

                    // Call to Action Buttons
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Get Started Primary CTA
                        ElevatedButton(
                          onPressed: () => context.go('/sign-up'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF000000), // Primary Black
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), // radius-lg (8px)
                            ),
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        const Gap(12),
                        
                        // Sign In Secondary CTA
                        OutlinedButton(
                          onPressed: () => context.go('/sign-in'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF000000),
                            side: const BorderSide(color: Color(0xFFD1D5DB)), // outline border
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ).animate(delay: 600.ms).fadeIn(duration: 800.ms),

                    const Gap(48),

                    // Secondary Navigation Footer Links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildFooterLink('Our Vision'),
                        _buildDotSeparator(),
                        _buildFooterLink('Community'),
                        _buildDotSeparator(),
                        _buildFooterLink('Contact'),
                      ],
                    ).animate(delay: 800.ms).fadeIn(duration: 800.ms),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Left Decorative Rotated Text
          Positioned(
            bottom: 48.0,
            left: -24.0,
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                'ESTABLISHED IN FAITH · MMXXIV',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280).withOpacity(0.4),
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 1000.ms),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return InkWell(
      onTap: () {},
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 10.0,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6B7280),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildDotSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        '•',
        style: TextStyle(
          color: const Color(0xFF6B7280).withOpacity(0.3),
        ),
      ),
    );
  }
}
