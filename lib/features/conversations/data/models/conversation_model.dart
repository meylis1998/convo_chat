import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/entities/entities.dart';

/// Data model for Firestore serialization
class ConversationModel {
  final String id;
  final ConversationType type;
  final List<String> participantIds;
  final Map<String, ParticipantInfoModel> participantDetails;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LastMessageModel? lastMessage;
  final GroupMetadataModel? metadata;
  final Map<String, DateTime> typingUsers;
  final Map<String, int> unreadCounts;

  const ConversationModel({
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

  static Map<String, ParticipantInfoModel> _parseParticipantDetails(dynamic data) {
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
    final result = <String, DateTime>{};
    for (final entry in map.entries) {
      final value = entry.value;
      if (value != null && value is Timestamp) {
        result[entry.key] = value.toDate();
      }
    }
    return result;
  }

  static Map<String, int> _parseUnreadCounts(dynamic data) {
    if (data == null) return {};
    final map = data as Map<String, dynamic>;
    return map.map((key, value) => MapEntry(key, value as int));
  }

  factory ConversationModel.fromEntity(ConversationEntity entity) {
    return ConversationModel(
      id: entity.id,
      type: entity.type,
      participantIds: entity.participantIds,
      participantDetails: entity.participantDetails.map(
        (key, value) => MapEntry(key, ParticipantInfoModel.fromEntity(value)),
      ),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      lastMessage: entity.lastMessage != null
          ? LastMessageModel.fromEntity(entity.lastMessage!)
          : null,
      metadata: entity.metadata != null
          ? GroupMetadataModel.fromEntity(entity.metadata!)
          : null,
      typingUsers: entity.typingUsers,
      unreadCounts: entity.unreadCounts,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type.name,
      'participantIds': participantIds,
      'participantDetails': participantDetails.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
      if (lastMessage != null) 'lastMessage': lastMessage!.toMap(),
      if (metadata != null) 'metadata': metadata!.toMap(),
      'typingUsers': typingUsers.map(
        (key, value) => MapEntry(key, Timestamp.fromDate(value)),
      ),
      'unreadCounts': unreadCounts,
    };
  }

  ConversationEntity toEntity() {
    return ConversationEntity(
      id: id,
      type: type,
      participantIds: participantIds,
      participantDetails: participantDetails.map(
        (key, value) => MapEntry(key, value.toEntity()),
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastMessage: lastMessage?.toEntity(),
      metadata: metadata?.toEntity(),
      typingUsers: typingUsers,
      unreadCounts: unreadCounts,
    );
  }

  ConversationModel copyWith({
    String? id,
    ConversationType? type,
    List<String>? participantIds,
    Map<String, ParticipantInfoModel>? participantDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
    LastMessageModel? lastMessage,
    GroupMetadataModel? metadata,
    Map<String, DateTime>? typingUsers,
    Map<String, int>? unreadCounts,
  }) {
    return ConversationModel(
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
}

class ParticipantInfoModel {
  final String displayName;
  final String? photoUrl;

  const ParticipantInfoModel({
    required this.displayName,
    this.photoUrl,
  });

  factory ParticipantInfoModel.fromMap(Map<String, dynamic> map) {
    return ParticipantInfoModel(
      displayName: map['displayName'] as String? ?? 'User',
      photoUrl: map['photoUrl'] as String?,
    );
  }

  factory ParticipantInfoModel.fromEntity(ParticipantInfo entity) {
    return ParticipantInfoModel(
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }

  ParticipantInfo toEntity() {
    return ParticipantInfo(
      displayName: displayName,
      photoUrl: photoUrl,
    );
  }
}

class LastMessageModel {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final MessageType type;
  final DateTime timestamp;

  const LastMessageModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.type,
    required this.timestamp,
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

  LastMessageInfo toEntity() {
    return LastMessageInfo(
      id: id,
      text: text,
      senderId: senderId,
      senderName: senderName,
      type: type,
      timestamp: timestamp,
    );
  }
}

class GroupMetadataModel {
  final String name;
  final String? description;
  final String? photoUrl;
  final List<String> adminIds;
  final String createdBy;

  const GroupMetadataModel({
    required this.name,
    this.description,
    this.photoUrl,
    required this.adminIds,
    required this.createdBy,
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

  GroupMetadata toEntity() {
    return GroupMetadata(
      name: name,
      description: description,
      photoUrl: photoUrl,
      adminIds: adminIds,
      createdBy: createdBy,
    );
  }
}
