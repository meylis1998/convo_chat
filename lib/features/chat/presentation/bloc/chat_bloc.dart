import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../conversations/data/datasources/firestore_conversation_service.dart';
import '../../data/datasources/firestore_message_service.dart';
import '../../../conversations/data/models/conversation_model.dart';
import '../../data/models/message_model.dart';
import '../../../../core/entities/entities.dart';

part 'chat_event.dart';
part 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirestoreMessageService _messageService;
  final FirestoreConversationService _conversationService;
  final _uuid = const Uuid();

  StreamSubscription<List<MessageModel>>? _messagesSubscription;
  StreamSubscription<ConversationModel?>? _conversationSubscription;
  Timer? _typingTimer;

  ChatBloc(this._messageService, this._conversationService)
      : super(const ChatState()) {
    on<LoadChat>(_onLoadChat);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<ConversationUpdated>(_onConversationUpdated);
    on<ChatError>(_onChatError);
    on<SendTextMessage>(_onSendTextMessage);
    on<SendMediaMessage>(_onSendMediaMessage);
    on<EditMessage>(_onEditMessage);
    on<DeleteMessage>(_onDeleteMessage);
    on<AddReaction>(_onAddReaction);
    on<RemoveReaction>(_onRemoveReaction);
    on<SetReplyTo>(_onSetReplyTo);
    on<ClearReplyTo>(_onClearReplyTo);
    on<UpdateTypingStatus>(_onUpdateTypingStatus);
    on<MarkMessagesAsRead>(_onMarkMessagesAsRead);
    on<MarkMessageAsRead>(_onMarkMessageAsRead);
    on<StopWatchingChat>(_onStopWatchingChat);
  }

  void _onLoadChat(LoadChat event, Emitter<ChatState> emit) {
    emit(state.copyWith(
      status: ChatStatus.loading,
      conversationId: event.conversationId,
      currentUser: event.currentUser,
    ));

    _messagesSubscription?.cancel();
    _conversationSubscription?.cancel();

    _messagesSubscription =
        _messageService.watchMessages(event.conversationId).listen(
              (messages) => add(MessagesUpdated(
                messages.map((m) => m.toEntity()).toList(),
              )),
              onError: (error) => add(ChatError(error.toString())),
            );

    _conversationSubscription =
        _conversationService.watchConversation(event.conversationId).listen(
              (conversation) {
                if (conversation != null) {
                  add(ConversationUpdated(conversation.toEntity()));
                }
              },
              onError: (error) => add(ChatError(error.toString())),
            );
  }

  void _onChatError(ChatError event, Emitter<ChatState> emit) {
    emit(state.copyWith(
      status: ChatStatus.error,
      errorMessage: event.message,
    ));
  }

  void _onMessagesUpdated(MessagesUpdated event, Emitter<ChatState> emit) {
    emit(state.copyWith(
      status: ChatStatus.loaded,
      messages: event.messages,
    ));
  }

  void _onConversationUpdated(
    ConversationUpdated event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(conversation: event.conversation));
  }

  Future<void> _onSendTextMessage(
    SendTextMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state.currentUser == null || state.conversationId == null) return;

    final tempId = _uuid.v4();
    final messageModel = MessageModel(
      id: tempId,
      conversationId: state.conversationId!,
      senderId: state.currentUser!.uid,
      senderName: state.currentUser!.displayName,
      senderPhotoUrl: state.currentUser!.photoUrl,
      type: MessageType.text,
      content: MessageContentModel.forText(event.text),
      replyTo: state.replyTo != null ? ReplyInfoModel.fromEntity(state.replyTo!) : null,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );

    // Optimistic update with entity
    emit(state.copyWith(
      messages: [messageModel.toEntity(), ...state.messages],
      clearReplyTo: true,
    ));

    try {
      final messageId = await _messageService.sendMessage(messageModel);

      // Remove optimistic message - the real one will come from Firestore stream
      final updatedMessages = state.messages
          .where((m) => m.id != tempId)
          .toList();
      emit(state.copyWith(messages: updatedMessages));

      // Update last message in conversation
      await _conversationService.updateLastMessage(
        state.conversationId!,
        LastMessageInfo(
          id: messageId,
          text: event.text,
          senderId: state.currentUser!.uid,
          senderName: state.currentUser!.displayName,
          type: MessageType.text,
          timestamp: DateTime.now(),
        ),
      );

      // Increment unread counts for other participants
      if (state.conversation != null) {
        await _conversationService.incrementUnreadCount(
          state.conversationId!,
          state.currentUser!.uid,
          state.conversation!.participantIds,
        );
      }
    } catch (e) {
      // Update message status to failed
      final updatedMessages = state.messages.map((m) {
        if (m.id == tempId) {
          return m.copyWith(status: MessageStatus.failed);
        }
        return m;
      }).toList();

      emit(state.copyWith(
        messages: updatedMessages,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSendMediaMessage(
    SendMediaMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state.currentUser == null || state.conversationId == null) return;

    final tempId = _uuid.v4();
    final messageModel = MessageModel(
      id: tempId,
      conversationId: state.conversationId!,
      senderId: state.currentUser!.uid,
      senderName: state.currentUser!.displayName,
      senderPhotoUrl: state.currentUser!.photoUrl,
      type: event.type,
      content: MessageContentModel.fromEntity(event.content),
      replyTo: state.replyTo != null ? ReplyInfoModel.fromEntity(state.replyTo!) : null,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );

    // Optimistic update with entity
    emit(state.copyWith(
      messages: [messageModel.toEntity(), ...state.messages],
      clearReplyTo: true,
    ));

    try {
      final messageId = await _messageService.sendMessage(messageModel);

      // Remove optimistic message - the real one will come from Firestore stream
      final updatedMessages = state.messages
          .where((m) => m.id != tempId)
          .toList();
      emit(state.copyWith(messages: updatedMessages));

      // Update last message
      await _conversationService.updateLastMessage(
        state.conversationId!,
        LastMessageInfo(
          id: messageId,
          text: event.content.text ?? '',
          senderId: state.currentUser!.uid,
          senderName: state.currentUser!.displayName,
          type: event.type,
          timestamp: DateTime.now(),
        ),
      );

      if (state.conversation != null) {
        await _conversationService.incrementUnreadCount(
          state.conversationId!,
          state.currentUser!.uid,
          state.conversation!.participantIds,
        );
      }
    } catch (e) {
      final updatedMessages = state.messages.map((m) {
        if (m.id == tempId) {
          return m.copyWith(status: MessageStatus.failed);
        }
        return m;
      }).toList();

      emit(state.copyWith(
        messages: updatedMessages,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onEditMessage(
    EditMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state.conversationId == null) return;

    try {
      await _messageService.editMessage(
        state.conversationId!,
        event.messageId,
        event.newText,
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state.conversationId == null) return;

    try {
      await _messageService.deleteMessage(
        state.conversationId!,
        event.messageId,
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onAddReaction(
    AddReaction event,
    Emitter<ChatState> emit,
  ) async {
    if (state.conversationId == null || state.currentUser == null) return;

    try {
      await _messageService.addReaction(
        state.conversationId!,
        event.messageId,
        state.currentUser!.uid,
        event.emoji,
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onRemoveReaction(
    RemoveReaction event,
    Emitter<ChatState> emit,
  ) async {
    if (state.conversationId == null || state.currentUser == null) return;

    try {
      await _messageService.removeReaction(
        state.conversationId!,
        event.messageId,
        state.currentUser!.uid,
        event.emoji,
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void _onSetReplyTo(SetReplyTo event, Emitter<ChatState> emit) {
    emit(state.copyWith(replyTo: event.replyTo));
  }

  void _onClearReplyTo(ClearReplyTo event, Emitter<ChatState> emit) {
    emit(state.copyWith(replyTo: null, clearReplyTo: true));
  }

  Future<void> _onUpdateTypingStatus(
    UpdateTypingStatus event,
    Emitter<ChatState> emit,
  ) async {
    if (state.conversationId == null || state.currentUser == null) return;

    _typingTimer?.cancel();

    try {
      await _conversationService.setTypingStatus(
        state.conversationId!,
        state.currentUser!.uid,
        event.isTyping,
      );

      if (event.isTyping) {
        _typingTimer = Timer(const Duration(seconds: 3), () {
          add(const UpdateTypingStatus(false));
        });
      }
    } catch (e) {
      // Silently fail for typing status - non-critical feature
    }
  }

  Future<void> _onMarkMessagesAsRead(
    MarkMessagesAsRead event,
    Emitter<ChatState> emit,
  ) async {
    if (state.conversationId == null || state.currentUser == null) return;

    // Reset unread count
    await _conversationService.resetUnreadCount(
      state.conversationId!,
      state.currentUser!.uid,
    );

    // Collect unread message IDs and mark them all in a single batch
    final unreadMessageIds = state.messages
        .where((m) =>
            m.senderId != state.currentUser!.uid &&
            !m.readBy.containsKey(state.currentUser!.uid))
        .map((m) => m.id)
        .toList();

    if (unreadMessageIds.isNotEmpty) {
      await _messageService.markMultipleAsRead(
        state.conversationId!,
        unreadMessageIds,
        state.currentUser!.uid,
      );
    }
  }

  Future<void> _onMarkMessageAsRead(
    MarkMessageAsRead event,
    Emitter<ChatState> emit,
  ) async {
    if (state.conversationId == null || state.currentUser == null) return;

    try {
      await _messageService.markAsRead(
        state.conversationId!,
        event.messageId,
        state.currentUser!.uid,
      );

      // Also reset unread count when reading messages
      await _conversationService.resetUnreadCount(
        state.conversationId!,
        state.currentUser!.uid,
      );
    } catch (e) {
      // Silently fail - non-critical
    }
  }

  void _onStopWatchingChat(
    StopWatchingChat event,
    Emitter<ChatState> emit,
  ) {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
    _conversationSubscription?.cancel();
    _conversationSubscription = null;
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    _conversationSubscription?.cancel();
    _typingTimer?.cancel();
    return super.close();
  }
}
