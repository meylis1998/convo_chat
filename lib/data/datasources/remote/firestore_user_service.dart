import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/utils/logger.dart';
import '../../models/user_model.dart';

@lazySingleton
class FirestoreUserService {
  final FirebaseFirestore _firestore;

  static const String _collection = 'users';

  FirestoreUserService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection(_collection);

  Future<void> createUser(UserModel user) async {
    try {
      AppLogger.firebase('Creating user: ${user.uid}');
      await _usersRef.doc(user.uid).set(user.toFirestore());
      AppLogger.firebase('User created successfully');
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to create user', error: e);
      throw ServerException(message: e.message ?? 'Failed to create user');
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      AppLogger.firebase('Getting user: $uid');
      final doc = await _usersRef.doc(uid).get();
      if (!doc.exists) {
        AppLogger.firebase('User not found');
        return null;
      }
      return UserModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to get user', error: e);
      throw ServerException(message: e.message ?? 'Failed to get user');
    }
  }

  Stream<UserModel?> watchUser(String uid) {
    return _usersRef.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      AppLogger.firebase('Updating user: $uid');
      await _usersRef.doc(uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      AppLogger.firebase('User updated successfully');
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to update user', error: e);
      throw ServerException(message: e.message ?? 'Failed to update user');
    }
  }

  Future<void> updateOnlineStatus(String uid, bool isOnline) async {
    try {
      await _usersRef.doc(uid).update({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to update online status', error: e);
      throw ServerException(
          message: e.message ?? 'Failed to update online status');
    }
  }

  Future<void> addFcmToken(String uid, String token) async {
    try {
      await _usersRef.doc(uid).update({
        'fcmTokens': FieldValue.arrayUnion([token]),
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to add FCM token', error: e);
      throw ServerException(message: e.message ?? 'Failed to add FCM token');
    }
  }

  Future<void> removeFcmToken(String uid, String token) async {
    try {
      await _usersRef.doc(uid).update({
        'fcmTokens': FieldValue.arrayRemove([token]),
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to remove FCM token', error: e);
      throw ServerException(message: e.message ?? 'Failed to remove FCM token');
    }
  }

  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final results = await _usersRef
          .where('displayName', isGreaterThanOrEqualTo: query)
          .where('displayName', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(20)
          .get();

      return results.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to search users', error: e);
      throw ServerException(message: e.message ?? 'Failed to search users');
    }
  }

  Future<List<UserModel>> getUsersByIds(List<String> uids) async {
    if (uids.isEmpty) return [];

    try {
      final results = await _usersRef.where(FieldPath.documentId, whereIn: uids).get();
      return results.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to get users by IDs', error: e);
      throw ServerException(message: e.message ?? 'Failed to get users');
    }
  }
}
