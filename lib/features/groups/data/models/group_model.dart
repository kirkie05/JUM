class GroupModel {
  final String id;
  final String name;
  final String? description;
  final String? bannerUrl;
  final String? leaderId;
  final String visibility; // 'open' or 'private'
  final bool isActive;
  final int? maxMembers;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Extra fields for UI convenience
  final int? memberCount;
  final String? leaderName;

  GroupModel({
    required this.id,
    required this.name,
    this.description,
    this.bannerUrl,
    this.leaderId,
    this.visibility = 'open',
    this.isActive = true,
    this.maxMembers,
    required this.createdAt,
    required this.updatedAt,
    this.memberCount,
    this.leaderName,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      bannerUrl: json['banner_url'] as String?,
      leaderId: json['leader_id'] as String?,
      visibility: json['visibility'] as String? ?? 'open',
      isActive: json['is_active'] as bool? ?? true,
      maxMembers: json['max_members'] as int?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : DateTime.now(),
      memberCount: json['member_count'] as int?,
      leaderName: json['leader_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'banner_url': bannerUrl,
      'leader_id': leaderId,
      'visibility': visibility,
      'is_active': isActive,
      'max_members': maxMembers,
    };
  }

  GroupModel copyWith({
    String? id,
    String? name,
    String? description,
    String? bannerUrl,
    String? leaderId,
    String? visibility,
    bool? isActive,
    int? maxMembers,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? memberCount,
    String? leaderName,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      leaderId: leaderId ?? this.leaderId,
      visibility: visibility ?? this.visibility,
      isActive: isActive ?? this.isActive,
      maxMembers: maxMembers ?? this.maxMembers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      memberCount: memberCount ?? this.memberCount,
      leaderName: leaderName ?? this.leaderName,
    );
  }
}
