import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.displayName,
    super.photoUrl,
    super.phoneNumber,
    super.bio,
    required super.createdAt,
    super.lastSeen,
    super.isOnline,
    super.settings,
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
          : const UserSettings(),
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
      settings: entity.settings,
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
      'settings': UserSettingsModel.fromEntity(settings).toMap(),
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
      settings: settings,
    );
  }
}

class UserSettingsModel extends UserSettings {
  const UserSettingsModel({
    super.notificationsEnabled,
    super.showOnlineStatus,
    super.readReceipts,
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
}
