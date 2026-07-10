import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../data/providers/reading_plan_providers.dart';
import '../../data/models/bible_reading_plan_engine.dart';
import '../../../../shared/widgets/jum_shimmer.dart';
import '../../data/providers/bible_providers.dart';

class BibleReadingPlanScreen extends ConsumerStatefulWidget {
  const BibleReadingPlanScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BibleReadingPlanScreen> createState() => _BibleReadingPlanScreenState();
}

class _BibleReadingPlanScreenState extends ConsumerState<BibleReadingPlanScreen> {
  int? _localSelectedDay;

  @override
  Widget build(BuildContext context) {
    final planStateAsync = ref.watch(readingPlanStateProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Bible Reading Plan',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: planStateAsync.when(
        loading: () => JumShimmer.list(),
        error: (err, _) => Center(
          child: Text('Error loading reading plan: $err'),
        ),
        data: (planState) {
          final activeDayNumber = _localSelectedDay ?? planState.nextReading.dayNumber;
          final dayPlan = BibleReadingPlanEngine.getPlan().firstWhere(
            (d) => d.dayNumber == activeDayNumber,
            orElse: () => planState.nextReading,
          );
          
          final completedDayNums = planState.completedDays.map((p) => p.dayNumber).toSet();
          final isDayCompleted = completedDayNums.contains(activeDayNumber);
          final isPlanFinished = planState.completedDays.length == 365;

          final currentStreak = planState.streak?.currentStreak ?? 0;
          final longestStreak = planState.streak?.longestStreak ?? 0;
          final completionPct = planState.completionPercentage;
          final daysRemaining = 365 - planState.completedDays.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. STATS ROW - Frosted Glass Card
                JumCard(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Streak', '$currentStreak 🔥', 'Longest: $longestStreak'),
                      Container(width: 1, height: 40, color: AppColors.divider),
                      _buildStatItem('Completed', '${completionPct.toStringAsFixed(1)}%', '$daysRemaining days left'),
                    ],
                  ),
                ),
                const Gap(24),

                // 2. ACTIVE DAY CARD
                Text(
                  isDayCompleted ? 'COMPLETED READING' : 'TODAY\'S READING',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
                const Gap(12),
                JumCard(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'DAY $activeDayNumber OF 365',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                              const Gap(4),
                              Text(
                                '${dayPlan.estimatedReadingTimeMinutes} MINS',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Gap(16),
                      Text(
                        dayPlan.title,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        isDayCompleted
                            ? 'You have completed this day\'s reading. Keep going!'
                            : 'Dive into the scriptures today and grow closer to God\'s Word.',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Gap(20),
                      // Progress bar
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: planState.completionPercentage / 100.0,
                                backgroundColor: const Color(0xFFE5E7EB),
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                                minHeight: 8,
                              ),
                            ),
                          ),
                          const Gap(12),
                          Text(
                            '${planState.completionPercentage.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Gap(24),
                      Row(
                        children: [
                          Expanded(
                            child: JumButton(
                              label: 'Read Scripture',
                              onPressed: () {
                                if (dayPlan.ranges.isNotEmpty) {
                                  ref.read(currentBookProvider.notifier).state = dayPlan.ranges.first.bookId;
                                  ref.read(currentChapterNumberProvider.notifier).state = dayPlan.ranges.first.startChapter;
                                  ref.read(selectedPlanDayProvider.notifier).state = activeDayNumber;
                                  context.push('/bible');
                                }
                              },
                            ),
                          ),
                          const Gap(12),
                          InkWell(
                            onTap: () {
                              if (!isDayCompleted) {
                                ref.read(readingPlanStateProvider.notifier).markCompleted(activeDayNumber, 300);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Day $activeDayNumber marked as completed!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: isDayCompleted ? Colors.green.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDayCompleted ? Colors.green : AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isDayCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                                    color: isDayCompleted ? Colors.green : AppColors.primary,
                                    size: 20,
                                  ),
                                  const Gap(8),
                                  Text(
                                    isDayCompleted ? 'DONE' : 'COMPLETE',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      color: isDayCompleted ? Colors.green : AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(28),

                // 3. PREV / NEXT NAV SLIDER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                      onPressed: activeDayNumber > 1
                          ? () => setState(() => _localSelectedDay = activeDayNumber - 1)
                          : null,
                    ),
                    Text(
                      'DAY $activeDayNumber OF 365',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: activeDayNumber < 365
                          ? () => setState(() => _localSelectedDay = activeDayNumber + 1)
                          : null,
                    ),
                  ],
                ),
                const Gap(28),

                // 4. READING CALENDAR / HISTORY
                const Text(
                  'READING JOURNEY CALENDAR',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
                const Gap(12),
                JumCard(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: 365,
                    itemBuilder: (context, idx) {
                      final dayNum = idx + 1;
                      final isCompleted = completedDayNums.contains(dayNum);
                      final isActive = dayNum == activeDayNumber;
                      
                      Color cellColor = Colors.grey.shade100;
                      Color textColor = Colors.black87;
                      Border? border;

                      if (isCompleted) {
                        cellColor = Colors.green.withOpacity(0.2);
                        textColor = Colors.green.shade800;
                      }
                      if (isActive) {
                        border = Border.all(color: AppColors.primary, width: 2.0);
                      }

                      return InkWell(
                        onTap: () => setState(() => _localSelectedDay = dayNum),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cellColor,
                            borderRadius: BorderRadius.circular(8),
                            border: border,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$dayNum',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String subtitle) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const Gap(4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const Gap(2),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.0,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
