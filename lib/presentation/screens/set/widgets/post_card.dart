import 'package:flutter/material.dart';
import 'dart:math' show cos, sin, pi;
import 'dart:ui';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/models/post_model.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final Function(PostModel) onUpdate;
  final VoidCallback onSwipeNext;

  const PostCard({
    super.key,
    required this.post,
    required this.onUpdate,
    required this.onSwipeNext,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with SingleTickerProviderStateMixin {
  late final AnimationController _heartController;
  late final Animation<double> _heartAnimation;
  bool _showHeart = false;

  Color get _accent => _deriveAccent(widget.post.backgroundColor);
  Color get _accentGlow => _accent.withOpacity(0.35);

  Color _deriveAccent(Color base) {
    final hsl = HSLColor.fromColor(base);
    return hsl.withSaturation(1.0).withLightness(0.62).toColor();
  }

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _heartAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );

    _heartController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 350), () {
          if (!mounted) return;
          setState(() => _showHeart = false);
          _heartController.reset();
        });
      }
    });
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _triggerHeart() {
    setState(() => _showHeart = true);
    _heartController.forward(from: 0);
    if (!widget.post.isLiked) {
      _toggleLike();
    }
  }

  void _toggleLike() {
    widget.onUpdate(
      widget.post.copyWith(
        isLiked: !widget.post.isLiked,
        likesCount: widget.post.isLiked
            ? widget.post.likesCount - 1
            : widget.post.likesCount + 1,
      ),
    );
  }

  void _togglePlay() {
    widget.onUpdate(widget.post.copyWith(isPlaying: !widget.post.isPlaying));
  }

  void _toggleFollow() {
    widget.onUpdate(widget.post.copyWith(isFollowing: !widget.post.isFollowing));
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CommentsSheet(accent: _accent),
    );
  }

  void _showInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _InfoSheet(
        post: widget.post,
        accent: _accent,
        onFollow: _toggleFollow,
        onMessage: () => _showMessageSheet(context),
      ),
    );
  }

  void _showMessageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MessageSheet(
        post: widget.post,
        accent: _accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return GestureDetector(
      onTap: _togglePlay,
      onDoubleTap: _triggerHeart,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _DynamicBackground(
            baseColor: widget.post.backgroundColor,
            accentColor: _accent,
          ),

          if (!widget.post.isPlaying)
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.45),
                  border: Border.all(color: _accent, width: 2),
                  boxShadow: [BoxShadow(color: _accentGlow, blurRadius: 24)],
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: _accent,
                  size: 42,
                ),
              ),
            ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 360,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    widget.post.backgroundColor.withOpacity(0.45),
                    Colors.black.withOpacity(0.94),
                  ],
                  stops: const [0.0, 0.52, 1.0],
                ),
              ),
            ),
          ),

          if (_showHeart)
            Center(
              child: ScaleTransition(
                scale: _heartAnimation,
                child: _StarBurst(color: _accent, size: 120),
              ),
            ),

          Positioned(
            right: 12,
            bottom: bottomSafe + 18,
            child: _ActionBar(
              post: widget.post,
              accent: _accent,
              onLike: _toggleLike,
              onComment: () => _showComments(context),
              onShare: () => widget.onUpdate(
                widget.post.copyWith(isShared: !widget.post.isShared),
              ),
              onInfo: () => _showInfoSheet(context),
            ),
          ),

          Positioned(
            bottom: bottomSafe + 8,
            left: 14,
            right: 80,
            child: _BottomInfo(
              post: widget.post,
              accent: _accent,
              onFollow: _toggleFollow,
              onMessage: () => _showMessageSheet(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _DynamicBackground extends StatelessWidget {
  final Color baseColor;
  final Color accentColor;

  const _DynamicBackground({
    required this.baseColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: baseColor),
        Positioned(
          top: -60,
          left: -60,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  accentColor.withOpacity(0.28),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          right: -40,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  accentColor.withOpacity(0.20),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.06,
            child: CustomPaint(painter: _NoisePainter()),
          ),
        ),
      ],
    );
  }
}

class _ActionBar extends StatelessWidget {
  final PostModel post;
  final Color accent;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onInfo;

  const _ActionBar({
    required this.post,
    required this.accent,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionBtn(
          icon: post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          label: Formatters.formatCount(post.likesCount),
          color: post.isLiked ? accent : Colors.white,
          glow: post.isLiked ? accent : Colors.transparent,
          onTap: onLike,
        ),
        const SizedBox(height: 8),
        _ActionBtn(
          icon: Icons.change_history_rounded,
          label: 'Boost',
          color: AppColors.neonGreen,
          glow: Colors.transparent,
          onTap: onShare,
        ),
        const SizedBox(height: 8),
        _ActionBtn(
          icon: Icons.chat_bubble_outline_rounded,
          label: Formatters.formatCount(post.commentsCount),
          color: Colors.white,
          glow: Colors.transparent,
          onTap: onComment,
        ),
        const SizedBox(height: 14),
        _MusicDisk(accent: accent),
        const SizedBox(height: 10),
        _ActionBtn(
          icon: Icons.info_outline_rounded,
          label: 'Info',
          color: Colors.white,
          glow: Colors.transparent,
          onTap: onInfo,
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color glow;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.glow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasGlow = glow != Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: hasGlow
                    ? [BoxShadow(color: glow, blurRadius: 14, spreadRadius: 2)]
                    : null,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MusicDisk extends StatefulWidget {
  final Color accent;

  const _MusicDisk({required this.accent});

  @override
  State<_MusicDisk> createState() => _MusicDiskState();
}

class _MusicDiskState extends State<_MusicDisk>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _ctrl,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.6),
          border: Border.all(color: widget.accent, width: 2),
          boxShadow: [
            BoxShadow(color: widget.accent.withOpacity(0.4), blurRadius: 12),
          ],
        ),
        child: Icon(
          Icons.music_note_rounded,
          color: widget.accent,
          size: 18,
        ),
      ),
    );
  }
}

class _BottomInfo extends StatelessWidget {
  final PostModel post;
  final Color accent;
  final VoidCallback onFollow;
  final VoidCallback onMessage;

  const _BottomInfo({
    required this.post,
    required this.accent,
    required this.onFollow,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: accent, width: 2),
                boxShadow: [
                  BoxShadow(color: accent.withOpacity(0.4), blurRadius: 10),
                ],
                color: Colors.black38,
              ),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                post.username,
                style: AppTextStyles.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: onFollow,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: post.isFollowing ? Colors.white : accent.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: post.isFollowing ? Colors.white : accent.withOpacity(0.55),
                    width: 1.2,
                  ),
                ),
                child: Text(
                  post.isFollowing ? 'Following' : 'Follow',
                  style: TextStyle(
                    color: post.isFollowing ? Colors.black : accent,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onMessage,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20
