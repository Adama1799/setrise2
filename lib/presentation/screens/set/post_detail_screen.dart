import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/post_model.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;

  const PostDetailScreen({
    super.key,
    required this.post,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late PostModel _post = widget.post;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _post = _post.copyWith(
        isLiked: !_post.isLiked,
        likesCount: _post.isLiked ? _post.likesCount - 1 : _post.likesCount + 1,
      );
    });
  }

  void _toggleSave() {
    setState(() {
      _post = _post.copyWith(
        isSaved: !_post.isSaved,
        savesCount: _post.isSaved ? _post.savesCount - 1 : _post.savesCount + 1,
      );
    });
  }

  void _sendComment() {
    if (_commentController.text.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment added')),
    );
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        title: const Text('Post'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 540,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _post.backgroundColor,
                  const Color(0xFF090909),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.34),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Icon(
                        _post.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 58,
                      ),
                    ),
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
                      _post.username,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'from Set feed',
                      style: AppTextStyles.labelSmall.copyWith(color: Colors.white60),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _toggleSave,
                child: Text(_post.isSaved ? 'Saved' : 'Save'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _post.title,
            style: AppTextStyles.h5.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          if (_post.hashtags != null)
            Text(
              _post.hashtags!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.cyan,
                fontWeight: FontWeight.w700,
              ),
            ),
          const SizedBox(height: 14),
          Row(
            children: [
              _StatButton(
                icon: _post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                label: _post.likesCount.toString(),
                selected: _post.isLiked,
                onTap: _toggleLike,
              ),
              const SizedBox(width: 10),
              _StatButton(
                icon: Icons.mode_comment_rounded,
                label: _post.commentsCount.toString(),
                selected: false,
                onTap: () {},
              ),
              const SizedBox(width: 10),
              _StatButton(
                icon: Icons.send_rounded,
                label: _post.sharesCount.toString(),
                selected: false,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: 'اكتب تعليق...',
              prefixIcon: const Icon(Icons.mode_comment_rounded),
              suffixIcon: IconButton(
                onPressed: _sendComment,
                icon: const Icon(Icons.send_rounded),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _CommentTile(name: 'sara', text: 'رائع جدًا 🔥'),
          _CommentTile(name: 'ahmed', text: 'الواجهة جميلة جدًا'),
          _CommentTile(name: 'nora', text: 'التصميم نظيف ومريح'),
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

class _CommentTile extends StatelessWidget {
  final String name;
  final String text;

  const _CommentTile({
    required this.name,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
