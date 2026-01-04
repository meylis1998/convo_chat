// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupMetadata {

 String get name; String? get description; String? get photoUrl; List<String> get adminIds; String get createdBy;
/// Create a copy of GroupMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupMetadataCopyWith<GroupMetadata> get copyWith => _$GroupMetadataCopyWithImpl<GroupMetadata>(this as GroupMetadata, _$identity);

  /// Serializes this GroupMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupMetadata&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&const DeepCollectionEquality().equals(other.adminIds, adminIds)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,photoUrl,const DeepCollectionEquality().hash(adminIds),createdBy);

@override
String toString() {
  return 'GroupMetadata(name: $name, description: $description, photoUrl: $photoUrl, adminIds: $adminIds, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class $GroupMetadataCopyWith<$Res>  {
  factory $GroupMetadataCopyWith(GroupMetadata value, $Res Function(GroupMetadata) _then) = _$GroupMetadataCopyWithImpl;
@useResult
$Res call({
 String name, String? description, String? photoUrl, List<String> adminIds, String createdBy
});




}
/// @nodoc
class _$GroupMetadataCopyWithImpl<$Res>
    implements $GroupMetadataCopyWith<$Res> {
  _$GroupMetadataCopyWithImpl(this._self, this._then);

  final GroupMetadata _self;
  final $Res Function(GroupMetadata) _then;

/// Create a copy of GroupMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? photoUrl = freezed,Object? adminIds = null,Object? createdBy = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,adminIds: null == adminIds ? _self.adminIds : adminIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupMetadata].
extension GroupMetadataPatterns on GroupMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupMetadata value)  $default,){
final _that = this;
switch (_that) {
case _GroupMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _GroupMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  String? photoUrl,  List<String> adminIds,  String createdBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupMetadata() when $default != null:
return $default(_that.name,_that.description,_that.photoUrl,_that.adminIds,_that.createdBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  String? photoUrl,  List<String> adminIds,  String createdBy)  $default,) {final _that = this;
switch (_that) {
case _GroupMetadata():
return $default(_that.name,_that.description,_that.photoUrl,_that.adminIds,_that.createdBy);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  String? photoUrl,  List<String> adminIds,  String createdBy)?  $default,) {final _that = this;
switch (_that) {
case _GroupMetadata() when $default != null:
return $default(_that.name,_that.description,_that.photoUrl,_that.adminIds,_that.createdBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupMetadata extends GroupMetadata {
  const _GroupMetadata({required this.name, this.description, this.photoUrl, required final  List<String> adminIds, required this.createdBy}): _adminIds = adminIds,super._();
  factory _GroupMetadata.fromJson(Map<String, dynamic> json) => _$GroupMetadataFromJson(json);

@override final  String name;
@override final  String? description;
@override final  String? photoUrl;
 final  List<String> _adminIds;
@override List<String> get adminIds {
  if (_adminIds is EqualUnmodifiableListView) return _adminIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_adminIds);
}

@override final  String createdBy;

/// Create a copy of GroupMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupMetadataCopyWith<_GroupMetadata> get copyWith => __$GroupMetadataCopyWithImpl<_GroupMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupMetadata&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&const DeepCollectionEquality().equals(other._adminIds, _adminIds)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,photoUrl,const DeepCollectionEquality().hash(_adminIds),createdBy);

@override
String toString() {
  return 'GroupMetadata(name: $name, description: $description, photoUrl: $photoUrl, adminIds: $adminIds, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class _$GroupMetadataCopyWith<$Res> implements $GroupMetadataCopyWith<$Res> {
  factory _$GroupMetadataCopyWith(_GroupMetadata value, $Res Function(_GroupMetadata) _then) = __$GroupMetadataCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, String? photoUrl, List<String> adminIds, String createdBy
});




}
/// @nodoc
class __$GroupMetadataCopyWithImpl<$Res>
    implements _$GroupMetadataCopyWith<$Res> {
  __$GroupMetadataCopyWithImpl(this._self, this._then);

  final _GroupMetadata _self;
  final $Res Function(_GroupMetadata) _then;

/// Create a copy of GroupMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? photoUrl = freezed,Object? adminIds = null,Object? createdBy = null,}) {
  return _then(_GroupMetadata(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,adminIds: null == adminIds ? _self._adminIds : adminIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
