import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_settings.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
sealed class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String uid,
    required String email,
    required String displayName,
    String? photoUrl,
    String? phoneNumber,
    String? bio,
    required DateTime createdAt,
    DateTime? lastSeen,
    @Default(false) bool isOnline,
    @Default(UserSettings()) UserSettings settings,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
