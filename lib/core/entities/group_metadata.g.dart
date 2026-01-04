// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupMetadata _$GroupMetadataFromJson(Map<String, dynamic> json) =>
    _GroupMetadata(
      name: json['name'] as String,
      description: json['description'] as String?,
      photoUrl: json['photoUrl'] as String?,
      adminIds: (json['adminIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdBy: json['createdBy'] as String,
    );

Map<String, dynamic> _$GroupMetadataToJson(_GroupMetadata instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'adminIds': instance.adminIds,
      'createdBy': instance.createdBy,
    };
