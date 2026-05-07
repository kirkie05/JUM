import 'package:freezed_annotation/freezed_annotation.dart';

part 'stream_model.freezed.dart';
part 'stream_model.g.dart';

@freezed
abstract class LiveStreamModel with _$LiveStreamModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LiveStreamModel({
    required String id,
    required String churchId,
    required String muxStreamId,
    required String muxPlaybackId,
    required String title,
    required String status,
    required DateTime scheduledAt,
  }) = _LiveStreamModel;

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) =>
      _$LiveStreamModelFromJson(json);
}

@freezed
abstract class StreamMessage with _$StreamMessage {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory StreamMessage({
    required String id,
    required String streamId,
    required String userId,
    required String userName,
    String? userAvatarUrl,
    required String body,
    required DateTime createdAt,
  }) = _StreamMessage;

  factory StreamMessage.fromJson(Map<String, dynamic> json) =>
      _$StreamMessageFromJson(json);
}
