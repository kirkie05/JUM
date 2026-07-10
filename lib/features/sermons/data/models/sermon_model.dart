import 'package:freezed_annotation/freezed_annotation.dart';

part 'sermon_model.freezed.dart';
part 'sermon_model.g.dart';

@freezed
abstract class SermonModel with _$SermonModel {
  const factory SermonModel({
    required String id,
    required String title,
    required String description,
    required String speaker,
    @JsonKey(name: 'media_url') required String mediaUrl,
    @JsonKey(name: 'thumbnail_url') required String thumbnailUrl,
    required String type,
    @JsonKey(name: 'duration_seconds') required int durationSeconds,
    @JsonKey(name: 'published_at') required DateTime publishedAt,
    @JsonKey(name: 'youtube_video_id') String? youtubeVideoId,
  }) = _SermonModel;

  factory SermonModel.fromJson(Map<String, dynamic> json) =>
      _$SermonModelFromJson(json);
}
