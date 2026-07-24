import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../../../../shared/widgets/jum_app_bar.dart';
import '../../../../shared/widgets/jum_shimmer.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../data/models/course_model.dart';
import '../../data/providers/gospel_army_providers.dart';
import '../../data/repositories/gospel_army_repository.dart';

Future<void> _generateAndPrintCertificate(CourseModel course, String userName) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (pw.Context context) {
        return pw.FullPage(
          ignoreMargins: true,
          child: pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColor.fromHex('#D4AF37'), width: 15), 
              color: PdfColors.white,
            ),
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'JESUS UNHINDERED MINISTRY',
                  style: pw.TextStyle(color: PdfColor.fromHex('#D4AF37'), fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Text('CERTIFICATE OF COMPLETION', style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 40),
                pw.Text('This is to certify that', style: const pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Text(userName.toUpperCase(), style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic)),
                pw.SizedBox(height: 10),
                pw.Text('has successfully completed the Gospel Army training module:', style: const pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 20),
                pw.Text(course.title.toUpperCase(), style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#004D40'))),
                pw.SizedBox(height: 40),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Column(
                      children: [
                        pw.Container(width: 150, height: 1, color: PdfColors.black),
                        pw.SizedBox(height: 8),
                        pw.Text('Date', style: const pw.TextStyle(fontSize: 14)),
                        pw.Text(DateTime.now().toString().split(' ')[0], style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Container(width: 150, height: 1, color: PdfColors.black),
                        pw.SizedBox(height: 8),
                        pw.Text('Apostle Kingsley', style: const pw.TextStyle(fontSize: 14)),
                        pw.Text('Senior Pastor', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}

class GospelArmyDetailScreen extends ConsumerWidget {
  final String courseId;
  const GospelArmyDetailScreen({Key? key, required this.courseId}) : super(key: key);

  Future<void> _enrollInCourse(BuildContext context, WidgetRef ref, CourseModel course) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please log in to enroll.')));
      return;
    }

    try {
      await ref.read(gospelArmyRepositoryProvider).enroll(user.id, course.id);
      ref.invalidate(enrollmentProvider(course.id));
      
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
          title: const Text('Glory to God!', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          content: Text(
            'You have successfully enrolled in "${course.title}". Begin studying to show yourself approved unto God.',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Start Now', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enrollment failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseProvider(courseId));
    final lessonsAsync = ref.watch(courseLessonsProvider(courseId));
    final enrollmentAsync = ref.watch(enrollmentProvider(courseId));
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: JumAppBar(title: 'Course Outline', showBack: true),
      body: courseAsync.when(
        loading: () => Padding(padding: const EdgeInsets.all(AppSizes.paddingLg), child: JumShimmer.card(height: 300)),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (course) {
          final isEnrolled = enrollmentAsync.value != null;
          final enrollment = enrollmentAsync.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        course.coverUrl ?? '',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 200,
                          color: AppColors.surface2,
                          child: const Icon(Icons.school, size: 64, color: AppColors.accent),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppSizes.paddingLg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(course.title, style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                            const Gap(8),
                            Text(course.description ?? '', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                            const Gap(24),
                            Text('Syllabus & Lessons', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                            const Gap(12),
                            lessonsAsync.when(
                              loading: () => JumShimmer.list(),
                              error: (e, __) => Text('Failed to load lessons: $e'),
                              data: (lessons) {
                                if (lessons.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Text('No lessons currently available.', style: TextStyle(color: AppColors.textSecondary)),
                                  );
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: lessons.length,
                                  itemBuilder: (context, idx) {
                                    final lesson = lessons[idx];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
                                      child: InkWell(
                                        onTap: () {
                                          if (isEnrolled) {
                                            context.push('/gospel_army/$courseId/lesson/${lesson.id}');
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Please enroll in the course to access lessons.')),
                                            );
                                          }
                                        },
                                        child: JumCard(
                                          child: Padding(
                                            padding: const EdgeInsets.all(AppSizes.paddingMd),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  isEnrolled ? Icons.play_circle_fill : Icons.lock_outline,
                                                  color: isEnrolled ? AppColors.accent : AppColors.textMuted,
                                                ),
                                                const Gap(12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        lesson.title,
                                                        style: AppTextStyles.bodyMedium.copyWith(
                                                          color: AppColors.textPrimary,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      if (lesson.content != null) ...[
                                                        const Gap(2),
                                                        Text(
                                                          lesson.content!,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                                                        ),
                                                      ]
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
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: isEnrolled
                    ? Column(
                        children: [
                          if (enrollment != null) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Course Progress', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                                Text('${enrollment.progressPercent}%', style: AppTextStyles.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Gap(8),
                            LinearProgressIndicator(
                              value: enrollment.progressPercent / 100.0,
                              color: AppColors.accent,
                              backgroundColor: AppColors.surface2,
                            ),
                            const Gap(16),
                          ],
                          JumButton(
                            label: enrollment?.progressPercent == 100 ? 'DOWNLOAD CERTIFICATE' : 'RESUME STUDYING',
                            isFullWidth: true,
                            onPressed: () async {
                              if (enrollment?.progressPercent == 100) {
                                await _generateAndPrintCertificate(course, user?.name ?? 'Devoted Disciple');
                              } else {
                                lessonsAsync.whenData((lessons) {
                                  if (lessons.isNotEmpty) {
                                    context.push('/gospel_army/$courseId/lesson/${lessons.first.id}');
                                  }
                                });
                              }
                            },
                          ),
                        ],
                      )
                    : JumButton(
                        label: 'ENROLL NOW',
                        isFullWidth: true,
                        onPressed: () => _enrollInCourse(context, ref, course),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
