import 'package:flutter/material.dart';
import '../../../../data/models/dating_profile_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SwipeableCard extends StatefulWidget {
  final DatingProfileModel profile;
  final bool isBackground;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onTap;

  const SwipeableCard({
    super.key,
    required this.profile,
    this.isBackground = false,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onTap,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard> {
  Offset _position = Offset.zero;
  double _rotation = 0;
  String? _swipeDirection;

  void _onPanStart(DragStartDetails details) {
    if (widget.isBackground) return;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (widget.isBackground) return;
    
    setState(() {
      _position += details.delta;
      _rotation = _position.dx * 0.02;
      
      if (_position.dx > 50) {
        _swipeDirection = 'right';
      } else if (_position.dx < -50) {
        _swipeDirection = 'left';
      } else {
        _swipeDirection = null;
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (widget.isBackground) return;
    
    if (_position.dx > 100) {
      widget.onSwipeRight?.call();
    } else if (_position.dx < -100) {
      widget.onSwipeLeft?.call();
    } else {
      setState(() {
        _position = Offset.zero;
        _rotation = 0;
        _swipeDirection = null;
      });
    }
  }

  void _onTap() {
    if (_position.dx.abs() < 5) {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBackground) {
      return _buildBackgroundCard();
    }

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onTap: _onTap,
      child: Transform.translate(
        offset: _position,
        child: Transform.rotate(
          angle: _rotation,
          child: _buildActiveCard(),
        ),
      ),
    );
  }

  Widget _buildBackgroundCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.network(
          widget.profile.imageUrls[0],
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget _buildActiveCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.network(
              widget.profile.imageUrls[0],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
            
            // Swipe Indicators
            if (_swipeDirection == 'right')
              Positioned(
                top: 40,
                left: 30,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.neonGreen, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'LIKE',
                    style: TextStyle(
                      color: AppColors.neonGreen,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            
            if (_swipeDirection == 'left')
              Positioned(
                top: 40,
                right: 30,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.neonRed, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'NOPE',
                    style: TextStyle(
                      color: AppColors.neonRed,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            
            // Locked Overlay
            if (widget.profile.isLocked)
              Container(
                color: Colors.black.withOpacity(0.6),
                child: BackdropFilter(
                  filter: const ColorFilter.matrix([
                    1, 0, 0, 0, 0,
                    0, 1, 0, 0, 0,
                    0, 0, 1, 0, 0,
                    0, 0, 0, 0.5, 0,
                  ]),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_rounded,
                          color: Colors.white70,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'مقفل',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'استخدم مفتاحاً لفتح',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            
            // Boosted Badge
            if (widget.profile.isBoosted)
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.neonYellow, Colors.orange],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'مميز',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Profile Info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name & Age
                    Row(
                      children: [
                        Text(
                          widget.profile.name,
                          style: AppTextStyles.profileName,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.profile.age}',
                          style: AppTextStyles.profileAge,
                        ),
                        if (widget.profile.isVerified) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.neonBlue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.grey1,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.profile.city,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.grey1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.grey1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.profile.distance,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.grey1,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Bio
                    Text(
                      widget.profile.bio,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Interests
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.profile.interests
                          .take(4)
                          .map((interest) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  interest,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
