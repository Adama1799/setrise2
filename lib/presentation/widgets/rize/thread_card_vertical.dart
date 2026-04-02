// lib/presentation/widgets/rize/thread_card_vertical.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/extensions/datetime_extensions.dart';
import '../../../data/models/thread_model.dart';

class ThreadCardVertical extends StatelessWidget {
  final ThreadModel thread;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final VoidCallback onRepost;
  final VoidCallback onShare;
  final VoidCallback onAuthorTap;

  const ThreadCardVertical({
    super.key,
    required this.thread,
    required this.onLike,
    required this.onReply,
    required this.onRepost,
    required this.onShare,
    required this.onAuthorTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Media Background (1000x650px or full screen)
        if (thread.mediaUrl != null)
          CachedNetworkImage(
            imageUrl: thread.mediaUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.surface,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.surface,
              child: const Icon(Icons.error),
            ),
          )
        else
          Container(color: AppColors.surface),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.black.withOpacity(0.9),
              ],
            ),
          ),
        ),

        // Content
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Author Info
                    GestureDetector(
                      onTap: onAuthorTap,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: CachedNetworkImageProvider(
                              thread.authorAvatar,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                thread.authorName,
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                thread.authorUsername,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // More Options
                    PopupMenuButton(
                      itemBuilder: (_) => [
                        const PopupMenuItem(child: Text('Report')),
                        const PopupMenuItem(child: Text('Block')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
              // Bottom Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thread Content
                    Text(
                      thread.content,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.white,
                      ),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    // Timestamp
                    Text(
                      thread.createdAt.toRelativeTime(),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Thread Chain Indicator
                    if (thread.hasMoreReplies)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.reply,
                              size: 14,
                              color: AppColors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${thread.replies} replies',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    // Actions Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionButton(
                          icon: Icons.chat_bubble_outline,
                          count: Formatters.formatNumber(thread.replies),
                          onPressed: onReply,
                        ),
                        _buildActionButton(
                          icon: Icons.repeat,
                          count: Formatters.formatNumber(thread.reposts),
                          color: thread.isReposted ? AppColors.primary : null,
                          onPressed: onRepost,
                        ),
                        _buildActionButton(
                          icon: thread.isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          count: Formatters.formatNumber(thread.likes),
                          color: thread.isLiked ? AppColors.primary : null,
                          onPressed: onLike,
                        ),
                        _buildActionButton(
                          icon: Icons.share,
                          count: '',
                          onPressed: onShare,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String count,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Icon(
            icon,
            color: color ?? AppColors.white,
            size: 20,
          ),
          if (count.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              count,
              style: AppTypography.caption.copyWith(
                color: color ?? AppColors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
