class MediaNoteModel {
  final String id;
  final String userId;
  final String videoId;
  final int timestampSeconds;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  MediaNoteModel({
    required this.id,
    required this.userId,
    required this.videoId,
    required this.timestampSeconds,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MediaNoteModel.fromJson(Map<String, dynamic> json) {
    final createdStr = json['created_at'] as String? ?? json['createdAt'] as String?;
    final updatedStr = json['updated_at'] as String? ?? json['updatedAt'] as String?;
    
    final created = createdStr != null ? DateTime.parse(createdStr) : DateTime.now();
    final updated = updatedStr != null ? DateTime.parse(updatedStr) : created;

    return MediaNoteModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      videoId: json['video_id'] as String? ?? json['videoId'] as String? ?? '',
      timestampSeconds: json['timestamp_seconds'] as int? ?? json['timestampSeconds'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      createdAt: created,
      updatedAt: updated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'video_id': videoId,
      'timestamp_seconds': timestampSeconds,
      'text': text,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  MediaNoteModel copyWith({
    String? id,
    String? userId,
    String? videoId,
    int? timestampSeconds,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MediaNoteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      videoId: videoId ?? this.videoId,
      timestampSeconds: timestampSeconds ?? this.timestampSeconds,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
