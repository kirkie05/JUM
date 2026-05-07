class QuizQuestion {
  final String id;
  final String lessonId;
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.id,
    required this.lessonId,
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  QuizQuestion copyWith({
    String? id,
    String? lessonId,
    String? question,
    List<String>? options,
    int? correctIndex,
  }) {
    return QuizQuestion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      question: question ?? this.question,
      options: options ?? this.options,
      correctIndex: correctIndex ?? this.correctIndex,
    );
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as Iterable),
      correctIndex: json['correct_index'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'question': question,
      'options': options,
      'correct_index': correctIndex,
    };
  }
}
