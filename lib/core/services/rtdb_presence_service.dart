import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../utils/logger.dart';
import 'presence_service.dart';

/// Service for managing user presence using Firebase Realtime Database.
/// Uses onDisconnect() for reliable offline detection even on force-kill.
@lazySingleton
class RtdbPresenceService {
  final FirebaseDatabase _database;
  static const String _tag = 'RtdbPresence';

  RtdbPresenceService({FirebaseDatabase? database})
      : _database = database ?? FirebaseDatabase.instance;

  DatabaseReference _statusRef(String uid) => _database.ref('status/$uid');

  /// Sets the user as online and registers onDisconnect handler.
  /// The onDisconnect handler ensures offline status is set even if
  /// the app is force-killed or loses connection.
  Future<void> goOnline(String uid) async {
    try {
      AppLogger.firebase('Going online for user: $uid', tag: _tag);
      final statusRef = _statusRef(uid);

      final onlineData = {
        'isOnline': true,
        'lastChanged': ServerValue.timestamp,
      };

      final offlineData = {
        'isOnline': false,
        'lastChanged': ServerValue.timestamp,
      };

      // Set up onDisconnect FIRST, before setting online
      // This ensures if connection drops immediately, we still get set offline
      await statusRef.onDisconnect().set(offlineData);
      AppLogger.firebase('onDisconnect handler set for: $uid', tag: _tag);

      // Now set ourselves online
      await statusRef.set(onlineData);
      AppLogger.firebase('User $uid is now online', tag: _tag);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to go online for user: $uid',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Manually sets the user as offline.
  /// This is optional since onDisconnect handles it automatically.
  Future<void> goOffline(String uid) async {
    try {
      AppLogger.firebase('Going offline for user: $uid', tag: _tag);
      final statusRef = _statusRef(uid);

      final offlineData = {
        'isOnline': false,
        'lastChanged': ServerValue.timestamp,
      };

      // Cancel any pending onDisconnect since we're manually going offline
      await statusRef.onDisconnect().cancel();
      await statusRef.set(offlineData);
      AppLogger.firebase('User $uid is now offline', tag: _tag);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to go offline for user: $uid',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Watch a single user's presence status from RTDB.
  Stream<UserPresence> watchUserPresence(String userId) {
    return _statusRef(userId).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) {
        return UserPresence.offline();
      }

      final isOnline = data['isOnline'] as bool? ?? false;
      final lastChangedMs = data['lastChanged'] as int?;

      return UserPresence(
        isOnline: isOnline,
        lastSeen: lastChangedMs != null
            ? DateTime.fromMillisecondsSinceEpoch(lastChangedMs)
            : null,
      );
    }).handleError((error, stackTrace) {
      AppLogger.error(
        'Error watching presence for user: $userId',
        tag: _tag,
        error: error,
        stackTrace: stackTrace,
      );
      return UserPresence.offline();
    });
  }

  /// Watch presence for multiple users at once.
  /// Returns a map of userId -> UserPresence.
  Stream<Map<String, UserPresence>> watchMultipleUsersPresence(
    List<String> userIds,
  ) {
    if (userIds.isEmpty) {
      return Stream.value({});
    }

    // Create individual streams for each user and combine them
    final streams = userIds.map((userId) {
      return watchUserPresence(userId).map((presence) => MapEntry(userId, presence));
    }).toList();

    return Rx.combineLatest<MapEntry<String, UserPresence>, Map<String, UserPresence>>(
      streams,
      (entries) => Map.fromEntries(entries),
    );
  }
}
