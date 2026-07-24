class AssignmentSubmissionModel {
  final String id;
  final String assignmentId;
  final String userId;
  final String? textContent;
  final String? fileUrl;
  final String status;
  final int? grade;
  final String? feedback;
  final DateTime submittedAt;
  final DateTime? gradedAt;

  const AssignmentSubmissionModel({
    required this.id,
    required this.assignmentId,
    required this.userId,
    this.textContent,
    this.fileUrl,
    required this.status,
    this.grade,
    this.feedback,
    required this.submittedAt,
    this.gradedAt,
  });

  factory AssignmentSubmissionModel.fromJson(Map<String, dynamic> json) {
    return AssignmentSubmissionModel(
      id: json['id'] as String,
      assignmentId: json['assignment_id'] as String,
      userId: json['user_id'] as String,
      textContent: json['text_content'] as String?,
      fileUrl: json['file_url'] as String?,
      status: json['status'] as String? ?? 'submitted',
      grade: json['grade'] as int?,
      feedback: json['feedback'] as String?,
      submittedAt: DateTime.parse(json['submitted_at'] as String),
      gradedAt: json['graded_at'] != null ? DateTime.parse(json['graded_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignment_id': assignmentId,
      'user_id': userId,
      'text_content': textContent,
      'file_url': fileUrl,
      'status': status,
      'grade': grade,
      'feedback': feedback,
      'submitted_at': submittedAt.toIso8601String(),
      'graded_at': gradedAt?.toIso8601String(),
    };
  }
}
