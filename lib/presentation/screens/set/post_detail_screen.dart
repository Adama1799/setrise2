// lib/presentation/screens/set/post_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/extensions/datetime_extensions.dart';
import '../../../data/models/post_model.dart';
import '../../widgets/post/post_actions_section.dart';

class PostDetailScreen extends StatelessWidget {
  final PostModel post;

  const PostDetailScreen({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Post'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: CachedNetworkImageProvider(post.authorAvatar),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: AppTypography.labelLarge,
                      ),
                      Text(
                        post.authorUsername,
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Post Content
            Text(
              post.content,
              style: AppTypography.bodyLarge,
            ),
            const SizedBox(height: 16),
            // Media
            if (post.mediaUrls.isNotEmpty)
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.surface,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: post.mediaUrls[0],
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Timestamp
            Text(
              post.createdAt.toRelativeTime(),
              style: AppTypography.caption,
            ),
            const SizedBox(height: 16),
            // Divider
            Divider(color: AppColors.border),
            const SizedBox(height: 16),
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(Formatters.formatNumber(post.likes), 'Likes'),
                _buildStat(Formatters.formatNumber(post.comments), 'Comments'),
                _buildStat(Formatters.formatNumber(post.shares), 'Shares'),
                _buildStat(Formatters.formatNumber(post.saves), 'Saves'),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: AppColors.border),
            const SizedBox(height: 16),
            // Actions
            PostActionsSection(post: post),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      children: [
        Text(count, style: AppTypography.labelLarge),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}
