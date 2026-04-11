import 'package:flutter/material.dart';
import 'dart:math' show cos, sin;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/models/rize_model.dart';

class RizePostCard extends StatefulWidget {
  final RizePostModel post;
  final Function(RizePostModel) onUpdate;

  const RizePostCard({
    super.key,
    required this.post,
    required this.onUpdate,
  });

  @override
  State<RizePostCard> createState() => _RizePostCardState();
}

class _RizePostCardState extends State<RizePostCard> {
  bool _showFullBody = false;

  void _toggleUpvote() {
    widget.onUpdate(widget.post.copyWith(
      isUpvoted: !widget.post.isUpvoted,
      upvotes: widget.post.isUpvoted
          ? widget.post.upvotes - 1
          : widget.post.upvotes + 1,
    ));
  }

  void _toggleFollow() {
    widget.onUpdate(widget.post.copyWith(
      isFollowing: !widget.post.isFollowing,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.black,
        border: Border(
          bottom: BorderSide(color: AppColors.grey, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 12),

          // Title
          Text(
            widget.post.title,
            style: AppTextStyles.rizeTitle.copyWith(color: AppColors.white),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Body
          _buildBody(),

          // Media (if exists)
          if (widget.post.hasMedia) ...[
            const SizedBox(height: 12),
            _buildMedia(),
          ],

          const SizedBox(height: 12),

          // Actions
          _buildActions(),
        ],
      ),
    );
  }

  // ===== HEADER =====
  Widget _buildHeader() {
    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.grey,
          child: const Icon(Icons.person, color: AppColors.white, size: 22),
        ),
        const SizedBox(width: 10),

        // Name & Username
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.name,
                style: AppTextStyles.rizeUsername.copyWith(
                  color: AppColors.white,
                ),
              ),
              Text(
                widget.post.username,
                style: AppTextStyles.rizeHandle.copyWith(
                  color: AppColors.grey2,
                ),
              ),
            ],
          ),
        ),

        // Time
        Text(
          Formatters.timeAgo(widget.post.createdAt),
          style: AppTextStyles.timestamp,
        ),

        const SizedBox(width: 8),

        // Views
        Row(
          children: [
            const Icon(Icons.visibility_outlined,
                color: AppColors.grey2, size: 16),
            const SizedBox(width: 4),
            Text(
              Formatters.formatCount(widget.post.views),
              style: AppTextStyles.caption,
            ),
          ],
        ),

        const SizedBox(width: 8),

        // Menu
        GestureDetector(
          onTap: () {
            _showPostMenu(context);
          },
          child: const Icon(
            Icons.more_horiz,
            color: AppColors.grey2,
            size: 20,
          ),
        ),
      ],
    );
  }

  // ===== BODY =====
  Widget _buildBody() {
    final bodyText = widget.post.body;
    final shouldTruncate = bodyText.length > 250;

    if (!shouldTruncate) {
      return Text(
        bodyText,
        style: AppTextStyles.rizeBody.copyWith(color: AppColors.white),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _showFullBody ? bodyText : '${bodyText.substring(0, 250)}...',
          style: AppTextStyles.rizeBody.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => setState(() => _showFullBody = !_showFullBody),
          child: Text(
            _showFullBody ? 'Show less' : 'More',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.neonRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ===== MEDIA =====
  Widget _buildMedia() {
    return GestureDetector(
      onTap: () {
        // TODO: Open fullscreen media
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fullscreen media - Coming soon!')),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 220,
          width: double.infinity,
          color: AppColors.grey,
          child: const Center(
            child: Icon(
              Icons.play_circle_outline,
              color: AppColors.white,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }

  // ===== ACTIONS =====
  Widget _buildActions() {
    return Row(
      children: [
        // Upvote (Orange pill)
        _buildUpvoteButton(),
        const SizedBox(width: 16),

        // Star (Like)
        _buildActionButton(
          child: _FourPointStar(
            size: 20,
            color: AppColors.white.withOpacity(0.7),
          ),
          count: 0,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Star - Coming soon!')),
            );
          },
        ),
        const SizedBox(width: 16),

        // Comment
        _buildActionButton(
          child: Icon(
            Icons.chat_bubble_outline,
            color: AppColors.white.withOpacity(0.7),
            size: 20,
          ),
          count: widget.post.comments,
          onTap: () {
            _showCommentsSheet(context);
          },
        ),
        const SizedBox(width: 16),

        // Triangle (Recommend)
        _buildActionButton(
          child: Transform.rotate(
            angle: 0,
            child: Icon(
              Icons.change_history,
              color: AppColors.neonGreen.withOpacity(0.7),
              size: 20,
            ),
          ),
          count: 0,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Recommend - Coming soon!')),
            );
          },
        ),
        const SizedBox(width: 16),

        // Share
        _buildActionButton(
          child: Icon(
            Icons.share_outlined,
            color: AppColors.white.withOpacity(0.7),
            size: 20,
          ),
          count: widget.post.shares,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share - Coming soon!')),
            );
          },
        ),
      ],
    );
  }

  // Upvote Button (Orange pill)
  Widget _buildUpvoteButton() {
    return GestureDetector(
      onTap: _toggleUpvote,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: widget.post.isUpvoted
              ? AppColors.warning.withOpacity(0.2)
              : Colors.transparent,
          border: Border.all(
            color: widget.post.isUpvoted
                ? AppColors.warning
                : AppColors.grey2.withOpacity(0.5),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_upward,
              color: widget.post.isUpvoted ? AppColors.warning : AppColors.grey2,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              Formatters.formatCount(widget.post.upvotes),
              style: AppTextStyles.labelSmall.copyWith(
                color:
                    widget.post.isUpvoted ? AppColors.warning : AppColors.grey2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required Widget child,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          if (count > 0) ...[
            const SizedBox(width: 4),
            Text(
              Formatters.formatCount(count),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.grey2,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ===== POST MENU =====
  void _showPostMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _menuItem(Icons.bookmark_outline, 'Save', () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved!')),
                );
              }),
              _menuItem(Icons.link, 'Copy link', () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied!')),
                );
              }),
              _menuItem(
                widget.post.isFollowing
                    ? Icons.person_remove_outlined
                    : Icons.person_add_outlined,
                widget.post.isFollowing ? 'Unfollow' : 'Follow',
                () {
                  Navigator.pop(context);
                  _toggleFollow();
                },
              ),
              _menuItem(Icons.flag_outlined, 'Report', () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted')),
                );
              }),
              _menuItem(Icons.block_outlined, 'Block', () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User blocked')),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.white),
      title: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
      ),
      onTap: onTap,
    );
  }

  // ===== COMMENTS SHEET =====
  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return _CommentsSheet(
              post: widget.post,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }
}

