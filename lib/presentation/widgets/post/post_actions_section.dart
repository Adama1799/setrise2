import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/post_model.dart';

class PostActionsSection extends StatelessWidget {
  final PostModel post;
  const PostActionsSection({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _action(Icons.favorite_border, Icons.favorite, Formatters.formatNumber(post.likes), post.isLiked, AppColors.like),
        const SizedBox(width: 20),
        _action(Icons.chat_bubble_outline, Icons.chat_bubble, Formatters.formatNumber(post.comments), false, AppColors.reply),
        const SizedBox(width: 20),
        _action(Icons.repeat, Icons.repeat, Formatters.formatNumber(post.shares), post.isShared, AppColors.repost),
        const SizedBox(width: 20),
        _action(Icons.send_outlined, Icons.send, '', false, AppColors.share),
        const Spacer(),
        _action(Icons.bookmark_border, Icons.bookmark, '', post.isSaved, AppColors.textSecondary),
      ],
    );
  }

  Widget _action(IconData off, IconData on, String label, bool active, Color activeColor) {
    return Row(children: [
      Icon(active ? on : off, color: active ? activeColor : AppColors.textTertiary, size: 20),
      if (label.isNotEmpty) ...[
        const SizedBox(width: 4),
        Text(label, style: AppTypography.caption),
      ],
    ]);
  }
}
