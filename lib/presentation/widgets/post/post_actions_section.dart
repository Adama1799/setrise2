// lib/presentation/widgets/post/post_actions_section.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/post_model.dart';

class PostActionsSection extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSave;

  const PostActionsSection({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ActionButton(
          icon: Icons.chat_bubble_outline,
          count: Formatters.formatNumber(post.comments),
          onPressed: onComment ?? () {},
        ),
        _ActionButton(
          icon: Icons.repeat,
          count: Formatters.formatNumber(post.shares),
          onPressed: onShare ?? () {},
        ),
        _ActionButton(
          icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
          count: Formatters.formatNumber(post.likes),
          isActive: post.isLiked,
          onPressed: onLike ?? () {},
        ),
        _ActionButton(
          icon: post.isSaved ? Icons.bookmark : Icons.bookmark_border,
          count: Formatters.formatNumber(post.saves),
          isActive: post.isSaved,
          onPressed: onSave ?? () {},
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String count;
  final bool isActive;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.count,
    this.isActive = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : AppColors.textTertiary,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            count,
            style: AppTypography.caption.copyWith(
              color: isActive ? AppColors.primary : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