// ===== FOUR POINT STAR =====
class _FourPointStar extends StatelessWidget {
  final double size;
  final Color color;

  const _FourPointStar({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _FourPointStarPainter(color: color),
    );
  }
}

class _FourPointStarPainter extends CustomPainter {
  final Color color;

  _FourPointStarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final outerRadius = size.width / 2;
    final innerRadius = size.width / 4;

    for (int i = 0; i < 4; i++) {
      final outerAngle = (i * 90 - 90) * (3.14159 / 180);
      final innerAngle = ((i * 90 - 90) + 45) * (3.14159 / 180);

      final outerX = centerX + outerRadius * cos(outerAngle);
      final outerY = centerY + outerRadius * sin(outerAngle);

      final innerX = centerX + innerRadius * cos(innerAngle);
      final innerY = centerY + innerRadius * sin(innerAngle);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ===== COMMENTS SHEET =====
class _CommentsSheet extends StatefulWidget {
  final RizePostModel post;
  final ScrollController scrollController;

  const _CommentsSheet({
    required this.post,
    required this.scrollController,
  });

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _textController = TextEditingController();
  String? _replyingTo;

  final List<Map<String, dynamic>> _comments = [
    {
      'id': '1',
      'user': 'ahmed_99',
      'avatar': null,
      'text': 'Great post! Really insightful 🔥',
      'time': '2m',
      'upvotes': 24,
      'isUpvoted': false,
      'replies': [],
    },
    {
      'id': '2',
      'user': 'sara_x',
      'avatar': null,
      'text': 'I completely agree with this perspective',
      'time': '5m',
      'upvotes': 12,
      'isUpvoted': false,
      'replies': [
        {
          'user': 'nora_m',
          'text': 'Same here!',
          'upvotes': 3,
          'isUpvoted': false,
        },
      ],
    },
    {
      'id': '3',
      'user': 'khalid_tech',
      'avatar': null,
      'text': 'Thanks for sharing this!',
      'time': '10m',
      'upvotes': 8,
      'isUpvoted': false,
      'replies': [],
    },
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendComment() {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      if (_replyingTo != null) {
        final parent = _comments.firstWhere((c) => c['id'] == _replyingTo);
        (parent['replies'] as List).add({
          'user': 'You',
          'text': _textController.text.trim(),
          'upvotes': 0,
          'isUpvoted': false,
        });
      } else {
        _comments.insert(0, {
          'id': DateTime.now().toString(),
          'user': 'You',
          'avatar': null,
          'text': _textController.text.trim(),
          'time': 'now',
          'upvotes': 0,
          'isUpvoted': false,
          'replies': [],
        });
      }
      _textController.clear();
      _replyingTo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Comments',
                  style: AppTextStyles.h5.copyWith(color: AppColors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${_comments.length})',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey2,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // TODO: Sort comments
                  },
                  child: Row(
                    children: [
                      Text(
                        'Latest',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.electricBlue,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.electricBlue,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.grey, height: 1),

          // Comments List
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return _CommentItem(
                  comment: _comments[index],
                  onReply: (id) => setState(() => _replyingTo = id),
                  onUpvote: (id) {
                    setState(() {
                      final comment = _comments.firstWhere((c) => c['id'] == id);
                      comment['isUpvoted'] = !comment['isUpvoted'];
                      comment['upvotes'] += comment['isUpvoted'] ? 1 : -1;
                    });
                  },
                );
              },
            ),
          ),

          // Reply indicator
          if (_replyingTo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.grey.withOpacity(0.3),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to @${_comments.firstWhere((c) => c['id'] == _replyingTo)['user']}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.grey2,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _replyingTo = null),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.grey2,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),

          // Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.black,
              border: Border(
                top: BorderSide(color: AppColors.grey, width: 0.5),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _textController,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.grey2,
                          ),
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendComment,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.electricBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== COMMENT ITEM =====
class _CommentItem extends StatelessWidget {
  final Map<String, dynamic> comment;
  final Function(String) onReply;
  final Function(String) onUpvote;

  const _CommentItem({
    required this.comment,
    required this.onReply,
    required this.onUpvote,
  });

  @override
  Widget build(BuildContext context) {
    final replies = comment['replies'] as List;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.grey,
            child: const Icon(Icons.person, color: AppColors.white, size: 18),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User & Time
                Row(
                  children: [
                    Text(
                      comment['user'],
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment['time'] ?? '',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Text
                Text(
                  comment['text'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),

                // Actions
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => onUpvote(comment['id']),
                      child: Row(
                        children: [
                          Icon(
                            comment['isUpvoted']
                                ? Icons.arrow_upward
                                : Icons.arrow_upward_outlined,
                            color: comment['isUpvoted']
                                ? AppColors.warning
                                : AppColors.grey2,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${comment['upvotes']}',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: comment['isUpvoted']
                                  ? AppColors.warning
                                  : AppColors.grey2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => onReply(comment['id']),
                      child: Text(
                        'Reply',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.grey2,
                        ),
                      ),
                    ),
                  ],
                ),

                // Replies (with connecting lines)
                if (replies.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ...replies.map((reply) => _ReplyItem(reply: reply)).toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===== REPLY ITEM =====
class _ReplyItem extends StatelessWidget {
  final Map<String, dynamic> reply;

  const _ReplyItem({required this.reply});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Connecting line
          Container(
            width: 2,
            height: 40,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(1),
            ),
          ),

          // Avatar
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.grey,
            child: const Icon(Icons.person, color: AppColors.white, size: 14),
          ),
          const SizedBox(width: 8),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reply['user'],
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  reply['text'],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),

          // Upvote
          Row(
            children: [
              Icon(
                reply['isUpvoted']
                    ? Icons.arrow_upward
                    : Icons.arrow_upward_outlined,
                color: reply['isUpvoted'] ? AppColors.warning : AppColors.grey2,
                size: 14,
              ),
              const SizedBox(width: 2),
              Text(
                '${reply['upvotes']}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: reply['isUpvoted'] ? AppColors.warning : AppColors.grey2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
