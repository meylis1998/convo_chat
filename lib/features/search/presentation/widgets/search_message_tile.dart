import 'package:flutter/material.dart';

import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../domain/entities/message_entity.dart';
import '../../../../presentation/theme/app_colors.dart';
import '../../../../presentation/widgets/user_avatar.dart';
import '../bloc/search_bloc.dart';

class SearchMessageTile extends StatelessWidget {
  final MessageSearchResult result;
  final String? highlightQuery;
  final VoidCallback? onTap;

  const SearchMessageTile({
    super.key,
    required this.result,
    this.highlightQuery,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final message = result.message;

    return ListTile(
      onTap: onTap,
      leading: UserAvatar(
        name: message.senderName,
        imageUrl: message.senderPhotoUrl,
        size: 44,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              result.conversationName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            message.createdAt.chatTimestamp,
            style: const TextStyle(
              color: AppColors.grey400,
              fontSize: 12,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            message.senderName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.grey600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          _buildMessagePreview(context),
        ],
      ),
      isThreeLine: true,
    );
  }

  Widget _buildMessagePreview(BuildContext context) {
    final message = result.message;

    if (message.type != MessageType.text) {
      return Row(
        children: [
          Icon(
            _getMessageTypeIcon(message.type),
            size: 14,
            color: AppColors.grey400,
          ),
          const SizedBox(width: 4),
          Text(
            _getMessageTypeText(message.type),
            style: const TextStyle(
              color: AppColors.grey400,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }

    final text = message.content.text ?? '';

    if (highlightQuery == null || highlightQuery!.isEmpty) {
      return Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.grey500,
          fontSize: 13,
        ),
      );
    }

    // Highlight matching text
    return _buildHighlightedText(text, highlightQuery!);
  }

  Widget _buildHighlightedText(String text, String query) {
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.grey500,
          fontSize: 13,
        ),
      );
    }

    final before = text.substring(0, index);
    final match = text.substring(index, index + query.length);
    final after = text.substring(index + query.length);

    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: const TextStyle(
          color: AppColors.grey500,
          fontSize: 13,
        ),
        children: [
          TextSpan(text: before),
          TextSpan(
            text: match,
            style: const TextStyle(
              backgroundColor: Color(0xFFFFEB3B),
              color: AppColors.grey900,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }

  IconData _getMessageTypeIcon(MessageType type) {
    switch (type) {
      case MessageType.image:
        return Icons.photo;
      case MessageType.video:
        return Icons.videocam;
      case MessageType.voice:
        return Icons.mic;
      case MessageType.file:
        return Icons.insert_drive_file;
      case MessageType.system:
        return Icons.info;
      case MessageType.text:
        return Icons.chat_bubble;
    }
  }

  String _getMessageTypeText(MessageType type) {
    switch (type) {
      case MessageType.image:
        return 'Photo';
      case MessageType.video:
        return 'Video';
      case MessageType.voice:
        return 'Voice message';
      case MessageType.file:
        return 'File';
      case MessageType.system:
        return 'System message';
      case MessageType.text:
        return 'Message';
    }
  }
}
