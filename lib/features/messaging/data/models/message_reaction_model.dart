class MessageReactionModel {
  final String id;
  final String messageId;
  final String userId;
  final String emoji;
  final DateTime createdAt;

  MessageReactionModel({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.emoji,
    required this.createdAt,
  });

  factory MessageReactionModel.fromJson(Map<String, dynamic> json) {
    return MessageReactionModel(
      id: json['id'] as String? ?? '',
      messageId: json['message_id'] as String? ?? json['messageId'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : (json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message_id': messageId,
      'user_id': userId,
      'emoji': emoji,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
