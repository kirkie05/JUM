class CourseModel {
  final String id;
  final String title;
  final String? description;
  final String? coverUrl;
  final bool isPublished;
  final String? categoryId;
  final String? instructorId;
  final String? difficultyLevel;
  final int? estimatedDurationMins;
  final List<String> prerequisites;
  final bool certificateOffered;

  const CourseModel({
    required this.id,
    required this.title,
    this.description,
    this.coverUrl,
    required this.isPublished,
    this.categoryId,
    this.instructorId,
    this.difficultyLevel,
    this.estimatedDurationMins,
    this.prerequisites = const [],
    this.certificateOffered = true,
  });

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? coverUrl,
    bool? isPublished,
    String? categoryId,
    String? instructorId,
    String? difficultyLevel,
    int? estimatedDurationMins,
    List<String>? prerequisites,
    bool? certificateOffered,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      isPublished: isPublished ?? this.isPublished,
      categoryId: categoryId ?? this.categoryId,
      instructorId: instructorId ?? this.instructorId,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      estimatedDurationMins: estimatedDurationMins ?? this.estimatedDurationMins,
      prerequisites: prerequisites ?? this.prerequisites,
      certificateOffered: certificateOffered ?? this.certificateOffered,
    );
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      coverUrl: json['thumbnail_url'] as String?,
      isPublished: json['is_published'] as bool? ?? false,
      categoryId: json['category_id'] as String?,
      instructorId: json['instructor_id'] as String?,
      difficultyLevel: json['difficulty_level'] as String?,
      estimatedDurationMins: json['estimated_duration_mins'] as int?,
      prerequisites: (json['prerequisites'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      certificateOffered: json['certificate_offered'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail_url': coverUrl,
      'is_published': isPublished,
      'category_id': categoryId,
      'instructor_id': instructorId,
      'difficulty_level': difficultyLevel,
      'estimated_duration_mins': estimatedDurationMins,
      'prerequisites': prerequisites,
      'certificate_offered': certificateOffered,
    };
  }
}
