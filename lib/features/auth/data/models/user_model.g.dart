// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  name: json['name'] as String,
  firstName: json['first_name'] as String?,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  role: json['role'] as String,
  avatarUrl: json['avatar_url'] as String?,
  bio: json['bio'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'first_name': instance.firstName,
      'email': instance.email,
      'phone': instance.phone,
      'role': instance.role,
      'avatar_url': instance.avatarUrl,
      'bio': instance.bio,
      'created_at': instance.createdAt.toIso8601String(),
    };
