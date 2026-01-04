import 'package:freezed_annotation/freezed_annotation.dart';

import 'message_type.dart';

part 'reply_info.freezed.dart';
part 'reply_info.g.dart';

@freezed
sealed class ReplyInfo with _$ReplyInfo {
  const factory ReplyInfo({
    required String messageId,
    required String senderId,
    required String senderName,
    String? text,
    required MessageType type,
  }) = _ReplyInfo;

  factory ReplyInfo.fromJson(Map<String, dynamic> json) =>
      _$ReplyInfoFromJson(json);
}
