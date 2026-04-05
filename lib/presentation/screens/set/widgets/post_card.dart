hereimport 'package:flutter/material.dart';
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

              // Interested Label
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

              // Skip Label
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

              // Double Tap Heart
              if (_showHeart)
                Center(
                  child: ScaleTransition(
                    scale: _heartAnimation,
                    child: const Icon(
                      Icons.favorite,
                      color: AppColors.like,
                      size: 120,
                    ),
                  ),
                ),

              // Right Actions
              Positioned(
                right: 10,
                bottom: 75,
                child: _buildActions(),
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

  Widget _buildActions() {
    return Column(
      children: [
        _actionButton(
          icon: widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
          label: Formatters.formatCount(widget.post.likesCount),
          color: widget.post.isLiked ? AppColors.like : AppColors.white,
          onTap: _toggleLike,
        ),
        _actionButton(
          icon: Icons.comment_outlined,
          label: Formatters.formatCount(widget.post.commentsCount),
          color: AppColors.white,
          onTap: () {
            // TODO: Open comments
          },
        ),
        _actionButton(
          icon: Icons.change_history,
          label: 'Boost',
          color: AppColors.recommend,
          onTap: () {
            // TODO: Recommend
          },
        ),
        _actionButton(
          icon: Icons.send_outlined,
          label: Formatters.formatCount(widget.post.sendsCount),
          color: AppColors.white,
          onTap: () {
            // TODO: Send
          },
        ),
        const SizedBox(height: 6),
        _buildMusicDisk(),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () {
            // TODO: Show info
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
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
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

  Widget _buildMusicDisk() {
    return Container(
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
    );
  }

  Widget _buildBottomInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
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
            Expanded(
              child: Text(
                widget.post.username,
                style: AppTextStyles.username.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
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
