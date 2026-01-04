import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/entities/conversation_entity.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/conversation_tile.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/search_bloc.dart';
import '../widgets/search_message_tile.dart';
import '../widgets/search_user_tile.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = getIt<SearchBloc>();

        // Set current user and load conversations
        final user = context.read<AuthBloc>().state.user;
        if (user != null) {
          bloc.add(InitializeSearch(user.uid));
        }

        return bloc;
      },
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });

    // Sync tab changes with BLoC
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final tab = SearchTab.values[_tabController.index];
        context.read<SearchBloc>().add(SearchTabChanged(tab));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<SearchBloc>().add(SearchQueryChanged(query));
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchBloc>().add(const ClearSearch());
    _searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state.hasError && state.errorMessage != null) {
            context.showErrorSnackBar(state.errorMessage!);
          }
          if (state.navigateToConversationId != null) {
            context.go('/chat/${state.navigateToConversationId}');
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildTabBar(state),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildUsersTab(state),
                    _buildConversationsTab(state),
                    _buildMessagesTab(state),
                  ],
                ),
              ),
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
      title: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search users, chats, messages...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: AppColors.grey400),
        ),
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state.hasQuery) {
              return IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearSearch,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildTabBar(SearchState state) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.grey200),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.grey500,
        indicatorColor: AppColors.primary,
        tabs: [
          _buildTab('Users', state.userCount),
          _buildTab('Chats', state.conversationCount),
          _buildTab('Messages', state.messageCount),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int count) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUsersTab(SearchState state) {
    if (state.isLoading) {
      return const Center(child: LoadingIndicator(size: 32));
    }

    if (!state.hasQuery) {
      return _buildInitialState(
        icon: Icons.person_search,
        message: 'Search for users to start a conversation',
      );
    }

    if (state.userResults.isEmpty) {
      return _buildEmptyState(
        icon: Icons.person_off_outlined,
        message: 'No users found',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.userResults.length,
      separatorBuilder: (context, index) => const Divider(indent: 72, height: 1),
      itemBuilder: (context, index) {
        final user = state.userResults[index];
        return SearchUserTile(
          user: user,
          onTap: () => _onUserSelected(user),
        );
      },
    );
  }

  Widget _buildConversationsTab(SearchState state) {
    if (state.isLoading) {
      return const Center(child: LoadingIndicator(size: 32));
    }

    if (!state.hasQuery) {
      return _buildInitialState(
        icon: Icons.chat_bubble_outline,
        message: 'Search your conversations',
      );
    }

    if (state.conversationResults.isEmpty) {
      return _buildEmptyState(
        icon: Icons.chat_bubble_outline,
        message: 'No conversations found',
      );
    }

    final currentUserId = context.read<AuthBloc>().state.user?.uid ?? '';

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.conversationResults.length,
      separatorBuilder: (context, index) => const Divider(indent: 76, height: 1),
      itemBuilder: (context, index) {
        final conversation = state.conversationResults[index];
        return ConversationTile(
          conversation: conversation,
          currentUserId: currentUserId,
          onTap: () => _onConversationSelected(conversation),
        );
      },
    );
  }

  Widget _buildMessagesTab(SearchState state) {
    if (state.isLoading) {
      return const Center(child: LoadingIndicator(size: 32));
    }

    if (!state.hasQuery) {
      return _buildInitialState(
        icon: Icons.search,
        message: 'Search messages across your chats',
      );
    }

    if (state.messageResults.isEmpty) {
      return _buildEmptyState(
        icon: Icons.message_outlined,
        message: 'No messages found',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.messageResults.length,
      separatorBuilder: (context, index) => const Divider(indent: 72, height: 1),
      itemBuilder: (context, index) {
        final result = state.messageResults[index];
        return SearchMessageTile(
          result: result,
          highlightQuery: state.query,
          onTap: () => _onMessageSelected(result),
        );
      },
    );
  }

  Widget _buildInitialState({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.grey300),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: AppColors.grey400,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: AppColors.grey300),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: AppColors.grey500,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              color: AppColors.grey400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  void _onUserSelected(UserEntity user) {
    final currentUser = context.read<AuthBloc>().state.user;
    if (currentUser == null) return;

    // Create or navigate to direct conversation
    context.read<SearchBloc>().add(
          StartConversationWithUser(
            currentUser: currentUser,
            otherUser: user,
          ),
        );
  }

  void _onConversationSelected(ConversationEntity conversation) {
    context.go('/chat/${conversation.id}');
  }

  void _onMessageSelected(MessageSearchResult result) {
    context.go('/chat/${result.conversationId}');
  }
}
