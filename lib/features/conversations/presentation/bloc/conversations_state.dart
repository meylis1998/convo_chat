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
  final Map<String, UserPresence> participantPresence;

  const ConversationsState({
    this.status = ConversationsStatus.initial,
    this.conversations = const [],
    this.errorMessage,
    this.createdConversationId,
    this.participantPresence = const {},
  });

  bool get isLoading => status == ConversationsStatus.loading;
  bool get isEmpty => conversations.isEmpty;

  /// Get presence for a specific user
  UserPresence? getPresence(String userId) => participantPresence[userId];

  ConversationsState copyWith({
    ConversationsStatus? status,
    List<ConversationEntity>? conversations,
    String? errorMessage,
    String? createdConversationId,
    Map<String, UserPresence>? participantPresence,
  }) {
    return ConversationsState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      errorMessage: errorMessage,
      createdConversationId: createdConversationId,
      participantPresence: participantPresence ?? this.participantPresence,
    );
  }

  @override
  List<Object?> get props => [
        status,
        conversations,
        errorMessage,
        createdConversationId,
        participantPresence,
      ];
}
