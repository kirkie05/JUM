import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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
  final List<String> _categories = [
    'Tithe',
    'Offering',
    'Missions',
    'Thanksgiving',
    'Building Fund',
  ];

  void _showMockPaymentSheet() {
    final amountText = _selectedAmount == 'Custom'
        ? _customAmountController.text
        : _selectedAmount;
    if (amountText.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
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
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.textPrimary,
                    ),
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
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 14,
                    color: AppColors.success,
                  ),
                  const Gap(6),
                  Text(
                    'SSL Encrypted Transaction',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Gap(24),
              Text(
                'Giving Amount',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
              const Gap(4),
              Text(
                '\$$amountText.00',
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
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
                prefix: Icon(
                  Icons.credit_card_outlined,
                  color: AppColors.textMuted,
                ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          title: const Center(
            child: Icon(Icons.check_circle, size: 64, color: AppColors.success),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Thank You!',
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(12),
              Text(
                'Your gift of \$$amount.00 for $_selectedCategory has been successfully processed.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
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
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
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
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.border,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '\$$amount',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isSelected
                                ? Colors.black
                                : AppColors.textPrimary,
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
                      color: _selectedAmount == 'Custom'
                          ? AppColors.accent
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(
                        color: _selectedAmount == 'Custom'
                            ? AppColors.accent
                            : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Custom',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: _selectedAmount == 'Custom'
                              ? Colors.black
                              : AppColors.textPrimary,
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
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
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
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.accent,
                  ),
                  isExpanded: true,
                  items: _categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (val) =>
                      setState(() => _selectedCategory = val ?? 'Tithe'),
                ),
              ),
            ),
            const Gap(24),
            SwitchListTile(
              value: _isRecurring,
              onChanged: (val) => setState(() => _isRecurring = val),
              title: Text(
                'Schedule Recurring Gift',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Automatically repeat this gift monthly',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
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
            const Gap(12),
            JumButton(
              label: 'Browse Giving Categories',
              isFullWidth: true,
              variant: JumButtonVariant.secondary,
              onPressed: () => context.push('/home/give/categories'),
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
      {
        'date': 'May 1, 2026',
        'category': 'Tithe',
        'amount': '150.00',
        'method': 'Visa •••• 4242',
      },
      {
        'date': 'April 15, 2026',
        'category': 'Offering',
        'amount': '50.00',
        'method': 'MasterCard •••• 5555',
      },
      {
        'date': 'April 1, 2026',
        'category': 'Tithe',
        'amount': '150.00',
        'method': 'Visa •••• 4242',
      },
      {
        'date': 'March 15, 2026',
        'category': 'Missions',
        'amount': '100.00',
        'method': 'Apple Pay',
      },
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
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      '\$450.00',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(24),
            Text(
              'Past Contributions',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
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
                                  child: Icon(
                                    Icons.volunteer_activism,
                                    color: AppColors.accent,
                                  ),
                                ),
                                const Gap(16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['category']!,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${item['date']} • ${item['method']}',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
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
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.push(
                                      '/home/give/confirmation?amount=${item['amount']}&category=${item['category']}&method=${Uri.encodeComponent(item['method']!)}',
                                    );
                                  },
                                  child: Text(
                                    'Receipt',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.info,
                                    ),
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

// -------------------------------------------------------------
// GIVE CATEGORIES SCREEN
// -------------------------------------------------------------
class GiveCategoriesScreen extends StatelessWidget {
  const GiveCategoriesScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _categories = const [
    {
      'title': 'Tithe',
      'verse': 'Malachi 3:10',
      'desc':
          'Bring ye all the tithes into the storehouse, that there may be meat in mine house...',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'title': 'Seed Offering',
      'verse': 'Luke 6:38',
      'desc':
          'Give, and it shall be given unto you; good measure, pressed down, shaken together...',
      'icon': Icons.eco_outlined,
    },
    {
      'title': 'First Fruits',
      'verse': 'Proverbs 3:9',
      'desc':
          'Honour the Lord with thy substance, and with the firstfruits of all thine increase...',
      'icon': Icons.spa_outlined,
    },
    {
      'title': 'Welfare & Missions',
      'verse': 'Galatians 6:2',
      'desc':
          'Bear ye one another\'s burdens, and so fulfil the law of Christ...',
      'icon': Icons.volunteer_activism_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Give to Ministry',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                context.push(
                  '/home/give/payment?category=${Uri.encodeComponent(cat['title'])}',
                );
              },
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: JumCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingLg),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.surface,
                        foregroundColor: Colors.white,
                        radius: 24,
                        child: Icon(cat['icon'] as IconData, size: 24),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cat['title'] as String,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.textMuted,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    cat['verse'] as String,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(8),
                            Text(
                              cat['desc'] as String,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                            const Gap(12),
                            const Row(
                              children: [
                                Text(
                                  'Proceed to Give',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Gap(4),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// -------------------------------------------------------------
// PAYMENT DETAIL SCREEN
// -------------------------------------------------------------
class PaymentDetailScreen extends StatefulWidget {
  final String category;
  const PaymentDetailScreen({Key? key, required this.category})
    : super(key: key);

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  String _selectedAmount = '50';
  final _customAmountController = TextEditingController();

  final List<String> _presetAmounts = ['10', '25', '50', '100', '250', '500'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Secure Contribution',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // SSL ENCRYPTED SECURED BANNER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                border: Border.all(color: Colors.white12),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SSL Secured Connection',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Your transaction is encrypted and securely processed.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),
            Text(
              'Gift Category',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const Gap(4),
            Text(
              widget.category,
              style: AppTextStyles.h2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(24),
            Text(
              'Select Amount',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presetAmounts.map((amt) {
                final isSelected = _selectedAmount == amt;
                return InkWell(
                  onTap: () => setState(() => _selectedAmount = amt),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 76,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.12)
                          : AppColors.surface,
                      border: Border.all(
                        color: isSelected ? Colors.white : AppColors.border,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '\$$amt',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Gap(12),
            InkWell(
              onTap: () => setState(() => _selectedAmount = 'Custom'),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedAmount == 'Custom'
                      ? Colors.white.withOpacity(0.12)
                      : AppColors.surface,
                  border: Border.all(
                    color: _selectedAmount == 'Custom'
                        ? Colors.white
                        : AppColors.border,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Custom Amount',
                    style: TextStyle(
                      color: _selectedAmount == 'Custom'
                          ? Colors.white
                          : AppColors.textSecondary,
                      fontWeight: _selectedAmount == 'Custom'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            if (_selectedAmount == 'Custom') ...[
              const Gap(16),
              JumTextField(
                label: 'Enter Amount (\$)',
                controller: _customAmountController,
                keyboardType: TextInputType.number,
                prefix: const Icon(Icons.attach_money, color: Colors.white),
              ),
            ],
            const Gap(32),
            Text(
              'Billing Details',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(16),
            JumTextField(
              label: 'Cardholder Name',
              controller: _nameController,
              hint: 'John Doe',
              prefix: const Icon(
                Icons.person_outline,
                color: AppColors.textMuted,
              ),
            ),
            const Gap(16),
            JumTextField(
              label: 'Card Number',
              controller: _cardNumberController,
              hint: '4111 2222 3333 4444',
              prefix: const Icon(
                Icons.credit_card_outlined,
                color: AppColors.textMuted,
              ),
              keyboardType: TextInputType.number,
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: JumTextField(
                    label: 'Expiry Date',
                    controller: _expiryController,
                    hint: 'MM/YY',
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: JumTextField(
                    label: 'CVV',
                    controller: _cvvController,
                    hint: '123',
                    obscureText: true,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const Gap(32),
            JumButton(
              label: 'Authorize Transaction',
              isFullWidth: true,
              onPressed: () {
                final amt = _selectedAmount == 'Custom'
                    ? _customAmountController.text
                    : _selectedAmount;
                final last4 = _cardNumberController.text.length >= 4
                    ? _cardNumberController.text.substring(
                        _cardNumberController.text.length - 4,
                      )
                    : '4242';
                context.push(
                  '/home/give/confirmation?amount=$amt&category=${Uri.encodeComponent(widget.category)}&method=${Uri.encodeComponent('Visa •••• $last4')}',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// GIVING CONFIRMATION SCREEN (RECEIPT VOUCHER)
// -------------------------------------------------------------
class GivingConfirmationScreen extends StatelessWidget {
  final String amount;
  final String category;
  final String method;
  const GivingConfirmationScreen({
    Key? key,
    required this.amount,
    required this.category,
    required this.method,
  }) : super(key: key);

  Future<void> _printReceipt() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(32),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 2),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Center(
                  child: pw.Text(
                    'JESUS UNHINDERED MINISTRY',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Text(
                    'OFFICIAL CONTRIBUTION RECEIPT',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey700,
                    ),
                  ),
                ),
                pw.SizedBox(height: 32),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Receipt No: JUM-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
                    ),
                    pw.Text(
                      'Date: ${DateTime.now().toLocal().toString().substring(0, 10)}',
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),
                pw.Divider(thickness: 1, color: PdfColors.grey400),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Category:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(category),
                  ],
                ),
                pw.SizedBox(height: 12),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Payment Method:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(method),
                  ],
                ),
                pw.SizedBox(height: 12),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Status:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('SUCCESSFUL'),
                  ],
                ),
                pw.SizedBox(height: 24),
                pw.Divider(thickness: 1, color: PdfColors.grey400),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Amount:',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      '\$$amount.00',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 64),
                pw.Center(
                  child: pw.Text(
                    'Thank you for your faithful partnership with the Gospel of Jesus Christ.',
                    style: pw.TextStyle(
                      fontStyle: pw.FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String txnId =
        'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Contribution Invoice',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // SUCCESS CHECKMARK
            const Center(
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 72,
              ),
            ),
            const Gap(16),
            Text(
              'Thank You for Giving!',
              style: AppTextStyles.h1.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              'Your transaction was successfully authorized.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(32),
            // PREMIUM VOUCHER RECEIPT LAYOUT
            JumCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'OFFICIAL RECEIPT',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(16),
                    const Divider(color: Colors.white24),
                    const Gap(16),
                    _buildReceiptRow('Transaction ID', txnId),
                    _buildReceiptRow(
                      'Date',
                      DateTime.now().toLocal().toString().substring(0, 10),
                    ),
                    _buildReceiptRow('Category', category),
                    _buildReceiptRow('Payment Method', method),
                    _buildReceiptRow('Status', 'SUCCESS'),
                    const Gap(16),
                    const Divider(color: Colors.white24),
                    const Gap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Gift',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$$amount.00',
                          style: AppTextStyles.h2.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Gap(32),
            JumButton(
              label: 'Print Voucher PDF',
              isFullWidth: true,
              onPressed: _printReceipt,
            ),
            const Gap(16),
            JumButton(
              label: 'Done',
              isFullWidth: true,
              variant: JumButtonVariant.secondary,
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class GivingReceiptScreen extends StatelessWidget {
  final String receiptId;

  const GivingReceiptScreen({Key? key, required this.receiptId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final receiptNumber = receiptId.isEmpty ? 'JUM-00000' : receiptId;
    final rows = [
      {'label': 'Receipt No.', 'value': receiptNumber},
      {'label': 'Date', 'value': 'May 8, 2026'},
      {'label': 'Category', 'value': 'Tithe'},
      {'label': 'Payment Method', 'value': 'Visa •••• 4242'},
      {'label': 'Status', 'value': 'Successful'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Giving Receipt',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/giving/history'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        children: [
          JumCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    size: 56,
                    color: AppColors.success,
                  ),
                  const Gap(16),
                  Text(
                    'Official Contribution Receipt',
                    style: AppTextStyles.h2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(6),
                  Text(
                    'Jesus Unhindered Ministry',
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(24),
                  ...rows.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(row['label']!, style: AppTextStyles.caption),
                          Flexible(
                            child: Text(
                              row['value']!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 32, color: AppColors.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: AppTextStyles.h3.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$150.00',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Gap(20),
          JumButton(
            label: 'Print Receipt',
            isFullWidth: true,
            onPressed: () => const GivingConfirmationScreen(
              amount: '150.00',
              category: 'Tithe',
              method: 'Visa •••• 4242',
            )._printReceipt(),
          ),
          const Gap(12),
          JumButton(
            label: 'Back to Giving History',
            isFullWidth: true,
            variant: JumButtonVariant.secondary,
            onPressed: () => context.go('/giving/history'),
          ),
        ],
      ),
    );
  }
}
