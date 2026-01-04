import 'package:freezed_annotation/freezed_annotation.dart';

import 'message_content.dart';
import 'message_status.dart';
import 'message_type.dart';
import 'reply_info.dart';

part 'message_entity.freezed.dart';
part 'message_entity.g.dart';

@freezed
sealed class MessageEntity with _$MessageEntity {
  const factory MessageEntity({
    required String id,
    required String conversationId,
    required String senderId,
    required String senderName,
    String? senderPhotoUrl,
    required MessageType type,
    required MessageContent content,
    ReplyInfo? replyTo,
    @Default({}) Map<String, List<String>> reactions,
    @Default({}) Map<String, DateTime> readBy,
    @Default({}) Map<String, DateTime> deliveredTo,
    required DateTime createdAt,
    DateTime? editedAt,
    DateTime? deletedAt,
    @Default(false) bool isDeleted,
    @Default(MessageStatus.sending) MessageStatus status,
  }) = _MessageEntity;

  const MessageEntity._();

  factory MessageEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageEntityFromJson(json);

  bool get isEdited => editedAt != null;
  bool get hasReactions => reactions.isNotEmpty;
  bool get isReply => replyTo != null;
}
