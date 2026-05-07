// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostModel _$PostModelFromJson(Map<String, dynamic> json) => _PostModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  churchId: json['church_id'] as String,
  body: json['body'] as String,
  mediaUrl: json['media_url'] as String?,
  mediaType: json['media_type'] as String?,
  likesCount: (json['likes_count'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  authorName: json['author_name'] as String?,
  authorAvatarUrl: json['author_avatar_url'] as String?,
  isLikedByMe: json['is_liked_by_me'] as bool?,
);

Map<String, dynamic> _$PostModelToJson(_PostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'church_id': instance.churchId,
      'body': instance.body,
      'media_url': instance.mediaUrl,
      'media_type': instance.mediaType,
      'likes_count': instance.likesCount,
      'created_at': instance.createdAt.toIso8601String(),
      'author_name': instance.authorName,
      'author_avatar_url': instance.authorAvatarUrl,
      'is_liked_by_me': instance.isLikedByMe,
    };

_CommentModel _$CommentModelFromJson(Map<String, dynamic> json) =>
    _CommentModel(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      authorName: json['author_name'] as String?,
      authorAvatarUrl: json['author_avatar_url'] as String?,
    );

Map<String, dynamic> _$CommentModelToJson(_CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'post_id': instance.postId,
      'user_id': instance.userId,
      'body': instance.body,
      'created_at': instance.createdAt.toIso8601String(),
      'author_name': instance.authorName,
      'author_avatar_url': instance.authorAvatarUrl,
    };
