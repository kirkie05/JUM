// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LiveStreamModel _$LiveStreamModelFromJson(Map<String, dynamic> json) =>
    _LiveStreamModel(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      muxStreamId: json['mux_stream_id'] as String,
      muxPlaybackId: json['mux_playback_id'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
    );

Map<String, dynamic> _$LiveStreamModelToJson(_LiveStreamModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'mux_stream_id': instance.muxStreamId,
      'mux_playback_id': instance.muxPlaybackId,
      'title': instance.title,
      'status': instance.status,
      'scheduled_at': instance.scheduledAt.toIso8601String(),
    };

_StreamMessage _$StreamMessageFromJson(Map<String, dynamic> json) =>
    _StreamMessage(
      id: json['id'] as String,
      streamId: json['stream_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      userAvatarUrl: json['user_avatar_url'] as String?,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$StreamMessageToJson(_StreamMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stream_id': instance.streamId,
      'user_id': instance.userId,
      'user_name': instance.userName,
      'user_avatar_url': instance.userAvatarUrl,
      'body': instance.body,
      'created_at': instance.createdAt.toIso8601String(),
    };
