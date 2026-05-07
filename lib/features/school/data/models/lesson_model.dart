class LessonModel {
  final String id;
  final String courseId;
  final String title;
  final String videoUrl;
  final String? pdfUrl;
  final int durationSeconds;
  final int sortOrder;

  const LessonModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.videoUrl,
    this.pdfUrl,
    required this.durationSeconds,
    required this.sortOrder,
  });

  LessonModel copyWith({
    String? id,
    String? courseId,
    String? title,
    String? videoUrl,
    String? pdfUrl,
    int? durationSeconds,
    int? sortOrder,
  }) {
    return LessonModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      videoUrl: videoUrl ?? this.videoUrl,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      title: json['title'] as String,
      videoUrl: json['video_url'] as String,
      pdfUrl: json['pdf_url'] as String?,
      durationSeconds: json['duration_seconds'] as int,
      sortOrder: json['sort_order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'video_url': videoUrl,
      'pdf_url': pdfUrl,
      'duration_seconds': durationSeconds,
      'sort_order': sortOrder,
    };
  }
}
