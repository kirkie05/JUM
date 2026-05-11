class EnrollmentModel {
  final String id;
  final String userId;
  final String courseId;
  final int progressPercent;
  final DateTime? completedAt;
  final String? receiptUrl;

  const EnrollmentModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.progressPercent,
    this.completedAt,
    this.receiptUrl,
  });

  EnrollmentModel copyWith({
    String? id,
    String? userId,
    String? courseId,
    int? progressPercent,
    DateTime? completedAt,
    String? receiptUrl,
  }) {
    return EnrollmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      progressPercent: progressPercent ?? this.progressPercent,
      completedAt: completedAt ?? this.completedAt,
      receiptUrl: receiptUrl ?? this.receiptUrl,
    );
  }

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      courseId: json['course_id'] as String,
      progressPercent: json['progress_percent'] as int,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      receiptUrl: json['receipt_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'course_id': courseId,
      'progress_percent': progressPercent,
      'completed_at': completedAt?.toIso8601String(),
      'receipt_url': receiptUrl,
    };
  }
}
