class CourseModuleModel {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final int orderIndex;
  
  const CourseModuleModel({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.orderIndex,
  });

  factory CourseModuleModel.fromJson(Map<String, dynamic> json) {
    return CourseModuleModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      orderIndex: json['order_index'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'order_index': orderIndex,
    };
  }
}
