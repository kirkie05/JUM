// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stream_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LiveStreamModel {

 String get id; String get churchId; String get muxStreamId; String get muxPlaybackId; String get title; String get status; DateTime get scheduledAt;
/// Create a copy of LiveStreamModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveStreamModelCopyWith<LiveStreamModel> get copyWith => _$LiveStreamModelCopyWithImpl<LiveStreamModel>(this as LiveStreamModel, _$identity);

  /// Serializes this LiveStreamModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveStreamModel&&(identical(other.id, id) || other.id == id)&&(identical(other.churchId, churchId) || other.churchId == churchId)&&(identical(other.muxStreamId, muxStreamId) || other.muxStreamId == muxStreamId)&&(identical(other.muxPlaybackId, muxPlaybackId) || other.muxPlaybackId == muxPlaybackId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,churchId,muxStreamId,muxPlaybackId,title,status,scheduledAt);

@override
String toString() {
  return 'LiveStreamModel(id: $id, churchId: $churchId, muxStreamId: $muxStreamId, muxPlaybackId: $muxPlaybackId, title: $title, status: $status, scheduledAt: $scheduledAt)';
}


}

/// @nodoc
abstract mixin class $LiveStreamModelCopyWith<$Res>  {
  factory $LiveStreamModelCopyWith(LiveStreamModel value, $Res Function(LiveStreamModel) _then) = _$LiveStreamModelCopyWithImpl;
@useResult
$Res call({
 String id, String churchId, String muxStreamId, String muxPlaybackId, String title, String status, DateTime scheduledAt
});




}
/// @nodoc
class _$LiveStreamModelCopyWithImpl<$Res>
    implements $LiveStreamModelCopyWith<$Res> {
  _$LiveStreamModelCopyWithImpl(this._self, this._then);

  final LiveStreamModel _self;
  final $Res Function(LiveStreamModel) _then;

/// Create a copy of LiveStreamModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? churchId = null,Object? muxStreamId = null,Object? muxPlaybackId = null,Object? title = null,Object? status = null,Object? scheduledAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,churchId: null == churchId ? _self.churchId : churchId // ignore: cast_nullable_to_non_nullable
as String,muxStreamId: null == muxStreamId ? _self.muxStreamId : muxStreamId // ignore: cast_nullable_to_non_nullable
as String,muxPlaybackId: null == muxPlaybackId ? _self.muxPlaybackId : muxPlaybackId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LiveStreamModel].
extension LiveStreamModelPatterns on LiveStreamModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveStreamModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveStreamModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveStreamModel value)  $default,){
final _that = this;
switch (_that) {
case _LiveStreamModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveStreamModel value)?  $default,){
final _that = this;
switch (_that) {
case _LiveStreamModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String churchId,  String muxStreamId,  String muxPlaybackId,  String title,  String status,  DateTime scheduledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveStreamModel() when $default != null:
return $default(_that.id,_that.churchId,_that.muxStreamId,_that.muxPlaybackId,_that.title,_that.status,_that.scheduledAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String churchId,  String muxStreamId,  String muxPlaybackId,  String title,  String status,  DateTime scheduledAt)  $default,) {final _that = this;
switch (_that) {
case _LiveStreamModel():
return $default(_that.id,_that.churchId,_that.muxStreamId,_that.muxPlaybackId,_that.title,_that.status,_that.scheduledAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String churchId,  String muxStreamId,  String muxPlaybackId,  String title,  String status,  DateTime scheduledAt)?  $default,) {final _that = this;
switch (_that) {
case _LiveStreamModel() when $default != null:
return $default(_that.id,_that.churchId,_that.muxStreamId,_that.muxPlaybackId,_that.title,_that.status,_that.scheduledAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _LiveStreamModel implements LiveStreamModel {
  const _LiveStreamModel({required this.id, required this.churchId, required this.muxStreamId, required this.muxPlaybackId, required this.title, required this.status, required this.scheduledAt});
  factory _LiveStreamModel.fromJson(Map<String, dynamic> json) => _$LiveStreamModelFromJson(json);

@override final  String id;
@override final  String churchId;
@override final  String muxStreamId;
@override final  String muxPlaybackId;
@override final  String title;
@override final  String status;
@override final  DateTime scheduledAt;

/// Create a copy of LiveStreamModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveStreamModelCopyWith<_LiveStreamModel> get copyWith => __$LiveStreamModelCopyWithImpl<_LiveStreamModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LiveStreamModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveStreamModel&&(identical(other.id, id) || other.id == id)&&(identical(other.churchId, churchId) || other.churchId == churchId)&&(identical(other.muxStreamId, muxStreamId) || other.muxStreamId == muxStreamId)&&(identical(other.muxPlaybackId, muxPlaybackId) || other.muxPlaybackId == muxPlaybackId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,churchId,muxStreamId,muxPlaybackId,title,status,scheduledAt);

@override
String toString() {
  return 'LiveStreamModel(id: $id, churchId: $churchId, muxStreamId: $muxStreamId, muxPlaybackId: $muxPlaybackId, title: $title, status: $status, scheduledAt: $scheduledAt)';
}


}

/// @nodoc
abstract mixin class _$LiveStreamModelCopyWith<$Res> implements $LiveStreamModelCopyWith<$Res> {
  factory _$LiveStreamModelCopyWith(_LiveStreamModel value, $Res Function(_LiveStreamModel) _then) = __$LiveStreamModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String churchId, String muxStreamId, String muxPlaybackId, String title, String status, DateTime scheduledAt
});




}
/// @nodoc
class __$LiveStreamModelCopyWithImpl<$Res>
    implements _$LiveStreamModelCopyWith<$Res> {
  __$LiveStreamModelCopyWithImpl(this._self, this._then);

  final _LiveStreamModel _self;
  final $Res Function(_LiveStreamModel) _then;

/// Create a copy of LiveStreamModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? churchId = null,Object? muxStreamId = null,Object? muxPlaybackId = null,Object? title = null,Object? status = null,Object? scheduledAt = null,}) {
  return _then(_LiveStreamModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,churchId: null == churchId ? _self.churchId : churchId // ignore: cast_nullable_to_non_nullable
as String,muxStreamId: null == muxStreamId ? _self.muxStreamId : muxStreamId // ignore: cast_nullable_to_non_nullable
as String,muxPlaybackId: null == muxPlaybackId ? _self.muxPlaybackId : muxPlaybackId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$StreamMessage {

 String get id; String get streamId; String get userId; String get userName; String? get userAvatarUrl; String get body; DateTime get createdAt;
/// Create a copy of StreamMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreamMessageCopyWith<StreamMessage> get copyWith => _$StreamMessageCopyWithImpl<StreamMessage>(this as StreamMessage, _$identity);

  /// Serializes this StreamMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreamMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.streamId, streamId) || other.streamId == streamId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatarUrl, userAvatarUrl) || other.userAvatarUrl == userAvatarUrl)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,streamId,userId,userName,userAvatarUrl,body,createdAt);

@override
String toString() {
  return 'StreamMessage(id: $id, streamId: $streamId, userId: $userId, userName: $userName, userAvatarUrl: $userAvatarUrl, body: $body, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StreamMessageCopyWith<$Res>  {
  factory $StreamMessageCopyWith(StreamMessage value, $Res Function(StreamMessage) _then) = _$StreamMessageCopyWithImpl;
@useResult
$Res call({
 String id, String streamId, String userId, String userName, String? userAvatarUrl, String body, DateTime createdAt
});




}
/// @nodoc
class _$StreamMessageCopyWithImpl<$Res>
    implements $StreamMessageCopyWith<$Res> {
  _$StreamMessageCopyWithImpl(this._self, this._then);

  final StreamMessage _self;
  final $Res Function(StreamMessage) _then;

/// Create a copy of StreamMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? streamId = null,Object? userId = null,Object? userName = null,Object? userAvatarUrl = freezed,Object? body = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,streamId: null == streamId ? _self.streamId : streamId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userAvatarUrl: freezed == userAvatarUrl ? _self.userAvatarUrl : userAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StreamMessage].
extension StreamMessagePatterns on StreamMessage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreamMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreamMessage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreamMessage value)  $default,){
final _that = this;
switch (_that) {
case _StreamMessage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreamMessage value)?  $default,){
final _that = this;
switch (_that) {
case _StreamMessage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String streamId,  String userId,  String userName,  String? userAvatarUrl,  String body,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreamMessage() when $default != null:
return $default(_that.id,_that.streamId,_that.userId,_that.userName,_that.userAvatarUrl,_that.body,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String streamId,  String userId,  String userName,  String? userAvatarUrl,  String body,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _StreamMessage():
return $default(_that.id,_that.streamId,_that.userId,_that.userName,_that.userAvatarUrl,_that.body,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String streamId,  String userId,  String userName,  String? userAvatarUrl,  String body,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StreamMessage() when $default != null:
return $default(_that.id,_that.streamId,_that.userId,_that.userName,_that.userAvatarUrl,_that.body,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _StreamMessage implements StreamMessage {
  const _StreamMessage({required this.id, required this.streamId, required this.userId, required this.userName, this.userAvatarUrl, required this.body, required this.createdAt});
  factory _StreamMessage.fromJson(Map<String, dynamic> json) => _$StreamMessageFromJson(json);

@override final  String id;
@override final  String streamId;
@override final  String userId;
@override final  String userName;
@override final  String? userAvatarUrl;
@override final  String body;
@override final  DateTime createdAt;

/// Create a copy of StreamMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreamMessageCopyWith<_StreamMessage> get copyWith => __$StreamMessageCopyWithImpl<_StreamMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StreamMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreamMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.streamId, streamId) || other.streamId == streamId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatarUrl, userAvatarUrl) || other.userAvatarUrl == userAvatarUrl)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,streamId,userId,userName,userAvatarUrl,body,createdAt);

@override
String toString() {
  return 'StreamMessage(id: $id, streamId: $streamId, userId: $userId, userName: $userName, userAvatarUrl: $userAvatarUrl, body: $body, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StreamMessageCopyWith<$Res> implements $StreamMessageCopyWith<$Res> {
  factory _$StreamMessageCopyWith(_StreamMessage value, $Res Function(_StreamMessage) _then) = __$StreamMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String streamId, String userId, String userName, String? userAvatarUrl, String body, DateTime createdAt
});




}
/// @nodoc
class __$StreamMessageCopyWithImpl<$Res>
    implements _$StreamMessageCopyWith<$Res> {
  __$StreamMessageCopyWithImpl(this._self, this._then);

  final _StreamMessage _self;
  final $Res Function(_StreamMessage) _then;

/// Create a copy of StreamMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? streamId = null,Object? userId = null,Object? userName = null,Object? userAvatarUrl = freezed,Object? body = null,Object? createdAt = null,}) {
  return _then(_StreamMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,streamId: null == streamId ? _self.streamId : streamId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userAvatarUrl: freezed == userAvatarUrl ? _self.userAvatarUrl : userAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
