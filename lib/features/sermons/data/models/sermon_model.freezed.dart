// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sermon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SermonModel {

 String get id; String get churchId; String get title; String get description; String get speaker; String get mediaUrl; String get thumbnailUrl; String get type; int get durationSeconds; DateTime get publishedAt;
/// Create a copy of SermonModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SermonModelCopyWith<SermonModel> get copyWith => _$SermonModelCopyWithImpl<SermonModel>(this as SermonModel, _$identity);

  /// Serializes this SermonModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SermonModel&&(identical(other.id, id) || other.id == id)&&(identical(other.churchId, churchId) || other.churchId == churchId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,churchId,title,description,speaker,mediaUrl,thumbnailUrl,type,durationSeconds,publishedAt);

@override
String toString() {
  return 'SermonModel(id: $id, churchId: $churchId, title: $title, description: $description, speaker: $speaker, mediaUrl: $mediaUrl, thumbnailUrl: $thumbnailUrl, type: $type, durationSeconds: $durationSeconds, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class $SermonModelCopyWith<$Res>  {
  factory $SermonModelCopyWith(SermonModel value, $Res Function(SermonModel) _then) = _$SermonModelCopyWithImpl;
@useResult
$Res call({
 String id, String churchId, String title, String description, String speaker, String mediaUrl, String thumbnailUrl, String type, int durationSeconds, DateTime publishedAt
});




}
/// @nodoc
class _$SermonModelCopyWithImpl<$Res>
    implements $SermonModelCopyWith<$Res> {
  _$SermonModelCopyWithImpl(this._self, this._then);

  final SermonModel _self;
  final $Res Function(SermonModel) _then;

/// Create a copy of SermonModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? churchId = null,Object? title = null,Object? description = null,Object? speaker = null,Object? mediaUrl = null,Object? thumbnailUrl = null,Object? type = null,Object? durationSeconds = null,Object? publishedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,churchId: null == churchId ? _self.churchId : churchId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SermonModel].
extension SermonModelPatterns on SermonModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SermonModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SermonModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SermonModel value)  $default,){
final _that = this;
switch (_that) {
case _SermonModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SermonModel value)?  $default,){
final _that = this;
switch (_that) {
case _SermonModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String churchId,  String title,  String description,  String speaker,  String mediaUrl,  String thumbnailUrl,  String type,  int durationSeconds,  DateTime publishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SermonModel() when $default != null:
return $default(_that.id,_that.churchId,_that.title,_that.description,_that.speaker,_that.mediaUrl,_that.thumbnailUrl,_that.type,_that.durationSeconds,_that.publishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String churchId,  String title,  String description,  String speaker,  String mediaUrl,  String thumbnailUrl,  String type,  int durationSeconds,  DateTime publishedAt)  $default,) {final _that = this;
switch (_that) {
case _SermonModel():
return $default(_that.id,_that.churchId,_that.title,_that.description,_that.speaker,_that.mediaUrl,_that.thumbnailUrl,_that.type,_that.durationSeconds,_that.publishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String churchId,  String title,  String description,  String speaker,  String mediaUrl,  String thumbnailUrl,  String type,  int durationSeconds,  DateTime publishedAt)?  $default,) {final _that = this;
switch (_that) {
case _SermonModel() when $default != null:
return $default(_that.id,_that.churchId,_that.title,_that.description,_that.speaker,_that.mediaUrl,_that.thumbnailUrl,_that.type,_that.durationSeconds,_that.publishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SermonModel implements SermonModel {
  const _SermonModel({required this.id, required this.churchId, required this.title, required this.description, required this.speaker, required this.mediaUrl, required this.thumbnailUrl, required this.type, required this.durationSeconds, required this.publishedAt});
  factory _SermonModel.fromJson(Map<String, dynamic> json) => _$SermonModelFromJson(json);

@override final  String id;
@override final  String churchId;
@override final  String title;
@override final  String description;
@override final  String speaker;
@override final  String mediaUrl;
@override final  String thumbnailUrl;
@override final  String type;
@override final  int durationSeconds;
@override final  DateTime publishedAt;

/// Create a copy of SermonModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SermonModelCopyWith<_SermonModel> get copyWith => __$SermonModelCopyWithImpl<_SermonModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SermonModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SermonModel&&(identical(other.id, id) || other.id == id)&&(identical(other.churchId, churchId) || other.churchId == churchId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,churchId,title,description,speaker,mediaUrl,thumbnailUrl,type,durationSeconds,publishedAt);

@override
String toString() {
  return 'SermonModel(id: $id, churchId: $churchId, title: $title, description: $description, speaker: $speaker, mediaUrl: $mediaUrl, thumbnailUrl: $thumbnailUrl, type: $type, durationSeconds: $durationSeconds, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class _$SermonModelCopyWith<$Res> implements $SermonModelCopyWith<$Res> {
  factory _$SermonModelCopyWith(_SermonModel value, $Res Function(_SermonModel) _then) = __$SermonModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String churchId, String title, String description, String speaker, String mediaUrl, String thumbnailUrl, String type, int durationSeconds, DateTime publishedAt
});




}
/// @nodoc
class __$SermonModelCopyWithImpl<$Res>
    implements _$SermonModelCopyWith<$Res> {
  __$SermonModelCopyWithImpl(this._self, this._then);

  final _SermonModel _self;
  final $Res Function(_SermonModel) _then;

/// Create a copy of SermonModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? churchId = null,Object? title = null,Object? description = null,Object? speaker = null,Object? mediaUrl = null,Object? thumbnailUrl = null,Object? type = null,Object? durationSeconds = null,Object? publishedAt = null,}) {
  return _then(_SermonModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,churchId: null == churchId ? _self.churchId : churchId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
