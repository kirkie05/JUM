class QuizAttempt {
  final String id;
  final String userId;
  final String lessonId;
  final int score;
  final DateTime submittedAt;

  const QuizAttempt({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.score,
    required this.submittedAt,
  });

  QuizAttempt copyWith({
    String? id,
    String? userId,
    String? lessonId,
    int? score,
    DateTime? submittedAt,
  }) {
    return QuizAttempt(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      lessonId: lessonId ?? this.lessonId,
      score: score ?? this.score,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      lessonId: json['lesson_id'] as String,
      score: json['score'] as int,
      submittedAt: DateTime.parse(json['submitted_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'lesson_id': lessonId,
      'score': score,
      'submitted_at': submittedAt.toIso8601String(),
    };
  }
}
