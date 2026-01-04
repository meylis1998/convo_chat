import 'package:flutter/material.dart';

import '../extensions/datetime_extensions.dart';
import '../entities/entities.dart';
import '../theme/app_colors.dart';
import 'user_avatar.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;
  final bool showAvatar;
  final bool showSenderName;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onReplyTap;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.showAvatar = false,
    this.showSenderName = false,
    this.onTap,
    this.onLongPress,
    this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: isMe ? 64 : 8,
        right: isMe ? 8 : 64,
        top: 2,
        bottom: 2,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && showAvatar) ...[
            UserAvatar(
              name: message.senderName,
              imageUrl: message.senderPhotoUrl,
              size: 28,
            ),
            const SizedBox(width: 8),
          ] else if (!isMe) ...[
            const SizedBox(width: 36),
          ],
          Flexible(
            child: GestureDetector(
              onTap: onTap,
              onLongPress: onLongPress,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isMe
                      ? (isDark
                          ? AppColors.sentBubbleDark
                          : AppColors.sentBubble)
                      : (isDark
                          ? AppColors.receivedBubbleDark
                          : AppColors.receivedBubble),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isMe ? 16 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showSenderName && !isMe) ...[
                      Text(
                        message.senderName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isMe
                              ? Colors.white70
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (message.replyTo != null) ...[
                      _buildReplyPreview(context),
                      const SizedBox(height: 4),
                    ],
                    _buildContent(context),
                    const SizedBox(height: 2),
                    _buildFooter(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyPreview(BuildContext context) {
    final reply = message.replyTo!;
    return GestureDetector(
      onTap: onReplyTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isMe ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reply.senderName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isMe ? Colors.white70 : AppColors.grey600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _getReplyPreviewText(reply),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: isMe ? Colors.white60 : AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getReplyPreviewText(ReplyInfo reply) {
    switch (reply.type) {
      case MessageType.text:
        return reply.text ?? '';
      case MessageType.image:
        return '📷 Photo';
      case MessageType.video:
        return '🎥 Video';
      case MessageType.file:
        return '📎 File';
      case MessageType.voice:
        return '🎤 Voice message';
      case MessageType.system:
        return reply.text ?? '';
    }
  }

  Widget _buildContent(BuildContext context) {
    if (message.isDeleted) {
      return Text(
        'This message was deleted',
        style: TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: isMe ? Colors.white60 : AppColors.grey400,
        ),
      );
    }

    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content.text ?? '',
          style: TextStyle(
            fontSize: 15,
            color: isMe ? Colors.white : AppColors.grey900,
          ),
        );
      case MessageType.image:
        return _buildImageContent(context);
      case MessageType.video:
        return _buildVideoContent(context);
      case MessageType.voice:
        return _buildVoiceContent(context);
      case MessageType.file:
        return _buildFileContent(context);
      case MessageType.system:
        return Text(
          message.content.text ?? '',
          style: TextStyle(
            fontSize: 13,
            fontStyle: FontStyle.italic,
            color: isMe ? Colors.white70 : AppColors.grey500,
          ),
        );
    }
  }

  Widget _buildImageContent(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        message.content.mediaUrl!,
        width: 200,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 200,
            height: 150,
            color: AppColors.grey200,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 200,
            height: 150,
            color: AppColors.grey200,
            child: const Icon(Icons.broken_image, color: AppColors.grey400),
          );
        },
      ),
    );
  }

  Widget _buildVideoContent(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (message.content.thumbnailUrl != null)
            Image.network(
              message.content.thumbnailUrl!,
              width: 200,
              fit: BoxFit.cover,
            )
          else
            Container(
              width: 200,
              height: 150,
              color: AppColors.grey800,
            ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 32,
            ),
          ),
          if (message.content.duration != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatDuration(message.content.duration!),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVoiceContent(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.play_circle_fill,
          color: isMe ? Colors.white : AppColors.primary,
          size: 36,
        ),
        const SizedBox(width: 8),
        Container(
          width: 120,
          height: 24,
          decoration: BoxDecoration(
            color: isMe ? Colors.white24 : AppColors.grey300,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatDuration(message.content.duration ?? 0),
          style: TextStyle(
            fontSize: 12,
            color: isMe ? Colors.white70 : AppColors.grey500,
          ),
        ),
      ],
    );
  }

  Widget _buildFileContent(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isMe ? Colors.white24 : AppColors.grey200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.insert_drive_file,
            color: isMe ? Colors.white : AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.content.fileName ?? 'File',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isMe ? Colors.white : AppColors.grey900,
                ),
              ),
              if (message.content.fileSize != null)
                Text(
                  _formatFileSize(message.content.fileSize!),
                  style: TextStyle(
                    fontSize: 12,
                    color: isMe ? Colors.white70 : AppColors.grey500,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message.createdAt.formattedTime,
          style: TextStyle(
            fontSize: 11,
            color: isMe ? Colors.white60 : AppColors.grey400,
          ),
        ),
        if (message.isEdited) ...[
          const SizedBox(width: 4),
          Text(
            '(edited)',
            style: TextStyle(
              fontSize: 11,
              color: isMe ? Colors.white60 : AppColors.grey400,
            ),
          ),
        ],
        if (isMe) ...[
          const SizedBox(width: 4),
          _buildStatusIcon(),
        ],
      ],
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;

    switch (message.status) {
      case MessageStatus.sending:
        icon = Icons.access_time;
        color = Colors.white60;
        break;
      case MessageStatus.sent:
        icon = Icons.check;
        color = Colors.white70;
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = Colors.white70;
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = Colors.lightBlueAccent;
        break;
      case MessageStatus.failed:
        icon = Icons.error_outline;
        color = AppColors.error;
        break;
    }

    return Icon(icon, size: 14, color: color);
  }

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
