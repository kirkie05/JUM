import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/enrollment_model.dart';
import '../models/quiz_question.dart';
import '../models/quiz_attempt.dart';

class SchoolRepository {
  final SupabaseClient _supabase;
  SchoolRepository(this._supabase);

  // In-memory fallback lists for demo/testing and safety
  static final List<CourseModel> _mockCourses = [
    CourseModel(
      id: 'course-1',
      churchId: 'jum-church-1',
      title: 'Foundations of Faith',
      description: 'Access certified courses and modules to mature in your walk with God.',
      coverUrl: 'https://images.unsplash.com/photo-1504052434569-70ad58565b90?w=800',
      isPublished: true,
    ),
    CourseModel(
      id: 'course-2',
      churchId: 'jum-church-1',
      title: 'Kingdom Leadership',
      description: 'Developing apostolic leaders for the end-time global harvest.',
      coverUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800',
      isPublished: true,
    ),
    CourseModel(
      id: 'course-3',
      churchId: 'jum-church-1',
      title: 'Advanced Biblical Hermeneutics',
      description: 'Mastering the skills of interpreting scripture with historical-grammatical methods.',
      coverUrl: 'https://images.unsplash.com/photo-1506784983877-45594efa4cbe?w=800',
      isPublished: true,
    ),
  ];

  static final List<LessonModel> _mockLessons = [
    LessonModel(
      id: 'lesson-1-1',
      courseId: 'course-1',
      title: '1. Intro to Scripture',
      videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-holding-a-small-leather-bible-41551-large.mp4',
      pdfUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      durationSeconds: 920,
      sortOrder: 1,
    ),
    LessonModel(
      id: 'lesson-1-2',
      courseId: 'course-1',
      title: '2. The Nature of God',
      videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-man-reading-the-holy-bible-41550-large.mp4',
      pdfUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      durationSeconds: 1125,
      sortOrder: 2,
    ),
    LessonModel(
      id: 'lesson-1-3',
      courseId: 'course-1',
      title: '3. Covenant Theology',
      videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-open-holy-bible-with-a-cross-41552-large.mp4',
      pdfUrl: null,
      durationSeconds: 1330,
      sortOrder: 3,
    ),
  ];

  static final List<QuizQuestion> _mockQuizQuestions = [
    QuizQuestion(
      id: 'q1',
      lessonId: 'lesson-1-1',
      question: 'What is the primary method of interpreting Scripture in Foundations of Faith?',
      options: [
        'A) Allegorical and speculative readings',
        'B) Literal, historical-grammatical context',
        'C) Strictly cultural-political opinions',
        'D) Purely modern subjective feeling'
      ],
      correctIndex: 1,
    ),
    QuizQuestion(
      id: 'q2',
      lessonId: 'lesson-1-1',
      question: 'How many books are in the Protestant Biblical Canon?',
      options: ['A) 39 books', 'B) 27 books', 'C) 66 books', 'D) 73 books'],
      correctIndex: 2,
    ),
    QuizQuestion(
      id: 'q3',
      lessonId: 'lesson-1-2',
      question: 'Which attribute defines God as being all-powerful?',
      options: ['A) Omniscience', 'B) Omnipresence', 'C) Omnipotence', 'D) Immutability'],
      correctIndex: 2,
    ),
  ];

  static final List<EnrollmentModel> _mockEnrollments = [];
  static final List<QuizAttempt> _mockQuizAttempts = [];

  Future<List<CourseModel>> fetchCourses(String churchId) async {
    try {
      final res = await _supabase.from('courses').select().eq('church_id', churchId).eq('is_published', true);
      return (res as List).map((row) => CourseModel.fromJson(row)).toList();
    } catch (_) {
      return _mockCourses.where((c) => c.churchId == churchId && c.isPublished).toList();
    }
  }

  Future<CourseModel> fetchCourse(String courseId) async {
    try {
      final res = await _supabase.from('courses').select().eq('id', courseId).single();
      return CourseModel.fromJson(res);
    } catch (_) {
      return _mockCourses.firstWhere((c) => c.id == courseId);
    }
  }

  Future<List<LessonModel>> fetchLessons(String courseId) async {
    try {
      final res = await _supabase.from('lessons').select().eq('course_id', courseId).order('sort_order');
      return (res as List).map((row) => LessonModel.fromJson(row)).toList();
    } catch (_) {
      return _mockLessons.where((l) => l.courseId == courseId).toList()..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    }
  }

  Future<EnrollmentModel?> fetchEnrollment(String userId, String courseId) async {
    try {
      final res = await _supabase.from('enrollments').select().eq('user_id', userId).eq('course_id', courseId).maybeSingle();
      if (res == null) return null;
      return EnrollmentModel.fromJson(res);
    } catch (_) {
      final matches = _mockEnrollments.where((e) => e.userId == userId && e.courseId == courseId);
      return matches.isEmpty ? null : matches.first;
    }
  }

  Future<void> enroll(String userId, String courseId) async {
    final enrollment = EnrollmentModel(
      id: 'enroll-${userId.hashCode}-${courseId.hashCode}-${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      courseId: courseId,
      progressPercent: 0,
    );

    try {
      await _supabase.from('enrollments').insert(enrollment.toJson());
    } catch (_) {
      final idx = _mockEnrollments.indexWhere((e) => e.userId == userId && e.courseId == courseId);
      if (idx == -1) {
        _mockEnrollments.add(enrollment);
      }
    }
  }

  Future<void> updateProgress(String enrollmentId, int progressPercent) async {
    try {
      await _supabase.from('enrollments').update({'progress_percent': progressPercent}).eq('id', enrollmentId);
    } catch (_) {
      final idx = _mockEnrollments.indexWhere((e) => e.id == enrollmentId);
      if (idx != -1) {
        final current = _mockEnrollments[idx];
        _mockEnrollments[idx] = current.copyWith(progressPercent: progressPercent);
      }
    }
  }

  Future<void> markCompleted(String enrollmentId) async {
    try {
      await _supabase.from('enrollments').update({
        'progress_percent': 100,
        'completed_at': DateTime.now().toIso8601String(),
      }).eq('id', enrollmentId);
    } catch (_) {
      final idx = _mockEnrollments.indexWhere((e) => e.id == enrollmentId);
      if (idx != -1) {
        final current = _mockEnrollments[idx];
        _mockEnrollments[idx] = current.copyWith(
          progressPercent: 100,
          completedAt: DateTime.now(),
        );
      }
    }
  }

  Future<List<QuizQuestion>> fetchQuiz(String lessonId) async {
    try {
      final res = await _supabase.from('quiz_questions').select().eq('lesson_id', lessonId);
      return (res as List).map((row) => QuizQuestion.fromJson(row)).toList();
    } catch (_) {
      return _mockQuizQuestions.where((q) => q.lessonId == lessonId).toList();
    }
  }

  Future<void> submitQuiz(QuizAttempt attempt) async {
    try {
      await _supabase.from('quiz_attempts').insert(attempt.toJson());
    } catch (_) {
      _mockQuizAttempts.add(attempt);
    }
  }

  Future<List<EnrollmentModel>> fetchUserEnrollments(String userId) async {
    try {
      final res = await _supabase.from('enrollments').select().eq('user_id', userId);
      return (res as List).map((row) => EnrollmentModel.fromJson(row)).toList();
    } catch (_) {
      return _mockEnrollments.where((e) => e.userId == userId).toList();
    }
  }
}

final schoolRepositoryProvider = Provider<SchoolRepository>((ref) {
  return SchoolRepository(ref.watch(supabaseClientProvider));
});
