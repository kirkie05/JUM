class AssignmentModel {
  final String id;
  final String lessonId;
  final String title;
  final String? description;
  final String? attachmentUrl;
  
  const AssignmentModel({
    required this.id,
    required this.lessonId,
    required this.title,
    this.description,
    this.attachmentUrl,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      attachmentUrl: json['attachment_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'title': title,
      'description': description,
      'attachment_url': attachmentUrl,
    };
  }
}
