import 'package:equatable/equatable.dart';

import 'message_entity.dart';

enum ConversationType {
  direct,
  group,
}

class ConversationEntity extends Equatable {
  final String id;
  final ConversationType type;
  final List<String> participantIds;
  final Map<String, ParticipantInfo> participantDetails;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LastMessageInfo? lastMessage;
  final GroupMetadata? metadata;
  final Map<String, DateTime> typingUsers;
  final Map<String, int> unreadCounts;

  const ConversationEntity({
    required this.id,
    required this.type,
    required this.participantIds,
    required this.participantDetails,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
    this.metadata,
    this.typingUsers = const {},
    this.unreadCounts = const {},
  });

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

  ConversationEntity copyWith({
    String? id,
    ConversationType? type,
    List<String>? participantIds,
    Map<String, ParticipantInfo>? participantDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
    LastMessageInfo? lastMessage,
    GroupMetadata? metadata,
    Map<String, DateTime>? typingUsers,
    Map<String, int>? unreadCounts,
  }) {
    return ConversationEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      participantIds: participantIds ?? this.participantIds,
      participantDetails: participantDetails ?? this.participantDetails,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessage: lastMessage ?? this.lastMessage,
      metadata: metadata ?? this.metadata,
      typingUsers: typingUsers ?? this.typingUsers,
      unreadCounts: unreadCounts ?? this.unreadCounts,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        participantIds,
        participantDetails,
        createdAt,
        updatedAt,
        lastMessage,
        metadata,
        typingUsers,
        unreadCounts,
      ];
}

class ParticipantInfo extends Equatable {
  final String displayName;
  final String? photoUrl;

  const ParticipantInfo({
    required this.displayName,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [displayName, photoUrl];
}

class LastMessageInfo extends Equatable {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final MessageType type;
  final DateTime timestamp;

  const LastMessageInfo({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.type,
    required this.timestamp,
  });

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

  @override
  List<Object?> get props => [
        id,
        text,
        senderId,
        senderName,
        type,
        timestamp,
      ];
}

class GroupMetadata extends Equatable {
  final String name;
  final String? description;
  final String? photoUrl;
  final List<String> adminIds;
  final String createdBy;

  const GroupMetadata({
    required this.name,
    this.description,
    this.photoUrl,
    required this.adminIds,
    required this.createdBy,
  });

  bool isAdmin(String userId) => adminIds.contains(userId);

  GroupMetadata copyWith({
    String? name,
    String? description,
    String? photoUrl,
    List<String>? adminIds,
    String? createdBy,
  }) {
    return GroupMetadata(
      name: name ?? this.name,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      adminIds: adminIds ?? this.adminIds,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  List<Object?> get props => [
        name,
        description,
        photoUrl,
        adminIds,
        createdBy,
      ];
}
