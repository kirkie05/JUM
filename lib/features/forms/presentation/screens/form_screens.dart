import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../../../shared/widgets/jum_card.dart';

class GenericFormScreen extends StatefulWidget {
  const GenericFormScreen({Key? key}) : super(key: key);

  @override
  State<GenericFormScreen> createState() => _GenericFormScreenState();
}

class _GenericFormScreenState extends State<GenericFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedFormType = 'Prayer Request';
  bool _isLoading = false;

  final List<String> _formTypes = [
    'Prayer Request',
    'Testimony',
    'New Member Registration',
    'General Feedback',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          final randomId = 'JUM-${Random().nextInt(90000) + 10000}';
          context.push('/forms/success?id=$randomId');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Share with Us',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Minimalist Ministry Tag
                Text(
                  'MINISTRY',
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(4),
                Text(
                  'Share with Us',
                  style: AppTextStyles.display.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 28.0,
                  ),
                ),
                const Gap(12),
                
                // Scripture Quote Box
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingMd),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your journey matters. Whether you need prayer, have a testimony, or are new here, we are here for you.',
                        style: AppTextStyles.body.copyWith(
                          fontSize: 14.0,
                          height: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Gap(12),
                      Text(
                        '“For where two or three are gathered in my name, there am I among them.” — Matthew 18:20',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 13.0,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(24),

                // Form Type Selection Header
                Text(
                  'SELECT FORM TYPE',
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(8),

                // Horizontal Form Type Selector Chips
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _formTypes.length,
                    itemBuilder: (context, index) {
                      final formType = _formTypes[index];
                      final isSelected = _selectedFormType == formType;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(formType),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedFormType = formType;
                              });
                            }
                          },
                          backgroundColor: AppColors.surface,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 13.0,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: 1.0,
                            ),
                          ),
                          elevation: 0,
                          pressElevation: 0,
                        ),
                      );
                    },
                  ),
                ),
                const Gap(24),

                // Input Form Fields
                Text(
                  'YOUR DETAILS',
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(12),

                // Name Input Field
                TextFormField(
                  controller: _nameController,
                  decoration: _getInputDecoration('Full Name'),
                  style: _getInputStyle(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const Gap(16),

                // Contact Input Field
                TextFormField(
                  controller: _contactController,
                  decoration: _getInputDecoration('Email or Phone Number'),
                  style: _getInputStyle(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email or phone number';
                    }
                    return null;
                  },
                ),
                const Gap(16),

                // Message Input Field
                TextFormField(
                  controller: _messageController,
                  decoration: _getInputDecoration('Details / Request Message').copyWith(
                    alignLabelWithHint: true,
                  ),
                  style: _getInputStyle(),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please describe your request or details';
                    }
                    return null;
                  },
                ),
                const Gap(32),

                // Submit CTA Button
                JumButton(
                  label: 'Submit Form',
                  onPressed: _submitForm,
                  isLoading: _isLoading,
                  isFullWidth: true,
                ),
                const Gap(16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontFamily: AppTextStyles.fontFamily,
        fontSize: 14.0,
        color: AppColors.textSecondary,
      ),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.border, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.border, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.error, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    );
  }

  TextStyle _getInputStyle() {
    return const TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 15.0,
      color: AppColors.textPrimary,
    );
  }
}

class SubmissionSuccessScreen extends StatelessWidget {
  final String referenceId;

  const SubmissionSuccessScreen({
    Key? key,
    required this.referenceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Animated checkmark visual anchor
              Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const Gap(24),

              Text(
                'Submission Success',
                style: AppTextStyles.display.copyWith(
                  fontSize: 26.0,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(12),
              
              Text(
                'Thank you for sharing with us. Your submission has been securely received by our ministry team.',
                style: AppTextStyles.body.copyWith(
                  fontSize: 15.0,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(32),

              // Unique reference details
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'REFERENCE ID',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11.0,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      referenceId,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Gap(12),
                    const Divider(color: AppColors.divider, height: 1),
                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textSecondary),
                        const Gap(6),
                        Text(
                          'Estimated response within 24 hours',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Spacer(),

              // Primary back home CTA
              JumButton(
                label: 'Back to Home',
                onPressed: () => context.go('/home'),
                isFullWidth: true,
              ),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}
