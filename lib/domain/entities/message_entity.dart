import 'package:equatable/equatable.dart';

enum MessageType {
  text,
  image,
  video,
  file,
  voice,
  system,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

class MessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String? senderPhotoUrl;
  final MessageType type;
  final MessageContent content;
  final ReplyInfo? replyTo;
  final Map<String, List<String>> reactions;
  final Map<String, DateTime> readBy;
  final Map<String, DateTime> deliveredTo;
  final DateTime createdAt;
  final DateTime? editedAt;
  final DateTime? deletedAt;
  final bool isDeleted;
  final MessageStatus status;

  const MessageEntity({
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

  bool get isEdited => editedAt != null;
  bool get hasReactions => reactions.isNotEmpty;
  bool get isReply => replyTo != null;

  MessageEntity copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderName,
    String? senderPhotoUrl,
    MessageType? type,
    MessageContent? content,
    ReplyInfo? replyTo,
    Map<String, List<String>>? reactions,
    Map<String, DateTime>? readBy,
    Map<String, DateTime>? deliveredTo,
    DateTime? createdAt,
    DateTime? editedAt,
    DateTime? deletedAt,
    bool? isDeleted,
    MessageStatus? status,
  }) {
    return MessageEntity(
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

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        senderName,
        senderPhotoUrl,
        type,
        content,
        replyTo,
        reactions,
        readBy,
        deliveredTo,
        createdAt,
        editedAt,
        deletedAt,
        isDeleted,
        status,
      ];
}

class MessageContent extends Equatable {
  final String? text;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final String? fileName;
  final int? fileSize;
  final String? mimeType;
  final int? duration;
  final int? width;
  final int? height;

  const MessageContent({
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

  factory MessageContent.text(String text) => MessageContent(text: text);

  factory MessageContent.image({
    required String mediaUrl,
    String? thumbnailUrl,
    int? width,
    int? height,
  }) =>
      MessageContent(
        mediaUrl: mediaUrl,
        thumbnailUrl: thumbnailUrl,
        width: width,
        height: height,
        mimeType: 'image/jpeg',
      );

  factory MessageContent.video({
    required String mediaUrl,
    String? thumbnailUrl,
    int? duration,
    int? width,
    int? height,
  }) =>
      MessageContent(
        mediaUrl: mediaUrl,
        thumbnailUrl: thumbnailUrl,
        duration: duration,
        width: width,
        height: height,
        mimeType: 'video/mp4',
      );

  factory MessageContent.voice({
    required String mediaUrl,
    required int duration,
  }) =>
      MessageContent(
        mediaUrl: mediaUrl,
        duration: duration,
        mimeType: 'audio/m4a',
      );

  factory MessageContent.file({
    required String mediaUrl,
    required String fileName,
    required int fileSize,
    required String mimeType,
  }) =>
      MessageContent(
        mediaUrl: mediaUrl,
        fileName: fileName,
        fileSize: fileSize,
        mimeType: mimeType,
      );

  @override
  List<Object?> get props => [
        text,
        mediaUrl,
        thumbnailUrl,
        fileName,
        fileSize,
        mimeType,
        duration,
        width,
        height,
      ];
}

class ReplyInfo extends Equatable {
  final String messageId;
  final String senderId;
  final String senderName;
  final String? text;
  final MessageType type;

  const ReplyInfo({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    this.text,
    required this.type,
  });

  @override
  List<Object?> get props => [
        messageId,
        senderId,
        senderName,
        text,
        type,
      ];
}
