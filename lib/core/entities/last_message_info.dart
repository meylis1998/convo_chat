import 'package:freezed_annotation/freezed_annotation.dart';

import 'message_type.dart';

part 'last_message_info.freezed.dart';
part 'last_message_info.g.dart';

@freezed
sealed class LastMessageInfo with _$LastMessageInfo {
  const factory LastMessageInfo({
    required String id,
    required String text,
    required String senderId,
    required String senderName,
    required MessageType type,
    required DateTime timestamp,
  }) = _LastMessageInfo;

  const LastMessageInfo._();

  factory LastMessageInfo.fromJson(Map<String, dynamic> json) =>
      _$LastMessageInfoFromJson(json);

  String get preview {
    switch (type) {
      case MessageType.text:
        return text;
      case MessageType.image:
        return '📷 Photo';
      case MessageType.video:
        return '🎥 Video';
      case MessageType.file:
        return '📎 File';
      case MessageType.voice:
        return '🎤 Voice message';
      case MessageType.system:
        return text;
    }
  }
}
