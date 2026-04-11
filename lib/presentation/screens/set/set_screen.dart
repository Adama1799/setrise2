import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:setrise/core/theme/app_colors.dart';
import 'package:setrise/core/theme/app_typography.dart';
import 'package:setrise/data/models/post_model.dart';
import 'package:setrise/presentation/widgets/post/comments_sheet.dart';

class SetScreen extends StatefulWidget {
  const SetScreen({Key? key}) : super(key: key);

  @override
  State<SetScreen> createState() => _SetScreenState();
}

class _SetScreenState extends State<SetScreen> {
  final List<PostModel> posts = [
    PostModel(
      id: '1',
      authorId: 'user1',
      authorName: 'John Doe',
      authorUsername: '@johndoe',
      authorAvatar: 'https://via.placeholder.com/150',
      content: 'Just had an amazing day! 🌟',
      mediaUrls: ['https://via.placeholder.com/400x300'],
      createdAt: DateTime.now(),
      likes: 24,
      comments: 5,
      shares: 2,
      isLiked: false,
      isBookmarked: false,
    ),
    PostModel(
      id: '2',
      authorId: 'user2',
      authorName: 'Jane Smith',
      authorUsername: '@janesmith',
      authorAvatar: 'https://via.placeholder.com/150',
      content: 'Beautiful sunset today! 🌅',
      mediaUrls: ['https://via.placeholder.com/400x300', 'https://via.placeholder.com/400x300'],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 42,
      comments: 8,
      shares: 3,
      isLiked: true,
      isBookmarked: true,
    ),
  ];

  void _toggleLike(int index) {
    setState(() {      posts[index] = posts[index].copyWith(
        isLiked: !posts[index].isLiked,
        likes: posts[index].isLiked ? posts[index].likes - 1 : posts[index].likes + 1,
      );
    });
  }

  void _showCommentsSheet(PostModel post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CommentsSheet(post: post),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post', style: AppTypography.h2),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement refresh logic
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return _buildPostCard(post, index);
          },
        ),
      ),
    );
  }

  Widget _buildPostCard(PostModel post, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: CachedNetworkImage(
                    imageUrl: post.authorAvatar,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 22,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => const CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.border,
                      child: Icon(Icons.person, color: AppColors.textSecondary),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.border,
                      child: Icon(Icons.person, color: AppColors.textSecondary),
                    ),
                  ),
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
                  icon: Icon(
                    post.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: AppColors.primary,
                  ),
                  onPressed: () {                    setState(() {
                      posts[index] = posts[index].copyWith(
                        isBookmarked: !post.isBookmarked,
                      );
                    });
                  },
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              post.content,
              style: AppTypography.bodyLarge,
            ),
          ),

          // Media
          if (post.mediaUrls.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: post.mediaUrls.length,
                itemBuilder: (context, mediaIndex) {
                  return CachedNetworkImage(
                    imageUrl: post.mediaUrls[mediaIndex],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 250,
                      color: AppColors.borderLight,
                      child: const Icon(Icons.image, color: AppColors.textSecondary),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 250,
                      color: AppColors.border,
                      child: const Icon(Icons.image, color: AppColors.textSecondary),
                    ),
                  );
                },
              ),
            ),
          ],

          // Actions
          Padding(
            padding: const EdgeInsets.all(12),            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: post.isLiked ? AppColors.error : AppColors.textSecondary,
                      ),
                      onPressed: () => _toggleLike(index),
                    ),
                    Text('${post.likes}', style: AppTypography.caption),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.comment,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () => _showCommentsSheet(post),
                ),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    // Share functionality
                  },
                ),
              ],
            ),
          ),

          // Location and Time
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  post.location.isNotEmpty ? post.location : 'Unknown Location',
                  style: AppTypography.caption,
                ),
                const Spacer(),
                Text(
                  _formatTime(post.createdAt),
                  style: AppTypography.caption,                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) return 'now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';
    
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
