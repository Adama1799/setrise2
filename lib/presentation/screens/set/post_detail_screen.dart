import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/post_model.dart';
import '../../widgets/post/comments_sheet.dart';

class PostDetailScreen extends StatelessWidget {
  final PostModel post;
  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('Post', style: AppTypography.h2), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CachedNetworkImage(imageUrl: post.authorAvatar, imageBuilder: (_, img) => CircleAvatar(radius: 22, backgroundImage: img),
              placeholder: (_, __) => const CircleAvatar(radius: 22, backgroundColor: AppColors.border),
              errorWidget: (_, __, ___) => const CircleAvatar(radius: 22, backgroundColor: AppColors.border, child: Icon(Icons.person))),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(post.authorName, style: AppTypography.labelLarge),
              Text(post.authorUsername, style: AppTypography.caption),
            ]),
          ]),
          const SizedBox(height: 16),
          Text(post.content, style: AppTypography.bodyLarge),
          if (post.mediaUrls.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(imageUrl: post.mediaUrls[0], fit: BoxFit.cover,
                placeholder: (_, __) => Container(height: 250, color: AppColors.border),
                errorWidget: (_, __, ___) => Container(height: 250, color: AppColors.border, child: const Icon(Icons.image)))),
          ],
          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
              builder: (_) => CommentsSheet(post: post)),
            child: Text('View all ${post.comments} comments', style: AppTypography.caption.copyWith(color: AppColors.primary))),
        ]),
      ),
    );
  }
}
