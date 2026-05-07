import 'package:freezed_annotation/freezed_annotation.dart';

part 'sermon_model.freezed.dart';
part 'sermon_model.g.dart';

@freezed
abstract class SermonModel with _$SermonModel {
  const factory SermonModel({
    required String id,
    required String churchId,
    required String title,
    required String description,
    required String speaker,
    required String mediaUrl,
    required String thumbnailUrl,
    required String type,
    required int durationSeconds,
    required DateTime publishedAt,
  }) = _SermonModel;

  factory SermonModel.fromJson(Map<String, dynamic> json) =>
      _$SermonModelFromJson(json);
}
