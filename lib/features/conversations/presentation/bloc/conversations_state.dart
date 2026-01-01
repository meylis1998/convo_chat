part of 'conversations_bloc.dart';

enum ConversationsStatus {
  initial,
  loading,
  loaded,
  error,
}

class ConversationsState extends Equatable {
  final ConversationsStatus status;
  final List<ConversationEntity> conversations;
  final String? errorMessage;
  final String? createdConversationId;

  const ConversationsState({
    this.status = ConversationsStatus.initial,
    this.conversations = const [],
    this.errorMessage,
    this.createdConversationId,
  });

  bool get isLoading => status == ConversationsStatus.loading;
  bool get isEmpty => conversations.isEmpty;

  ConversationsState copyWith({
    ConversationsStatus? status,
    List<ConversationEntity>? conversations,
    String? errorMessage,
    String? createdConversationId,
  }) {
    return ConversationsState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      errorMessage: errorMessage,
      createdConversationId: createdConversationId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        conversations,
        errorMessage,
        createdConversationId,
      ];
}
