class GroupJoinRequestModel {
  final String id;
  final String groupId;
  final String userId;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime requestedAt;
  final DateTime? resolvedAt;

  // Extra profile fields for UI display
  final String? userName;
  final String? userAvatarUrl;

  GroupJoinRequestModel({
    required this.id,
    required this.groupId,
    required this.userId,
    this.status = 'pending',
    required this.requestedAt,
    this.resolvedAt,
    this.userName,
    this.userAvatarUrl,
  });

  factory GroupJoinRequestModel.fromJson(Map<String, dynamic> json) {
    return GroupJoinRequestModel(
      id: json['id'] as String? ?? '',
      groupId: json['group_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      requestedAt: json['requested_at'] != null ? DateTime.parse(json['requested_at'] as String) : DateTime.now(),
      resolvedAt: json['resolved_at'] != null ? DateTime.parse(json['resolved_at'] as String) : null,
      userName: json['profiles']?['name'] as String? ?? json['user_name'] as String?,
      userAvatarUrl: json['profiles']?['avatar_url'] as String? ?? json['user_avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'user_id': userId,
      'status': status,
    };
  }
}
