import 'package:flutter/material.dart';

import '../../../../core/entities/user_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/user_avatar.dart';

class SearchUserTile extends StatelessWidget {
  final UserEntity user;
  final VoidCallback? onTap;

  const SearchUserTile({
    super.key,
    required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: UserAvatar(
        name: user.displayName,
        imageUrl: user.photoUrl,
        size: 48,
        showOnlineIndicator: true,
        isOnline: user.isOnline,
      ),
      title: Text(
        user.displayName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user.email.isNotEmpty)
            Text(
              user.email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.grey500,
                fontSize: 13,
              ),
            ),
          if (user.bio != null && user.bio!.isNotEmpty)
            Text(
              user.bio!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.grey400,
                fontSize: 12,
              ),
            ),
        ],
      ),
      trailing: const Icon(
        Icons.chat_bubble_outline,
        color: AppColors.grey400,
        size: 20,
      ),
    );
  }
}
