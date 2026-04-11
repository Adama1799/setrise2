import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/post_model.dart';
import '../post_detail_screen.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final ValueChanged<PostModel> onUpdate;
  final VoidCallback onLikeTap;
  final VoidCallback onOpenDetails;

  const PostCard({
    super.key,
    required this.post,
    required this.onUpdate,
    required this.onLikeTap,
    required this.onOpenDetails,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with SingleTickerProviderStateMixin {
  bool _showHeart = false;
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerLike() {
    widget.onLikeTap();
    setState(() => _showHeart = true);
    _controller.forward(from: 0);

    Timer(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      setState(() => _showHeart = false);
    });
  }

  void _togglePlay() {
    widget.onUpdate(widget.post.copyWith(isPlaying: !widget.post.isPlaying));
  }

  void _toggleSave() {
    widget.onUpdate(
      widget.post.copyWith(
        isSaved: !widget.post.isSaved,
        savesCount: widget.post.isSaved
            ? widget.post.savesCount - 1
            : widget.post.savesCount + 1,
      ),
    );
  }

  void _openInfoSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PostInfoSheet(post: widget.post),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return GestureDetector(
      onTap: widget.onOpenDetails,
      onDoubleTap: _triggerLike,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 128, 12, 84),
        child: AspectRatio(
          aspectRatio: 0.65,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white12),
              boxShadow: [
                BoxShadow(
                  color: post.backgroundColor.withOpacity(0.35),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            post.backgroundColor,
                            const Color(0xFF090909),
                            Colors.black,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.08,
                      child: CustomPaint(painter: _GridPainter()),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white24),
                                  color: Colors.white10,
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.username,
                                      style: AppTextStyles.labelLarge.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '3m ago • 1.2K views',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: _openInfoSheet,
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(color: Colors.white12),
                                  ),
                                  child: const Icon(
                                    Icons.info_outline_rounded,
                                    color: Colors.white,
                                    size: 19,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withOpacity(0.14),
                                          Colors.white.withOpacity(0.04),
                                        ],
                                      ),
                                      border: Border.all(color: Colors.white12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                gradient: RadialGradient(
                                                  colors: [
                                                    AppColors.cyan.withOpacity(0.22),
                                                    Colors.transparent,
                                                  ],
                                                  radius: 0.9,
                                                  center: Alignment.topLeft,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              width: 90,
                                              height: 90,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black.withOpacity(0.34),
                                                border: Border.all(
                                                  color: Colors.white24,
                                                  width: 1.2,
                                                ),
                                              ),
                                              child: Icon(
                                                post.isPlaying
                                                    ? Icons.pause_rounded
                                                    : Icons.play_arrow_rounded,
                                                color: Colors.white,
                                                size: 42,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (_showHeart)
                                    ScaleTransition(
                                      scale: _scale,
                                      child: Container(
                                        width: 110,
                                        height: 110,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black.withOpacity(0.28),
                                        ),
                                        child: const Icon(
                                          Icons.favorite_rounded,
                                          color: Colors.redAccent,
                                          size: 68,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            post.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.postTitle.copyWith(
                              color: Colors.white,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (post.hashtags != null)
                            Text(
                              post.hashtags!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.cyan,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              _MetaPill(
                                icon: post.isLiked
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                text: _formatCount(post.likesCount),
                                selected: post.isLiked,
                                onTap: _triggerLike,
                              ),
                              const SizedBox(width: 8),
                              _MetaPill(
                                icon: Icons.mode_comment_rounded,
                                text: _formatCount(post.commentsCount),
                                selected: false,
                                onTap: widget.onOpenDetails,
                              ),
                              const SizedBox(width: 8),
                              _MetaPill(
                                icon: post.isSaved
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                text: _formatCount(post.savesCount),
                                selected: post.isSaved,
                                onTap: _toggleSave,
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: _togglePlay,
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(color: Colors.white12),
                                  ),
                                  child: Icon(
                                    post.isPlaying
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatCount(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toString();
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _MetaPill({
    required this.icon,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.white : Colors.white10;
    final fg = selected ? Colors.black : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: fg, size: 18),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: fg,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostInfoSheet extends StatelessWidget {
  final PostModel post;

  const _PostInfoSheet({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.46,
      padding: EdgeInsets.fromLTRB(
        16,
        14,
        16,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Info',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          _RowInfo(icon: Icons.visibility_rounded, text: '${post.viewsCount} views'),
          _RowInfo(icon: Icons.favorite_rounded, text: '${post.likesCount} likes'),
          _RowInfo(icon: Icons.mode_comment_rounded, text: '${post.commentsCount} comments'),
          _RowInfo(icon: Icons.send_rounded, text: '${post.sharesCount} shares'),
          const SizedBox(height: 8),
          Text(
            post.title,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _RowInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _RowInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (var y = 0.0; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint..strokeWidth = 0.4);
    }
    for (var x = 0.0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint..strokeWidth = 0.4);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
