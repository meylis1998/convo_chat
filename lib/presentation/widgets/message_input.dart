import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback onSend;
  final VoidCallback? onAttachmentTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onVoiceStart;
  final VoidCallback? onVoiceEnd;
  final VoidCallback? onVoiceCancel;
  final ValueChanged<String>? onChanged;
  final Widget? replyWidget;
  final VoidCallback? onCancelReply;
  final bool isRecording;
  final String? recordingDuration;

  const MessageInput({
    super.key,
    required this.controller,
    this.focusNode,
    required this.onSend,
    this.onAttachmentTap,
    this.onCameraTap,
    this.onVoiceStart,
    this.onVoiceEnd,
    this.onVoiceCancel,
    this.onChanged,
    this.replyWidget,
    this.onCancelReply,
    this.isRecording = false,
    this.recordingDuration,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  bool get hasText => widget.controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
    widget.onChanged?.call(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.replyWidget != null) _buildReplyBar(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: widget.isRecording
                  ? _buildRecordingBar()
                  : _buildInputBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        border: Border(
          bottom: BorderSide(color: AppColors.grey200),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: widget.replyWidget!),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: widget.onCancelReply,
            color: AppColors.grey500,
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: widget.onAttachmentTap,
          color: AppColors.grey500,
        ),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 120),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Message',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: widget.onCameraTap,
                  color: AppColors.grey500,
                  iconSize: 22,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: hasText
              ? _buildSendButton()
              : _buildVoiceButton(),
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return Container(
      key: const ValueKey('send'),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.send),
        onPressed: () {
          if (hasText) {
            widget.onSend();
          }
        },
        color: AppColors.white,
        iconSize: 22,
      ),
    );
  }

  Widget _buildVoiceButton() {
    return GestureDetector(
      key: const ValueKey('voice'),
      onLongPressStart: (_) => widget.onVoiceStart?.call(),
      onLongPressEnd: (_) => widget.onVoiceEnd?.call(),
      onLongPressCancel: () => widget.onVoiceCancel?.call(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.mic,
          color: AppColors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildRecordingBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            widget.recordingDuration ?? '0:00',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Text(
            'Release to send, swipe to cancel',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.grey500,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: widget.onVoiceCancel,
            color: AppColors.error,
          ),
        ],
      ),
    );
  }
}
