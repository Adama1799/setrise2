import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/rize_model.dart';

class RizePostDetailScreen extends StatefulWidget {
  final RizePostModel post;

  const RizePostDetailScreen({
    super.key,
    required this.post,
  });

  @override
  State<RizePostDetailScreen> createState() => _RizePostDetailScreenState();
}

class _RizePostDetailScreenState extends State<RizePostDetailScreen> {
  late RizePostModel _post = widget.post;

  void _toggleUpvote() {
    setState(() {
      _post = _post.copyWith(
        isUpvoted: !_post.isUpvoted,
        upvotes: _post.isUpvoted ? _post.upvotes - 1 : _post.upvotes + 1,
      );
    });
  }

  void _toggleFollow() {
    setState(() {
      _post = _post.copyWith(isFollowing: !_post.isFollowing);
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = _post;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        title: const Text('Rize post'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 520,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.electricBlue.withOpacity(0.28),
                  const Color(0xFF080808),
                ],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 132,
                    height: 132,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.34),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(Icons.article_rounded, color: Colors.white, size: 60),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white10,
                child: Icon(Icons.person_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.name,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.username,
                      style: AppTextStyles.labelSmall.copyWith(color: Colors.white60),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _toggleFollow,
                child: Text(post.isFollowing ? 'Following' : 'Follow'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            post.title,
            style: AppTextStyles.h5.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post.body,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70, height: 1.6),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _StatButton(
                icon: post.isUpvoted ? Icons.arrow_upward_rounded : Icons.arrow_upward_outlined,
                label: post.upvotes.toString(),
                selected: post.isUpvoted,
                onTap: _toggleUpvote,
              ),
              const SizedBox(width: 10),
              _StatButton(
                icon: Icons.mode_comment_rounded,
                label: post.comments.toString(),
                selected: false,
                onTap: () {},
              ),
              const SizedBox(width: 10),
              _StatButton(
                icon: Icons.send_rounded,
                label: post.shares.toString(),
                selected: false,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _StatButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.black : Colors.white;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.white10,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: fg, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
