import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' show cos, sin, pi;
import 'dart:ui';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/models/post_model.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final ValueChanged<PostModel> onUpdate;
  final VoidCallback onSwipeNext;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeStart;
  final VoidCallback? onSwipeEnd;

  const PostCard({
    super.key,
    required this.post,
    required this.onUpdate,
    required this.onSwipeNext,
    this.onSwipeRight,
    this.onSwipeLeft,
    this.onSwipeStart,
    this.onSwipeEnd,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartAnimation;
  bool _showHeart = false;

  double _dragX = 0.0;
  bool _isDraggingHorizontal = false;
  bool _isDismissing = false;

  Color get _accent => _deriveAccent(widget.post.backgroundColor);
  Color get _accentGlow => _accent.withOpacity(0.35);

  Color _deriveAccent(Color base) {
    final HSLColor hsl = HSLColor.fromColor(base);
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
    _heartController.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
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

  void _finishSwipe({bool notifyEnd = true}) {
    if (!mounted) return;
    setState(() {
      _dragX = 0;
      _isDraggingHorizontal = false;
      _isDismissing = false;
    });
    if (notifyEnd) {
      widget.onSwipeEnd?.call();
    }
  }

  void _handleHorizontalDragStart(DragStartDetails details) {
    if (_isDismissing) return;
    _isDraggingHorizontal = true;
    widget.onSwipeStart?.call();
  }

  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isDismissing) return;
    final width = MediaQuery.of(context).size.width;
    setState(() {
      _dragX = (_dragX + details.delta.dx).clamp(-width * 1.15, width * 1.15).toDouble();
      _isDraggingHorizontal = true;
    });
  }

  void _handleHorizontalDragEnd(DragEndDetails details) {
    if (_isDismissing) return;

    final width = MediaQuery.of(context).size.width;
    final velocity = details.primaryVelocity ?? 0;
    final passedThreshold = _dragX.abs() > width * 0.22 || velocity.abs() > 850;

    if (passedThreshold) {
      final swipeRight = _dragX >= 0 || velocity > 0;
      final targetX = swipeRight ? width * 1.2 : -width * 1.2;

      HapticFeedback.mediumImpact();

      setState(() {
        _dragX = targetX;
        _isDismissing = true;
      });

      if (swipeRight) {
        widget.onSwipeRight?.call();
      } else {
        widget.onSwipeLeft?.call();
      }

      Future.delayed(const Duration(milliseconds: 170), () {
        if (!mounted) return;
        widget.onSwipeNext();
        _finishSwipe();
      });
    } else {
      HapticFeedback.selectionClick();
      _finishSwipe();
    }
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
    final width = MediaQuery.of(context).size.width;
    final showInterested = _dragX > 44;
    final showSkip = _dragX < -44;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _togglePlay,
      onDoubleTap: _triggerHeart,
      onHorizontalDragStart: _handleHorizontalDragStart,
      onHorizontalDragUpdate: _handleHorizontalDragUpdate,
      onHorizontalDragEnd: _handleHorizontalDragEnd,
      onHorizontalDragCancel: () {
        if (!_isDismissing) {
          _finishSwipe();
        }
      },
      child: Transform.translate(
        offset: Offset(_dragX, 0),
        child: Transform.rotate(
          angle: width == 0 ? 0.0 : ((_dragX / width) * 0.08).clamp(-0.08, 0.08).toDouble(),
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

              if (showInterested)
                Positioned(
                  top: 110,
                  left: 18,
                  child: Transform.rotate(
                    angle: -0.18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.greenAccent, width: 2),
                      ),
                      child: const Text(
                        'INTERESTED',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                ),

              if (showSkip)
                Positioned(
                  top: 110,
                  right: 18,
                  child: Transform.rotate(
                    angle: 0.18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.redAccent, width: 2),
                      ),
                      child: const Text(
                        'SKIP',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
                          letterSpacing: 0.6,
                        ),
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
                right: 10,
                bottom: bottomSafe + 6,
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
                bottom: bottomSafe + 2,
                left: 14,
                right: 80,
                child: _BottomInfo(
                  post: widget.post,
                  accent: _accent,
                  onFollow: _toggleFollow,
                ),
              ),
            ],
          ),
        ),
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
        const SizedBox(height: 6),
        _ActionBtn(
          icon: Icons.chat_bubble_outline_rounded,
          label: Formatters.formatCount(post.commentsCount),
          color: Colors.white,
          glow: Colors.transparent,
          onTap: onComment,
        ),
        const SizedBox(height: 6),
        _ActionBtn(
          icon: Icons.change_history_rounded,
          label: 'Boost',
          color: AppColors.neonGreen,
          glow: Colors.transparent,
          onTap: () {},
        ),
        const SizedBox(height: 6),
        _ActionBtn(
          icon: Icons.send_rounded,
          label: Formatters.formatCount(post.sharesCount),
          color: Colors.white,
          glow: Colors.transparent,
          onTap: onShare,
        ),
        const SizedBox(height: 10),
        _MusicDisk(accent: accent),
        const SizedBox(height: 8),
        _ActionBtn(
          icon: Icons.keyboard_arrow_up_rounded,
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
        padding: const EdgeInsets.symmetric(vertical: 2),
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
            const SizedBox(height: 2),
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

class _MusicDiskState extends State<_MusicDisk> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

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

  const _BottomInfo({
    required this.post,
    required this.accent,
    required this.onFollow,
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
                boxShadow: [BoxShadow(color: accent.withOpacity(0.4), blurRadius: 10)],
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
            if (!post.isFollowing)
              GestureDetector(
                onTap: onFollow,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: accent, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                    color: accent.withOpacity(0.12),
                  ),
                  child: Text(
                    'Follow',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          post.title,
          style: AppTextStyles.postTitle.copyWith(
            color: Colors.white,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _InfoSheet extends StatelessWidget {
  final PostModel post;
  final Color accent;
  final VoidCallback onFollow;
  final VoidCallback onMessage;

  const _InfoSheet({
    required this.post,
    required this.accent,
    required this.onFollow,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    final contentType = post.isPlaying ? 'Video / Media' : 'Image / Post';
    final fullBio =
        'Bio كامل لصاحب المحتوى: هذا الحساب ينشر محتوى قصير، تفاعلي، ويهتم بالمشاركة السريعة والردود المباشرة.';

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.48,
      maxChildSize: 0.94,
      builder: (_, controller) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D0D).withOpacity(0.88),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border(
                  top: BorderSide(color: accent.withOpacity(0.35), width: 1.4),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: accent, width: 2),
                            color: Colors.black38,
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Creator profile • connected to the current post',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.65),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: onFollow,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: post.isFollowing ? Colors.white : accent.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(999),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _SectionTitle(title: 'Bio'),
                        const SizedBox(height: 8),
                        _DarkCard(
                          child: Text(
                            fullBio,
                            style: const TextStyle(
                              color: Colors.white70,
                              height: 1.55,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _SectionTitle(title: 'Content'),
                        const SizedBox(height: 8),
                        _DarkCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoRow(label: 'Type', value: contentType, accent: accent),
                              const SizedBox(height: 12),
                              _InfoRow(label: 'Title', value: post.title, accent: accent),
                              const SizedBox(height: 12),
                              _InfoRow(
                                label: 'Audio',
                                value: 'Original audio',
                                accent: accent,
                              ),
                              const SizedBox(height: 12),
                              _InfoRow(
                                label: 'Views',
                                value: Formatters.formatCount(post.viewsCount),
                                accent: accent,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        _SectionTitle(title: 'Post description'),
                        const SizedBox(height: 8),
                        _DarkCard(
                          child: Text(
                            post.title,
                            style: const TextStyle(
                              color: Colors.white70,
                              height: 1.55,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (post.hashtags != null) ...[
                          _SectionTitle(title: 'Hashtags'),
                          const SizedBox(height: 8),
                          _DarkCard(
                            child: Text(
                              post.hashtags!,
                              style: TextStyle(
                                color: accent,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                        _SectionTitle(title: 'Quick stats'),
                        const SizedBox(height: 8),
                        _DarkCard(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _MiniStat(label: 'Likes', value: post.likesCount.toString()),
                              _MiniStat(label: 'Comments', value: post.commentsCount.toString()),
                              _MiniStat(label: 'Shares', value: post.sharesCount.toString()),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: onMessage,
                                child: Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.white12),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Message',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: onFollow,
                                child: Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: accent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Follow',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MessageSheet extends StatefulWidget {
  final PostModel post;
  final Color accent;

  const _MessageSheet({
    required this.post,
    required this.accent,
  });

  @override
  State<_MessageSheet> createState() => _MessageSheetState();
}

class _MessageSheetState extends State<_MessageSheet> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _send() {
    if (_ctrl.text.trim().isEmpty) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message prepared')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.42,
      minChildSize: 0.32,
      maxChildSize: 0.68,
      builder: (_, controller) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              color: const Color(0xFF0C0C0C).withOpacity(0.9),
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white10,
                        child: const Icon(Icons.person_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Message ${widget.post.username}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _ctrl,
                    maxLines: 5,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Write your message...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.45)),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: widget.accent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          'Send',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _DarkCard extends StatelessWidget {
  final Widget child;

  const _DarkCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 84,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Icon(Icons.circle, color: accent, size: 8),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _StarBurst extends StatelessWidget {
  final Color color;
  final double size;

  const _StarBurst({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _StarBurstPainter(color: color),
    );
  }
}

class _StarBurstPainter extends CustomPainter {
  final Color color;

  const _StarBurstPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outer = size.width / 2;
    final inner = size.width / 4.5;
    const points = 8;
    final path = Path();

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * pi / points) - pi / 2;
      final r = i.isEven ? outer : inner;
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();

    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StarBurstPainter oldDelegate) => false;
}

class _NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final rng = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < 800; i++) {
      final x = (((rng * (i + 1) * 6364136223846793005 + 1442695040888963407) & 0xFFFF) / 0xFFFF) * size.width;
      final y = (((rng * (i + 2) * 2862933555777941757 + 3037000499) & 0xFFFF) / 0xFFFF) * size.height;
      canvas.drawCircle(Offset(x, y), 0.6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) => false;
}

class _CommentsSheet extends StatefulWidget {
  final Color accent;

  const _CommentsSheet({required this.accent});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final _ctrl = TextEditingController();
  final List<Map<String, dynamic>> _comments = [
    {'user': 'ahmed_99', 'text': 'This is 🔥🔥', 'time': '2m', 'likes': 24},
    {'user': 'sara_x', 'text': 'Love this content ❤️', 'time': '5m', 'likes': 18},
    {'user': 'nora_m', 'text': 'Amazing shot!', 'time': '12m', 'likes': 9},
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _send() {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() {
      _comments.insert(0, {
        'user': 'You',
        'text': _ctrl.text.trim(),
        'time': 'now',
        'likes': 0,
      });
      _ctrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: widget.accent.withOpacity(0.3), width: 1.5),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: widget.accent.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Comments',
            style: AppTextStyles.h5.copyWith(color: Colors.white),
          ),
          Divider(color: widget.accent.withOpacity(0.15), height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _comments.length,
              itemBuilder: (_, i) {
                final c = _comments[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.grey,
                          border: Border.all(color: widget.accent.withOpacity(0.4)),
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  c['user'],
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  c['time'],
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.grey2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              c['text'],
                              style: AppTextStyles.body2.copyWith(color: Colors.white),
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
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              border: Border(
                top: BorderSide(color: widget.accent.withOpacity(0.15)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.grey,
                      borderRadius: BorderRadius.circular(21),
                      border: Border.all(color: widget.accent.withOpacity(0.3)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _ctrl,
                      style: AppTextStyles.body2.copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: AppTextStyles.body2.copyWith(color: AppColors.grey2),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.accent,
                      boxShadow: [
                        BoxShadow(
                          color: widget.accent.withOpacity(0.4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
