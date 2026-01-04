import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/conversation_tile.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/conversations_bloc.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ConversationsBloc>(),
      child: const _ConversationsView(),
    );
  }
}

class _ConversationsView extends StatefulWidget {
  const _ConversationsView();

  @override
  State<_ConversationsView> createState() => _ConversationsViewState();
}

class _ConversationsViewState extends State<_ConversationsView> {
  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  void _loadConversations() {
    final user = context.read<AuthBloc>().state.user;
    if (user != null) {
      context.read<ConversationsBloc>().add(LoadConversations(user.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocConsumer<ConversationsBloc, ConversationsState>(
        listener: (context, state) {
          if (state.createdConversationId != null) {
            context.go('/chat/${state.createdConversationId}');
          }
          if (state.errorMessage != null) {
            context.showErrorSnackBar(state.errorMessage!);
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.conversations.isEmpty) {
            return const Center(child: LoadingIndicator(size: 40));
          }

          if (state.isEmpty) {
            return _buildEmptyState();
          }

          return _buildConversationsList(state);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewChatOptions(context),
        child: const Icon(Icons.chat),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Chats'),
      leading: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: UserAvatar(
              name: state.user?.displayName ?? 'User',
              imageUrl: state.user?.photoUrl,
              size: 36,
              onTap: () => _showProfileMenu(context),
            ),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => context.go('/search'),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppColors.grey300,
          ),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: context.textTheme.titleMedium?.copyWith(
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a new chat to get going',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.grey400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsList(ConversationsState state) {
    final user = context.read<AuthBloc>().state.user;
    if (user == null) return const SizedBox.shrink();

    return RefreshIndicator(
      onRefresh: () async => _loadConversations(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.conversations.length,
        separatorBuilder: (context, index) => const Divider(
          indent: 76,
          height: 1,
        ),
        itemBuilder: (context, index) {
          final conversation = state.conversations[index];
          return ConversationTile(
            conversation: conversation,
            currentUserId: user.uid,
            onTap: () => context.go('/chat/${conversation.id}'),
            onLongPress: () => _showConversationOptions(context, conversation.id),
          );
        },
      ),
    );
  }

  void _showNewChatOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('New Chat'),
              subtitle: const Text('Start a private conversation'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to user search
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('New Group'),
              subtitle: const Text('Create a group chat'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to group creation
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showConversationOptions(BuildContext context, String conversationId) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.push_pin_outlined),
              title: const Text('Pin conversation'),
              onTap: () {
                Navigator.pop(ctx);
                // TODO: Implement pin
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off_outlined),
              title: const Text('Mute notifications'),
              onTap: () {
                Navigator.pop(ctx);
                // TODO: Implement mute
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive_outlined),
              title: const Text('Archive'),
              onTap: () {
                Navigator.pop(ctx);
                // TODO: Implement archive
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: AppColors.error),
              title: Text('Delete', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context, conversationId);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String conversationId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Conversation'),
        content: const Text(
          'Are you sure you want to delete this conversation? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<ConversationsBloc>()
                  .add(DeleteConversation(conversationId));
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return ListTile(
                  leading: UserAvatar(
                    name: state.user?.displayName ?? 'User',
                    imageUrl: state.user?.photoUrl,
                    size: 48,
                  ),
                  title: Text(state.user?.displayName ?? 'User'),
                  subtitle: Text(state.user?.email ?? ''),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(ctx);
                // TODO: Navigate to profile
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(ctx);
                // TODO: Navigate to settings
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.error),
              title: Text('Sign Out', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(ctx);
                // Cancel Firestore listeners before signing out to avoid permission errors
                context.read<ConversationsBloc>().add(const StopWatchingConversations());
                context.read<AuthBloc>().add(const SignOutRequested());
              },
            ),
          ],
        ),
      ),
    );
  }
}
