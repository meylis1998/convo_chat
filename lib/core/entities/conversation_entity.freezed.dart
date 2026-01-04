// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationEntity {

 String get id; ConversationType get type; List<String> get participantIds; Map<String, ParticipantInfo> get participantDetails; DateTime get createdAt; DateTime get updatedAt; LastMessageInfo? get lastMessage; GroupMetadata? get metadata; Map<String, DateTime> get typingUsers; Map<String, int> get unreadCounts;
/// Create a copy of ConversationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationEntityCopyWith<ConversationEntity> get copyWith => _$ConversationEntityCopyWithImpl<ConversationEntity>(this as ConversationEntity, _$identity);

  /// Serializes this ConversationEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.participantIds, participantIds)&&const DeepCollectionEquality().equals(other.participantDetails, participantDetails)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&const DeepCollectionEquality().equals(other.typingUsers, typingUsers)&&const DeepCollectionEquality().equals(other.unreadCounts, unreadCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,const DeepCollectionEquality().hash(participantIds),const DeepCollectionEquality().hash(participantDetails),createdAt,updatedAt,lastMessage,metadata,const DeepCollectionEquality().hash(typingUsers),const DeepCollectionEquality().hash(unreadCounts));

@override
String toString() {
  return 'ConversationEntity(id: $id, type: $type, participantIds: $participantIds, participantDetails: $participantDetails, createdAt: $createdAt, updatedAt: $updatedAt, lastMessage: $lastMessage, metadata: $metadata, typingUsers: $typingUsers, unreadCounts: $unreadCounts)';
}


}

