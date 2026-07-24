class LessonProgressModel {
  final String id;
  final String userId;
  final String lessonId;
  final String courseId;
  final bool completed;
  final DateTime? completedAt;

  const LessonProgressModel({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.courseId,
    this.completed = false,
    this.completedAt,
  });

  factory LessonProgressModel.fromJson(Map<String, dynamic> json) {
    return LessonProgressModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      lessonId: json['lesson_id'] as String,
      courseId: json['course_id'] as String,
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'lesson_id': lessonId,
      'course_id': courseId,
      'completed': completed,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
