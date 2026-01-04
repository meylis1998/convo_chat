import 'package:flutter/material.dart';

import '../extensions/datetime_extensions.dart';
import '../entities/conversation_entity.dart';
import '../theme/app_colors.dart';
import 'user_avatar.dart';

class ConversationTile extends StatelessWidget {
  final ConversationEntity conversation;
  final String currentUserId;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.currentUserId,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = conversation.getDisplayName(currentUserId);
    final displayPhoto = conversation.getDisplayPhoto(currentUserId);
    final unreadCount = conversation.getUnreadCount(currentUserId);
    final typingUsers = conversation.getTypingUserNames(currentUserId);

    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      leading: UserAvatar(
        name: displayName,
        imageUrl: displayPhoto,
        size: 52,
        showOnlineIndicator: conversation.isDirect,
        isOnline: false,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight:
                    unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          if (conversation.lastMessage != null)
            Text(
              conversation.lastMessage!.timestamp.conversationTimestamp,
              style: TextStyle(
                fontSize: 12,
                color: unreadCount > 0 ? AppColors.primary : AppColors.grey400,
                fontWeight:
                    unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: typingUsers.isNotEmpty
                ? _buildTypingIndicator(typingUsers)
                : _buildLastMessage(context),
          ),
          if (unreadCount > 0) ...[
            const SizedBox(width: 8),
            _buildUnreadBadge(unreadCount),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(List<String> typingUsers) {
    final text = typingUsers.length == 1
        ? '${typingUsers.first} is typing...'
        : '${typingUsers.length} people are typing...';

    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: AppColors.primary,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildLastMessage(BuildContext context) {
    if (conversation.lastMessage == null) {
      return const Text(
        'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: AppColors.grey400),
      );
    }

    final lastMessage = conversation.lastMessage!;
    final isMe = lastMessage.senderId == currentUserId;
    final prefix = conversation.isGroup && !isMe ? '${lastMessage.senderName}: ' : '';

    return Row(
      children: [
        if (isMe) ...[
          const Icon(
            Icons.done_all,
            size: 16,
            color: AppColors.grey400,
          ),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Text(
            '$prefix${lastMessage.preview}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.grey500),
          ),
        ),
      ],
    );
  }

  Widget _buildUnreadBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
