part of 'conversations_bloc.dart';

abstract class ConversationsEvent extends Equatable {
  const ConversationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadConversations extends ConversationsEvent {
  final String userId;

  const LoadConversations(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ConversationsUpdated extends ConversationsEvent {
  final List<ConversationEntity> conversations;

  const ConversationsUpdated(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class ConversationsError extends ConversationsEvent {
  final String message;

  const ConversationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateDirectConversation extends ConversationsEvent {
  final UserEntity currentUser;
  final UserEntity otherUser;

  const CreateDirectConversation({
    required this.currentUser,
    required this.otherUser,
  });

  @override
  List<Object?> get props => [currentUser, otherUser];
}

class CreateGroupConversation extends ConversationsEvent {
  final UserEntity currentUser;
  final String name;
  final String? description;
  final List<UserEntity> members;

  const CreateGroupConversation({
    required this.currentUser,
    required this.name,
    this.description,
    required this.members,
  });

  @override
  List<Object?> get props => [currentUser, name, description, members];
}

class DeleteConversation extends ConversationsEvent {
  final String conversationId;

  const DeleteConversation(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class StopWatchingConversations extends ConversationsEvent {
  const StopWatchingConversations();
}
