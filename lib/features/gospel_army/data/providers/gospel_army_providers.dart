import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../models/course_model.dart';
import '../models/course_module_model.dart';
import '../models/lesson_model.dart';
import '../models/enrollment_model.dart';
import '../models/quiz_attempt.dart';
import '../models/assignment_model.dart';
import '../models/assignment_submission_model.dart';
import '../models/lesson_progress_model.dart';
import '../repositories/gospel_army_repository.dart';

final coursesProvider = FutureProvider<List<CourseModel>>((ref) async {
  return ref.watch(gospelArmyRepositoryProvider).fetchCourses();
});

final courseProvider = FutureProvider.family<CourseModel, String>((ref, courseId) async {
  return ref.watch(gospelArmyRepositoryProvider).fetchCourse(courseId);
});

final courseModulesProvider = FutureProvider.family<List<CourseModuleModel>, String>((ref, courseId) async {
  return ref.watch(gospelArmyRepositoryProvider).fetchModules(courseId);
});

final courseLessonsProvider = FutureProvider.family<List<LessonModel>, String>((ref, courseId) async {
  return ref.watch(gospelArmyRepositoryProvider).fetchLessons(courseId);
});

final enrollmentProvider = FutureProvider.family<EnrollmentModel?, String>((ref, courseId) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return null;
  return ref.watch(gospelArmyRepositoryProvider).fetchEnrollment(user.id, courseId);
});

final lessonProgressProvider = FutureProvider.family<LessonProgressModel?, String>((ref, lessonId) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return null;
  return ref.watch(gospelArmyRepositoryProvider).fetchLessonProgress(user.id, lessonId);
});

final assignmentProvider = FutureProvider.family<AssignmentModel?, String>((ref, lessonId) async {
  return ref.watch(gospelArmyRepositoryProvider).fetchAssignment(lessonId);
});

final assignmentSubmissionProvider = FutureProvider.family<AssignmentSubmissionModel?, String>((ref, assignmentId) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return null;
  return ref.watch(gospelArmyRepositoryProvider).fetchAssignmentSubmission(user.id, assignmentId);
});

final lessonDiscussionsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, lessonId) async {
  return ref.watch(gospelArmyRepositoryProvider).fetchLessonDiscussions(lessonId);
});

class LessonPlayerState {
  final int currentLessonIndex;
  final bool showQuiz;
  final List<int?> selectedAnswers; 
  final int? quizScore;

  const LessonPlayerState({
    this.currentLessonIndex = 0,
    this.showQuiz = false,
    this.selectedAnswers = const [],
    this.quizScore,
  });

  LessonPlayerState copyWith({
    int? currentLessonIndex,
    bool? showQuiz,
    List<int?>? selectedAnswers,
    int? quizScore,
  }) {
    return LessonPlayerState(
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

  void initLesson(LessonModel lesson, int index) {
    state = LessonPlayerState(
      currentLessonIndex: index,
      showQuiz: false,
      selectedAnswers: [],
      quizScore: null,
    );
  }

  void triggerQuiz() {
    state = state.copyWith(showQuiz: true);
  }

  void selectAnswer(int questionIndex, int answerIndex) {
    final answers = List<int?>.from(state.selectedAnswers);
    while (answers.length <= questionIndex) {
      answers.add(null);
    }
    answers[questionIndex] = answerIndex;
    state = state.copyWith(selectedAnswers: answers);
  }

  Future<void> submitQuiz(List<dynamic> questions, {required String userId, required String lessonId}) async {
    int correctCount = 0;
    for (int i = 0; i < questions.length; i++) {
      final selected = i < state.selectedAnswers.length ? state.selectedAnswers[i] : null;
      if (selected == questions[i]['correct_index']) {
        correctCount++;
      }
    }

    final attempt = QuizAttempt(
      id: 'attempt-${userId.hashCode}-${lessonId.hashCode}-${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      lessonId: lessonId,
      score: correctCount,
      submittedAt: DateTime.now(),
    );

    await ref.read(gospelArmyRepositoryProvider).submitQuiz(attempt);
    state = state.copyWith(quizScore: correctCount);
  }
}

final lessonPlayerNotifierProvider = StateNotifierProvider<LessonPlayerNotifier, LessonPlayerState>((ref) {
  return LessonPlayerNotifier(ref);
});
