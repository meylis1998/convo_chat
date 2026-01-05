import 'package:injectable/injectable.dart';

import 'rtdb_presence_service.dart';

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

/// Service for watching user presence status.
/// Delegates to RtdbPresenceService for reliable presence detection.
@lazySingleton
class PresenceService {
  final RtdbPresenceService _rtdbPresenceService;

  PresenceService(this._rtdbPresenceService);

  /// Watch a single user's presence status
  Stream<UserPresence> watchUserPresence(String userId) {
    return _rtdbPresenceService.watchUserPresence(userId);
  }

  /// Watch presence for multiple users at once
  /// Returns a map of userId -> UserPresence
  Stream<Map<String, UserPresence>> watchMultipleUsersPresence(
    List<String> userIds,
  ) {
    return _rtdbPresenceService.watchMultipleUsersPresence(userIds);
  }
}
