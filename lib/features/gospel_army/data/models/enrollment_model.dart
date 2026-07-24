class EnrollmentModel {
  final String id;
  final String userId;
  final String courseId;
  final int progressPercent;
  final DateTime? completedAt;
  final DateTime createdAt;
  final int? totalStudyTimeMins;

  const EnrollmentModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.progressPercent,
    this.completedAt,
    required this.createdAt,
    this.totalStudyTimeMins,
  });

  EnrollmentModel copyWith({
    String? id,
    String? userId,
    String? courseId,
    int? progressPercent,
    DateTime? completedAt,
    DateTime? createdAt,
    int? totalStudyTimeMins,
  }) {
    return EnrollmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      progressPercent: progressPercent ?? this.progressPercent,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      totalStudyTimeMins: totalStudyTimeMins ?? this.totalStudyTimeMins,
    );
  }

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      courseId: json['course_id'] as String,
      progressPercent: json['progress_percent'] as int? ?? 0,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      totalStudyTimeMins: json['total_study_time_mins'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'course_id': courseId,
      'progress_percent': progressPercent,
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'total_study_time_mins': totalStudyTimeMins,
    };
  }
}
