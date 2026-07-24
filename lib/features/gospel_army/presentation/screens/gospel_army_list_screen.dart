import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_app_bar.dart';
import '../../../../shared/widgets/jum_shimmer.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../widgets/progress_ring.dart';
import '../../data/models/course_model.dart';
import '../../data/models/enrollment_model.dart';
import '../../data/providers/gospel_army_providers.dart';
import '../../data/repositories/gospel_army_repository.dart';

class GospelArmyListScreen extends ConsumerStatefulWidget {
  const GospelArmyListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GospelArmyListScreen> createState() => _GospelArmyListScreenState();
}

class _GospelArmyListScreenState extends ConsumerState<GospelArmyListScreen> {
  List<EnrollmentModel> _userEnrollments = [];

  @override
  void initState() {
    super.initState();
    _loadEnrollments();
  }

  Future<void> _loadEnrollments() async {
    final user = ref.read(currentUserProvider).value;
    if (user != null) {
      final repo = ref.read(gospelArmyRepositoryProvider);
      final enrollments = await repo.fetchUserEnrollments(user.id);
      if (mounted) {
        setState(() {
          _userEnrollments = enrollments;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(coursesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: JumAppBar(
        title: 'Gospel Army',
        showBack: true,
      ),
      body: coursesAsync.when(
        loading: () => JumShimmer.list(),
        error: (err, st) => Center(child: Text('Failed to load courses: $err', style: const TextStyle(color: Colors.red))),
        data: (courses) {
          final enrolledMap = {for (var e in _userEnrollments) e.courseId: e};
          final activeCourses = courses.where((c) => enrolledMap.containsKey(c.id)).toList();
          final otherCourses = courses.where((c) => !enrolledMap.containsKey(c.id)).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hero
                JumCard(
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.paddingLg),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Equipping Saints for Ministry',
                          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                        ),
                        const Gap(8),
                        Text(
                          'Study theological and practical ministry modules crafted by anointed leaders.',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(24),

                if (activeCourses.isNotEmpty) ...[
                  Text(
                    'Continue Learning',
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                  const Gap(12),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: activeCourses.length,
                      itemBuilder: (context, index) {
                        final course = activeCourses[index];
                        final enrollment = enrolledMap[course.id]!;
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            onTap: () => context.push('/gospel_army/${course.id}'),
                            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                            child: JumCard(
                              child: Padding(
                                padding: const EdgeInsets.all(AppSizes.paddingMd),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            course.title,
                                            style: AppTextStyles.bodyMedium.copyWith(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const Gap(8),
                                          Text(
                                            'Click to Resume',
                                            style: AppTextStyles.caption.copyWith(color: AppColors.accent),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Gap(12),
                                    ProgressRing(progress: enrollment.progressPercent, size: 55),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Gap(24),
                ],

                Text(
                  'Available Modules',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                ),
                const Gap(12),
                if (otherCourses.isEmpty && activeCourses.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'You are enrolled in all available modules! Praise God!',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                    ),
                  )
                else
                  ...otherCourses.map((course) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.paddingMd),
                      child: InkWell(
                        onTap: () => context.push('/gospel_army/${course.id}'),
                        child: JumCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusSm)),
                                child: Image.network(
                                  course.coverUrl ?? '',
                                  height: 140,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 140,
                                    color: AppColors.surface2,
                                    child: const Icon(Icons.school, size: 48, color: AppColors.accent),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(AppSizes.paddingLg),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.title,
                                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                    ),
                                    const Gap(6),
                                    Text(
                                      course.description ?? '',
                                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Gap(16),
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.video_library_outlined, size: 16, color: AppColors.accent),
                                            Gap(4),
                                            Text('Study Now', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                          ],
                                        ),
                                        Text(
                                          'Enroll Now →',
                                          style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 13),
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
                    );
                  }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
