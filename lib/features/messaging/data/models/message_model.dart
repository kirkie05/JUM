import 'message_attachment_model.dart';
import 'message_reaction_model.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String? receiverId;
  final String? conversationId;
  final String? groupId;
  final String body;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final bool isEdited;
  final String? replyToId;
  final String type;
  final Map<String, dynamic>? metadata;
  final List<MessageAttachmentModel> attachments;
  final List<MessageReactionModel> reactions;

  MessageModel({
    required this.id,
    required this.senderId,
    this.receiverId,
    this.conversationId,
    this.groupId,
    required this.body,
    this.readAt,
    required this.createdAt,
    this.deletedAt,
    this.isEdited = false,
    this.replyToId,
    this.type = 'text',
    this.metadata,
    this.attachments = const [],
    this.reactions = const [],
  });

  bool isFromMe(String currentUserId) => senderId == currentUserId;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String? ?? '',
      senderId: json['sender_id'] as String? ?? json['senderId'] as String? ?? '',
      receiverId: json['receiver_id'] as String? ?? json['receiverId'] as String?,
      conversationId: json['conversation_id'] as String? ?? json['conversationId'] as String?,
      groupId: json['group_id'] as String? ?? json['groupId'] as String?,
      body: json['body'] as String? ?? '',
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : (json['readAt'] != null ? DateTime.parse(json['readAt'] as String) : null),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : (json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now()),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : (json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null),
      isEdited: json['is_edited'] as bool? ?? json['isEdited'] as bool? ?? false,
      replyToId: json['reply_to_id'] as String? ?? json['replyToId'] as String?,
      type: json['type'] as String? ?? 'text',
      metadata: json['metadata'] as Map<String, dynamic>?,
      attachments: (json['attachments'] as List<dynamic>?)?.map((e) => MessageAttachmentModel.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      reactions: (json['reactions'] as List<dynamic>?)?.map((e) => MessageReactionModel.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'conversation_id': conversationId,
      'group_id': groupId,
      'body': body,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'is_edited': isEdited,
      'reply_to_id': replyToId,
      'type': type,
      'metadata': metadata,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'reactions': reactions.map((e) => e.toJson()).toList(),
    };
  }
}
