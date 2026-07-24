import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../../../shared/widgets/jum_app_bar.dart';
import '../../../../shared/widgets/jum_shimmer.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../data/models/lesson_model.dart';
import '../../data/models/quiz_question.dart';
import '../../data/providers/gospel_army_providers.dart';
import '../../data/repositories/gospel_army_repository.dart';

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
  YoutubePlayerController? _ytController;
  
  List<dynamic> _questions = [];
  bool _loadingExtras = true;
  String _assignmentSubmissionStatus = 'none'; // 'none', 'submitted', 'graded'
  
  final _assignmentBodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadExtras();
  }

  Future<void> _loadExtras() async {
    final repo = ref.read(gospelArmyRepositoryProvider);
    final user = ref.read(currentUserProvider).value;
    
    if (user != null) {
      final quizData = await repo.fetchQuiz(widget.lessonId);
      final assignment = await repo.fetchAssignment(widget.lessonId);
      
      if (assignment != null) {
        final submission = await repo.fetchAssignmentSubmission(user.id, assignment.id);
        if (submission != null) {
          _assignmentSubmissionStatus = submission.status;
        }
      }

      if (mounted) {
        setState(() {
          if (quizData != null && quizData['questions'] != null) {
            _questions = quizData['questions'] as List<dynamic>;
          }
          _loadingExtras = false;
        });
      }
    }
  }

  void _initYoutube(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      _ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
      );
      _ytController!.addListener(() {
        if (_ytController!.value.playerState == PlayerState.ended) {
           ref.read(lessonPlayerNotifierProvider.notifier).triggerQuiz();
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ytController?.dispose();
    _assignmentBodyController.dispose();
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
        loading: () => JumShimmer.list(),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (lessons) {
          final lessonIndex = lessons.indexWhere((l) => l.id == widget.lessonId);
          if (lessonIndex == -1) return const Center(child: Text('Lesson not found.'));

          final lesson = lessons[lessonIndex];
          if (_currentLesson?.id != lesson.id) {
            _currentLesson = lesson;
            if (lesson.videoUrl != null) {
              _initYoutube(lesson.videoUrl!);
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(lessonPlayerNotifierProvider.notifier).initLesson(lesson, lessonIndex);
            });
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. VIDEO PLAYER
              if (_ytController != null)
                YoutubePlayer(controller: _ytController!, showVideoProgressIndicator: true)
              else if (lesson.audioUrl != null)
                Container(
                   height: 150,
                   color: AppColors.surface2,
                   child: const Center(child: Text('Audio Player Placeholder (Audio Not Fully Configured)')),
                )
              else
                Container(
                  height: 200,
                  color: Colors.black87,
                  child: const Center(child: Icon(Icons.menu_book, color: AppColors.accent, size: 64)),
                ),

              // 2. TAB BAR
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppColors.accent,
                labelColor: AppColors.accent,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Assignment'),
                  Tab(text: 'Quiz'),
                  Tab(text: 'Discussion'),
                ],
              ),

              // 3. TABS
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // --- OVERVIEW TAB ---
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSizes.paddingLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lesson.title, style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                          const Gap(16),
                          if (lesson.content != null)
                            Text(lesson.content!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                          const Gap(24),
                          if (lesson.pdfUrl != null)
                            JumButton(
                              label: 'OPEN STUDY NOTES (PDF)',
                              onPressed: () {
                                // PDF opening logic
                              },
                            )
                        ],
                      ),
                    ),

                    // --- ASSIGNMENT TAB ---
                    _loadingExtras ? JumShimmer.card() : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSizes.paddingLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Lesson Assignment', style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                          const Gap(12),
                          if (_assignmentSubmissionStatus == 'none') ...[
                            const Text('Submit your reflection or assignment below. This is required to proceed.', style: TextStyle(color: AppColors.textSecondary)),
                            const Gap(16),
                            TextField(
                              controller: _assignmentBodyController,
                              maxLines: 6,
                              decoration: const InputDecoration(
                                hintText: 'Type your answer here...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const Gap(16),
                            JumButton(
                              label: 'SUBMIT ASSIGNMENT',
                              onPressed: () async {
                                final repo = ref.read(gospelArmyRepositoryProvider);
                                final assignment = await repo.fetchAssignment(lesson.id);
                                if (assignment != null && user != null) {
                                  await repo.submitAssignment(
                                    assignmentId: assignment.id,
                                    userId: user.id,
                                    textContent: _assignmentBodyController.text,
                                  );
                                  setState(() {
                                    _assignmentSubmissionStatus = 'submitted';
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assignment Submitted!')));
                                }
                              },
                            )
                          ] else ...[
                            JumCard(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    const Icon(Icons.check_circle, color: AppColors.success, size: 48),
                                    const Gap(8),
                                    Text('Assignment Submitted', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                                    const Gap(4),
                                    Text('Status: $_assignmentSubmissionStatus', style: const TextStyle(color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                    ),

                    // --- QUIZ TAB ---
                    _loadingExtras ? JumShimmer.list() : _questions.isEmpty
                        ? const Center(child: Text('No quiz for this lesson.', style: TextStyle(color: AppColors.textSecondary)))
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(AppSizes.paddingLg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (playerState.quizScore == null) ...[
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
                                          Text('Q${qIdx + 1}: ${question['question']}', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                                          const Gap(8),
                                          ...(question['options'] as List<dynamic>).asMap().entries.map((optEntry) {
                                            final optIdx = optEntry.key;
                                            final optionText = optEntry.value as String;
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
                                                        Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? AppColors.accent : AppColors.textMuted, size: 20),
                                                        const Gap(12),
                                                        Expanded(child: Text(optionText, style: TextStyle(color: isSelected ? AppColors.textPrimary : AppColors.textSecondary))),
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
                                      if (user != null) {
                                        await ref.read(lessonPlayerNotifierProvider.notifier).submitQuiz(_questions, userId: user.id, lessonId: lesson.id);
                                      }
                                    },
                                  ),
                                ] else ...[
                                  Container(
                                    padding: const EdgeInsets.all(AppSizes.paddingLg),
                                    decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                                    child: Column(
                                      children: [
                                        const Icon(Icons.stars, color: AppColors.accent, size: 60),
                                        const Gap(12),
                                        Text('Quiz Completed!', style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                                        const Gap(4),
                                        Text('Score: ${playerState.quizScore}/${_questions.length}', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 16)),
                                        const Gap(24),
                                        JumButton(
                                          label: 'MARK LESSON COMPLETE',
                                          isFullWidth: true,
                                          onPressed: () async {
                                            if (user != null) {
                                              await ref.read(gospelArmyRepositoryProvider).markLessonCompleted(user.id, lesson.id, widget.courseId);
                                              // Advance to next lesson logic
                                              final enrollRes = ref.read(enrollmentProvider(widget.courseId)).value;
                                              if (enrollRes != null) {
                                                final newProgress = (((lessonIndex + 1) / lessons.length) * 100).toInt();
                                                await ref.read(gospelArmyRepositoryProvider).updateProgress(enrollRes.id, newProgress);
                                                ref.invalidate(enrollmentProvider(widget.courseId));
                                                context.pop();
                                              }
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),

                    // --- DISCUSSION TAB ---
                    const Center(child: Text('Discussion coming soon', style: TextStyle(color: AppColors.textSecondary))),
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
