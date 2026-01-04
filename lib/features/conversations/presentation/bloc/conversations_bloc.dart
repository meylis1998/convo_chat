import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasources/firestore_conversation_service.dart';
import '../../data/models/conversation_model.dart';
import '../../../../core/entities/entities.dart';
import '../../../../core/services/presence_service.dart';

part 'conversations_event.dart';
part 'conversations_state.dart';

@injectable
class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final FirestoreConversationService _conversationService;
  final PresenceService _presenceService;
  StreamSubscription<List<ConversationModel>>? _conversationsSubscription;
  StreamSubscription<Map<String, UserPresence>>? _presenceSubscription;
  String? _currentUserId;

  ConversationsBloc(this._conversationService, this._presenceService)
      : super(const ConversationsState()) {
    on<LoadConversations>(_onLoadConversations);
    on<ConversationsUpdated>(_onConversationsUpdated);
    on<ConversationsError>(_onConversationsError);
    on<ParticipantPresenceUpdated>(_onParticipantPresenceUpdated);
    on<CreateDirectConversation>(_onCreateDirectConversation);
    on<CreateGroupConversation>(_onCreateGroupConversation);
    on<DeleteConversation>(_onDeleteConversation);
    on<StopWatchingConversations>(_onStopWatchingConversations);
  }

  void _onLoadConversations(
    LoadConversations event,
    Emitter<ConversationsState> emit,
  ) {
    _currentUserId = event.userId;
    emit(state.copyWith(status: ConversationsStatus.loading));

    _conversationsSubscription?.cancel();
    _conversationsSubscription =
        _conversationService.watchConversations(event.userId).listen(
              (conversations) => add(ConversationsUpdated(
                conversations.map((c) => c.toEntity()).toList(),
              )),
              onError: (error) => add(ConversationsError(error.toString())),
            );
  }

  void _onConversationsError(
    ConversationsError event,
    Emitter<ConversationsState> emit,
  ) {
    emit(state.copyWith(
      status: ConversationsStatus.error,
      errorMessage: event.message,
    ));
  }

  void _onConversationsUpdated(
    ConversationsUpdated event,
    Emitter<ConversationsState> emit,
  ) {
    emit(state.copyWith(
      status: ConversationsStatus.loaded,
      conversations: event.conversations,
    ));

    // Start watching presence for direct conversation participants
    _updatePresenceSubscription(event.conversations);
  }

  void _updatePresenceSubscription(List<ConversationEntity> conversations) {
    if (_currentUserId == null) return;

    // Get unique other participant IDs from direct conversations
    final otherParticipantIds = <String>{};
    for (final conv in conversations) {
      if (conv.isDirect) {
        final otherId = conv.getOtherParticipantId(_currentUserId!);
        if (otherId != null) {
          otherParticipantIds.add(otherId);
        }
      }
    }

    if (otherParticipantIds.isEmpty) {
      _presenceSubscription?.cancel();
      _presenceSubscription = null;
      return;
    }

    // Only resubscribe if the participant list changed
    _presenceSubscription?.cancel();
    _presenceSubscription = _presenceService
        .watchMultipleUsersPresence(otherParticipantIds.toList())
        .listen(
          (presenceMap) => add(ParticipantPresenceUpdated(presenceMap)),
        );
  }

  void _onParticipantPresenceUpdated(
    ParticipantPresenceUpdated event,
    Emitter<ConversationsState> emit,
  ) {
    emit(state.copyWith(participantPresence: event.presenceMap));
  }

  Future<void> _onCreateDirectConversation(
    CreateDirectConversation event,
    Emitter<ConversationsState> emit,
  ) async {
    try {
      // Check if conversation already exists
      final existingId = await _conversationService.findDirectConversation(
        event.currentUser.uid,
        event.otherUser.uid,
      );

      if (existingId != null) {
        emit(state.copyWith(createdConversationId: existingId));
        return;
      }

      // Create new conversation
      final conversation = ConversationModel(
        id: '',
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
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final id = await _conversationService.createConversation(conversation);
      emit(state.copyWith(createdConversationId: id));
    } catch (e) {
      emit(state.copyWith(
        status: ConversationsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCreateGroupConversation(
    CreateGroupConversation event,
    Emitter<ConversationsState> emit,
  ) async {
    try {
      final participantIds = event.members.map((u) => u.uid).toList()
        ..add(event.currentUser.uid);

      final participantDetails = <String, ParticipantInfoModel>{};
      for (final member in event.members) {
        participantDetails[member.uid] = ParticipantInfoModel(
          displayName: member.displayName,
          photoUrl: member.photoUrl,
        );
      }
      participantDetails[event.currentUser.uid] = ParticipantInfoModel(
        displayName: event.currentUser.displayName,
        photoUrl: event.currentUser.photoUrl,
      );

      final conversation = ConversationModel(
        id: '',
        type: ConversationType.group,
        participantIds: participantIds,
        participantDetails: participantDetails,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        metadata: GroupMetadataModel(
          name: event.name,
          description: event.description,
          adminIds: [event.currentUser.uid],
          createdBy: event.currentUser.uid,
        ),
      );

      final id = await _conversationService.createConversation(conversation);
      emit(state.copyWith(createdConversationId: id));
    } catch (e) {
      emit(state.copyWith(
        status: ConversationsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteConversation(
    DeleteConversation event,
    Emitter<ConversationsState> emit,
  ) async {
    try {
      await _conversationService.deleteConversation(event.conversationId);
    } catch (e) {
      emit(state.copyWith(
        status: ConversationsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onStopWatchingConversations(
    StopWatchingConversations event,
    Emitter<ConversationsState> emit,
  ) {
    _conversationsSubscription?.cancel();
    _conversationsSubscription = null;
    _presenceSubscription?.cancel();
    _presenceSubscription = null;
  }

  @override
  Future<void> close() {
    _conversationsSubscription?.cancel();
    _presenceSubscription?.cancel();
    return super.close();
  }
}
