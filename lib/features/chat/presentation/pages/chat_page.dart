import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/entities/entities.dart';
import '../../../../core/services/presence_service.dart';
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
  final Set<String> _markedAsReadIds = {};
  final Set<String> _animatedMessageIds = {};
  bool _showNewMessageButton = false;
  int _previousMessageCount = 0;
  late final ChatBloc _chatBloc;
  Timer? _lastSeenRefreshTimer;

  @override
  void initState() {
    super.initState();
    _chatBloc = context.read<ChatBloc>();
    _scrollController.addListener(_onScroll);
    _loadChat();
    _startLastSeenRefreshTimer();
  }

  void _startLastSeenRefreshTimer() {
    _lastSeenRefreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => setState(() {}),
    );
  }

  bool get _isNearBottom {
    if (!_scrollController.hasClients) return true;
    return _scrollController.offset < 100;
  }

  void _onScroll() {
    if (_isNearBottom && _showNewMessageButton) {
      setState(() => _showNewMessageButton = false);
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    setState(() => _showNewMessageButton = false);
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
    _lastSeenRefreshTimer?.cancel();
    // Clear typing status and stop watching before disposing
    _chatBloc.add(const UpdateTypingStatus(false));
    _chatBloc.add(const StopWatchingChat());
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
    final currentUser = context.read<AuthBloc>().state.user;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: reactions.map((emoji) {
              final hasReacted = message.reactions[emoji]
                      ?.contains(currentUser?.uid) ??
                  false;

              return GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  if (hasReacted) {
                    context.read<ChatBloc>().add(RemoveReaction(
                          messageId: message.id,
                          emoji: emoji,
                        ));
                  } else {
                    context.read<ChatBloc>().add(AddReaction(
                          messageId: message.id,
                          emoji: emoji,
                        ));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: hasReacted
                      ? BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: Text(emoji, style: const TextStyle(fontSize: 32)),
                ),
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
              final newText = controller.text.trim();
              if (newText.isEmpty) {
                return;
              }
              Navigator.pop(ctx);
              context.read<ChatBloc>().add(EditMessage(
                    messageId: message.id,
                    newText: newText,
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

          // Detect new message from another user while scrolled up
          if (state.messages.length > _previousMessageCount &&
              _previousMessageCount > 0) {
            final newestMessage = state.messages.first;
            final currentUser = context.read<AuthBloc>().state.user;
            final isFromOther = newestMessage.senderId != currentUser?.uid;

            if (isFromOther && !_isNearBottom) {
              setState(() => _showNewMessageButton = true);
            }
          }
          _previousMessageCount = state.messages.length;
        },
        builder: (context, state) {
          if (state.isLoading && state.messages.isEmpty) {
            return const Center(child: LoadingIndicator(size: 40));
          }

          return Column(
            children: [
              Expanded(child: _buildMessagesList(state)),
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

          // For direct conversations, stream the other user's presence
          if (state.conversation!.isDirect) {
            final otherUserId =
                state.conversation!.getOtherParticipantId(currentUser?.uid ?? '');
            if (otherUserId != null) {
              return StreamBuilder<UserPresence>(
                stream: getIt<PresenceService>().watchUserPresence(otherUserId),
                builder: (context, snapshot) {
                  final presence = snapshot.data;
                  final isOnline = presence?.isOnline ?? false;
                  final lastSeen = presence?.lastSeen;

                  return _buildAppBarContent(
                    displayName: displayName,
                    displayPhoto: displayPhoto,
                    isOnline: isOnline,
                    lastSeen: lastSeen,
                    showOnlineIndicator: true,
                    typingUserNames: state.typingUserNames,
                  );
                },
              );
            }
          }

          // For group conversations, no online indicator
          return _buildAppBarContent(
            displayName: displayName,
            displayPhoto: displayPhoto,
            isOnline: false,
            lastSeen: null,
            showOnlineIndicator: false,
            typingUserNames: state.typingUserNames,
            participantCount: state.conversation!.participantIds.length,
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

  Widget _buildAppBarContent({
    required String displayName,
    required String? displayPhoto,
    required bool isOnline,
    required DateTime? lastSeen,
    required bool showOnlineIndicator,
    required List<String> typingUserNames,
    int? participantCount,
  }) {
    return Row(
      children: [
        UserAvatar(
          name: displayName,
          imageUrl: displayPhoto,
          size: 36,
          showOnlineIndicator: showOnlineIndicator,
          isOnline: isOnline,
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
              _buildSubtitle(
                typingUserNames: typingUserNames,
                isOnline: isOnline,
                lastSeen: lastSeen,
                showOnlineIndicator: showOnlineIndicator,
                participantCount: participantCount,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle({
    required List<String> typingUserNames,
    required bool isOnline,
    required DateTime? lastSeen,
    required bool showOnlineIndicator,
    int? participantCount,
  }) {
    // Priority 1: Typing indicator
    if (typingUserNames.isNotEmpty) {
      return Text(
        typingUserNames.length == 1
            ? '${typingUserNames.first} is typing...'
            : '${typingUserNames.length} people are typing...',
        style: context.textTheme.bodySmall?.copyWith(
          color: AppColors.primary,
        ),
      );
    }

    // Priority 2: For direct chats - online status or last seen
    if (showOnlineIndicator) {
      if (isOnline) {
        return Text(
          'Online',
          style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.online,
          ),
        );
      } else if (lastSeen != null) {
        return Text(
          lastSeen.lastSeenFormatted,
          style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.grey500,
          ),
        );
      }
    }

    // Priority 3: For group chats - show member count
    if (participantCount != null) {
      return Text(
        '$participantCount members',
        style: context.textTheme.bodySmall?.copyWith(
          color: AppColors.grey500,
        ),
      );
    }

    return const SizedBox.shrink();
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

    return Stack(
      children: [
        ListView.builder(
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

            // Skip animation for messages that have already been animated
            final alreadyAnimated = _animatedMessageIds.contains(message.id);

            return _AnimatedMessageBubble(
              key: Key('animated_${message.id}'),
              message: message,
              isMe: isMe,
              showAvatar: showAvatar,
              showSenderName: showSenderName,
              skipAnimation: alreadyAnimated,
              onAnimationComplete: () => _animatedMessageIds.add(message.id),
              onLongPress: () => _showMessageOptions(message),
              onDoubleTap: () {
                _setReplyTo(message);
                _focusNode.requestFocus();
              },
              onVisible: !isMe && !message.readBy.containsKey(currentUser?.uid)
                  ? () {
                      if (!_markedAsReadIds.contains(message.id)) {
                        _markedAsReadIds.add(message.id);
                        context.read<ChatBloc>().add(MarkMessageAsRead(message.id));
                      }
                    }
                  : null,
            );
          },
        ),
        if (_showNewMessageButton)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: _buildNewMessageButton(),
            ),
          ),
      ],
    );
  }

  Widget _buildNewMessageButton() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(20),
      color: AppColors.primary,
      child: InkWell(
        onTap: _scrollToBottom,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_downward,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'New message',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
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

class _AnimatedMessageBubble extends StatefulWidget {
  final MessageEntity message;
  final bool isMe;
  final bool showAvatar;
  final bool showSenderName;
  final VoidCallback onLongPress;
  final VoidCallback onDoubleTap;
  final VoidCallback? onVisible;
  final bool skipAnimation;
  final VoidCallback? onAnimationComplete;

  const _AnimatedMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.showAvatar,
    required this.showSenderName,
    required this.onLongPress,
    required this.onDoubleTap,
    this.onVisible,
    this.skipAnimation = false,
    this.onAnimationComplete,
  });

  @override
  State<_AnimatedMessageBubble> createState() => _AnimatedMessageBubbleState();
}

class _AnimatedMessageBubbleState extends State<_AnimatedMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(widget.isMe ? 0.1 : -0.1, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Skip animation for already-seen messages
    if (widget.skipAnimation) {
      _hasAnimated = true;
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.3 && !_hasAnimated) {
      _hasAnimated = true;
      _controller.forward();
      widget.onVisible?.call();
      widget.onAnimationComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('visibility_${widget.message.id}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: child,
              ),
            ),
          );
        },
        child: MessageBubble(
          message: widget.message,
          isMe: widget.isMe,
          showAvatar: widget.showAvatar,
          showSenderName: widget.showSenderName,
          onLongPress: widget.onLongPress,
          onDoubleTap: widget.onDoubleTap,
        ),
      ),
    );
  }
}
