import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/entities/entities.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/message_bubble.dart';
import '../../../../core/widgets/message_input.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/chat_bloc.dart';

class ChatPage extends StatelessWidget {
  final String conversationId;

  const ChatPage({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChatBloc>(),
      child: _ChatView(conversationId: conversationId),
    );
  }
}

class _ChatView extends StatefulWidget {
  final String conversationId;

  const _ChatView({required this.conversationId});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  void _loadChat() {
    final user = context.read<AuthBloc>().state.user;
    if (user != null) {
      context.read<ChatBloc>().add(LoadChat(
            conversationId: widget.conversationId,
            currentUser: user,
          ));
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatBloc>().add(SendTextMessage(text));
      _messageController.clear();
    }
  }

  void _onTextChanged(String text) {
    context.read<ChatBloc>().add(UpdateTypingStatus(text.isNotEmpty));
  }

  void _setReplyTo(MessageEntity message) {
    context.read<ChatBloc>().add(SetReplyTo(ReplyInfo(
          messageId: message.id,
          senderId: message.senderId,
          senderName: message.senderName,
          text: message.content.text,
          type: message.type,
        )));
  }

  void _showMessageOptions(MessageEntity message) {
    final currentUser = context.read<AuthBloc>().state.user;
    final isMe = message.senderId == currentUser?.uid;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Reply'),
              onTap: () {
                Navigator.pop(ctx);
                _setReplyTo(message);
                _focusNode.requestFocus();
              },
            ),
            ListTile(
              leading: const Icon(Icons.emoji_emotions_outlined),
              title: const Text('React'),
              onTap: () {
                Navigator.pop(ctx);
                _showReactionPicker(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () {
                Navigator.pop(ctx);
                // TODO: Copy to clipboard
              },
            ),
            if (isMe && message.type == MessageType.text) ...[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showEditDialog(message);
                },
              ),
            ],
            if (isMe)
              ListTile(
                leading: Icon(Icons.delete, color: AppColors.error),
                title: Text('Delete', style: TextStyle(color: AppColors.error)),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete(message);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showReactionPicker(MessageEntity message) {
    final reactions = ['👍', '❤️', '😂', '😮', '😢', '😡'];
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: reactions.map((emoji) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<ChatBloc>().add(AddReaction(
                        messageId: message.id,
                        emoji: emoji,
                      ));
                },
                child: Text(emoji, style: const TextStyle(fontSize: 32)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(MessageEntity message) {
    final controller = TextEditingController(text: message.content.text);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Message'),
        content: TextField(
          controller: controller,
          maxLines: null,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter new message',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ChatBloc>().add(EditMessage(
                    messageId: message.id,
                    newText: controller.text.trim(),
                  ));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(MessageEntity message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ChatBloc>().add(DeleteMessage(message.id));
            },
            child: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            context.showErrorSnackBar(state.errorMessage!);
          }
          if (state.status == ChatStatus.loaded && state.messages.isNotEmpty) {
            context.read<ChatBloc>().add(const MarkMessagesAsRead());
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.messages.isEmpty) {
            return const Center(child: LoadingIndicator(size: 40));
          }

          return Column(
            children: [
              Expanded(child: _buildMessagesList(state)),
              _buildTypingIndicator(state),
              _buildInput(state),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      title: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state.conversation == null) {
            return const SizedBox.shrink();
          }

          final currentUser = context.read<AuthBloc>().state.user;
          final displayName =
              state.conversation!.getDisplayName(currentUser?.uid ?? '');
          final displayPhoto =
              state.conversation!.getDisplayPhoto(currentUser?.uid ?? '');

          return Row(
            children: [
              UserAvatar(
                name: displayName,
                imageUrl: displayPhoto,
                size: 36,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: context.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (state.typingUserNames.isNotEmpty)
                      Text(
                        '${state.typingUserNames.first} is typing...',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // TODO: Show chat options
          },
        ),
      ],
    );
  }

  Widget _buildMessagesList(ChatState state) {
    if (state.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.grey300),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: context.textTheme.titleMedium?.copyWith(
                color: AppColors.grey500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Send a message to start the conversation',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.grey400,
              ),
            ),
          ],
        ),
      );
    }

    final currentUser = context.read<AuthBloc>().state.user;

    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        final isMe = message.senderId == currentUser?.uid;

        // Determine if we should show avatar and sender name
        final showAvatar = index == state.messages.length - 1 ||
            state.messages[index + 1].senderId != message.senderId;
        final showSenderName =
            state.conversation?.isGroup == true && !isMe && showAvatar;

        return MessageBubble(
          message: message,
          isMe: isMe,
          showAvatar: showAvatar,
          showSenderName: showSenderName,
          onLongPress: () => _showMessageOptions(message),
        );
      },
    );
  }

  Widget _buildTypingIndicator(ChatState state) {
    if (state.typingUserNames.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: _TypingDots(),
          ),
          const SizedBox(width: 8),
          Text(
            state.typingUserNames.length == 1
                ? '${state.typingUserNames.first} is typing...'
                : '${state.typingUserNames.length} people are typing...',
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.grey500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(ChatState state) {
    return MessageInput(
      controller: _messageController,
      focusNode: _focusNode,
      onSend: _sendMessage,
      onChanged: _onTextChanged,
      replyWidget: state.hasReply ? _buildReplyPreview(state) : null,
      onCancelReply: () => context.read<ChatBloc>().add(const ClearReplyTo()),
      onAttachmentTap: () {
        // TODO: Show attachment options
      },
      onCameraTap: () {
        // TODO: Open camera
      },
    );
  }

  Widget _buildReplyPreview(ChatState state) {
    final reply = state.replyTo!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          reply.senderName,
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          reply.text ?? _getTypePreview(reply.type),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.grey500,
          ),
        ),
      ],
    );
  }

  String _getTypePreview(MessageType type) {
    switch (type) {
      case MessageType.image:
        return '📷 Photo';
      case MessageType.video:
        return '🎥 Video';
      case MessageType.file:
        return '📎 File';
      case MessageType.voice:
        return '🎤 Voice message';
      default:
        return '';
    }
  }
}

class _TypingDots extends StatefulWidget {
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = (_controller.value + delay) % 1.0;
            final opacity = (0.3 + 0.7 * (1 - (value - 0.5).abs() * 2))
                .clamp(0.3, 1.0);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.grey400.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
