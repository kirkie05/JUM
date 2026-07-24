class LessonModel {
  final String id;
  final String courseId;
  final String? moduleId;
  final String title;
  final String? content;
  final String? videoUrl;
  final String? audioUrl;
  final String? pdfUrl;
  final int orderIndex;
  final bool isFreePreview;
  final bool requiresPrevious;

  const LessonModel({
    required this.id,
    required this.courseId,
    this.moduleId,
    required this.title,
    this.content,
    this.videoUrl,
    this.audioUrl,
    this.pdfUrl,
    required this.orderIndex,
    this.isFreePreview = false,
    this.requiresPrevious = true,
  });

  LessonModel copyWith({
    String? id,
    String? courseId,
    String? moduleId,
    String? title,
    String? content,
    String? videoUrl,
    String? audioUrl,
    String? pdfUrl,
    int? orderIndex,
    bool? isFreePreview,
    bool? requiresPrevious,
  }) {
    return LessonModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      content: content ?? this.content,
      videoUrl: videoUrl ?? this.videoUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      orderIndex: orderIndex ?? this.orderIndex,
      isFreePreview: isFreePreview ?? this.isFreePreview,
      requiresPrevious: requiresPrevious ?? this.requiresPrevious,
    );
  }

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      moduleId: json['module_id'] as String?,
      title: json['title'] as String,
      content: json['content'] as String?,
      videoUrl: json['video_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      pdfUrl: json['pdf_url'] as String?,
      orderIndex: json['order_index'] as int? ?? 0,
      isFreePreview: json['is_free_preview'] as bool? ?? false,
      requiresPrevious: json['requires_previous'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'module_id': moduleId,
      'title': title,
      'content': content,
      'video_url': videoUrl,
      'audio_url': audioUrl,
      'pdf_url': pdfUrl,
      'order_index': orderIndex,
      'is_free_preview': isFreePreview,
      'requires_previous': requiresPrevious,
    };
  }
}
