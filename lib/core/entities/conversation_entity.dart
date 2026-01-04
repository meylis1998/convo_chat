import 'package:freezed_annotation/freezed_annotation.dart';

import 'conversation_type.dart';
import 'group_metadata.dart';
import 'last_message_info.dart';
import 'participant_info.dart';

part 'conversation_entity.freezed.dart';
part 'conversation_entity.g.dart';

@freezed
sealed class ConversationEntity with _$ConversationEntity {
  const factory ConversationEntity({
    required String id,
    required ConversationType type,
    required List<String> participantIds,
    required Map<String, ParticipantInfo> participantDetails,
    required DateTime createdAt,
    required DateTime updatedAt,
    LastMessageInfo? lastMessage,
    GroupMetadata? metadata,
    @Default({}) Map<String, DateTime> typingUsers,
    @Default({}) Map<String, int> unreadCounts,
  }) = _ConversationEntity;

  const ConversationEntity._();

  factory ConversationEntity.fromJson(Map<String, dynamic> json) =>
      _$ConversationEntityFromJson(json);

  bool get isGroup => type == ConversationType.group;
  bool get isDirect => type == ConversationType.direct;

  String getDisplayName(String currentUserId) {
    if (isGroup) {
      return metadata?.name ?? 'Group Chat';
    }
    final otherParticipant = participantDetails.entries
        .where((e) => e.key != currentUserId)
        .firstOrNull;
    return otherParticipant?.value.displayName ?? 'Unknown';
  }

  String? getDisplayPhoto(String currentUserId) {
    if (isGroup) {
      return metadata?.photoUrl;
    }
    final otherParticipant = participantDetails.entries
        .where((e) => e.key != currentUserId)
        .firstOrNull;
    return otherParticipant?.value.photoUrl;
  }

  String? getOtherParticipantId(String currentUserId) {
    if (isGroup) return null;
    return participantIds.where((id) => id != currentUserId).firstOrNull;
  }

  int getUnreadCount(String userId) => unreadCounts[userId] ?? 0;

  List<String> getTypingUserNames(String currentUserId) {
    return typingUsers.entries
        .where((e) => e.key != currentUserId)
        .map((e) => participantDetails[e.key]?.displayName ?? 'Someone')
        .toList();
  }
}
