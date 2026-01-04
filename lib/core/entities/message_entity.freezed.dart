// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageEntity {

 String get id; String get conversationId; String get senderId; String get senderName; String? get senderPhotoUrl; MessageType get type; MessageContent get content; ReplyInfo? get replyTo; Map<String, List<String>> get reactions; Map<String, DateTime> get readBy; Map<String, DateTime> get deliveredTo; DateTime get createdAt; DateTime? get editedAt; DateTime? get deletedAt; bool get isDeleted; MessageStatus get status;
/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageEntityCopyWith<MessageEntity> get copyWith => _$MessageEntityCopyWithImpl<MessageEntity>(this as MessageEntity, _$identity);

  /// Serializes this MessageEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.senderPhotoUrl, senderPhotoUrl) || other.senderPhotoUrl == senderPhotoUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.content, content) || other.content == content)&&(identical(other.replyTo, replyTo) || other.replyTo == replyTo)&&const DeepCollectionEquality().equals(other.reactions, reactions)&&const DeepCollectionEquality().equals(other.readBy, readBy)&&const DeepCollectionEquality().equals(other.deliveredTo, deliveredTo)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,senderId,senderName,senderPhotoUrl,type,content,replyTo,const DeepCollectionEquality().hash(reactions),const DeepCollectionEquality().hash(readBy),const DeepCollectionEquality().hash(deliveredTo),createdAt,editedAt,deletedAt,isDeleted,status);

@override
String toString() {
  return 'MessageEntity(id: $id, conversationId: $conversationId, senderId: $senderId, senderName: $senderName, senderPhotoUrl: $senderPhotoUrl, type: $type, content: $content, replyTo: $replyTo, reactions: $reactions, readBy: $readBy, deliveredTo: $deliveredTo, createdAt: $createdAt, editedAt: $editedAt, deletedAt: $deletedAt, isDeleted: $isDeleted, status: $status)';
}


}

/// @nodoc
abstract mixin class $MessageEntityCopyWith<$Res>  {
  factory $MessageEntityCopyWith(MessageEntity value, $Res Function(MessageEntity) _then) = _$MessageEntityCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String senderId, String senderName, String? senderPhotoUrl, MessageType type, MessageContent content, ReplyInfo? replyTo, Map<String, List<String>> reactions, Map<String, DateTime> readBy, Map<String, DateTime> deliveredTo, DateTime createdAt, DateTime? editedAt, DateTime? deletedAt, bool isDeleted, MessageStatus status
});


$MessageContentCopyWith<$Res> get content;$ReplyInfoCopyWith<$Res>? get replyTo;

}
/// @nodoc
class _$MessageEntityCopyWithImpl<$Res>
    implements $MessageEntityCopyWith<$Res> {
  _$MessageEntityCopyWithImpl(this._self, this._then);

  final MessageEntity _self;
  final $Res Function(MessageEntity) _then;

/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? senderName = null,Object? senderPhotoUrl = freezed,Object? type = null,Object? content = null,Object? replyTo = freezed,Object? reactions = null,Object? readBy = null,Object? deliveredTo = null,Object? createdAt = null,Object? editedAt = freezed,Object? deletedAt = freezed,Object? isDeleted = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,senderPhotoUrl: freezed == senderPhotoUrl ? _self.senderPhotoUrl : senderPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as MessageContent,replyTo: freezed == replyTo ? _self.replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as ReplyInfo?,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,readBy: null == readBy ? _self.readBy : readBy // ignore: cast_nullable_to_non_nullable
as Map<String, DateTime>,deliveredTo: null == deliveredTo ? _self.deliveredTo : deliveredTo // ignore: cast_nullable_to_non_nullable
as Map<String, DateTime>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MessageStatus,
  ));
}
/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageContentCopyWith<$Res> get content {
  
  return $MessageContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReplyInfoCopyWith<$Res>? get replyTo {
    if (_self.replyTo == null) {
    return null;
  }

  return $ReplyInfoCopyWith<$Res>(_self.replyTo!, (value) {
    return _then(_self.copyWith(replyTo: value));
  });
}
}


