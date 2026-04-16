// lib/presentation/screens/date/widgets/swipeable_card.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/dating_profile_model.dart';

class SwipeableCard extends StatefulWidget {
  final DatingProfileModel profile;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onTap;
  final bool isBackground;

  const SwipeableCard({
    super.key,
    required this.profile,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onTap,
    this.isBackground = false,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard> with SingleTickerProviderStateMixin {
  double _dragX = 0;
  final double _swipeThreshold = 80;
  late final PageController _imageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _imageController = PageController();
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (widget.isBackground) return;
    setState(() => _dragX += details.delta.dx);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (widget.isBackground) return;
    if (_dragX > _swipeThreshold) {
      widget.onSwipeRight?.call();
    } else if (_dragX < -_swipeThreshold) {
      widget.onSwipeLeft?.call();
    } else {
      setState(() => _dragX = 0);
    }
  }

  int _sharedInterestsCount() {
    // محاكاة اهتمامات المستخدم الحالي
    const myInterests = ['Travel', 'Music', 'Tech', 'Photography'];
    return widget.profile.interests.where((i) => myInterests.contains(i)).length;
  }

  @override
  Widget build(BuildContext context) {
    final isRight = _dragX > 40;
    final isLeft = _dragX < -40;
    final sharedCount = _sharedInterestsCount();

    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      onTap: widget.onTap,
      child: Transform.translate(
        offset: Offset(_dragX, 0),
        child: Transform.rotate(
          angle: _dragX / 800,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(24),
              border: widget.profile.isBoosted ? Border.all(color: Colors.purpleAccent, width: 3) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  controller: _imageController,
                  onPageChanged: (index) => setState(() => _currentImageIndex = index),
                  itemCount: widget.profile.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          widget.profile.imageUrls[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.grey,
                            child: const Icon(Icons.person, color: Colors.white54, size: 80),
                          ),
                        ),
                        if (widget.profile.isLocked)
                          Container(
                            color: Colors.black.withOpacity(0.6),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.lock_rounded, color: Colors.white, size: 48),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Locked Profile',
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.dating,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text('Tap to unlock', style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                if (widget.profile.imageUrls.length > 1)
                  Positioned(
                    top: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.profile.imageUrls.length,
                        (index) => Container(
                          width: 30,
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _currentImageIndex == index ? Colors.white : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 250,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                      ),
                    ),
                  ),
                ),
                if (isRight && !widget.isBackground)
                  Positioned(
                    top: 40,
                    left: 20,
                    child: Transform.rotate(
                      angle: -0.3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.dating, width: 3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'LIKE 💛',
                          style: TextStyle(color: AppColors.dating, fontSize: 26, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                if (isLeft && !widget.isBackground)
                  Positioned(
                    top: 40,
                    right: 20,
                    child: Transform.rotate(
                      angle: 0.3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.neonRed, width: 3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'NOPE ✕',
                          style: TextStyle(color: AppColors.neonRed, fontSize: 26, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                if (widget.profile.isBoosted && !widget.isBackground)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text('BOOSTED', style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${widget.profile.name}, ${widget.profile.age}',
                              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            if (widget.profile.isVerified) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.verified, color: AppColors.electricBlue, size: 20),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.grey2, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.profile.city} · ${widget.profile.distance}',
                              style: const TextStyle(color: AppColors.grey2, fontSize: 13),
                            ),
                          ],
                        ),
                        if (sharedCount > 0) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.dating.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.favorite_rounded, color: AppColors.dating, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '$sharedCount shared interest${sharedCount > 1 ? 's' : ''}',
                                  style: TextStyle(color: AppColors.dating, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          widget.profile.bio,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          children: widget.profile.interests.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.dating.withOpacity(0.6)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(tag, style: const TextStyle(color: AppColors.dating, fontSize: 12)),
                            );
                          }).toList(),
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
    );
  }
}
