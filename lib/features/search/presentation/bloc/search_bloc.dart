import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../conversations/data/datasources/firestore_conversation_service.dart';
import '../../../chat/data/datasources/firestore_message_service.dart';
import '../../../auth/data/datasources/firestore_user_service.dart';
import '../../../conversations/data/models/conversation_model.dart';
import '../../../../core/entities/entities.dart';

part 'search_event.dart';
part 'search_state.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FirestoreUserService _userService;
  final FirestoreMessageService _messageService;
  final FirestoreConversationService _conversationService;

  Timer? _debounceTimer;
  StreamSubscription<dynamic>? _conversationsSubscription;
  static const _debounceDuration = Duration(milliseconds: 500);

  SearchBloc(
    this._userService,
    this._messageService,
    this._conversationService,
  ) : super(const SearchState()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchTabChanged>(_onSearchTabChanged);
    on<ClearSearch>(_onClearSearch);
    on<_ExecuteSearch>(_onExecuteSearch);
    on<InitializeSearch>(_onInitializeSearch);
    on<_ConversationsLoaded>(_onConversationsLoaded);
    on<StartConversationWithUser>(_onStartConversationWithUser);
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(query: event.query));

    if (event.query.trim().isEmpty) {
      emit(state.copyWith(
        status: SearchStatus.initial,
        userResults: [],
        conversationResults: [],
        messageResults: [],
      ));
      return;
    }

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Start debounce timer
    _debounceTimer = Timer(_debounceDuration, () {
      add(_ExecuteSearch(event.query));
    });
  }

  void _onSearchTabChanged(
    SearchTabChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(activeTab: event.tab));
  }

  void _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) {
    _debounceTimer?.cancel();
    emit(const SearchState());
  }

  Future<void> _onInitializeSearch(
    InitializeSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(currentUserId: event.userId));

    // Load conversations for this user
    _conversationsSubscription?.cancel();
    _conversationsSubscription = _conversationService
        .watchConversations(event.userId)
        .listen((conversationModels) {
      final conversations = conversationModels
          .map((model) => model.toEntity())
          .toList();
      // We can't use emit here since this is in a listener
      // Instead, we update via a private event
      add(_ConversationsLoaded(conversations));
    });
  }

  void _onConversationsLoaded(
    _ConversationsLoaded event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(allConversations: event.conversations));
  }

  Future<void> _onStartConversationWithUser(
    StartConversationWithUser event,
    Emitter<SearchState> emit,
  ) async {
    try {
      // Check if conversation already exists
      final existingConversationId = await _conversationService
          .findDirectConversation(event.currentUser.uid, event.otherUser.uid);

      if (existingConversationId != null) {
        emit(state.copyWith(navigateToConversationId: existingConversationId));
        return;
      }

      // Create new conversation
      final now = DateTime.now();
      final conversationModel = ConversationModel(
        id: '', // Will be set by Firestore
        type: ConversationType.direct,
        participantIds: [event.currentUser.uid, event.otherUser.uid],
        participantDetails: {
          event.currentUser.uid: ParticipantInfoModel(
            displayName: event.currentUser.displayName,
            photoUrl: event.currentUser.photoUrl,
          ),
          event.otherUser.uid: ParticipantInfoModel(
            displayName: event.otherUser.displayName,
            photoUrl: event.otherUser.photoUrl,
          ),
        },
        createdAt: now,
        updatedAt: now,
      );

      final conversationId = await _conversationService.createConversation(conversationModel);
      emit(state.copyWith(navigateToConversationId: conversationId));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.error,
        errorMessage: 'Failed to start conversation: $e',
      ));
    }
  }

  Future<void> _onExecuteSearch(
    _ExecuteSearch event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) return;

    emit(state.copyWith(status: SearchStatus.loading));

    try {
      // Search users
      final userModels = await _userService.searchUsers(query);
      final userResults = userModels
          .map((model) => model.toEntity())
          .where((user) => user.uid != state.currentUserId)
          .toList();

      // Filter conversations locally
      final conversationResults = _filterConversations(query);

      // Search messages across conversations
      final messageResults = await _searchMessagesAcrossConversations(query);

      emit(state.copyWith(
        status: SearchStatus.loaded,
        userResults: userResults,
        conversationResults: conversationResults,
        messageResults: messageResults,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  List<ConversationEntity> _filterConversations(String query) {
    final lowerQuery = query.toLowerCase();
    return state.allConversations.where((conversation) {
      // Check group name
      if (conversation.isGroup && conversation.metadata != null) {
        final groupName = conversation.metadata!.name.toLowerCase();
        if (groupName.contains(lowerQuery)) return true;
      }

      // Check participant names
      for (final participant in conversation.participantDetails.values) {
        if (participant.displayName.toLowerCase().contains(lowerQuery)) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  Future<List<MessageSearchResult>> _searchMessagesAcrossConversations(
    String query,
  ) async {
    final results = <MessageSearchResult>[];

    // Search in each conversation (limit to prevent excessive queries)
    for (final conversation in state.allConversations.take(10)) {
      try {
        final messages = await _messageService.searchMessages(
          conversation.id,
          query,
        );

        for (final message in messages.take(5)) {
          results.add(MessageSearchResult(
            message: message.toEntity(),
            conversationId: conversation.id,
            conversationName: conversation.getDisplayName(state.currentUserId ?? ''),
          ));
        }
      } catch (_) {
        // Continue searching other conversations even if one fails
      }
    }

    return results;
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    _conversationsSubscription?.cancel();
    return super.close();
  }
}
