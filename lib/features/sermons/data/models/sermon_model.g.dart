// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sermon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SermonModel _$SermonModelFromJson(Map<String, dynamic> json) => _SermonModel(
  id: json['id'] as String,
  churchId: json['churchId'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  speaker: json['speaker'] as String,
  mediaUrl: json['mediaUrl'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String,
  type: json['type'] as String,
  durationSeconds: (json['durationSeconds'] as num).toInt(),
  publishedAt: DateTime.parse(json['publishedAt'] as String),
);

Map<String, dynamic> _$SermonModelToJson(_SermonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'churchId': instance.churchId,
      'title': instance.title,
      'description': instance.description,
      'speaker': instance.speaker,
      'mediaUrl': instance.mediaUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'type': instance.type,
      'durationSeconds': instance.durationSeconds,
      'publishedAt': instance.publishedAt.toIso8601String(),
    };
