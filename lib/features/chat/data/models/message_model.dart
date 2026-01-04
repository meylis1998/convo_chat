import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/entities/entities.dart';

/// Data model for Firestore serialization
class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String? senderPhotoUrl;
  final MessageType type;
  final MessageContentModel content;
  final ReplyInfoModel? replyTo;
  final Map<String, List<String>> reactions;
  final Map<String, DateTime> readBy;
  final Map<String, DateTime> deliveredTo;
  final DateTime createdAt;
  final DateTime? editedAt;
  final DateTime? deletedAt;
  final bool isDeleted;
  final MessageStatus status;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    this.senderPhotoUrl,
    required this.type,
    required this.content,
    this.replyTo,
    this.reactions = const {},
    this.readBy = const {},
    this.deliveredTo = const {},
    required this.createdAt,
    this.editedAt,
    this.deletedAt,
    this.isDeleted = false,
    this.status = MessageStatus.sending,
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

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      conversationId: entity.conversationId,
      senderId: entity.senderId,
      senderName: entity.senderName,
      senderPhotoUrl: entity.senderPhotoUrl,
      type: entity.type,
      content: MessageContentModel.fromEntity(entity.content),
      replyTo: entity.replyTo != null
          ? ReplyInfoModel.fromEntity(entity.replyTo!)
          : null,
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

  Map<String, dynamic> toFirestore() {
    return {
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhotoUrl': senderPhotoUrl,
      'type': type.name,
      'content': content.toMap(),
      if (replyTo != null) 'replyTo': replyTo!.toMap(),
      'reactions': reactions,
      'readBy': readBy.map((k, v) => MapEntry(k, Timestamp.fromDate(v))),
      'deliveredTo': deliveredTo.map((k, v) => MapEntry(k, Timestamp.fromDate(v))),
      'createdAt': FieldValue.serverTimestamp(),
      if (editedAt != null) 'editedAt': Timestamp.fromDate(editedAt!),
      if (deletedAt != null) 'deletedAt': Timestamp.fromDate(deletedAt!),
      'isDeleted': isDeleted,
      'status': status.name,
    };
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      senderPhotoUrl: senderPhotoUrl,
      type: type,
      content: content.toEntity(),
      replyTo: replyTo?.toEntity(),
      reactions: reactions,
      readBy: readBy,
      deliveredTo: deliveredTo,
      createdAt: createdAt,
      editedAt: editedAt,
      deletedAt: deletedAt,
      isDeleted: isDeleted,
      status: status,
    );
  }

  MessageModel copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderName,
    String? senderPhotoUrl,
    MessageType? type,
    MessageContentModel? content,
    ReplyInfoModel? replyTo,
    Map<String, List<String>>? reactions,
    Map<String, DateTime>? readBy,
    Map<String, DateTime>? deliveredTo,
    DateTime? createdAt,
    DateTime? editedAt,
    DateTime? deletedAt,
    bool? isDeleted,
    MessageStatus? status,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderPhotoUrl: senderPhotoUrl ?? this.senderPhotoUrl,
      type: type ?? this.type,
      content: content ?? this.content,
      replyTo: replyTo ?? this.replyTo,
      reactions: reactions ?? this.reactions,
      readBy: readBy ?? this.readBy,
      deliveredTo: deliveredTo ?? this.deliveredTo,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      status: status ?? this.status,
    );
  }
}

class MessageContentModel {
  final String? text;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final String? fileName;
  final int? fileSize;
  final String? mimeType;
  final int? duration;
  final int? width;
  final int? height;

  const MessageContentModel({
    this.text,
    this.mediaUrl,
    this.thumbnailUrl,
    this.fileName,
    this.fileSize,
    this.mimeType,
    this.duration,
    this.width,
    this.height,
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

  MessageContent toEntity() {
    return MessageContent(
      text: text,
      mediaUrl: mediaUrl,
      thumbnailUrl: thumbnailUrl,
      fileName: fileName,
      fileSize: fileSize,
      mimeType: mimeType,
      duration: duration,
      width: width,
      height: height,
    );
  }

  /// Factory for text messages
  static MessageContentModel forText(String text) => MessageContentModel(text: text);

  /// Factory for image messages
  static MessageContentModel image({
    required String mediaUrl,
    String? thumbnailUrl,
    int? width,
    int? height,
  }) =>
      MessageContentModel(
        mediaUrl: mediaUrl,
        thumbnailUrl: thumbnailUrl,
        width: width,
        height: height,
        mimeType: 'image/jpeg',
      );

  /// Factory for video messages
  static MessageContentModel video({
    required String mediaUrl,
    String? thumbnailUrl,
    int? duration,
    int? width,
    int? height,
  }) =>
      MessageContentModel(
        mediaUrl: mediaUrl,
        thumbnailUrl: thumbnailUrl,
        duration: duration,
        width: width,
        height: height,
        mimeType: 'video/mp4',
      );

  /// Factory for voice messages
  static MessageContentModel voice({
    required String mediaUrl,
    required int duration,
  }) =>
      MessageContentModel(
        mediaUrl: mediaUrl,
        duration: duration,
        mimeType: 'audio/m4a',
      );

  /// Factory for file messages
  static MessageContentModel file({
    required String mediaUrl,
    required String fileName,
    required int fileSize,
    required String mimeType,
  }) =>
      MessageContentModel(
        mediaUrl: mediaUrl,
        fileName: fileName,
        fileSize: fileSize,
        mimeType: mimeType,
      );
}

class ReplyInfoModel {
  final String messageId;
  final String senderId;
  final String senderName;
  final String? text;
  final MessageType type;

  const ReplyInfoModel({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    this.text,
    required this.type,
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

  ReplyInfo toEntity() {
    return ReplyInfo(
      messageId: messageId,
      senderId: senderId,
      senderName: senderName,
      text: text,
      type: type,
    );
  }
}
