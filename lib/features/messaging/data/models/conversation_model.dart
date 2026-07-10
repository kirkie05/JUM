class ConversationModel {
  final String id;
  final String? name;
  final bool isGroup;
  final DateTime createdAt;

  ConversationModel({
    required this.id,
    this.name,
    required this.isGroup,
    required this.createdAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String?,
      isGroup: json['is_group'] as bool? ?? json['isGroup'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : (json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_group': isGroup,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
