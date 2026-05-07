import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../../../shared/widgets/jum_text_field.dart';

// -------------------------------------------------------------
// GIVE SCREEN
// -------------------------------------------------------------
class GiveScreen extends StatefulWidget {
  const GiveScreen({Key? key}) : super(key: key);

  @override
  State<GiveScreen> createState() => _GiveScreenState();
}

class _GiveScreenState extends State<GiveScreen> {
  String _selectedAmount = '50';
  String _selectedCategory = 'Tithe';
  final _customAmountController = TextEditingController();
  bool _isRecurring = false;

  final List<String> _amounts = ['10', '20', '50', '100', '500'];
  final List<String> _categories = ['Tithe', 'Offering', 'Missions', 'Thanksgiving', 'Building Fund'];

  void _showMockPaymentSheet() {
    final amountText = _selectedAmount == 'Custom' ? _customAmountController.text : _selectedAmount;
    if (amountText.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: AppSizes.paddingLg,
            left: AppSizes.paddingLg,
            right: AppSizes.paddingLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Secure Checkout',
                    style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                children: [
                  const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.success),
                  const Gap(6),
                  Text(
                    'SSL Encrypted Transaction',
                    style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Gap(24),
              Text(
                'Giving Amount',
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0),
              ),
              const Gap(4),
              Text(
                '\$$amountText.00',
                style: AppTextStyles.h1.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
              ),
              const Gap(24),
              const JumTextField(
                label: 'Cardholder Name',
                hint: 'John Doe',
                prefix: Icon(Icons.person_outline, color: AppColors.textMuted),
              ),
              const Gap(16),
              const JumTextField(
                label: 'Card Number',
                hint: '4111 2222 3333 4444',
                prefix: Icon(Icons.credit_card_outlined, color: AppColors.textMuted),
                keyboardType: TextInputType.number,
              ),
              const Gap(16),
              const Row(
                children: [
                  Expanded(
                    child: JumTextField(
                      label: 'Expiry Date',
                      hint: 'MM/YY',
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  Gap(16),
                  Expanded(
                    child: JumTextField(
                      label: 'CVV',
                      hint: '123',
                      obscureText: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const Gap(32),
              JumButton(
                label: 'Confirm Contribution',
                isFullWidth: true,
                onPressed: () {
                  Navigator.pop(context);
                  _showSuccessDialog(amountText);
                },
              ),
              const Gap(24),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessDialog(String amount) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
          title: const Center(
            child: Icon(Icons.check_circle, size: 64, color: AppColors.success),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Thank You!',
                style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Gap(12),
              Text(
                'Your gift of \$$amount.00 for $_selectedCategory has been successfully processed.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: JumButton(
                label: 'Done',
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/home');
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Online Giving',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Amount',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            const Gap(16),
            // AMOUNT SELECTOR BUTTONS
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: [
                ..._amounts.map((amount) {
                  final isSelected = _selectedAmount == amount;
                  return InkWell(
                    onTap: () => setState(() => _selectedAmount = amount),
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accent : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        border: Border.all(
                          color: isSelected ? AppColors.accent : AppColors.border,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '\$$amount',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isSelected ? Colors.black : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                InkWell(
                  onTap: () => setState(() => _selectedAmount = 'Custom'),
                  child: Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: _selectedAmount == 'Custom' ? AppColors.accent : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(
                        color: _selectedAmount == 'Custom' ? AppColors.accent : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Custom',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: _selectedAmount == 'Custom' ? Colors.black : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_selectedAmount == 'Custom') ...[
              const Gap(16),
              JumTextField(
                label: 'Custom Amount (\$)',
                controller: _customAmountController,
                keyboardType: TextInputType.number,
                prefix: const Icon(Icons.attach_money, color: AppColors.accent),
              ),
            ],
            const Gap(24),
            Text(
              'Select Gift Category',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            const Gap(12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  dropdownColor: AppColors.surface,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.accent),
                  isExpanded: true,
                  items: _categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val ?? 'Tithe'),
                ),
              ),
            ),
            const Gap(24),
            SwitchListTile(
              value: _isRecurring,
              onChanged: (val) => setState(() => _isRecurring = val),
              title: Text(
                'Schedule Recurring Gift',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Automatically repeat this gift monthly',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              activeColor: AppColors.accent,
              contentPadding: EdgeInsets.zero,
            ),
            const Gap(40),
            JumButton(
              label: 'Proceed to Secure Contribution',
              isFullWidth: true,
              onPressed: _showMockPaymentSheet,
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// GIVING HISTORY SCREEN
// -------------------------------------------------------------
class GivingHistoryScreen extends StatelessWidget {
  const GivingHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final history = [
      {'date': 'May 1, 2026', 'category': 'Tithe', 'amount': '150.00', 'method': 'Visa •••• 4242'},
      {'date': 'April 15, 2026', 'category': 'Offering', 'amount': '50.00', 'method': 'MasterCard •••• 5555'},
      {'date': 'April 1, 2026', 'category': 'Tithe', 'amount': '150.00', 'method': 'Visa •••• 4242'},
      {'date': 'March 15, 2026', 'category': 'Missions', 'amount': '100.00', 'method': 'Apple Pay'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Giving History',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // SUMMARY CARD
            JumCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'TOTAL CONTRIBUTED (2026)',
                      style: AppTextStyles.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                    const Gap(8),
                    Text(
                      '\$450.00',
                      style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(24),
            Text(
              'Past Contributions',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            const Gap(12),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
                    child: JumCard(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.paddingMd),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  child: Icon(Icons.volunteer_activism, color: AppColors.accent),
                                ),
                                const Gap(16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['category']!,
                                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${item['date']} • ${item['method']}',
                                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${item['amount']}',
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Receipt',
                                    style: AppTextStyles.caption.copyWith(color: AppColors.info),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
