class ConversationModel {
  final String id;
  final String? name;
  final bool isGroup;
  final bool isAnnouncement;
  final bool isLocked;
  final DateTime createdAt;
  final DateTime updatedAt;

  ConversationModel({
    required this.id,
    this.name,
    required this.isGroup,
    this.isAnnouncement = false,
    this.isLocked = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String?,
      isGroup: json['is_group'] as bool? ?? json['isGroup'] as bool? ?? false,
      isAnnouncement: json['is_announcement'] as bool? ?? json['isAnnouncement'] as bool? ?? false,
      isLocked: json['is_locked'] as bool? ?? json['isLocked'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : (json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now()),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : (json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_group': isGroup,
      'is_announcement': isAnnouncement,
      'is_locked': isLocked,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
