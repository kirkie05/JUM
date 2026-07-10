class CourseModel {
  final String id;
  final String title;
  final String description;
  final String coverUrl;
  final bool isPublished;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.isPublished,
  });

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? coverUrl,
    bool? isPublished,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      coverUrl: json['cover_url'] as String,
      isPublished: json['is_published'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'cover_url': coverUrl,
      'is_published': isPublished,
    };
  }
}
