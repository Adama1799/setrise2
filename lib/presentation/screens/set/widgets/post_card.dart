import 'package:flutter/material.dart';
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

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  double _dragX = 0;
  bool _showHeart = false;
  late AnimationController _heartController;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _heartAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );
    _heartController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() => _showHeart = false);
            _heartController.reset();
          }
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
    if (!widget.post.isLiked) {
      _toggleLike();
    }
  }

  void _toggleLike() {
    widget.onUpdate(widget.post.copyWith(
      isLiked: !widget.post.isLiked,
      likesCount: widget.post.isLiked
          ? widget.post.likesCount - 1
          : widget.post.likesCount + 1,
    ));
  }

  void _togglePlay() {
    widget.onUpdate(widget.post.copyWith(
      isPlaying: !widget.post.isPlaying,
    ));
  }

  void _toggleFollow() {
    widget.onUpdate(widget.post.copyWith(
      isFollowing: !widget.post.isFollowing,
    ));
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() => _dragX += details.delta.dx);
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragX > 80 || _dragX < -80) {
      widget.onSwipeNext();
    }
    setState(() => _dragX = 0);
  }

  @override
  Widget build(BuildContext context) {
    final isRight = _dragX > 40;
    final isLeft = _dragX < -40;

    Color bgTint = Colors.transparent;
    if (_dragX > 0) {
      bgTint = AppColors.neonGreen.withOpacity((_dragX / 300).clamp(0, 0.3));
    } else if (_dragX < 0) {
      bgTint = AppColors.neonRed.withOpacity((-_dragX / 300).clamp(0, 0.3));
    }

    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      onTap: _togglePlay,
      onDoubleTap: _triggerHeart,
      child: Transform.translate(
        offset: Offset(_dragX * 0.2, 0),
        child: Transform.rotate(
          angle: _dragX / 1200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background
              Container(color: widget.post.backgroundColor),

              // Swipe Tint
              AnimatedContainer(
                duration: const Duration(milliseconds: 50),
                color: bgTint,
              ),

              // Play/Pause Icon
              if (!widget.post.isPlaying)
                Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: AppColors.white,
                      size: 44,
                    ),
                  ),
                ),

              // Bottom Gradient
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 320,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.95),
                      ],
                    ),
                  ),
                ),
              ),

              // INTERESTED Label
              if (isRight)
                Positioned(
                  top: 100,
                  left: 20,
                  child: Transform.rotate(
                    angle: -0.3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.neonGreen, width: 3),
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.neonGreen.withOpacity(0.1),
                      ),
                      child: Text(
                        'INTERESTED',
                        style: AppTextStyles.h5.copyWith(
                          color: AppColors.neonGreen,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),

              // SKIP Label
              if (isLeft)
                Positioned(
                  top: 100,
                  right: 20,
                  child: Transform.rotate(
                    angle: 0.3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.neonRed, width: 3),
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.neonRed.withOpacity(0.1),
                      ),
                      child: Text(
                        'SKIP',
                        style: AppTextStyles.h5.copyWith(
                          color: AppColors.neonRed,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),

              // Double Tap Heart Animation
              if (_showHeart)
                Center(
                  child: ScaleTransition(
                    scale: _heartAnimation,
                    child: _FourPointStar(
                      size: 120,
                      color: AppColors.neonYellow,
                    ),
                  ),
                ),

              // Right Actions Bar
              Positioned(
                right: 10,
                bottom: 75,
                child: _buildActionsBar(),
              ),

              // Bottom Info
              Positioned(
                bottom: 70,
                left: 12,
                right: 80,
                child: _buildBottomInfo(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== ACTIONS BAR =====
  Widget _buildActionsBar() {
    return Column(
      children: [
        // ✦ Like (Four-point star)
        _actionButton(
          child: _FourPointStar(
            size: 30,
            color: widget.post.isLiked ? AppColors.neonYellow : AppColors.white,
          ),
          label: Formatters.formatCount(widget.post.likesCount),
          onTap: _toggleLike,
        ),
        
        // 💬 Comment
        _actionButton(
          child: Icon(
            Icons.chat_bubble_outline,
            color: AppColors.white,
            size: 30,
          ),
          label: Formatters.formatCount(widget.post.commentsCount),
          onTap: () {
            // TODO: Open comments
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Comments - Coming soon!')),
            );
          },
        ),
        
        // △ Recommend (Triangle)
        _actionButton(
          child: Transform.rotate(
            angle: 0,
            child: const Icon(
              Icons.change_history,
              color: AppColors.neonGreen,
              size: 30,
            ),
          ),
          label: 'Boost',
          onTap: () {
            // TODO: Recommend
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Recommend - Coming soon!')),
            );
          },
        ),
        
        // ↗️ Share
        _actionButton(
          child: const Icon(
            Icons.share_outlined,
            color: AppColors.white,
            size: 30,
          ),
          label: Formatters.formatCount(widget.post.sharesCount),
          onTap: () {
            // TODO: Share
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share - Coming soon!')),
            );
          },
        ),

        const SizedBox(height: 8),
        
        // 🎵 Music Disk (Rotating)
        _MusicDisk(),
        
        const SizedBox(height: 8),
        
        // ⬆️ Info
        GestureDetector(
          onTap: () {
            // TODO: Show info sheet
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Info - Coming soon!')),
            );
          },
          child: Column(
            children: [
              const Icon(
                Icons.keyboard_arrow_up,
                color: AppColors.white,
                size: 28,
              ),
              Text(
                'Info',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required Widget child,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            child,
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== BOTTOM INFO =====
  Widget _buildBottomInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.grey,
              child: const Icon(
                Icons.person,
                color: AppColors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            
            // Username
            Expanded(
              child: Text(
                widget.post.username,
                style: AppTextStyles.username.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
            
            // Follow Button
            if (!widget.post.isFollowing)
              GestureDetector(
                onTap: _toggleFollow,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.white, width: 1.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Follow',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Title
        Text(
          widget.post.title,
          style: AppTextStyles.postTitle.copyWith(
            color: AppColors.white,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ===== CUSTOM WIDGETS =====

// ✦ Four-Point Star (نجمة رباعية)
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

    // Create 4-point star
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

// Import for cos/sin
import 'dart:math' show cos, sin;

// 🎵 Music Disk (Rotating)
class _MusicDisk extends StatefulWidget {
  @override
  State<_MusicDisk> createState() => _MusicDiskState();
}

class _MusicDiskState extends State<_MusicDisk>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 2),
          color: AppColors.grey,
        ),
        child: const Icon(
          Icons.music_note,
          color: AppColors.white,
          size: 20,
        ),
      ),
    );
  }
}
