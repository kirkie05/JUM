class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String? groupId;
  final String body;
  final DateTime? readAt;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.groupId,
    required this.body,
    this.readAt,
    required this.createdAt,
  });

  bool isFromMe(String currentUserId) => senderId == currentUserId;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String? ?? '',
      senderId: json['sender_id'] as String? ?? json['senderId'] as String? ?? '',
      receiverId: json['receiver_id'] as String? ?? json['receiverId'] as String? ?? '',
      groupId: json['group_id'] as String? ?? json['groupId'] as String?,
      body: json['body'] as String? ?? '',
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : (json['readAt'] != null ? DateTime.parse(json['readAt'] as String) : null),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : (json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'group_id': groupId,
      'body': body,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
