// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationEntity _$ConversationEntityFromJson(
  Map<String, dynamic> json,
) => _ConversationEntity(
  id: json['id'] as String,
  type: $enumDecode(_$ConversationTypeEnumMap, json['type']),
  participantIds: (json['participantIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  participantDetails: (json['participantDetails'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, ParticipantInfo.fromJson(e as Map<String, dynamic>)),
  ),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  lastMessage: json['lastMessage'] == null
      ? null
      : LastMessageInfo.fromJson(json['lastMessage'] as Map<String, dynamic>),
  metadata: json['metadata'] == null
      ? null
      : GroupMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
  typingUsers:
      (json['typingUsers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, DateTime.parse(e as String)),
      ) ??
      const {},
  unreadCounts:
      (json['unreadCounts'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
);

Map<String, dynamic> _$ConversationEntityToJson(_ConversationEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ConversationTypeEnumMap[instance.type]!,
      'participantIds': instance.participantIds,
      'participantDetails': instance.participantDetails.map(
        (k, e) => MapEntry(k, e.toJson()),
      ),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastMessage': instance.lastMessage?.toJson(),
      'metadata': instance.metadata?.toJson(),
      'typingUsers': instance.typingUsers.map(
        (k, e) => MapEntry(k, e.toIso8601String()),
      ),
      'unreadCounts': instance.unreadCounts,
    };

const _$ConversationTypeEnumMap = {
  ConversationType.direct: 'direct',
  ConversationType.group: 'group',
};
