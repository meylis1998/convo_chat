part of 'chat_bloc.dart';

enum ChatStatus {
  initial,
  loading,
  loaded,
  error,
}

class ChatState extends Equatable {
  final ChatStatus status;
  final String? conversationId;
  final ConversationEntity? conversation;
  final List<MessageEntity> messages;
  final UserEntity? currentUser;
  final ReplyInfo? replyTo;
  final String? errorMessage;

  const ChatState({
    this.status = ChatStatus.initial,
    this.conversationId,
    this.conversation,
    this.messages = const [],
    this.currentUser,
    this.replyTo,
    this.errorMessage,
  });

  bool get isLoading => status == ChatStatus.loading;
  bool get isEmpty => messages.isEmpty;
  bool get hasReply => replyTo != null;

  List<String> get typingUserNames {
    if (conversation == null || currentUser == null) return [];
    return conversation!.getTypingUserNames(currentUser!.uid);
  }

  ChatState copyWith({
    ChatStatus? status,
    String? conversationId,
    ConversationEntity? conversation,
    List<MessageEntity>? messages,
    UserEntity? currentUser,
    ReplyInfo? replyTo,
    String? errorMessage,
    bool clearReplyTo = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      conversationId: conversationId ?? this.conversationId,
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      currentUser: currentUser ?? this.currentUser,
      replyTo: clearReplyTo ? null : (replyTo ?? this.replyTo),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        conversationId,
        conversation,
        messages,
        currentUser,
        replyTo,
        errorMessage,
      ];
}
