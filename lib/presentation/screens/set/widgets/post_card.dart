import 'package:flutter/material.dart';
import 'dart:math' show cos, sin, pi;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/models/post_model.dart';

// ─── Vero-style: content-first, dynamic color, full-bleed ─────────────────────

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

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartAnimation;
  bool _showHeart = false;

  // Derived accent color from post background — simulates dynamic extraction
  Color get _accent => _deriveAccent(widget.post.backgroundColor);
  Color get _accentGlow => _accent.withOpacity(0.35);

  // Simulate color extraction: shift hue toward vivid neon
  Color _deriveAccent(Color base) {
    final HSLColor hsl = HSLColor.fromColor(base);
    return hsl
        .withSaturation(1.0)
        .withLightness(0.62)
        .toColor();
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
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) setState(() => _showHeart = false);
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
    _heartController.forward();
    if (!widget.post.isLiked) _toggleLike();
  }

  void _toggleLike() {
    widget.onUpdate(widget.post.copyWith(
      isLiked: !widget.post.isLiked,
      likesCount: widget.post.isLiked
          ? widget.post.likesCount - 1
          : widget.post.likesCount + 1,
    ));
  }

  void _togglePlay() =>
      widget.onUpdate(widget.post.copyWith(isPlaying: !widget.post.isPlaying));

  void _toggleFollow() =>
      widget.onUpdate(widget.post.copyWith(isFollowing: !widget.post.isFollowing));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlay,
      onDoubleTap: _triggerHeart,
      child: Stack(fit: StackFit.expand, children: [
        // ── 1. BACKGROUND — dynamic color field ──────────────────────────────
        _DynamicBackground(
          baseColor: widget.post.backgroundColor,
          accentColor: _accent,
        ),

        // ── 2. CONTENT placeholder (video/image area) ─────────────────────
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
              child: Icon(Icons.play_arrow_rounded,
                  color: _accent, size: 42),
            ),
          ),

        // ── 3. BOTTOM GRADIENT — content bleeds into UI ──────────────────
        Positioned(
          bottom: 0, left: 0, right: 0, height: 380,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  widget.post.backgroundColor.withOpacity(0.5),
                  Colors.black.withOpacity(0.92),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),

        // ── 4. HEART animation ────────────────────────────────────────────
        if (_showHeart)
          Center(
            child: ScaleTransition(
              scale: _heartAnimation,
              child: _StarBurst(color: _accent, size: 120),
            ),
          ),

        // ── 5. RIGHT ACTION BAR ───────────────────────────────────────────
        Positioned(
          right: 12,
          bottom: 90,
          child: _ActionBar(
            post: widget.post,
            accent: _accent,
            onLike: _toggleLike,
            onComment: () => _showComments(context),
            onShare: () => widget.onUpdate(
                widget.post.copyWith(isShared: !widget.post.isShared)),
          ),
        ),

        // ── 6. BOTTOM INFO ────────────────────────────────────────────────
        Positioned(
          bottom: 72,
          left: 14,
          right: 80,
          child: _BottomInfo(
            post: widget.post,
            accent: _accent,
            onFollow: _toggleFollow,
          ),
        ),
      ]),
    );
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CommentsSheet(accent: _accent),
    );
  }
}

// ─── Dynamic Background ────────────────────────────────────────────────────────
class _DynamicBackground extends StatelessWidget {
  final Color baseColor;
  final Color accentColor;
  const _DynamicBackground({required this.baseColor, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      // Base solid
      ColoredBox(color: baseColor),

      // Glowing orb top-left
      Positioned(
        top: -60, left: -60,
        child: Container(
          width: 280, height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              accentColor.withOpacity(0.28),
              Colors.transparent,
            ]),
          ),
        ),
      ),

      // Glowing orb bottom-right
      Positioned(
        bottom: -40, right: -40,
        child: Container(
          width: 220, height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              accentColor.withOpacity(0.20),
              Colors.transparent,
            ]),
          ),
        ),
      ),

      // Subtle noise overlay for depth
      Positioned.fill(
        child: Opacity(
          opacity: 0.06,
          child: CustomPaint(painter: _NoisePainter()),
        ),
      ),
    ]);
  }
}

// ─── Right Action Bar ─────────────────────────────────────────────────────────
class _ActionBar extends StatelessWidget {
  final PostModel post;
  final Color accent;
  final VoidCallback onLike, onComment, onShare;

  const _ActionBar({
    required this.post,
    required this.accent,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Like
      _ActionBtn(
        icon: post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        label: Formatters.formatCount(post.likesCount),
        color: post.isLiked ? accent : Colors.white,
        glow: post.isLiked ? accent : Colors.transparent,
        onTap: onLike,
      ),
      const SizedBox(height: 4),
      // Comment
      _ActionBtn(
        icon: Icons.chat_bubble_outline_rounded,
        label: Formatters.formatCount(post.commentsCount),
        color: Colors.white,
        glow: Colors.transparent,
        onTap: onComment,
      ),
      const SizedBox(height: 4),
      // Boost (triangle)
      _ActionBtn(
        icon: Icons.change_history_rounded,
        label: 'Boost',
        color: AppColors.neonGreen,
        glow: Colors.transparent,
        onTap: () {},
      ),
      const SizedBox(height: 4),
      // Share
      _ActionBtn(
        icon: Icons.send_rounded,
        label: Formatters.formatCount(post.sharesCount),
        color: Colors.white,
        glow: Colors.transparent,
        onTap: onShare,
      ),
      const SizedBox(height: 16),
      // Spinning music disk
      _MusicDisk(accent: accent),
    ]);
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color, glow;
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
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: glow != Colors.transparent
                  ? [BoxShadow(color: glow, blurRadius: 14, spreadRadius: 2)]
                  : null,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 3),
          Text(label, style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}

