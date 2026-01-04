import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/entities/entities.dart';

/// Data model for Firestore serialization
/// Separate from UserEntity to maintain clean architecture boundaries
class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final String? bio;
  final DateTime createdAt;
  final DateTime? lastSeen;
  final bool isOnline;
  final UserSettingsModel settings;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.bio,
    required this.createdAt,
    this.lastSeen,
    this.isOnline = false,
    this.settings = const UserSettingsModel(),
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? 'User',
      photoUrl: data['photoUrl'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      bio: data['bio'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastSeen: (data['lastSeen'] as Timestamp?)?.toDate(),
      isOnline: data['isOnline'] as bool? ?? false,
      settings: data['settings'] != null
          ? UserSettingsModel.fromMap(data['settings'] as Map<String, dynamic>)
          : const UserSettingsModel(),
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      phoneNumber: entity.phoneNumber,
      bio: entity.bio,
      createdAt: entity.createdAt,
      lastSeen: entity.lastSeen,
      isOnline: entity.isOnline,
      settings: UserSettingsModel.fromEntity(entity.settings),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
      'isOnline': isOnline,
      'settings': settings.toMap(),
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      bio: bio,
      createdAt: createdAt,
      lastSeen: lastSeen,
      isOnline: isOnline,
      settings: settings.toEntity(),
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? bio,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isOnline,
    UserSettingsModel? settings,
  }) {
    return UserModel(
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
}

class UserSettingsModel {
  final bool notificationsEnabled;
  final bool showOnlineStatus;
  final bool readReceipts;

  const UserSettingsModel({
    this.notificationsEnabled = true,
    this.showOnlineStatus = true,
    this.readReceipts = true,
  });

  factory UserSettingsModel.fromMap(Map<String, dynamic> map) {
    return UserSettingsModel(
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      showOnlineStatus: map['showOnlineStatus'] as bool? ?? true,
      readReceipts: map['readReceipts'] as bool? ?? true,
    );
  }

  factory UserSettingsModel.fromEntity(UserSettings entity) {
    return UserSettingsModel(
      notificationsEnabled: entity.notificationsEnabled,
      showOnlineStatus: entity.showOnlineStatus,
      readReceipts: entity.readReceipts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'showOnlineStatus': showOnlineStatus,
      'readReceipts': readReceipts,
    };
  }

  UserSettings toEntity() {
    return UserSettings(
      notificationsEnabled: notificationsEnabled,
      showOnlineStatus: showOnlineStatus,
      readReceipts: readReceipts,
    );
  }
}
