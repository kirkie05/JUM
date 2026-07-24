import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/course_model.dart';
import '../models/course_module_model.dart';
import '../models/lesson_model.dart';
import '../models/enrollment_model.dart';
import '../models/quiz_question.dart';
import '../models/quiz_attempt.dart';
import '../models/assignment_model.dart';
import '../models/assignment_submission_model.dart';
import '../models/lesson_progress_model.dart';

class GospelArmyRepository {
  final SupabaseClient _supabase;
  GospelArmyRepository(this._supabase);

  // --- COURSES ---
  Future<List<CourseModel>> fetchCourses() async {
    final res = await _supabase.from('courses').select().eq('is_published', true);
    return (res as List).map((row) => CourseModel.fromJson(row)).toList();
  }

  Future<CourseModel> fetchCourse(String courseId) async {
    final res = await _supabase.from('courses').select().eq('id', courseId).single();
    return CourseModel.fromJson(res);
  }

  // --- MODULES & LESSONS ---
  Future<List<CourseModuleModel>> fetchModules(String courseId) async {
    final res = await _supabase.from('course_modules').select().eq('course_id', courseId).order('order_index');
    return (res as List).map((row) => CourseModuleModel.fromJson(row)).toList();
  }

  Future<List<LessonModel>> fetchLessons(String courseId) async {
    final res = await _supabase.from('lessons').select().eq('course_id', courseId).order('order_index');
    return (res as List).map((row) => LessonModel.fromJson(row)).toList();
  }

  Future<LessonModel> fetchLesson(String lessonId) async {
    final res = await _supabase.from('lessons').select().eq('id', lessonId).single();
    return LessonModel.fromJson(res);
  }

  // --- ENROLLMENTS & PROGRESS ---
  Future<List<EnrollmentModel>> fetchUserEnrollments(String userId) async {
    final res = await _supabase.from('enrollments').select().eq('user_id', userId);
    return (res as List).map((e) => EnrollmentModel.fromJson(e)).toList();
  }

  Future<EnrollmentModel?> fetchEnrollment(String userId, String courseId) async {
    final res = await _supabase.from('enrollments').select().eq('user_id', userId).eq('course_id', courseId).maybeSingle();
    if (res == null) return null;
    return EnrollmentModel.fromJson(res);
  }

  Future<void> enroll(String userId, String courseId) async {
    await _supabase.from('enrollments').insert({
      'user_id': userId,
      'course_id': courseId,
      'progress_percent': 0,
      'total_study_time_mins': 0,
    });
  }

  Future<void> updateProgress(String enrollmentId, int progressPercent, {int? studyTimeMins}) async {
    final updateData = <String, dynamic>{'progress_percent': progressPercent};
    if (studyTimeMins != null) {
      updateData['total_study_time_mins'] = studyTimeMins;
    }
    if (progressPercent == 100) {
      updateData['completed_at'] = DateTime.now().toIso8601String();
    }
    await _supabase.from('enrollments').update(updateData).eq('id', enrollmentId);
  }

  Future<LessonProgressModel?> fetchLessonProgress(String userId, String lessonId) async {
    final res = await _supabase.from('lesson_progress').select().eq('user_id', userId).eq('lesson_id', lessonId).maybeSingle();
    if (res == null) return null;
    return LessonProgressModel.fromJson(res);
  }

  Future<void> markLessonCompleted(String userId, String lessonId, String courseId) async {
    await _supabase.from('lesson_progress').upsert({
      'user_id': userId,
      'lesson_id': lessonId,
      'course_id': courseId,
      'completed': true,
      'completed_at': DateTime.now().toIso8601String(),
    });
  }

  // --- QUIZZES ---
  Future<Map<String, dynamic>?> fetchQuiz(String lessonId) async {
    final res = await _supabase.from('quizzes').select().eq('lesson_id', lessonId).maybeSingle();
    return res; // returns quiz metadata including the questions jsonb
  }

  Future<void> submitQuiz(QuizAttempt attempt) async {
    await _supabase.from('quiz_attempts').insert(attempt.toJson());
  }

  // --- ASSIGNMENTS ---
  Future<AssignmentModel?> fetchAssignment(String lessonId) async {
    final res = await _supabase.from('assignments').select().eq('lesson_id', lessonId).maybeSingle();
    if (res == null) return null;
    return AssignmentModel.fromJson(res);
  }

  Future<AssignmentSubmissionModel?> fetchAssignmentSubmission(String userId, String assignmentId) async {
    final res = await _supabase.from('assignment_submissions').select().eq('user_id', userId).eq('assignment_id', assignmentId).maybeSingle();
    if (res == null) return null;
    return AssignmentSubmissionModel.fromJson(res);
  }

  Future<void> submitAssignment({
    required String assignmentId,
    required String userId,
    String? textContent,
    String? fileUrl,
  }) async {
    await _supabase.from('assignment_submissions').upsert({
      'assignment_id': assignmentId,
      'user_id': userId,
      'text_content': textContent,
      'file_url': fileUrl,
      'status': 'submitted',
      'submitted_at': DateTime.now().toIso8601String(),
    });
  }

  // --- DISCUSSIONS ---
  Future<List<Map<String, dynamic>>> fetchLessonDiscussions(String lessonId) async {
    final res = await _supabase
        .from('lesson_discussions')
        .select('*, profiles(name, avatar_url)')
        .eq('lesson_id', lessonId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res as List);
  }

  Future<void> postDiscussion(String lessonId, String userId, String body) async {
    await _supabase.from('lesson_discussions').insert({
      'lesson_id': lessonId,
      'user_id': userId,
      'body': body,
    });
  }
}

final gospelArmyRepositoryProvider = Provider<GospelArmyRepository>((ref) {
  return GospelArmyRepository(ref.watch(supabaseClientProvider));
});
