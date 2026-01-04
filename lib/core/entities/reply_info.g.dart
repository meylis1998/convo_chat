// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReplyInfo _$ReplyInfoFromJson(Map<String, dynamic> json) => _ReplyInfo(
  messageId: json['messageId'] as String,
  senderId: json['senderId'] as String,
  senderName: json['senderName'] as String,
  text: json['text'] as String?,
  type: $enumDecode(_$MessageTypeEnumMap, json['type']),
);

Map<String, dynamic> _$ReplyInfoToJson(_ReplyInfo instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'text': instance.text,
      'type': _$MessageTypeEnumMap[instance.type]!,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.video: 'video',
  MessageType.file: 'file',
  MessageType.voice: 'voice',
  MessageType.system: 'system',
};
