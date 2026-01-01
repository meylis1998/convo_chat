import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/datasources/remote/firestore_conversation_service.dart';
import '../../../../data/models/conversation_model.dart';
import '../../../../domain/entities/conversation_entity.dart';
import '../../../../domain/entities/user_entity.dart';

part 'conversations_event.dart';
part 'conversations_state.dart';

@injectable
class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final FirestoreConversationService _conversationService;
  StreamSubscription<List<ConversationModel>>? _conversationsSubscription;

  ConversationsBloc(this._conversationService)
      : super(const ConversationsState()) {
    on<LoadConversations>(_onLoadConversations);
    on<ConversationsUpdated>(_onConversationsUpdated);
    on<ConversationsError>(_onConversationsError);
    on<CreateDirectConversation>(_onCreateDirectConversation);
    on<CreateGroupConversation>(_onCreateGroupConversation);
    on<DeleteConversation>(_onDeleteConversation);
  }

  void _onLoadConversations(
    LoadConversations event,
    Emitter<ConversationsState> emit,
  ) {
    emit(state.copyWith(status: ConversationsStatus.loading));

    _conversationsSubscription?.cancel();
    _conversationsSubscription =
        _conversationService.watchConversations(event.userId).listen(
              (conversations) => add(ConversationsUpdated(conversations)),
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
          event.currentUser.uid: ParticipantInfo(
            displayName: event.currentUser.displayName,
            photoUrl: event.currentUser.photoUrl,
          ),
          event.otherUser.uid: ParticipantInfo(
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

      final participantDetails = <String, ParticipantInfo>{};
      for (final member in event.members) {
        participantDetails[member.uid] = ParticipantInfo(
          displayName: member.displayName,
          photoUrl: member.photoUrl,
        );
      }
      participantDetails[event.currentUser.uid] = ParticipantInfo(
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
        metadata: GroupMetadata(
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

  @override
  Future<void> close() {
    _conversationsSubscription?.cancel();
    return super.close();
  }
}
