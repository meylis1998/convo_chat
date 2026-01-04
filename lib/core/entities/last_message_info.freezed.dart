// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'last_message_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LastMessageInfo {

 String get id; String get text; String get senderId; String get senderName; MessageType get type; DateTime get timestamp;
/// Create a copy of LastMessageInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LastMessageInfoCopyWith<LastMessageInfo> get copyWith => _$LastMessageInfoCopyWithImpl<LastMessageInfo>(this as LastMessageInfo, _$identity);

  /// Serializes this LastMessageInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LastMessageInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.type, type) || other.type == type)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,senderId,senderName,type,timestamp);

@override
String toString() {
  return 'LastMessageInfo(id: $id, text: $text, senderId: $senderId, senderName: $senderName, type: $type, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $LastMessageInfoCopyWith<$Res>  {
  factory $LastMessageInfoCopyWith(LastMessageInfo value, $Res Function(LastMessageInfo) _then) = _$LastMessageInfoCopyWithImpl;
@useResult
$Res call({
 String id, String text, String senderId, String senderName, MessageType type, DateTime timestamp
});




}
/// @nodoc
class _$LastMessageInfoCopyWithImpl<$Res>
    implements $LastMessageInfoCopyWith<$Res> {
  _$LastMessageInfoCopyWithImpl(this._self, this._then);

  final LastMessageInfo _self;
  final $Res Function(LastMessageInfo) _then;

/// Create a copy of LastMessageInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? senderId = null,Object? senderName = null,Object? type = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LastMessageInfo].
extension LastMessageInfoPatterns on LastMessageInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LastMessageInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LastMessageInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LastMessageInfo value)  $default,){
final _that = this;
switch (_that) {
case _LastMessageInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LastMessageInfo value)?  $default,){
final _that = this;
switch (_that) {
case _LastMessageInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  String senderId,  String senderName,  MessageType type,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LastMessageInfo() when $default != null:
return $default(_that.id,_that.text,_that.senderId,_that.senderName,_that.type,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  String senderId,  String senderName,  MessageType type,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _LastMessageInfo():
return $default(_that.id,_that.text,_that.senderId,_that.senderName,_that.type,_that.timestamp);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  String senderId,  String senderName,  MessageType type,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _LastMessageInfo() when $default != null:
return $default(_that.id,_that.text,_that.senderId,_that.senderName,_that.type,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LastMessageInfo extends LastMessageInfo {
  const _LastMessageInfo({required this.id, required this.text, required this.senderId, required this.senderName, required this.type, required this.timestamp}): super._();
  factory _LastMessageInfo.fromJson(Map<String, dynamic> json) => _$LastMessageInfoFromJson(json);

@override final  String id;
@override final  String text;
@override final  String senderId;
@override final  String senderName;
@override final  MessageType type;
@override final  DateTime timestamp;

/// Create a copy of LastMessageInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LastMessageInfoCopyWith<_LastMessageInfo> get copyWith => __$LastMessageInfoCopyWithImpl<_LastMessageInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LastMessageInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LastMessageInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.type, type) || other.type == type)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,senderId,senderName,type,timestamp);

@override
String toString() {
  return 'LastMessageInfo(id: $id, text: $text, senderId: $senderId, senderName: $senderName, type: $type, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$LastMessageInfoCopyWith<$Res> implements $LastMessageInfoCopyWith<$Res> {
  factory _$LastMessageInfoCopyWith(_LastMessageInfo value, $Res Function(_LastMessageInfo) _then) = __$LastMessageInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, String senderId, String senderName, MessageType type, DateTime timestamp
});




}
/// @nodoc
class __$LastMessageInfoCopyWithImpl<$Res>
    implements _$LastMessageInfoCopyWith<$Res> {
  __$LastMessageInfoCopyWithImpl(this._self, this._then);

  final _LastMessageInfo _self;
  final $Res Function(_LastMessageInfo) _then;

/// Create a copy of LastMessageInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? senderId = null,Object? senderName = null,Object? type = null,Object? timestamp = null,}) {
  return _then(_LastMessageInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
