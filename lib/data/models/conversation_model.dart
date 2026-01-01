import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';

class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.id,
    required super.type,
    required super.participantIds,
    required super.participantDetails,
    required super.createdAt,
    required super.updatedAt,
    super.lastMessage,
    super.metadata,
    super.typingUsers,
    super.unreadCounts,
  });

  factory ConversationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ConversationModel(
      id: doc.id,
      type: ConversationType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => ConversationType.direct,
      ),
      participantIds: List<String>.from(data['participantIds'] ?? []),
      participantDetails: _parseParticipantDetails(data['participantDetails']),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastMessage: data['lastMessage'] != null
          ? LastMessageModel.fromMap(data['lastMessage'] as Map<String, dynamic>)
          : null,
      metadata: data['metadata'] != null
          ? GroupMetadataModel.fromMap(data['metadata'] as Map<String, dynamic>)
          : null,
      typingUsers: _parseTypingUsers(data['typingUsers']),
      unreadCounts: _parseUnreadCounts(data['unreadCounts']),
    );
  }

  static Map<String, ParticipantInfo> _parseParticipantDetails(dynamic data) {
    if (data == null) return {};
    final map = data as Map<String, dynamic>;
    return map.map(
      (key, value) => MapEntry(
        key,
        ParticipantInfoModel.fromMap(value as Map<String, dynamic>),
      ),
    );
  }

  static Map<String, DateTime> _parseTypingUsers(dynamic data) {
    if (data == null) return {};
    final map = data as Map<String, dynamic>;
    return map.map(
      (key, value) => MapEntry(
        key,
        (value as Timestamp).toDate(),
      ),
    );
  }

  static Map<String, int> _parseUnreadCounts(dynamic data) {
    if (data == null) return {};
    final map = data as Map<String, dynamic>;
    return map.map((key, value) => MapEntry(key, value as int));
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type.name,
      'participantIds': participantIds,
      'participantDetails': participantDetails.map(
        (key, value) => MapEntry(key, {
          'displayName': value.displayName,
          'photoUrl': value.photoUrl,
        }),
      ),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
      if (lastMessage != null)
        'lastMessage': LastMessageModel.fromEntity(lastMessage!).toMap(),
      if (metadata != null)
        'metadata': GroupMetadataModel.fromEntity(metadata!).toMap(),
      'typingUsers': typingUsers.map(
        (key, value) => MapEntry(key, Timestamp.fromDate(value)),
      ),
      'unreadCounts': unreadCounts,
    };
  }

  ConversationEntity toEntity() => this;

  factory ConversationModel.fromEntity(ConversationEntity entity) {
    return ConversationModel(
      id: entity.id,
      type: entity.type,
      participantIds: entity.participantIds,
      participantDetails: entity.participantDetails,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      lastMessage: entity.lastMessage,
      metadata: entity.metadata,
      typingUsers: entity.typingUsers,
      unreadCounts: entity.unreadCounts,
    );
  }
}

class ParticipantInfoModel extends ParticipantInfo {
  const ParticipantInfoModel({
    required super.displayName,
    super.photoUrl,
  });

  factory ParticipantInfoModel.fromMap(Map<String, dynamic> map) {
    return ParticipantInfoModel(
      displayName: map['displayName'] as String? ?? 'User',
      photoUrl: map['photoUrl'] as String?,
    );
  }
}

class LastMessageModel extends LastMessageInfo {
  const LastMessageModel({
    required super.id,
    required super.text,
    required super.senderId,
    required super.senderName,
    required super.type,
    required super.timestamp,
  });

  factory LastMessageModel.fromMap(Map<String, dynamic> map) {
    return LastMessageModel(
      id: map['id'] as String? ?? '',
      text: map['text'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      senderName: map['senderName'] as String? ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => MessageType.text,
      ),
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory LastMessageModel.fromEntity(LastMessageInfo entity) {
    return LastMessageModel(
      id: entity.id,
      text: entity.text,
      senderId: entity.senderId,
      senderName: entity.senderName,
      type: entity.type,
      timestamp: entity.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'type': type.name,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class GroupMetadataModel extends GroupMetadata {
  const GroupMetadataModel({
    required super.name,
    super.description,
    super.photoUrl,
    required super.adminIds,
    required super.createdBy,
  });

  factory GroupMetadataModel.fromMap(Map<String, dynamic> map) {
    return GroupMetadataModel(
      name: map['name'] as String? ?? 'Group',
      description: map['description'] as String?,
      photoUrl: map['photoUrl'] as String?,
      adminIds: List<String>.from(map['adminIds'] ?? []),
      createdBy: map['createdBy'] as String? ?? '',
    );
  }

  factory GroupMetadataModel.fromEntity(GroupMetadata entity) {
    return GroupMetadataModel(
      name: entity.name,
      description: entity.description,
      photoUrl: entity.photoUrl,
      adminIds: entity.adminIds,
      createdBy: entity.createdBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'adminIds': adminIds,
      'createdBy': createdBy,
    };
  }
}
