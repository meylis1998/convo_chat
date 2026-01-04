import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_metadata.freezed.dart';
part 'group_metadata.g.dart';

@freezed
sealed class GroupMetadata with _$GroupMetadata {
  const factory GroupMetadata({
    required String name,
    String? description,
    String? photoUrl,
    required List<String> adminIds,
    required String createdBy,
  }) = _GroupMetadata;

  const GroupMetadata._();

  factory GroupMetadata.fromJson(Map<String, dynamic> json) =>
      _$GroupMetadataFromJson(json);

  bool isAdmin(String userId) => adminIds.contains(userId);
}
