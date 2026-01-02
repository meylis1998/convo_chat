part of 'search_bloc.dart';

enum SearchStatus { initial, loading, loaded, error }

enum SearchTab { users, conversations, messages }

class MessageSearchResult extends Equatable {
  final MessageEntity message;
  final String conversationId;
  final String conversationName;

  const MessageSearchResult({
    required this.message,
    required this.conversationId,
    required this.conversationName,
  });

  @override
  List<Object?> get props => [message, conversationId, conversationName];
}

class SearchState extends Equatable {
  final SearchStatus status;
  final SearchTab activeTab;
  final String query;
  final String? currentUserId;
  final List<UserEntity> userResults;
  final List<ConversationEntity> conversationResults;
  final List<MessageSearchResult> messageResults;
  final List<ConversationEntity> allConversations;
  final String? errorMessage;
  final String? navigateToConversationId;

  const SearchState({
    this.status = SearchStatus.initial,
    this.activeTab = SearchTab.users,
    this.query = '',
    this.currentUserId,
    this.userResults = const [],
    this.conversationResults = const [],
    this.messageResults = const [],
    this.allConversations = const [],
    this.errorMessage,
    this.navigateToConversationId,
  });

  bool get isLoading => status == SearchStatus.loading;
  bool get isLoaded => status == SearchStatus.loaded;
  bool get hasError => status == SearchStatus.error;
  bool get hasQuery => query.trim().isNotEmpty;

  bool get hasResults =>
      userResults.isNotEmpty ||
      conversationResults.isNotEmpty ||
      messageResults.isNotEmpty;

  bool get isEmpty => hasQuery && !hasResults && isLoaded;

  int get userCount => userResults.length;
  int get conversationCount => conversationResults.length;
  int get messageCount => messageResults.length;

  SearchState copyWith({
    SearchStatus? status,
    SearchTab? activeTab,
    String? query,
    String? currentUserId,
    List<UserEntity>? userResults,
    List<ConversationEntity>? conversationResults,
    List<MessageSearchResult>? messageResults,
    List<ConversationEntity>? allConversations,
    String? errorMessage,
    String? navigateToConversationId,
  }) {
    return SearchState(
      status: status ?? this.status,
      activeTab: activeTab ?? this.activeTab,
      query: query ?? this.query,
      currentUserId: currentUserId ?? this.currentUserId,
      userResults: userResults ?? this.userResults,
      conversationResults: conversationResults ?? this.conversationResults,
      messageResults: messageResults ?? this.messageResults,
      allConversations: allConversations ?? this.allConversations,
      errorMessage: errorMessage,
      navigateToConversationId: navigateToConversationId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        activeTab,
        query,
        currentUserId,
        userResults,
        conversationResults,
        messageResults,
        allConversations,
        errorMessage,
        navigateToConversationId,
      ];
}
