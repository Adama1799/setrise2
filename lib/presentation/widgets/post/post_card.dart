// lib/presentation/widgets/post/post_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/extensions/datetime_extensions.dart';
import '../../../data/models/post_model.dart';
import 'post_actions_section.dart';

class PostCard extends StatelessWidget {
  final PostModel? post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onSave;
  final VoidCallback onFollow;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onSave,
    required this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    if (post == null) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        CachedNetworkImageProvider(post!.authorAvatar),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post!.authorName,
                          style: AppTypography.labelLarge,
                        ),
                        Text(
                          post!.authorUsername,
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  if (!post!.isFollowing)
                    GestureDetector(
                      onTap: onFollow,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Follow',
                          style: AppTypography.labelSmall,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Content
              Text(
                post!.content,
                style: AppTypography.bodyMedium,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Media
              if (post!.mediaUrls.isNotEmpty)
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: post!.mediaUrls[0],
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              // Timestamp
              Text(
                post!.createdAt.toRelativeTime(),
                style: AppTypography.caption,
              ),
              const SizedBox(height: 12),
              // Actions
              PostActionsSection(post: post!),
            ],
          ),
        ),
        Divider(color: AppColors.border, height: 1),
      ],
    );
  }
}
