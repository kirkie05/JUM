import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';

class AdminReadingPlansScreen extends ConsumerStatefulWidget {
  const AdminReadingPlansScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminReadingPlansScreen> createState() => _AdminReadingPlansScreenState();
}

class _AdminReadingPlansScreenState extends ConsumerState<AdminReadingPlansScreen> {
  final List<Map<String, dynamic>> _plans = [
    {
      'id': '1',
      'name': '365-Day Complete Bible Plan',
      'description': 'Read the entire Bible cover-to-cover in one year.',
      'duration': '365 Days',
      'status': 'Active',
      'subscribers': 1205,
    },
    {
      'id': '2',
      'name': '90-Day New Testament Challenge',
      'description': 'A high-intensity plan focusing on Gospels, Acts, and Epistles.',
      'duration': '90 Days',
      'status': 'Draft',
      'subscribers': 0,
    },
    {
      'id': '3',
      'name': '30-Day Proverbs Wisdom Plan',
      'description': 'Daily wisdom reading from the Book of Proverbs.',
      'duration': '30 Days',
      'status': 'Scheduled',
      'subscribers': 0,
    }
  ];

  void _publishNewPlan() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final descController = TextEditingController();
        final daysController = TextEditingController();

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Publish New Reading Plan', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Plan Name', hintText: 'e.g. 180-Day Chronological'),
                ),
                const Gap(12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description', hintText: 'Enter plan details...'),
                ),
                const Gap(12),
                TextField(
                  controller: daysController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Duration (Days)', hintText: 'e.g. 180'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final days = int.tryParse(daysController.text.trim()) ?? 0;
                if (name.isNotEmpty && days > 0) {
                  setState(() {
                    _plans.add({
                      'id': '${_plans.length + 1}',
                      'name': name,
                      'description': descController.text.trim(),
                      'duration': '$days Days',
                      'status': 'Active',
                      'subscribers': 0,
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reading Plan "$name" published successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Publish', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        title: const Text(
          'Manage Reading Plans',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PUBLISHED PLANS',
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
                JumButton(
                  label: 'Publish Plan',
                  onPressed: _publishNewPlan,
                ),
              ],
            ),
            const Gap(16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                final plan = _plans[index];
                final status = plan['status'] as String;
                Color statusColor = Colors.grey;
                if (status == 'Active') statusColor = Colors.green;
                if (status == 'Scheduled') statusColor = Colors.blue;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: JumCard(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              plan['name'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(6),
                        Text(
                          plan['description'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Gap(12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Duration: ${plan['duration']}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                            ),
                            Text(
                              'Active Subscribers: ${plan['subscribers']}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
