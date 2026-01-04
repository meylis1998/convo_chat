import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/entities/entities.dart';
import '../models/conversation_model.dart';

@lazySingleton
class FirestoreConversationService {
  final FirebaseFirestore _firestore;

  static const String _collection = 'conversations';

  FirestoreConversationService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _conversationsRef =>
      _firestore.collection(_collection);

  Stream<List<ConversationModel>> watchConversations(String userId) {
    return _conversationsRef
        .where('participantIds', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConversationModel.fromFirestore(doc))
            .toList());
  }

  Future<ConversationModel?> getConversation(String id) async {
    try {
      final doc = await _conversationsRef.doc(id).get();
      if (!doc.exists) return null;
      return ConversationModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to get conversation', error: e);
      throw ServerException(message: e.message ?? 'Failed to get conversation');
    }
  }

  Stream<ConversationModel?> watchConversation(String id) {
    return _conversationsRef.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return ConversationModel.fromFirestore(doc);
    });
  }

  Future<String?> findDirectConversation(
      String userId1, String userId2) async {
    try {
      final query = await _conversationsRef
          .where('type', isEqualTo: 'direct')
          .where('participantIds', arrayContains: userId1)
          .get();

      for (final doc in query.docs) {
        final participants =
            List<String>.from(doc.data()['participantIds'] ?? []);
        if (participants.contains(userId2)) {
          return doc.id;
        }
      }
      return null;
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to find direct conversation', error: e);
      throw ServerException(
          message: e.message ?? 'Failed to find conversation');
    }
  }

  Future<String> createConversation(ConversationModel conversation) async {
    try {
      AppLogger.firebase('Creating conversation');
      final docRef = await _conversationsRef.add(conversation.toFirestore());
      AppLogger.firebase('Conversation created: ${docRef.id}');
      return docRef.id;
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to create conversation', error: e);
      throw ServerException(
          message: e.message ?? 'Failed to create conversation');
    }
  }

  Future<void> updateConversation(
      String id, Map<String, dynamic> data) async {
    try {
      await _conversationsRef.doc(id).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to update conversation', error: e);
      throw ServerException(
          message: e.message ?? 'Failed to update conversation');
    }
  }

  Future<void> updateLastMessage(
      String conversationId, LastMessageInfo lastMessage) async {
    try {
      await _conversationsRef.doc(conversationId).update({
        'lastMessage': {
          'id': lastMessage.id,
          'text': lastMessage.text,
          'senderId': lastMessage.senderId,
          'senderName': lastMessage.senderName,
          'type': lastMessage.type.name,
          'timestamp': FieldValue.serverTimestamp(),
        },
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to update last message', error: e);
      throw ServerException(
          message: e.message ?? 'Failed to update last message');
    }
  }

  Future<void> setTypingStatus(
    String conversationId,
    String userId,
    bool isTyping,
  ) async {
    try {
      if (isTyping) {
        await _conversationsRef.doc(conversationId).update({
          'typingUsers.$userId': FieldValue.serverTimestamp(),
        });
      } else {
        await _conversationsRef.doc(conversationId).update({
          'typingUsers.$userId': FieldValue.delete(),
        });
      }
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to update typing status', error: e);
    }
  }

  Future<void> incrementUnreadCount(
    String conversationId,
    String excludeUserId,
    List<String> participantIds,
  ) async {
    try {
      final updates = <String, dynamic>{};
      for (final participantId in participantIds) {
        if (participantId != excludeUserId) {
          updates['unreadCounts.$participantId'] = FieldValue.increment(1);
        }
      }
      if (updates.isNotEmpty) {
        await _conversationsRef.doc(conversationId).update(updates);
      }
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to increment unread count', error: e);
    }
  }

  Future<void> resetUnreadCount(String conversationId, String userId) async {
    try {
      await _conversationsRef.doc(conversationId).update({
        'unreadCounts.$userId': 0,
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to reset unread count', error: e);
    }
  }

  Future<void> deleteConversation(String id) async {
    try {
      await _conversationsRef.doc(id).delete();
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to delete conversation', error: e);
      throw ServerException(
          message: e.message ?? 'Failed to delete conversation');
    }
  }

  Future<void> addParticipant(
    String conversationId,
    String userId,
    ParticipantInfo info,
  ) async {
    try {
      await _conversationsRef.doc(conversationId).update({
        'participantIds': FieldValue.arrayUnion([userId]),
        'participantDetails.$userId': {
          'displayName': info.displayName,
          'photoUrl': info.photoUrl,
        },
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to add participant', error: e);
      throw ServerException(message: e.message ?? 'Failed to add participant');
    }
  }

  Future<void> removeParticipant(String conversationId, String userId) async {
    try {
      await _conversationsRef.doc(conversationId).update({
        'participantIds': FieldValue.arrayRemove([userId]),
        'participantDetails.$userId': FieldValue.delete(),
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to remove participant', error: e);
      throw ServerException(
          message: e.message ?? 'Failed to remove participant');
    }
  }
}