/// Adds pattern-matching-related methods to [MessageEntity].
extension MessageEntityPatterns on MessageEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageEntity value)  $default,){
final _that = this;
switch (_that) {
case _MessageEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MessageEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String senderId,  String senderName,  String? senderPhotoUrl,  MessageType type,  MessageContent content,  ReplyInfo? replyTo,  Map<String, List<String>> reactions,  Map<String, DateTime> readBy,  Map<String, DateTime> deliveredTo,  DateTime createdAt,  DateTime? editedAt,  DateTime? deletedAt,  bool isDeleted,  MessageStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageEntity() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.senderName,_that.senderPhotoUrl,_that.type,_that.content,_that.replyTo,_that.reactions,_that.readBy,_that.deliveredTo,_that.createdAt,_that.editedAt,_that.deletedAt,_that.isDeleted,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String senderId,  String senderName,  String? senderPhotoUrl,  MessageType type,  MessageContent content,  ReplyInfo? replyTo,  Map<String, List<String>> reactions,  Map<String, DateTime> readBy,  Map<String, DateTime> deliveredTo,  DateTime createdAt,  DateTime? editedAt,  DateTime? deletedAt,  bool isDeleted,  MessageStatus status)  $default,) {final _that = this;
switch (_that) {
case _MessageEntity():
return $default(_that.id,_that.conversationId,_that.senderId,_that.senderName,_that.senderPhotoUrl,_that.type,_that.content,_that.replyTo,_that.reactions,_that.readBy,_that.deliveredTo,_that.createdAt,_that.editedAt,_that.deletedAt,_that.isDeleted,_that.status);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String senderId,  String senderName,  String? senderPhotoUrl,  MessageType type,  MessageContent content,  ReplyInfo? replyTo,  Map<String, List<String>> reactions,  Map<String, DateTime> readBy,  Map<String, DateTime> deliveredTo,  DateTime createdAt,  DateTime? editedAt,  DateTime? deletedAt,  bool isDeleted,  MessageStatus status)?  $default,) {final _that = this;
switch (_that) {
case _MessageEntity() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.senderName,_that.senderPhotoUrl,_that.type,_that.content,_that.replyTo,_that.reactions,_that.readBy,_that.deliveredTo,_that.createdAt,_that.editedAt,_that.deletedAt,_that.isDeleted,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageEntity extends MessageEntity {
  const _MessageEntity({required this.id, required this.conversationId, required this.senderId, required this.senderName, this.senderPhotoUrl, required this.type, required this.content, this.replyTo, final  Map<String, List<String>> reactions = const {}, final  Map<String, DateTime> readBy = const {}, final  Map<String, DateTime> deliveredTo = const {}, required this.createdAt, this.editedAt, this.deletedAt, this.isDeleted = false, this.status = MessageStatus.sending}): _reactions = reactions,_readBy = readBy,_deliveredTo = deliveredTo,super._();
  factory _MessageEntity.fromJson(Map<String, dynamic> json) => _$MessageEntityFromJson(json);

@override final  String id;
@override final  String conversationId;
@override final  String senderId;
@override final  String senderName;
@override final  String? senderPhotoUrl;
@override final  MessageType type;
@override final  MessageContent content;
@override final  ReplyInfo? replyTo;
 final  Map<String, List<String>> _reactions;
@override@JsonKey() Map<String, List<String>> get reactions {
  if (_reactions is EqualUnmodifiableMapView) return _reactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_reactions);
}

 final  Map<String, DateTime> _readBy;
@override@JsonKey() Map<String, DateTime> get readBy {
  if (_readBy is EqualUnmodifiableMapView) return _readBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_readBy);
}

 final  Map<String, DateTime> _deliveredTo;
@override@JsonKey() Map<String, DateTime> get deliveredTo {
  if (_deliveredTo is EqualUnmodifiableMapView) return _deliveredTo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_deliveredTo);
}

