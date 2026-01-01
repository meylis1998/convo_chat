import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final String? bio;
  final DateTime createdAt;
  final DateTime? lastSeen;
  final bool isOnline;
  final UserSettings settings;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.bio,
    required this.createdAt,
    this.lastSeen,
    this.isOnline = false,
    this.settings = const UserSettings(),
  });

  UserEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? bio,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isOnline,
    UserSettings? settings,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoUrl,
        phoneNumber,
        bio,
        createdAt,
        lastSeen,
        isOnline,
        settings,
      ];
}

class UserSettings extends Equatable {
  final bool notificationsEnabled;
  final bool showOnlineStatus;
  final bool readReceipts;

  const UserSettings({
    this.notificationsEnabled = true,
    this.showOnlineStatus = true,
    this.readReceipts = true,
  });

  UserSettings copyWith({
    bool? notificationsEnabled,
    bool? showOnlineStatus,
    bool? readReceipts,
  }) {
    return UserSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      readReceipts: readReceipts ?? this.readReceipts,
    );
  }

  @override
  List<Object?> get props => [
        notificationsEnabled,
        showOnlineStatus,
        readReceipts,
      ];
}
