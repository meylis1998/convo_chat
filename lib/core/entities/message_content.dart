import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_content.freezed.dart';
part 'message_content.g.dart';

@freezed
sealed class MessageContent with _$MessageContent {
  const factory MessageContent({
    String? text,
    String? mediaUrl,
    String? thumbnailUrl,
    String? fileName,
    int? fileSize,
    String? mimeType,
    int? duration,
    int? width,
    int? height,
  }) = _MessageContent;

  const MessageContent._();

  factory MessageContent.fromJson(Map<String, dynamic> json) =>
      _$MessageContentFromJson(json);

}
