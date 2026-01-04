import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant_info.freezed.dart';
part 'participant_info.g.dart';

@freezed
sealed class ParticipantInfo with _$ParticipantInfo {
  const factory ParticipantInfo({
    required String displayName,
    String? photoUrl,
  }) = _ParticipantInfo;

  factory ParticipantInfo.fromJson(Map<String, dynamic> json) =>
      _$ParticipantInfoFromJson(json);
}
