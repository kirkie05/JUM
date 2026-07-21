class GroupMemberModel {
  final String id;
  final String groupId;
  final String userId;
  final String role; // 'member', 'leader', 'admin'
  final DateTime joinedAt;
  
  // Extra profile fields for UI display
  final String? userName;
  final String? userAvatarUrl;

  GroupMemberModel({
    required this.id,
    required this.groupId,
    required this.userId,
    this.role = 'member',
    required this.joinedAt,
    this.userName,
    this.userAvatarUrl,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) {
    return GroupMemberModel(
      id: json['id'] as String? ?? '',
      groupId: json['group_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      role: json['role'] as String? ?? 'member',
      joinedAt: json['joined_at'] != null ? DateTime.parse(json['joined_at'] as String) : DateTime.now(),
      userName: json['profiles']?['name'] as String? ?? json['user_name'] as String?,
      userAvatarUrl: json['profiles']?['avatar_url'] as String? ?? json['user_avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'user_id': userId,
      'role': role,
    };
  }
}