@override final  DateTime createdAt;
@override final  DateTime? editedAt;
@override final  DateTime? deletedAt;
@override@JsonKey() final  bool isDeleted;
@override@JsonKey() final  MessageStatus status;

/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageEntityCopyWith<_MessageEntity> get copyWith => __$MessageEntityCopyWithImpl<_MessageEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.senderPhotoUrl, senderPhotoUrl) || other.senderPhotoUrl == senderPhotoUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.content, content) || other.content == content)&&(identical(other.replyTo, replyTo) || other.replyTo == replyTo)&&const DeepCollectionEquality().equals(other._reactions, _reactions)&&const DeepCollectionEquality().equals(other._readBy, _readBy)&&const DeepCollectionEquality().equals(other._deliveredTo, _deliveredTo)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,senderId,senderName,senderPhotoUrl,type,content,replyTo,const DeepCollectionEquality().hash(_reactions),const DeepCollectionEquality().hash(_readBy),const DeepCollectionEquality().hash(_deliveredTo),createdAt,editedAt,deletedAt,isDeleted,status);

@override
String toString() {
  return 'MessageEntity(id: $id, conversationId: $conversationId, senderId: $senderId, senderName: $senderName, senderPhotoUrl: $senderPhotoUrl, type: $type, content: $content, replyTo: $replyTo, reactions: $reactions, readBy: $readBy, deliveredTo: $deliveredTo, createdAt: $createdAt, editedAt: $editedAt, deletedAt: $deletedAt, isDeleted: $isDeleted, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MessageEntityCopyWith<$Res> implements $MessageEntityCopyWith<$Res> {
  factory _$MessageEntityCopyWith(_MessageEntity value, $Res Function(_MessageEntity) _then) = __$MessageEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String senderId, String senderName, String? senderPhotoUrl, MessageType type, MessageContent content, ReplyInfo? replyTo, Map<String, List<String>> reactions, Map<String, DateTime> readBy, Map<String, DateTime> deliveredTo, DateTime createdAt, DateTime? editedAt, DateTime? deletedAt, bool isDeleted, MessageStatus status
});


@override $MessageContentCopyWith<$Res> get content;@override $ReplyInfoCopyWith<$Res>? get replyTo;

}
/// @nodoc
class __$MessageEntityCopyWithImpl<$Res>
    implements _$MessageEntityCopyWith<$Res> {
  __$MessageEntityCopyWithImpl(this._self, this._then);

  final _MessageEntity _self;
  final $Res Function(_MessageEntity) _then;

/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? senderName = null,Object? senderPhotoUrl = freezed,Object? type = null,Object? content = null,Object? replyTo = freezed,Object? reactions = null,Object? readBy = null,Object? deliveredTo = null,Object? createdAt = null,Object? editedAt = freezed,Object? deletedAt = freezed,Object? isDeleted = null,Object? status = null,}) {
  return _then(_MessageEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,senderPhotoUrl: freezed == senderPhotoUrl ? _self.senderPhotoUrl : senderPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as MessageContent,replyTo: freezed == replyTo ? _self.replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as ReplyInfo?,reactions: null == reactions ? _self._reactions : reactions // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,readBy: null == readBy ? _self._readBy : readBy // ignore: cast_nullable_to_non_nullable
as Map<String, DateTime>,deliveredTo: null == deliveredTo ? _self._deliveredTo : deliveredTo // ignore: cast_nullable_to_non_nullable
as Map<String, DateTime>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MessageStatus,
  ));
}

/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageContentCopyWith<$Res> get content {
  
  return $MessageContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReplyInfoCopyWith<$Res>? get replyTo {
    if (_self.replyTo == null) {
    return null;
  }

  return $ReplyInfoCopyWith<$Res>(_self.replyTo!, (value) {
    return _then(_self.copyWith(replyTo: value));
  });
}
}

// dart format on
