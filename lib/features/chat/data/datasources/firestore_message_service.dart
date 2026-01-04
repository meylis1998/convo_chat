import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/message_model.dart';

@lazySingleton
class FirestoreMessageService {
  final FirebaseFirestore _firestore;

  FirestoreMessageService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _messagesRef(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');
  }

  Stream<List<MessageModel>> watchMessages(
    String conversationId, {
    int limit = 50,
  }) {
    return _messagesRef(conversationId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc))
            .toList());
  }

  Future<List<MessageModel>> getMessages(
    String conversationId, {
    DocumentSnapshot? lastDocument,
    int limit = 50,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _messagesRef(conversationId)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to get messages', error: e);
      throw ServerException(message: e.message ?? 'Failed to get messages');
    }
  }

  Future<MessageModel?> getMessage(
      String conversationId, String messageId) async {
    try {
      final doc = await _messagesRef(conversationId).doc(messageId).get();
      if (!doc.exists) return null;
      return MessageModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to get message', error: e);
      throw ServerException(message: e.message ?? 'Failed to get message');
    }
  }

  Future<String> sendMessage(MessageModel message) async {
    try {
      AppLogger.firebase('Sending message to ${message.conversationId}');
      final docRef =
          await _messagesRef(message.conversationId).add(message.toFirestore());
      AppLogger.firebase('Message sent: ${docRef.id}');
      return docRef.id;
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to send message', error: e);
      throw ServerException(message: e.message ?? 'Failed to send message');
    }
  }

  Future<void> updateMessage(
    String conversationId,
    String messageId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _messagesRef(conversationId).doc(messageId).update(data);
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to update message', error: e);
      throw ServerException(message: e.message ?? 'Failed to update message');
    }
  }

  Future<void> editMessage(
    String conversationId,
    String messageId,
    String newText,
  ) async {
    try {
      await _messagesRef(conversationId).doc(messageId).update({
        'content.text': newText,
        'editedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to edit message', error: e);
      throw ServerException(message: e.message ?? 'Failed to edit message');
    }
  }

  Future<void> deleteMessage(String conversationId, String messageId) async {
    try {
      await _messagesRef(conversationId).doc(messageId).update({
        'isDeleted': true,
        'deletedAt': FieldValue.serverTimestamp(),
        'content.text': 'This message was deleted',
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to delete message', error: e);
      throw ServerException(message: e.message ?? 'Failed to delete message');
    }
  }

  Future<void> addReaction(
    String conversationId,
    String messageId,
    String userId,
    String emoji,
  ) async {
    try {
      await _messagesRef(conversationId).doc(messageId).update({
        'reactions.$emoji': FieldValue.arrayUnion([userId]),
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to add reaction', error: e);
      throw ServerException(message: e.message ?? 'Failed to add reaction');
    }
  }

  Future<void> removeReaction(
    String conversationId,
    String messageId,
    String userId,
    String emoji,
  ) async {
    try {
      await _messagesRef(conversationId).doc(messageId).update({
        'reactions.$emoji': FieldValue.arrayRemove([userId]),
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to remove reaction', error: e);
      throw ServerException(message: e.message ?? 'Failed to remove reaction');
    }
  }

  Future<void> markAsRead(
    String conversationId,
    String messageId,
    String userId,
  ) async {
    try {
      await _messagesRef(conversationId).doc(messageId).update({
        'readBy.$userId': FieldValue.serverTimestamp(),
        'status': 'read',
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to mark as read', error: e);
    }
  }

  Future<void> markMultipleAsRead(
    String conversationId,
    List<String> messageIds,
    String userId,
  ) async {
    if (messageIds.isEmpty) return;

    try {
      final batch = _firestore.batch();
      for (final messageId in messageIds) {
        final docRef = _messagesRef(conversationId).doc(messageId);
        batch.update(docRef, {
          'readBy.$userId': FieldValue.serverTimestamp(),
          'status': 'read',
        });
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to mark messages as read', error: e);
    }
  }

  Future<void> markAsDelivered(
    String conversationId,
    String messageId,
    String userId,
  ) async {
    try {
      await _messagesRef(conversationId).doc(messageId).update({
        'deliveredTo.$userId': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to mark as delivered', error: e);
    }
  }

  Future<List<MessageModel>> searchMessages(
    String conversationId,
    String query,
  ) async {
    try {
      // Note: Firestore doesn't support full-text search natively
      // This is a basic implementation - consider Algolia for production
      final snapshot = await _messagesRef(conversationId)
          .where('content.text', isGreaterThanOrEqualTo: query)
          .where('content.text', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(50)
          .get();

      return snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to search messages', error: e);
      throw ServerException(message: e.message ?? 'Failed to search messages');
    }
  }
}
