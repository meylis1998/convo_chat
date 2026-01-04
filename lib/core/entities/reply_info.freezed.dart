// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reply_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReplyInfo {

 String get messageId; String get senderId; String get senderName; String? get text; MessageType get type;
/// Create a copy of ReplyInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReplyInfoCopyWith<ReplyInfo> get copyWith => _$ReplyInfoCopyWithImpl<ReplyInfo>(this as ReplyInfo, _$identity);

  /// Serializes this ReplyInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReplyInfo&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.text, text) || other.text == text)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,senderId,senderName,text,type);

@override
String toString() {
  return 'ReplyInfo(messageId: $messageId, senderId: $senderId, senderName: $senderName, text: $text, type: $type)';
}


}

/// @nodoc
abstract mixin class $ReplyInfoCopyWith<$Res>  {
  factory $ReplyInfoCopyWith(ReplyInfo value, $Res Function(ReplyInfo) _then) = _$ReplyInfoCopyWithImpl;
@useResult
$Res call({
 String messageId, String senderId, String senderName, String? text, MessageType type
});




}
/// @nodoc
class _$ReplyInfoCopyWithImpl<$Res>
    implements $ReplyInfoCopyWith<$Res> {
  _$ReplyInfoCopyWithImpl(this._self, this._then);

  final ReplyInfo _self;
  final $Res Function(ReplyInfo) _then;

/// Create a copy of ReplyInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? senderId = null,Object? senderName = null,Object? text = freezed,Object? type = null,}) {
  return _then(_self.copyWith(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,
  ));
}

}


/// Adds pattern-matching-related methods to [ReplyInfo].
extension ReplyInfoPatterns on ReplyInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReplyInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReplyInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReplyInfo value)  $default,){
final _that = this;
switch (_that) {
case _ReplyInfo():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReplyInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ReplyInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String messageId,  String senderId,  String senderName,  String? text,  MessageType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReplyInfo() when $default != null:
return $default(_that.messageId,_that.senderId,_that.senderName,_that.text,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String messageId,  String senderId,  String senderName,  String? text,  MessageType type)  $default,) {final _that = this;
switch (_that) {
case _ReplyInfo():
return $default(_that.messageId,_that.senderId,_that.senderName,_that.text,_that.type);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String messageId,  String senderId,  String senderName,  String? text,  MessageType type)?  $default,) {final _that = this;
switch (_that) {
case _ReplyInfo() when $default != null:
return $default(_that.messageId,_that.senderId,_that.senderName,_that.text,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReplyInfo implements ReplyInfo {
  const _ReplyInfo({required this.messageId, required this.senderId, required this.senderName, this.text, required this.type});
  factory _ReplyInfo.fromJson(Map<String, dynamic> json) => _$ReplyInfoFromJson(json);

@override final  String messageId;
@override final  String senderId;
@override final  String senderName;
@override final  String? text;
@override final  MessageType type;

/// Create a copy of ReplyInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReplyInfoCopyWith<_ReplyInfo> get copyWith => __$ReplyInfoCopyWithImpl<_ReplyInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReplyInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReplyInfo&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.text, text) || other.text == text)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,senderId,senderName,text,type);

@override
String toString() {
  return 'ReplyInfo(messageId: $messageId, senderId: $senderId, senderName: $senderName, text: $text, type: $type)';
}


}

/// @nodoc
abstract mixin class _$ReplyInfoCopyWith<$Res> implements $ReplyInfoCopyWith<$Res> {
  factory _$ReplyInfoCopyWith(_ReplyInfo value, $Res Function(_ReplyInfo) _then) = __$ReplyInfoCopyWithImpl;
@override @useResult
$Res call({
 String messageId, String senderId, String senderName, String? text, MessageType type
});




}
/// @nodoc
class __$ReplyInfoCopyWithImpl<$Res>
    implements _$ReplyInfoCopyWith<$Res> {
  __$ReplyInfoCopyWithImpl(this._self, this._then);

  final _ReplyInfo _self;
  final $Res Function(_ReplyInfo) _then;

/// Create a copy of ReplyInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? senderId = null,Object? senderName = null,Object? text = freezed,Object? type = null,}) {
  return _then(_ReplyInfo(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,
  ));
}


}

// dart format on
