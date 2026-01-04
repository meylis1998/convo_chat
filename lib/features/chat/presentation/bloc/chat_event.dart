part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChat extends ChatEvent {
  final String conversationId;
  final UserEntity currentUser;

  const LoadChat({
    required this.conversationId,
    required this.currentUser,
  });

  @override
  List<Object?> get props => [conversationId, currentUser];
}

class MessagesUpdated extends ChatEvent {
  final List<MessageEntity> messages;

  const MessagesUpdated(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ConversationUpdated extends ChatEvent {
  final ConversationEntity conversation;

  const ConversationUpdated(this.conversation);

  @override
  List<Object?> get props => [conversation];
}

class ChatError extends ChatEvent {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

class SendTextMessage extends ChatEvent {
  final String text;

  const SendTextMessage(this.text);

  @override
  List<Object?> get props => [text];
}

class SendMediaMessage extends ChatEvent {
  final MessageType type;
  final MessageContent content;

  const SendMediaMessage({
    required this.type,
    required this.content,
  });

  @override
  List<Object?> get props => [type, content];
}

class EditMessage extends ChatEvent {
  final String messageId;
  final String newText;

  const EditMessage({
    required this.messageId,
    required this.newText,
  });

  @override
  List<Object?> get props => [messageId, newText];
}

class DeleteMessage extends ChatEvent {
  final String messageId;

  const DeleteMessage(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class AddReaction extends ChatEvent {
  final String messageId;
  final String emoji;

  const AddReaction({
    required this.messageId,
    required this.emoji,
  });

  @override
  List<Object?> get props => [messageId, emoji];
}

class RemoveReaction extends ChatEvent {
  final String messageId;
  final String emoji;

  const RemoveReaction({
    required this.messageId,
    required this.emoji,
  });

  @override
  List<Object?> get props => [messageId, emoji];
}

class SetReplyTo extends ChatEvent {
  final ReplyInfo replyTo;

  const SetReplyTo(this.replyTo);

  @override
  List<Object?> get props => [replyTo];
}

class ClearReplyTo extends ChatEvent {
  const ClearReplyTo();
}

class UpdateTypingStatus extends ChatEvent {
  final bool isTyping;

  const UpdateTypingStatus(this.isTyping);

  @override
  List<Object?> get props => [isTyping];
}

class MarkMessagesAsRead extends ChatEvent {
  const MarkMessagesAsRead();
}

class MarkMessageAsRead extends ChatEvent {
  final String messageId;

  const MarkMessageAsRead(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class StopWatchingChat extends ChatEvent {
  const StopWatchingChat();
}
