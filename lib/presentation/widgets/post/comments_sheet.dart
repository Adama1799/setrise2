// lib/presentation/widgets/post/comments_sheet.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CommentsSheet extends StatefulWidget {
  final dynamic post;

  const CommentsSheet({
    super.key,
    required this.post,
  });

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final _commentController = TextEditingController();
  final List<Map<String, dynamic>> _comments = [
    {
      'id': '1',
      'author': 'User 1',
      'username': '@user1',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'content': 'Amazing post! 🔥',
      'time': '2h ago',
      'likes': 24,
      'isLiked': false,
    },
    {
      'id': '2',
      'author': 'User 2',
      'username': '@user2',
      'avatar': 'https://i.pravatar.cc/150?img=2',
      'content': 'Love this! ❤️',
      'time': '1h ago',
      'likes': 12,
      'isLiked': false,
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Comments', style: AppTypography.h3),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.border),
          // Comments List
          Expanded(
            child: ListView.separated(
              itemCount: _comments.length,
              separatorBuilder: (_, __) => Divider(color: AppColors.border),
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            NetworkImage(comment['avatar']),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment['author'],
                                  style: AppTypography.labelLarge,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  comment['username'],
                                  style: AppTypography.caption,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              comment['content'],
                              style: AppTypography.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  comment['time'],
                                  style: AppTypography.caption,
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      comment['isLiked'] = !comment['isLiked'];
                                    });
                                  },
                                  child: Icon(
                                    comment['isLiked']
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 14,
                                    color: comment['isLiked']
                                        ? AppColors.primary
                                        : AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Comment Input
          Divider(color: AppColors.border),
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: AppTypography.bodySmall,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (_commentController.text.isNotEmpty) {
                      setState(() {
                        _comments.add({
                          'id': '${_comments.length + 1}',
                          'author': 'You',
                          'username': '@yourusername',
                          'avatar': 'https://i.pravatar.cc/150?img=0',
                          'content': _commentController.text,
                          'time': 'now',
                          'likes': 0,
                          'isLiked': false,
                        });
                        _commentController.clear();
                      });
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _commentController.text.isEmpty
                          ? AppColors.surface
                          : AppColors.primary,
                    ),
                    child: Icon(
                      Icons.send,
                      color: _commentController.text.isEmpty
                          ? AppColors.textTertiary
                          : AppColors.background,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
