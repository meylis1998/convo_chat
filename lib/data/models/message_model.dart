import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.conversationId,
    required super.senderId,
    required super.senderName,
    super.senderPhotoUrl,
    required super.type,
    required super.content,
    super.replyTo,
    super.reactions,
    super.readBy,
    super.deliveredTo,
    required super.createdAt,
    super.editedAt,
    super.deletedAt,
    super.isDeleted,
    super.status,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MessageModel(
      id: doc.id,
      conversationId: data['conversationId'] as String? ?? '',
      senderId: data['senderId'] as String? ?? '',
      senderName: data['senderName'] as String? ?? 'User',
      senderPhotoUrl: data['senderPhotoUrl'] as String?,
      type: MessageType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => MessageType.text,
      ),
      content: MessageContentModel.fromMap(
        data['content'] as Map<String, dynamic>? ?? {},
      ),
      replyTo: data['replyTo'] != null
          ? ReplyInfoModel.fromMap(data['replyTo'] as Map<String, dynamic>)
          : null,
      reactions: _parseReactions(data['reactions']),
      readBy: _parseTimestampMap(data['readBy']),
      deliveredTo: _parseTimestampMap(data['deliveredTo']),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      editedAt: (data['editedAt'] as Timestamp?)?.toDate(),
      deletedAt: (data['deletedAt'] as Timestamp?)?.toDate(),
      isDeleted: data['isDeleted'] as bool? ?? false,
      status: MessageStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => MessageStatus.sent,
      ),
    );
  }

  static Map<String, List<String>> _parseReactions(dynamic data) {
    if (data == null) return {};
    final map = data as Map<String, dynamic>;
    return map.map(
      (key, value) => MapEntry(key, List<String>.from(value as List)),
    );
  }

  static Map<String, DateTime> _parseTimestampMap(dynamic data) {
    if (data == null) return {};
    final map = data as Map<String, dynamic>;
    final result = <String, DateTime>{};
    for (final entry in map.entries) {
      final timestamp = entry.value as Timestamp?;
      if (timestamp != null) {
        result[entry.key] = timestamp.toDate();
      }
    }
    return result;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhotoUrl': senderPhotoUrl,
      'type': type.name,
      'content': MessageContentModel.fromEntity(content).toMap(),
      if (replyTo != null)
        'replyTo': ReplyInfoModel.fromEntity(replyTo!).toMap(),
      'reactions': reactions,
      'readBy': readBy.map((k, v) => MapEntry(k, Timestamp.fromDate(v))),
      'deliveredTo':
          deliveredTo.map((k, v) => MapEntry(k, Timestamp.fromDate(v))),
      'createdAt': FieldValue.serverTimestamp(),
      if (editedAt != null) 'editedAt': Timestamp.fromDate(editedAt!),
      if (deletedAt != null) 'deletedAt': Timestamp.fromDate(deletedAt!),
      'isDeleted': isDeleted,
      'status': status.name,
    };
  }

  MessageEntity toEntity() => this;

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      conversationId: entity.conversationId,
      senderId: entity.senderId,
      senderName: entity.senderName,
      senderPhotoUrl: entity.senderPhotoUrl,
      type: entity.type,
      content: entity.content,
      replyTo: entity.replyTo,
      reactions: entity.reactions,
      readBy: entity.readBy,
      deliveredTo: entity.deliveredTo,
      createdAt: entity.createdAt,
      editedAt: entity.editedAt,
      deletedAt: entity.deletedAt,
      isDeleted: entity.isDeleted,
      status: entity.status,
    );
  }
}

class MessageContentModel extends MessageContent {
  const MessageContentModel({
    super.text,
    super.mediaUrl,
    super.thumbnailUrl,
    super.fileName,
    super.fileSize,
    super.mimeType,
    super.duration,
    super.width,
    super.height,
  });

  factory MessageContentModel.fromMap(Map<String, dynamic> map) {
    return MessageContentModel(
      text: map['text'] as String?,
      mediaUrl: map['mediaUrl'] as String?,
      thumbnailUrl: map['thumbnailUrl'] as String?,
      fileName: map['fileName'] as String?,
      fileSize: map['fileSize'] as int?,
      mimeType: map['mimeType'] as String?,
      duration: map['duration'] as int?,
      width: map['width'] as int?,
      height: map['height'] as int?,
    );
  }

  factory MessageContentModel.fromEntity(MessageContent entity) {
    return MessageContentModel(
      text: entity.text,
      mediaUrl: entity.mediaUrl,
      thumbnailUrl: entity.thumbnailUrl,
      fileName: entity.fileName,
      fileSize: entity.fileSize,
      mimeType: entity.mimeType,
      duration: entity.duration,
      width: entity.width,
      height: entity.height,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (text != null) 'text': text,
      if (mediaUrl != null) 'mediaUrl': mediaUrl,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (fileName != null) 'fileName': fileName,
      if (fileSize != null) 'fileSize': fileSize,
      if (mimeType != null) 'mimeType': mimeType,
      if (duration != null) 'duration': duration,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
    };
  }
}

class ReplyInfoModel extends ReplyInfo {
  const ReplyInfoModel({
    required super.messageId,
    required super.senderId,
    required super.senderName,
    super.text,
    required super.type,
  });

  factory ReplyInfoModel.fromMap(Map<String, dynamic> map) {
    return ReplyInfoModel(
      messageId: map['messageId'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      senderName: map['senderName'] as String? ?? '',
      text: map['text'] as String?,
      type: MessageType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => MessageType.text,
      ),
    );
  }

  factory ReplyInfoModel.fromEntity(ReplyInfo entity) {
    return ReplyInfoModel(
      messageId: entity.messageId,
      senderId: entity.senderId,
      senderName: entity.senderName,
      text: entity.text,
      type: entity.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'senderName': senderName,
      if (text != null) 'text': text,
      'type': type.name,
    };
  }
}
