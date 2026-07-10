import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/enrollment_model.dart';
import '../models/quiz_question.dart';
import '../models/quiz_attempt.dart';

class GospelArmyRepository {
  final SupabaseClient _supabase;
  GospelArmyRepository(this._supabase);

  Future<List<CourseModel>> fetchCourses() async {
    final res = await _supabase.from('courses').select().eq('is_published', true);
    return (res as List).map((row) => CourseModel.fromJson(row)).toList();
  }

  Future<CourseModel> fetchCourse(String courseId) async {
    final res = await _supabase.from('courses').select().eq('id', courseId).single();
    return CourseModel.fromJson(res);
  }

  Future<List<LessonModel>> fetchLessons(String courseId) async {
    final res = await _supabase.from('lessons').select().eq('course_id', courseId).order('sort_order');
    return (res as List).map((row) => LessonModel.fromJson(row)).toList();
  }

  Future<EnrollmentModel?> fetchEnrollment(String userId, String courseId) async {
    final res = await _supabase.from('enrollments').select().eq('user_id', userId).eq('course_id', courseId).maybeSingle();
    if (res == null) return null;
    return EnrollmentModel.fromJson(res);
  }

  Future<void> enroll(String userId, String courseId) async {
    final enrollment = EnrollmentModel(
      id: 'enroll-${userId.hashCode}-${courseId.hashCode}-${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      courseId: courseId,
      progressPercent: 0,
    );
    await _supabase.from('enrollments').insert(enrollment.toJson());
  }

  Future<void> updateProgress(String enrollmentId, int progressPercent) async {
    await _supabase.from('enrollments').update({'progress_percent': progressPercent}).eq('id', enrollmentId);
  }

  Future<void> markCompleted(String enrollmentId) async {
    await _supabase.from('enrollments').update({
      'progress_percent': 100,
      'completed_at': DateTime.now().toIso8601String(),
    }).eq('id', enrollmentId);
  }

  Future<List<QuizQuestion>> fetchQuiz(String lessonId) async {
    final res = await _supabase.from('quiz_questions').select().eq('lesson_id', lessonId);
    return (res as List).map((row) => QuizQuestion.fromJson(row)).toList();
  }

  Future<void> submitQuiz(QuizAttempt attempt) async {
    await _supabase.from('quiz_attempts').insert(attempt.toJson());
  }

  Future<List<EnrollmentModel>> fetchUserEnrollments(String userId) async {
    final res = await _supabase.from('enrollments').select().eq('user_id', userId);
    return (res as List).map((row) => EnrollmentModel.fromJson(row)).toList();
  }
}

final gospelArmyRepositoryProvider = Provider<GospelArmyRepository>((ref) {
  return GospelArmyRepository(ref.watch(supabaseClientProvider));
});
