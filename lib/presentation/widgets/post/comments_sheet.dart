import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:setrise/core/theme/app_colors.dart';
import 'package:setrise/core/theme/app_typography.dart';
import 'package:setrise/data/models/post_model.dart';

class CommentsSheet extends StatefulWidget {
  final PostModel post;
  
  const CommentsSheet({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<CommentModel> comments = [
    CommentModel(
      id: '1',
      authorName: 'Alice Johnson',
      authorAvatar: 'https://via.placeholder.com/150',
      content: 'This looks amazing!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      likes: 3,
    ),
    CommentModel(
      id: '2',
      authorName: 'Bob Wilson',
      authorAvatar: 'https://via.placeholder.com/150',
      content: 'Great post! Thanks for sharing.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      likes: 1,
    ),
  ];

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: 'Current User',
      authorAvatar: 'https://via.placeholder.com/150',
      content: _commentController.text.trim(),
      timestamp: DateTime.now(),      likes: 0,
    );

    setState(() {
      comments.insert(0, newComment);
      _commentController.clear();
    });

    // Scroll to top
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comments (${widget.post.comments})',
                  style: AppTypography.h5,
                ),
                IconButton(                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Divider
          const Divider(height: 1),
          
          // Comments List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return _buildCommentItem(comment);
              },
            ),
          ),
          
          // Add Comment
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: 'https://via.placeholder.com/40',
                    width: 40,
                    height: 40,
                    placeholder: (context, url) => Container(
                      width: 40,
                      height: 40,
                      color: AppColors.border,
                      child: const Icon(Icons.person, color: AppColors.textSecondary, size: 18),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 40,
                      height: 40,
                      color: AppColors.border,
                      child: const Icon(Icons.person, color: AppColors.textSecondary, size: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _addComment(),
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  onPressed: _addComment,
                  backgroundColor: AppColors.primary,
                  mini: true,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentModel comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: CachedNetworkImage(
                  imageUrl: comment.authorAvatar,
                  width: 36,
                  height: 36,
                  placeholder: (context, url) => Container(
                    width: 36,
                    height: 36,
                    color: AppColors.border,
                    child: const Icon(Icons.person, color: AppColors.textSecondary, size: 16),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 36,
                    height: 36,
                    color: AppColors.border,
                    child: const Icon(Icons.person, color: AppColors.textSecondary, size: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.authorName,
                      style: AppTypography.labelMedium,
                    ),
                    Text(
                      _formatTime(comment.timestamp),
                      style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    comment.likes.toString(),                    style: AppTypography.caption,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.content,
            style: AppTypography.bodyMedium,
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
    
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// Comment Model
class CommentModel {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final DateTime timestamp;
  final int likes;

  CommentModel({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.timestamp,    required this.likes,
  });
}
