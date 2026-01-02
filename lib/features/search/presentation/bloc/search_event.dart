part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchTabChanged extends SearchEvent {
  final SearchTab tab;

  const SearchTabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
}

class InitializeSearch extends SearchEvent {
  final String userId;

  const InitializeSearch(this.userId);

  @override
  List<Object?> get props => [userId];
}

class _ExecuteSearch extends SearchEvent {
  final String query;

  const _ExecuteSearch(this.query);

  @override
  List<Object?> get props => [query];
}

class _ConversationsLoaded extends SearchEvent {
  final List<ConversationEntity> conversations;

  const _ConversationsLoaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class StartConversationWithUser extends SearchEvent {
  final UserEntity currentUser;
  final UserEntity otherUser;

  const StartConversationWithUser({
    required this.currentUser,
    required this.otherUser,
  });

  @override
  List<Object?> get props => [currentUser, otherUser];
}
