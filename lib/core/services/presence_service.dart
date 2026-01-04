import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

/// Represents a user's presence status
class UserPresence {
  final bool isOnline;
  final DateTime? lastSeen;

  const UserPresence({
    required this.isOnline,
    this.lastSeen,
  });

  factory UserPresence.offline() => const UserPresence(isOnline: false);
}

/// Service for watching user presence status
@lazySingleton
class PresenceService {
  final FirebaseFirestore _firestore;

  PresenceService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Watch a single user's presence status
  Stream<UserPresence> watchUserPresence(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (!doc.exists) {
        return UserPresence.offline();
      }

      final data = doc.data()!;
      final isOnline = data['isOnline'] as bool? ?? false;
      final lastSeenTimestamp = data['lastSeen'] as Timestamp?;

      return UserPresence(
        isOnline: isOnline,
        lastSeen: lastSeenTimestamp?.toDate(),
      );
    });
  }

  /// Watch presence for multiple users at once
  /// Returns a map of userId -> UserPresence
  Stream<Map<String, UserPresence>> watchMultipleUsersPresence(
    List<String> userIds,
  ) {
    if (userIds.isEmpty) {
      return Stream.value({});
    }

    // Firestore whereIn limit is 30, so chunk if needed
    if (userIds.length <= 30) {
      return _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds)
          .snapshots()
          .map((snapshot) {
        final result = <String, UserPresence>{};
        for (final doc in snapshot.docs) {
          final data = doc.data();
          final isOnline = data['isOnline'] as bool? ?? false;
          final lastSeenTimestamp = data['lastSeen'] as Timestamp?;

          result[doc.id] = UserPresence(
            isOnline: isOnline,
            lastSeen: lastSeenTimestamp?.toDate(),
          );
        }
        // Fill in offline for any missing users
        for (final userId in userIds) {
          result.putIfAbsent(userId, () => UserPresence.offline());
        }
        return result;
      });
    }

    // For larger lists, we'd need to merge multiple streams
    // For now, just take first 30
    return watchMultipleUsersPresence(userIds.take(30).toList());
  }
}
