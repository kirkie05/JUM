class MessageAttachmentModel {
  final String id;
  final String messageId;
  final String fileUrl;
  final String fileType;
  final int? fileSize;
  final String? fileName;
  final DateTime createdAt;

  MessageAttachmentModel({
    required this.id,
    required this.messageId,
    required this.fileUrl,
    required this.fileType,
    this.fileSize,
    this.fileName,
    required this.createdAt,
  });

  factory MessageAttachmentModel.fromJson(Map<String, dynamic> json) {
    return MessageAttachmentModel(
      id: json['id'] as String? ?? '',
      messageId: json['message_id'] as String? ?? json['messageId'] as String? ?? '',
      fileUrl: json['file_url'] as String? ?? json['fileUrl'] as String? ?? '',
      fileType: json['file_type'] as String? ?? json['fileType'] as String? ?? 'document',
      fileSize: json['file_size'] as int? ?? json['fileSize'] as int?,
      fileName: json['file_name'] as String? ?? json['fileName'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : (json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message_id': messageId,
      'file_url': fileUrl,
      'file_type': fileType,
      'file_size': fileSize,
      'file_name': fileName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