/// @nodoc
abstract mixin class $ConversationEntityCopyWith<$Res>  {
  factory $ConversationEntityCopyWith(ConversationEntity value, $Res Function(ConversationEntity) _then) = _$ConversationEntityCopyWithImpl;
@useResult
$Res call({
 String id, ConversationType type, List<String> participantIds, Map<String, ParticipantInfo> participantDetails, DateTime createdAt, DateTime updatedAt, LastMessageInfo? lastMessage, GroupMetadata? metadata, Map<String, DateTime> typingUsers, Map<String, int> unreadCounts
});


$LastMessageInfoCopyWith<$Res>? get lastMessage;$GroupMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$ConversationEntityCopyWithImpl<$Res>
    implements $ConversationEntityCopyWith<$Res> {
  _$ConversationEntityCopyWithImpl(this._self, this._then);

  final ConversationEntity _self;
  final $Res Function(ConversationEntity) _then;

/// Create a copy of ConversationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? participantIds = null,Object? participantDetails = null,Object? createdAt = null,Object? updatedAt = null,Object? lastMessage = freezed,Object? metadata = freezed,Object? typingUsers = null,Object? unreadCounts = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ConversationType,participantIds: null == participantIds ? _self.participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,participantDetails: null == participantDetails ? _self.participantDetails : participantDetails // ignore: cast_nullable_to_non_nullable
as Map<String, ParticipantInfo>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as LastMessageInfo?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as GroupMetadata?,typingUsers: null == typingUsers ? _self.typingUsers : typingUsers // ignore: cast_nullable_to_non_nullable
as Map<String, DateTime>,unreadCounts: null == unreadCounts ? _self.unreadCounts : unreadCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}
/// Create a copy of ConversationEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LastMessageInfoCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $LastMessageInfoCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}/// Create a copy of ConversationEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $GroupMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConversationEntity].
extension ConversationEntityPatterns on ConversationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationEntity value)  $default,){
final _that = this;
switch (_that) {
case _ConversationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ConversationType type,  List<String> participantIds,  Map<String, ParticipantInfo> participantDetails,  DateTime createdAt,  DateTime updatedAt,  LastMessageInfo? lastMessage,  GroupMetadata? metadata,  Map<String, DateTime> typingUsers,  Map<String, int> unreadCounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationEntity() when $default != null:
return $default(_that.id,_that.type,_that.participantIds,_that.participantDetails,_that.createdAt,_that.updatedAt,_that.lastMessage,_that.metadata,_that.typingUsers,_that.unreadCounts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ConversationType type,  List<String> participantIds,  Map<String, ParticipantInfo> participantDetails,  DateTime createdAt,  DateTime updatedAt,  LastMessageInfo? lastMessage,  GroupMetadata? metadata,  Map<String, DateTime> typingUsers,  Map<String, int> unreadCounts)  $default,) {final _that = this;
switch (_that) {
case _ConversationEntity():
return $default(_that.id,_that.type,_that.participantIds,_that.participantDetails,_that.createdAt,_that.updatedAt,_that.lastMessage,_that.metadata,_that.typingUsers,_that.unreadCounts);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ConversationType type,  List<String> participantIds,  Map<String, ParticipantInfo> participantDetails,  DateTime createdAt,  DateTime updatedAt,  LastMessageInfo? lastMessage,  GroupMetadata? metadata,  Map<String, DateTime> typingUsers,  Map<String, int> unreadCounts)?  $default,) {final _that = this;
switch (_that) {
case _ConversationEntity() when $default != null:
return $default(_that.id,_that.type,_that.participantIds,_that.participantDetails,_that.createdAt,_that.updatedAt,_that.lastMessage,_that.metadata,_that.typingUsers,_that.unreadCounts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationEntity extends ConversationEntity {
  const _ConversationEntity({required this.id, required this.type, required final  List<String> participantIds, required final  Map<String, ParticipantInfo> participantDetails, required this.createdAt, required this.updatedAt, this.lastMessage, this.metadata, final  Map<String, DateTime> typingUsers = const {}, final  Map<String, int> unreadCounts = const {}}): _participantIds = participantIds,_participantDetails = participantDetails,_typingUsers = typingUsers,_unreadCounts = unreadCounts,super._();
  factory _ConversationEntity.fromJson(Map<String, dynamic> json) => _$ConversationEntityFromJson(json);

@override final  String id;
@override final  ConversationType type;
 final  List<String> _participantIds;
@override List<String> get participantIds {
  if (_participantIds is EqualUnmodifiableListView) return _participantIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participantIds);
}

 final  Map<String, ParticipantInfo> _participantDetails;
@override Map<String, ParticipantInfo> get participantDetails {
  if (_participantDetails is EqualUnmodifiableMapView) return _participantDetails;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_participantDetails);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  LastMessageInfo? lastMessage;
@override final  GroupMetadata? metadata;
 final  Map<String, DateTime> _typingUsers;
@override@JsonKey() Map<String, DateTime> get typingUsers {
  if (_typingUsers is EqualUnmodifiableMapView) return _typingUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_typingUsers);
}

 final  Map<String, int> _unreadCounts;
@override@JsonKey() Map<String, int> get unreadCounts {
  if (_unreadCounts is EqualUnmodifiableMapView) return _unreadCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_unreadCounts);
}


/// Create a copy of ConversationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationEntityCopyWith<_ConversationEntity> get copyWith => __$ConversationEntityCopyWithImpl<_ConversationEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._participantIds, _participantIds)&&const DeepCollectionEquality().equals(other._participantDetails, _participantDetails)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&const DeepCollectionEquality().equals(other._typingUsers, _typingUsers)&&const DeepCollectionEquality().equals(other._unreadCounts, _unreadCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,const DeepCollectionEquality().hash(_participantIds),const DeepCollectionEquality().hash(_participantDetails),createdAt,updatedAt,lastMessage,metadata,const DeepCollectionEquality().hash(_typingUsers),const DeepCollectionEquality().hash(_unreadCounts));

@override
String toString() {
  return 'ConversationEntity(id: $id, type: $type, participantIds: $participantIds, participantDetails: $participantDetails, createdAt: $createdAt, updatedAt: $updatedAt, lastMessage: $lastMessage, metadata: $metadata, typingUsers: $typingUsers, unreadCounts: $unreadCounts)';
}


}

/// @nodoc
abstract mixin class _$ConversationEntityCopyWith<$Res> implements $ConversationEntityCopyWith<$Res> {
  factory _$ConversationEntityCopyWith(_ConversationEntity value, $Res Function(_ConversationEntity) _then) = __$ConversationEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, ConversationType type, List<String> participantIds, Map<String, ParticipantInfo> participantDetails, DateTime createdAt, DateTime updatedAt, LastMessageInfo? lastMessage, GroupMetadata? metadata, Map<String, DateTime> typingUsers, Map<String, int> unreadCounts
});


@override $LastMessageInfoCopyWith<$Res>? get lastMessage;@override $GroupMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$ConversationEntityCopyWithImpl<$Res>
    implements _$ConversationEntityCopyWith<$Res> {
  __$ConversationEntityCopyWithImpl(this._self, this._then);

  final _ConversationEntity _self;
  final $Res Function(_ConversationEntity) _then;

/// Create a copy of ConversationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? participantIds = null,Object? participantDetails = null,Object? createdAt = null,Object? updatedAt = null,Object? lastMessage = freezed,Object? metadata = freezed,Object? typingUsers = null,Object? unreadCounts = null,}) {
  return _then(_ConversationEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ConversationType,participantIds: null == participantIds ? _self._participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,participantDetails: null == participantDetails ? _self._participantDetails : participantDetails // ignore: cast_nullable_to_non_nullable
as Map<String, ParticipantInfo>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as LastMessageInfo?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as GroupMetadata?,typingUsers: null == typingUsers ? _self._typingUsers : typingUsers // ignore: cast_nullable_to_non_nullable
as Map<String, DateTime>,unreadCounts: null == unreadCounts ? _self._unreadCounts : unreadCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

/// Create a copy of ConversationEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LastMessageInfoCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $LastMessageInfoCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}/// Create a copy of ConversationEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $GroupMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
