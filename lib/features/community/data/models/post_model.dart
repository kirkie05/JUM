import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class PostModel with _$PostModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PostModel({
    required String id,
    required String userId,
    required String churchId,
    required String body,
    String? mediaUrl,
    String? mediaType,
    required int likesCount,
    required DateTime createdAt,
    String? authorName,
    String? authorAvatarUrl,
    bool? isLikedByMe,
  }) = _PostModel;
  
  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
}

@freezed
abstract class CommentModel with _$CommentModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CommentModel({
    required String id,
    required String postId,
    required String userId,
    required String body,
    required DateTime createdAt,
    String? authorName,
    String? authorAvatarUrl,
  }) = _CommentModel;
  
  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
}
