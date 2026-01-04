// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_message_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LastMessageInfo _$LastMessageInfoFromJson(Map<String, dynamic> json) =>
    _LastMessageInfo(
      id: json['id'] as String,
      text: json['text'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$LastMessageInfoToJson(_LastMessageInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.video: 'video',
  MessageType.file: 'file',
  MessageType.voice: 'voice',
  MessageType.system: 'system',
};
