import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../../../shared/widgets/jum_app_bar.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../widgets/progress_ring.dart';
import '../../data/models/course_model.dart';
import '../../data/models/lesson_model.dart';
import '../../data/models/enrollment_model.dart';
import '../../data/models/quiz_question.dart';
import '../../data/providers/gospel_army_providers.dart';
import '../../data/repositories/gospel_army_repository.dart';

// -------------------------------------------------------------
// HELPER: PDF CERTIFICATE GENERATOR
// -------------------------------------------------------------
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
              border: pw.Border.all(color: PdfColor.fromHex('#D4AF37'), width: 15), // Gold Accent
              color: PdfColors.white,
            ),
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'JESUS UNHINDERED MINISTRY',
                  style: pw.TextStyle(
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#1E293B'),
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'GOSPEL ARMY SCHOOL OF MINISTRY',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#64748B'),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'CERTIFICATE OF COMPLETION',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#D4AF37'),
                    letterSpacing: 2,
                  ),
                ),
                pw.SizedBox(height: 25),
                pw.Text(
                  'This is proudly presented to',
                  style: const pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text(
                  userName.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 30,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#0F172A'),
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text(
                  'for successfully completing the ordained training course',
                  style: const pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text(
                  course.title,
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#1E293B'),
                  ),
                ),
                pw.SizedBox(height: 35),
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text(
                          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Date Issued',
                          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
                        ),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text(
                          'Pastor Kingsley',
                          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#1E293B')),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'School Chancellor',
                          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}

// -------------------------------------------------------------
// 1. GOSPEL ARMY LIST SCREEN (COURSES)
// -------------------------------------------------------------
class GospelArmyListScreen extends ConsumerStatefulWidget {
  const GospelArmyListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GospelArmyListScreen> createState() => _GospelArmyListScreenState();
}

class _GospelArmyListScreenState extends ConsumerState<GospelArmyListScreen> {
  List<EnrollmentModel> _userEnrollments = [];
  bool _loadingEnrollments = true;

  @override
  void initState() {
    super.initState();
    _loadEnrollments();
  }

  Future<void> _loadEnrollments() async {
    final user = ref.read(currentUserProvider).value;
    if (user != null) {
      final repo = ref.read(gospelArmyRepositoryProvider);
      final list = await repo.fetchUserEnrollments(user.id);
      if (mounted) {
        setState(() {
          _userEnrollments = list;
          _loadingEnrollments = false;
        });
      }
    } else {
      if (mounted) {
        setState(() => _loadingEnrollments = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(coursesProvider);
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: JumAppBar(
        title: 'Gospel Army',
        showBack: true,
      ),
      body: coursesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (err, st) => Center(child: Text('Failed to load courses: $err', style: const TextStyle(color: Colors.red))),
        data: (courses) {
          // Identify enrolled courses
          final enrolledMap = {for (var e in _userEnrollments) e.courseId: e};
          final activeCourses = courses.where((c) => enrolledMap.containsKey(c.id)).toList();
          final otherCourses = courses.where((c) => !enrolledMap.containsKey(c.id)).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Academic Hero Card
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

                // Continued Learning Section
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

                // All Courses Section
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
                                  course.coverUrl,
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
                                      course.description,
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
                                            Text('3 Lessons', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
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

// -------------------------------------------------------------
// 2. GOSPEL ARMY DETAIL SCREEN (COURSE VIEW)
// -------------------------------------------------------------
class GospelArmyDetailScreen extends ConsumerWidget {
  final String courseId;
  const GospelArmyDetailScreen({Key? key, required this.courseId}) : super(key: key);

  Future<void> _enrollInCourse(BuildContext context, WidgetRef ref, CourseModel course) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to enroll.')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enrollment failed: $e')),
      );
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
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
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
                      // Course Header Image
                      Image.network(
                        course.coverUrl,
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
                            Text(
                              course.title,
                              style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                            ),
                            const Gap(8),
                            Text(
                              course.description,
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                            const Gap(24),
                            Text(
                              'Syllabus & Lessons',
                              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                            ),
                            const Gap(12),
                            lessonsAsync.when(
                              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
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
                                                      const Gap(2),
                                                      Text(
                                                        'Duration: ${lesson.durationSeconds ~/ 60}m',
                                                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
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

              // Bottom Sticky CTA Action
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

// -------------------------------------------------------------
// 3. LESSON PLAYER SCREEN
// -------------------------------------------------------------
class LessonPlayerScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String lessonId;
  const LessonPlayerScreen({Key? key, required this.courseId, required this.lessonId}) : super(key: key);

  @override
  ConsumerState<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends ConsumerState<LessonPlayerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  LessonModel? _currentLesson;
  List<QuizQuestion> _questions = [];
  bool _loadingQuiz = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    final repo = ref.read(gospelArmyRepositoryProvider);
    final quiz = await repo.fetchQuiz(widget.lessonId);
    if (mounted) {
      setState(() {
        _questions = quiz;
        _loadingQuiz = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessonsAsync = ref.watch(courseLessonsProvider(widget.courseId));
    final playerState = ref.watch(lessonPlayerNotifierProvider);
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: JumAppBar(title: 'Lesson Study', showBack: true),
      body: lessonsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (lessons) {
          final lessonIndex = lessons.indexWhere((l) => l.id == widget.lessonId);
          if (lessonIndex == -1) {
            return const Center(child: Text('Lesson not found.'));
          }

          final lesson = lessons[lessonIndex];
          if (_currentLesson?.id != lesson.id) {
            _currentLesson = lesson;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(lessonPlayerNotifierProvider.notifier).initLesson(lesson);
            });
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. VIDEO PLAYER WINDOW
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.black,
                  child: playerState.controller != null && playerState.controller!.value.isInitialized
                      ? Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            VideoPlayerWidget(controller: playerState.controller!),
                            _VideoControlOverlay(controller: playerState.controller!),
                          ],
                        )
                      : const Center(child: CircularProgressIndicator(color: AppColors.accent)),
                ),
              ),

              // 2. TAB CONTROLLER BAR
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.accent,
                labelColor: AppColors.accent,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: const [
                  Tab(text: 'Summary'),
                  Tab(text: 'Study Notes'),
                  Tab(text: 'Quiz'),
                ],
              ),

              // 3. TAB VIEWS
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // A) Summary View
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSizes.paddingLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.title,
                            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                          ),
                          const Gap(6),
                          const Text(
                            'Instructor: Pastor Kingsley',
                            style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const Gap(16),
                          Text(
                            'This ordained module guides disciples of Gospel Army into a profound grasp of foundational doctrine. Ensure you watch the complete video stream and engage with the quiz to solidify your understanding.',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),

                    // B) Study Notes View
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSizes.paddingLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Key Takeaways',
                            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                          ),
                          const Gap(12),
                          JumCard(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSizes.paddingLg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('📜 Theological Hermeneutics', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                                  const Gap(4),
                                  Text(
                                    'Always prioritize historical context and grammatical structure before seeking spiritualized interpretations.',
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                  ),
                                  const Gap(12),
                                  const Text('🕊️ Nature of God', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                                  const Gap(4),
                                  Text(
                                    'He is eternal, omnipotent, and unchanging in His absolute covenants with His body of believers.',
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Gap(16),
                          if (lesson.pdfUrl != null)
                            JumButton(
                              label: 'OPEN ATTACHED PDF',
                              onPressed: () async {
                                final url = Uri.parse(lesson.pdfUrl!);
                                await Printing.layoutPdf(
                                  onLayout: (format) async => await showDialog(
                                    context: context,
                                    builder: (c) => const AlertDialog(
                                      title: Text('Reading PDF'),
                                      content: Text('PDF resources are fully synchronized with our cloud server.'),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),

                    // C) Practice Quiz View
                    _loadingQuiz
                        ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                        : _questions.isEmpty
                            ? const Center(child: Text('No quiz for this lesson.', style: TextStyle(color: AppColors.textSecondary)))
                            : SingleChildScrollView(
                                padding: const EdgeInsets.all(AppSizes.paddingLg),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    if (playerState.quizScore == null) ...[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Solidify Your Faith',
                                            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.fullscreen, color: Colors.white),
                                            tooltip: 'Launch Standalone Quiz',
                                            onPressed: () {
                                              context.push('/gospel_army/${widget.courseId}/lesson/${widget.lessonId}/quiz');
                                            },
                                          ),
                                        ],
                                      ),
                                      const Gap(8),
                                      JumButton(
                                        label: 'LAUNCH ADVANCED QUIZ & CERTIFICATE',
                                        variant: JumButtonVariant.secondary,
                                        isFullWidth: true,
                                        onPressed: () {
                                          context.push('/gospel_army/${widget.courseId}/lesson/${widget.lessonId}/quiz');
                                        },
                                      ),
                                      const Gap(20),
                                      ..._questions.asMap().entries.map((entry) {
                                        final qIdx = entry.key;
                                        final question = entry.value;
                                        final selectedAns = qIdx < playerState.selectedAnswers.length
                                            ? playerState.selectedAnswers[qIdx]
                                            : null;

                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: AppSizes.paddingLg),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Question ${qIdx + 1}: ${question.question}',
                                                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                              ),
                                              const Gap(8),
                                              ...question.options.asMap().entries.map((optEntry) {
                                                final optIdx = optEntry.key;
                                                final optionText = optEntry.value;
                                                final isSelected = selectedAns == optIdx;

                                                return Container(
                                                  margin: const EdgeInsets.only(bottom: 6),
                                                  child: InkWell(
                                                    onTap: () {
                                                      ref.read(lessonPlayerNotifierProvider.notifier).selectAnswer(qIdx, optIdx);
                                                    },
                                                    child: JumCard(
                                                      borderColor: isSelected ? AppColors.accent : null,
                                                      borderWidth: isSelected ? 1.0 : null,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(AppSizes.paddingMd),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                                              color: isSelected ? AppColors.accent : AppColors.textMuted,
                                                              size: 20,
                                                            ),
                                                            const Gap(12),
                                                            Expanded(
                                                              child: Text(
                                                                optionText,
                                                                style: TextStyle(
                                                                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      const Gap(16),
                                      JumButton(
                                        label: 'SUBMIT QUIZ',
                                        isFullWidth: true,
                                        onPressed: () async {
                                          await ref.read(lessonPlayerNotifierProvider.notifier).submitQuiz(
                                                _questions,
                                                userId: user?.id,
                                                lessonId: lesson.id,
                                              );
                                        },
                                      ),
                                    ] else ...[
                                      // Score Display Screen
                                      Container(
                                        padding: const EdgeInsets.all(AppSizes.paddingLg),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface2,
                                          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                                        ),
                                        child: Column(
                                          children: [
                                            const Icon(Icons.stars, color: AppColors.accent, size: 60),
                                            const Gap(12),
                                            Text(
                                              'Quiz Completed!',
                                              style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                            ),
                                            const Gap(4),
                                            Text(
                                              'You scored ${playerState.quizScore} out of ${_questions.length}!',
                                              style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            const Gap(16),
                                            const Text(
                                              'Success! Continue your spiritual journey by completing the syllabus of Christ.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: AppColors.textSecondary),
                                            ),
                                            const Gap(24),
                                            JumButton(
                                              label: 'ADVANCE TO NEXT LEVEL',
                                              isFullWidth: true,
                                              onPressed: () async {
                                                final enrollRes = ref.read(enrollmentProvider(widget.courseId)).value;
                                                if (enrollRes != null) {
                                                  await ref.read(lessonPlayerNotifierProvider.notifier).advanceLesson(
                                                        enrollmentId: enrollRes.id,
                                                        completedLessonsCount: lessonIndex + 1,
                                                        totalLessonsCount: lessons.length,
                                                      );
                                                  ref.invalidate(enrollmentProvider(widget.courseId));
                                                  context.pop();
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// -------------------------------------------------------------
// VIDEO PLAYER WIDGET LAYER
// -------------------------------------------------------------
class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController controller;
  const VideoPlayerWidget({Key? key, required this.controller}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return VideoPlayer(widget.controller);
  }
}

// -------------------------------------------------------------
// VIDEO OVERLAY LAYER
// -------------------------------------------------------------
class _VideoControlOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  const _VideoControlOverlay({Key? key, required this.controller}) : super(key: key);

  @override
  State<_VideoControlOverlay> createState() => _VideoControlOverlayState();
}

class _VideoControlOverlayState extends State<_VideoControlOverlay> {
  bool _showControls = true;

  @override
  Widget build(BuildContext context) {
    final isPlaying = widget.controller.value.isPlaying;

    return GestureDetector(
      onTap: () {
        setState(() => _showControls = !_showControls);
      },
      child: AnimatedOpacity(
        opacity: _showControls ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {},
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10, color: Colors.white, size: 36),
                    onPressed: () {
                      final pos = widget.controller.value.position;
                      widget.controller.seekTo(pos - const Duration(seconds: 10));
                    },
                  ),
                  const Gap(16),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: AppColors.accent,
                      size: 56,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isPlaying) {
                          widget.controller.pause();
                        } else {
                          widget.controller.play();
                        }
                      });
                    },
                  ),
                  const Gap(16),
                  IconButton(
                    icon: const Icon(Icons.forward_10, color: Colors.white, size: 36),
                    onPressed: () {
                      final pos = widget.controller.value.position;
                      widget.controller.seekTo(pos + const Duration(seconds: 10));
                    },
                  ),
                ],
              ),
              VideoProgressIndicator(
                widget.controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: AppColors.accent,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.black26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// DYNAMIC LESSON ASSESSMENT QUIZ SCREEN
// -------------------------------------------------------------
class QuizScreen extends StatefulWidget {
  final String courseId;
  final String lessonId;
  const QuizScreen({Key? key, required this.courseId, required this.lessonId}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
  int _score = 0;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _mockQuestions = [
    {
      'question': 'What is the primary scriptural foundation for the Gospel Army school?',
      'options': [
        'Study to shew thyself approved unto God (2 Tim 2:15)',
        'By grace are ye saved through faith (Eph 2:8)',
        'Seek ye first the kingdom of God (Matt 6:33)',
        'Iron sharpeneth iron; so a man sharpeneth (Prov 27:17)'
      ],
      'correctIndex': 0,
    },
    {
      'question': 'Which dynamic layout standard is strictly enforced throughout Christ\'s teachings?',
      'options': [
        'Compromise & Ambiguity',
        'Holiness & Unhindered Power',
        'Casual Intellectual Fellowship',
        'Sectarian Separation Only'
      ],
      'correctIndex': 1,
    },
    {
      'question': 'What is the role of a Bible student regarding theological context?',
      'options': [
        'Ignore historical context entirely',
        'Extract spiritualization before grammatical structures',
        'Always prioritize grammatical and historical context before application',
        'Depend solely on emotional responses'
      ],
      'correctIndex': 2,
    },
  ];

  void _submitOption() {
    if (_selectedOptionIndex == null) return;

    if (_selectedOptionIndex == _mockQuestions[_currentQuestionIndex]['correctIndex']) {
      _score++;
    }

    if (_currentQuestionIndex < _mockQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
      });
    } else {
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  Future<void> _printCertificate() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(32),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 8),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'GOSPEL ARMY SCHOOL OF MINISTRY',
                  style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'CERTIFICATE OF COMPLETION',
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
                ),
                pw.SizedBox(height: 32),
                pw.Text('This is to certify that', style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 8),
                pw.Text('EMMANUEL OLUWASEUN', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                pw.Text(
                  'has successfully completed all studies and assessments for Course Module 101',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 48),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      children: [
                        pw.Container(width: 150, height: 1, color: PdfColors.black),
                        pw.SizedBox(height: 4),
                        pw.Text('Pastor Kingsley', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Instructor'),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Container(width: 150, height: 1, color: PdfColors.black),
                        pw.SizedBox(height: 4),
                        pw.Text('Bishop J.U.M.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Chancellor'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Lesson Assessment', style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: _quizCompleted ? _buildResultsView() : _buildQuizView(),
      ),
    );
  }

  Widget _buildQuizView() {
    final question = _mockQuestions[_currentQuestionIndex];
    final double progress = (_currentQuestionIndex + 1) / _mockQuestions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${_mockQuestions.length}',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
            Text(
              '${(progress * 100).toInt()}% Done',
              style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Gap(8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.surface,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        const Gap(32),
        JumCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: Text(
              question['question'] as String,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold, height: 1.4),
            ),
          ),
        ),
        const Gap(24),
        ...List.generate((question['options'] as List).length, (index) {
          final optionText = question['options'][index] as String;
          final isSelected = _selectedOptionIndex == index;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => setState(() => _selectedOptionIndex = index),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: JumCard(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withOpacity(0.08) : null,
                    border: isSelected ? Border.all(color: Colors.white, width: 1.5) : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? Colors.white : AppColors.textMuted,
                      ),
                      const Gap(16),
                      Expanded(
                        child: Text(
                          optionText,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        const Gap(24),
        JumButton(
          label: _currentQuestionIndex == _mockQuestions.length - 1 ? 'Finish Assessment' : 'Next Question',
          isFullWidth: true,
          variant: _selectedOptionIndex == null ? JumButtonVariant.secondary : JumButtonVariant.primary,
          onPressed: _selectedOptionIndex == null ? () {} : _submitOption,
        ),
      ],
    );
  }

  Widget _buildResultsView() {
    final bool isPassed = _score >= 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        JumCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: Column(
              children: [
                Icon(
                  isPassed ? Icons.emoji_events_outlined : Icons.info_outline,
                  color: isPassed ? Colors.white : AppColors.textMuted,
                  size: 72,
                ),
                const Gap(16),
                Text(
                  isPassed ? 'Approved Unto God!' : 'Study to Shew Thyself',
                  style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                ),
                const Gap(8),
                Text(
                  'You scored $_score out of ${_mockQuestions.length} questions correctly.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const Gap(24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _score / _mockQuestions.length,
                    minHeight: 12,
                    backgroundColor: AppColors.surface,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(24),
        if (isPassed) ...[
          // FROSTED PHYSICAL CERTIFICATE MOCK
          JumCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'OFFICIAL CERTIFICATE',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, letterSpacing: 1.5),
                      ),
                      const Icon(Icons.verified, color: Colors.white, size: 18),
                    ],
                  ),
                  const Gap(16),
                  Text(
                    'Emmanuel Oluwaseun',
                    style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontFamily: 'serif'),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(4),
                  Text(
                    'has successfully completed all requirements of G.A.S. Module 101 with an approved score.',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(24),
                  JumButton(
                    label: 'Print PDF Certificate',
                    variant: JumButtonVariant.secondary,
                    onPressed: _printCertificate,
                  ),
                ],
              ),
            ),
          ),
          const Gap(24),
        ],
        JumButton(
          label: 'Back to Courses',
          isFullWidth: true,
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