// ─── Music Disk ───────────────────────────────────────────────────────────────
class _MusicDisk extends StatefulWidget {
  final Color accent;
  const _MusicDisk({required this.accent});
  @override State<_MusicDisk> createState() => _MusicDiskState();
}

class _MusicDiskState extends State<_MusicDisk> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _ctrl,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.6),
          border: Border.all(color: widget.accent, width: 2),
          boxShadow: [BoxShadow(color: widget.accent.withOpacity(0.4), blurRadius: 12)],
        ),
        child: Icon(Icons.music_note_rounded, color: widget.accent, size: 18),
      ),
    );
  }
}

// ─── Bottom Info ──────────────────────────────────────────────────────────────
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Username row
      Row(children: [
        // Avatar with accent ring
        Container(
          width: 36, height: 36,
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
          child: Text(post.username,
            style: AppTextStyles.labelLarge.copyWith(
              color: Colors.white, fontWeight: FontWeight.w800)),
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
              child: Text('Follow',
                style: AppTextStyles.labelSmall.copyWith(
                  color: accent, fontWeight: FontWeight.bold)),
            ),
          ),
      ]),
      const SizedBox(height: 10),
      // Title
      Text(post.title,
        style: AppTextStyles.postTitle.copyWith(
          color: Colors.white, height: 1.35),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      const SizedBox(height: 8),
      // Hashtags with accent color
      if (post.hashtags != null)
        Text(post.hashtags!,
          style: AppTextStyles.labelSmall.copyWith(
            color: accent, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
    ]);
  }
}

// ─── Starburst (double-tap animation) ────────────────────────────────────────
class _StarBurst extends StatelessWidget {
  final Color color;
  final double size;
  const _StarBurst({required this.color, required this.size});

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
    final cx = size.width / 2, cy = size.height / 2;
    final outer = size.width / 2, inner = size.width / 4.5;
    const points = 8;
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * pi / points) - pi / 2;
      final r = i.isEven ? outer : inner;
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    // Glow
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Noise Painter (texture depth) ───────────────────────────────────────────
class _NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final rng = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < 800; i++) {
      final x = ((rng * (i + 1) * 6364136223846793005 + 1442695040888963407) & 0xFFFF) /
          0xFFFF * size.width;
      final y = ((rng * (i + 2) * 2862933555777941757 + 3037000499) & 0xFFFF) /
          0xFFFF * size.height;
      canvas.drawCircle(Offset(x, y), 0.6, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Comments Sheet ───────────────────────────────────────────────────────────
class _CommentsSheet extends StatefulWidget {
  final Color accent;
  const _CommentsSheet({required this.accent});
  @override State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final _ctrl = TextEditingController();
  final List<Map<String, dynamic>> _comments = [
    {'user': 'ahmed_99', 'text': 'This is 🔥🔥', 'time': '2m', 'likes': 24},
    {'user': 'sara_x',   'text': 'Love this content ❤️', 'time': '5m', 'likes': 18},
    {'user': 'nora_m',   'text': 'Amazing shot!', 'time': '12m', 'likes': 9},
  ];

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  void _send() {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() {
      _comments.insert(0, {
        'user': 'You', 'text': _ctrl.text.trim(), 'time': 'now', 'likes': 0,
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
        border: Border(top: BorderSide(color: widget.accent.withOpacity(0.3), width: 1.5)),
      ),
      child: Column(children: [
        const SizedBox(height: 12),
        Container(width: 40, height: 4,
          decoration: BoxDecoration(color: widget.accent.withOpacity(0.4),
            borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 14),
        Text('Comments', style: AppTextStyles.h5.copyWith(color: Colors.white)),
        Divider(color: widget.accent.withOpacity(0.15), height: 20),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _comments.length,
          itemBuilder: (_, i) {
            final c = _comments[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 36, height: 36,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    color: AppColors.grey,
                    border: Border.all(color: widget.accent.withOpacity(0.4))),
                  child: const Icon(Icons.person, color: Colors.white, size: 20)),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(c['user'], style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    Text(c['time'], style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.grey2)),
                  ]),
                  const SizedBox(height: 4),
                  Text(c['text'], style: AppTextStyles.body2.copyWith(color: Colors.white)),
                ])),
              ]),
            );
          },
        )),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            border: Border(top: BorderSide(color: widget.accent.withOpacity(0.15)))),
          child: Row(children: [
            Expanded(child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(21),
                border: Border.all(color: widget.accent.withOpacity(0.3)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(controller: _ctrl,
                style: AppTextStyles.body2.copyWith(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: AppTextStyles.body2.copyWith(color: AppColors.grey2),
                  border: InputBorder.none)),
            )),
            const SizedBox(width: 10),
            GestureDetector(onTap: _send,
              child: Container(width: 42, height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.accent,
                  boxShadow: [BoxShadow(color: widget.accent.withOpacity(0.4),
                    blurRadius: 12)]),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 18))),
          ]),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ]),
    );
  }
}
