import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/enrollment_model.dart';
import '../models/quiz_question.dart';
import '../models/quiz_attempt.dart';
import '../repositories/gospel_army_repository.dart';

final coursesProvider = FutureProvider<List<CourseModel>>((ref) async {
  final churchId = ref.watch(currentUserProvider).value?.churchId ?? 'jum-church-1';
  return ref.watch(gospelArmyRepositoryProvider).fetchCourses(churchId);
});

final courseProvider = FutureProvider.family<CourseModel, String>((ref, courseId) async {
  return ref.watch(gospelArmyRepositoryProvider).fetchCourse(courseId);
});

final courseLessonsProvider = FutureProvider.family<List<LessonModel>, String>((ref, courseId) async {
  return ref.watch(gospelArmyRepositoryProvider).fetchLessons(courseId);
});

final enrollmentProvider = FutureProvider.family<EnrollmentModel?, String>((ref, courseId) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return null;
  return ref.watch(gospelArmyRepositoryProvider).fetchEnrollment(user.id, courseId);
});

class LessonPlayerState {
  final VideoPlayerController? controller;
  final int currentLessonIndex;
  final bool showQuiz;
  final List<int?> selectedAnswers; // null = unanswered
  final int? quizScore;

  const LessonPlayerState({
    this.controller,
    this.currentLessonIndex = 0,
    this.showQuiz = false,
    this.selectedAnswers = const [],
    this.quizScore,
  });

  LessonPlayerState copyWith({
    VideoPlayerController? controller,
    int? currentLessonIndex,
    bool? showQuiz,
    List<int?>? selectedAnswers,
    int? quizScore,
  }) {
    return LessonPlayerState(
      controller: controller ?? this.controller,
      currentLessonIndex: currentLessonIndex ?? this.currentLessonIndex,
      showQuiz: showQuiz ?? this.showQuiz,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      quizScore: quizScore ?? this.quizScore,
    );
  }
}

class LessonPlayerNotifier extends StateNotifier<LessonPlayerState> {
  final Ref ref;

  LessonPlayerNotifier(this.ref) : super(const LessonPlayerState());

  @override
  void dispose() {
    state.controller?.dispose();
    super.dispose();
  }

  void initLesson(LessonModel lesson) {
    state.controller?.dispose();
    final controller = VideoPlayerController.networkUrl(Uri.parse(lesson.videoUrl));
    
    state = LessonPlayerState(
      controller: controller,
      currentLessonIndex: state.currentLessonIndex,
      showQuiz: false,
      selectedAnswers: [],
      quizScore: null,
    );

    controller.initialize().then((_) {
      state = state.copyWith(controller: controller);
      controller.play();
      controller.addListener(_videoListener);
    });
  }

  void _videoListener() {
    final controller = state.controller;
    if (controller != null && controller.value.position >= controller.value.duration) {
      controller.removeListener(_videoListener);
      state = state.copyWith(showQuiz: true);
    }
  }

  void selectAnswer(int questionIndex, int answerIndex) {
    final answers = List<int?>.from(state.selectedAnswers);
    while (answers.length <= questionIndex) {
      answers.add(null);
    }
    answers[questionIndex] = answerIndex;
    state = state.copyWith(selectedAnswers: answers);
  }

  Future<void> submitQuiz(List<QuizQuestion> questions, {String? userId, String? lessonId}) async {
    final effectiveUserId = userId ?? 'mock-user-id';
    final effectiveLessonId = lessonId ?? 'mock-lesson-id';

    int correctCount = 0;
    for (int i = 0; i < questions.length; i++) {
      final selected = i < state.selectedAnswers.length ? state.selectedAnswers[i] : null;
      if (selected == questions[i].correctIndex) {
        correctCount++;
      }
    }

    final attempt = QuizAttempt(
      id: 'attempt-${effectiveUserId.hashCode}-${effectiveLessonId.hashCode}-${DateTime.now().millisecondsSinceEpoch}',
      userId: effectiveUserId,
      lessonId: effectiveLessonId,
      score: correctCount,
      submittedAt: DateTime.now(),
    );

    await ref.read(gospelArmyRepositoryProvider).submitQuiz(attempt);
    state = state.copyWith(quizScore: correctCount);
  }

  Future<void> advanceLesson({
    required String enrollmentId,
    required int completedLessonsCount,
    required int totalLessonsCount,
  }) async {
    final int newProgress = ((completedLessonsCount / totalLessonsCount) * 100).toInt();
    if (newProgress >= 100) {
      await ref.read(gospelArmyRepositoryProvider).markCompleted(enrollmentId);
    } else {
      await ref.read(gospelArmyRepositoryProvider).updateProgress(enrollmentId, newProgress);
    }
    state = state.copyWith(currentLessonIndex: state.currentLessonIndex + 1);
  }
}

final lessonPlayerNotifierProvider = StateNotifierProvider<LessonPlayerNotifier, LessonPlayerState>((ref) {
  return LessonPlayerNotifier(ref);
});
