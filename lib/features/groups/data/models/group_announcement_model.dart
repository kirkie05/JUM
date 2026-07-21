class GroupAnnouncementModel {
  final String id;
  final String groupId;
  final String authorId;
  final String title;
  final String content;
  final DateTime createdAt;

  // Extra profile fields for UI display
  final String? authorName;
  final String? authorAvatarUrl;

  GroupAnnouncementModel({
    required this.id,
    required this.groupId,
    required this.authorId,
    required this.title,
    required this.content,
    required this.createdAt,
    this.authorName,
    this.authorAvatarUrl,
  });

  factory GroupAnnouncementModel.fromJson(Map<String, dynamic> json) {
    return GroupAnnouncementModel(
      id: json['id'] as String? ?? '',
      groupId: json['group_id'] as String? ?? '',
      authorId: json['author_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
      authorName: json['profiles']?['name'] as String? ?? json['author_name'] as String?,
      authorAvatarUrl: json['profiles']?['avatar_url'] as String? ?? json['author_avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'author_id': authorId,
      'title': title,
      'content': content,
    };
  }
}
