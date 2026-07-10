// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sermon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SermonModel _$SermonModelFromJson(Map<String, dynamic> json) => _SermonModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  speaker: json['speaker'] as String,
  mediaUrl: json['media_url'] as String,
  thumbnailUrl: json['thumbnail_url'] as String,
  type: json['type'] as String,
  durationSeconds: (json['duration_seconds'] as num).toInt(),
  publishedAt: DateTime.parse(json['published_at'] as String),
  youtubeVideoId: json['youtube_video_id'] as String?,
);

Map<String, dynamic> _$SermonModelToJson(_SermonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'speaker': instance.speaker,
      'media_url': instance.mediaUrl,
      'thumbnail_url': instance.thumbnailUrl,
      'type': instance.type,
      'duration_seconds': instance.durationSeconds,
      'published_at': instance.publishedAt.toIso8601String(),
      'youtube_video_id': instance.youtubeVideoId,
    };
