import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../data/models/dating_profile_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SwipeableCard extends StatefulWidget {
  final DatingProfileModel profile;
  final bool isBackground;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSuperLike;
  final VoidCallback? onTap;

  const SwipeableCard({
    super.key,
    required this.profile,
    this.isBackground = false,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSuperLike,
    this.onTap,
  });

  @override
  State<SwipeableCard> createState() => SwipeableCardState();
}

class SwipeableCardState extends State<SwipeableCard>
    with TickerProviderStateMixin {
  // --- Physics ---
  Offset _position = Offset.zero;
  double _rotation = 0;
  double _scale = 1.0;
  String? _swipeDirection;

  // --- Swipe thresholds ---
  static const double _swipeThreshold = 120.0;
  static const double _rotationFactor = 0.008;
  static const double _scaleFactor = 0.002;
  static const double _maxRotation = 0.35;

  // --- Dismissal animation ---
  AnimationController? _dismissController;
  Animation<Offset>? _dismissOffset;
  Animation<double>? _dismissRotation;
  Animation<double>? _dismissOpacity;
  bool _isDismissing = false;

  // --- Entrance animation ---
  late AnimationController _entryController;
  late Animation<double> _entryScale;
  late Animation<double> _entryOpacity;

  // --- Like/Nope indicator opacity ---
  double _likeOpacity = 0;
  double _nopeOpacity = 0;
  double _superLikeOpacity = 0;

  // --- Photo gallery ---
  late PageController _photoController;
  int _currentPhotoIndex = 0;
  int get _photoCount => widget.profile.imageUrls.length;

  // --- Verified pulse ---
  late AnimationController _verifiedPulseController;

  @override
  void initState() {
    super.initState();

    // Entry animation
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _entryScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );

    _entryOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );

    // Photo controller
    _photoController = PageController();

    // Verified pulse
    _verifiedPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Start entry
    if (!widget.isBackground) {
      _entryController.forward();
    }
  }

  @override
  void dispose() {
    _dismissController?.dispose();
    _entryController.dispose();
    _photoController.dispose();
    _verifiedPulseController.dispose();
    super.dispose();
  }

  // =========================================================================
  //  GESTURE HANDLERS
  // =========================================================================

  void _onPanStart(DragStartDetails details) {
    if (widget.isBackground || _isDismissing) return;
    HapticFeedback.selectionClick();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (widget.isBackground || _isDismissing) return;

    setState(() {
      _position += details.delta;

      // Rotation proportional to horizontal displacement
      _rotation = (_position.dx * _rotationFactor).clamp(
        -_maxRotation,
        _maxRotation,
      );

      // Scale down slightly when dragging far
      _scale = (1.0 - _position.dx.abs() * _scaleFactor).clamp(0.92, 1.0);

      // Swipe direction with thresholds
      if (_position.dx > 40) {
        _swipeDirection = 'right';
        _likeOpacity = ((_position.dx - 40) / 80).clamp(0.0, 1.0);
        _nopeOpacity = 0;
        _superLikeOpacity = 0;
      } else if (_position.dx < -40) {
        _swipeDirection = 'left';
        _nopeOpacity = ((_position.dx.abs() - 40) / 80).clamp(0.0, 1.0);
        _likeOpacity = 0;
        _superLikeOpacity = 0;
      } else if (_position.dy < -40) {
        _swipeDirection = 'up';
        _superLikeOpacity = ((_position.dy.abs() - 40) / 80).clamp(0.0, 1.0);
        _likeOpacity = 0;
        _nopeOpacity = 0;
      } else {
        _swipeDirection = null;
        _likeOpacity = 0;
        _nopeOpacity = 0;
        _superLikeOpacity = 0;
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (widget.isBackground || _isDismissing) return;

    final velocity = details.velocity.pixelsPerSecond;

    // Fast flick dismiss (velocity-based)
    if (velocity.dx > 500) {
      _animateDismiss(direction: 'right');
      return;
    } else if (velocity.dx < -500) {
      _animateDismiss(direction: 'left');
      return;
    } else if (velocity.dy < -500) {
      _animateDismiss(direction: 'up');
      return;
    }

    // Threshold-based dismiss
    if (_position.dx > _swipeThreshold) {
      _animateDismiss(direction: 'right');
    } else if (_position.dx < -_swipeThreshold) {
      _animateDismiss(direction: 'left');
    } else if (_position.dy < -_swipeThreshold) {
      _animateDismiss(direction: 'up');
    } else {
      // Spring back
      _animateReturn();
    }
  }

  // =========================================================================
  //  DISMISSAL ANIMATION
  // =========================================================================

  void _animateDismiss({required String direction}) {
    HapticFeedback.heavyImpact();
    _isDismissing = true;

    _dismissController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    final endOffset = switch (direction) {
      'right' => const Offset(600, 0),
      'left' => const Offset(-600, 0),
      'up' => const Offset(0, -800),
      _ => Offset.zero,
    };

    _dismissOffset = Tween<Offset>(
      begin: _position,
      end: endOffset,
    ).animate(CurvedAnimation(
      parent: _dismissController!,
      curve: Curves.easeInCubic,
    ));

    _dismissRotation = Tween<double>(
      begin: _rotation,
      end: direction == 'right'
          ? 0.4
          : direction == 'left'
              ? -0.4
              : 0,
    ).animate(CurvedAnimation(
      parent: _dismissController!,
      curve: Curves.easeInCubic,
    ));

    _dismissOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _dismissController!,
      curve: Curves.easeIn,
    ));

    _dismissController!.forward().then((_) {
      switch (direction) {
        case 'right':
          widget.onSwipeRight?.call();
        case 'left':
          widget.onSwipeLeft?.call();
        case 'up':
          widget.onSuperLike?.call();
      }
    });

    if (mounted) setState(() {});
  }

  void _animateReturn() {
    _dismissController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _dismissOffset = Tween<Offset>(
      begin: _position,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _dismissController!,
      curve: Curves.easeOutBack,
    ));

    _dismissRotation = Tween<double>(
      begin: _rotation,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _dismissController!,
      curve: Curves.easeOutBack,
    ));

    _dismissOpacity = null; // Don't animate opacity on return

    _dismissController!.forward().then((_) {
      if (mounted) {
        setState(() {
          _position = Offset.zero;
          _rotation = 0;
          _scale = 1.0;
          _swipeDirection = null;
          _likeOpacity = 0;
          _nopeOpacity = 0;
          _superLikeOpacity = 0;
          _isDismissing = false;
          _dismissController?.dispose();
          _dismissController = null;
        });
      }
    });

    if (mounted) setState(() {});
  }

  // =========================================================================
  //  BUILD
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    if (widget.isBackground) {
      return _buildBackgroundCard();
    }

    if (_isDismissing && _dismissController != null) {
      return AnimatedBuilder(
        animation: _dismissController!,
        builder: (context, _) {
          return Transform.translate(
            offset: _dismissOffset!.value,
            child: Opacity(
              opacity: _dismissOpacity?.value ?? 1.0,
              child: Transform.rotate(
                angle: _dismissRotation!.value,
                child: _buildActiveCard(),
              ),
            ),
          );
        },
      );
    }

    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, _) {
        return Opacity(
          opacity: _entryOpacity.value,
          child: Transform.scale(
            scale: _entryScale.value * _scale,
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              onTap: () => widget.onTap?.call(),
              child: Transform.translate(
                offset: _position,
                child: Transform.rotate(
                  angle: _rotation,
                  child: _buildActiveCard(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  //  BACKGROUND CARD
  // ---------------------------------------------------------------------------

  Widget _buildBackgroundCard() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _photoCount > 0 ? widget.profile.imageUrls[0] : '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.dating.withOpacity(0.1),
                      Colors.white.withOpacity(0.03),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.person_rounded,
                      size: 60, color: AppColors.grey2),
                ),
              ),
            ),
            // Dark overlay
            Container(color: Colors.black.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  ACTIVE CARD
  // ---------------------------------------------------------------------------

  Widget _buildActiveCard() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
          if (_swipeDirection != null)
            BoxShadow(
              color: _swipeDirection == 'right'
                  ? AppColors.neonGreen.withOpacity(0.15)
                  : _swipeDirection == 'left'
                      ? AppColors.neonRed.withOpacity(0.15)
                      : AppColors.neonYellow.withOpacity(0.15),
              blurRadius: 40,
              spreadRadius: 5,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // --- Photo Gallery ---
            _buildPhotoGallery(),

            // --- Gradient Overlay ---
            _buildGradientOverlay(),

            // --- Swipe Indicators ---
            _buildLikeIndicator(),
            _buildNopeIndicator(),
            _buildSuperLikeIndicator(),

            // --- Photo Indicators ---
            if (_photoCount > 1) _buildPhotoIndicators(),

            // --- Top badges ---
            _buildTopBadges(),

            // --- Locked Overlay ---
            if (widget.profile.isLocked) _buildLockedOverlay(),

            // --- Bottom Info ---
            _buildProfileInfo(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  PHOTO GALLERY
  // ---------------------------------------------------------------------------

  Widget _buildPhotoGallery() {
    if (_photoCount <= 1) {
      return Image.network(
        _photoCount > 0 ? widget.profile.imageUrls[0] : '',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.dating.withOpacity(0.15),
                Colors.white.withOpacity(0.03),
              ],
            ),
          ),
          child: const Center(
            child: Icon(Icons.person_rounded, size: 80, color: AppColors.grey2),
          ),
        ),
      );
    }

    return PageView.builder(
      controller: _photoController,
      itemCount: _photoCount,
      onPageChanged: (index) {
        setState(() => _currentPhotoIndex = index);
      },
      itemBuilder: (_, index) {
        return Image.network(
          widget.profile.imageUrls[index],
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.background,
            child: const Center(
              child: Icon(Icons.person_rounded,
                  size: 80, color: AppColors.grey2),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhotoIndicators() {
    return Positioned(
      top: 16,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_photoCount, (index) {
          final isActive = index == _currentPhotoIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            width: isActive ? 24 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(4),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.4),
                        blurRadius: 6,
                      ),
                    ]
                  : null,
            ),
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  GRADIENT OVERLAY
  // ---------------------------------------------------------------------------

  Widget _buildGradientOverlay() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: Container(
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.75),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  SWIPE INDICATORS
  // ---------------------------------------------------------------------------

  Widget _buildLikeIndicator() {
    return Positioned(
      top: 60,
      left: 24,
      child: Opacity(
        opacity: _likeOpacity.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: 0.8 + (_likeOpacity * 0.2),
          child: Transform.rotate(
            angle: -0.15,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColors.neonGreen,
                    width: 4,
                    strokeAlign: BorderSide.strokeAlignOutside),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'LIKE',
                style: TextStyle(
                  color: AppColors.neonGreen,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(color: AppColors.neonGreen, blurRadius: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNopeIndicator() {
    return Positioned(
      top: 60,
      right: 24,
      child: Opacity(
        opacity: _nopeOpacity.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: 0.8 + (_nopeOpacity * 0.2),
          child: Transform.rotate(
            angle: 0.15,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColors.neonRed,
                    width: 4,
                    strokeAlign: BorderSide.strokeAlignOutside),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'NOPE',
                style: TextStyle(
                  color: AppColors.neonRed,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(color: AppColors.neonRed, blurRadius: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuperLikeIndicator() {
    return Positioned(
      bottom: 240,
      left: 0,
      right: 0,
      child: Opacity(
        opacity: _superLikeOpacity.clamp(0.0, 1.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: 0.6 + (_superLikeOpacity * 0.4),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.neonYellow,
                    width: 4,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonYellow.withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: AppColors.neonYellow,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'SUPER LIKE',
              style: TextStyle(
                color: AppColors.neonYellow,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                shadows: [
                  Shadow(color: AppColors.neonYellow, blurRadius: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  TOP BADGES
  // ---------------------------------------------------------------------------

  Widget _buildTopBadges() {
    return Positioned(
      top: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Boosted badge
          if (widget.profile.isBoosted)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.neonYellow, Colors.orange],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonYellow.withOpacity(0.4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'مميز',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

          // Photo counter
          if (_photoCount > 1)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentPhotoIndex + 1}/$_photoCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  LOCKED OVERLAY
  // ---------------------------------------------------------------------------

  Widget _buildLockedOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      color: Colors.white70,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'مقفل',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'استخدم مفتاحاً لفتح الملف الشخصي',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  PROFILE INFO (Bottom Section)
  // ---------------------------------------------------------------------------

  Widget _buildProfileInfo() {
    if (widget.profile.isLocked) return const SizedBox.shrink();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name & Age & Verified
              Row(
                children: [
                  Text(
                    widget.profile.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      shadows: [
                        Shadow(color: Colors.black, blurRadius: 10),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${widget.profile.age}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (widget.profile.isVerified) ...[
                    const SizedBox(width: 8),
                    _buildVerifiedBadge(),
                  ],
                  const Spacer(),
                  // Distance pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.near_me_rounded,
                            color: Colors.white, size: 13),
                        const SizedBox(width: 4),
                        Text(
                          widget.profile.distance,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Location
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white70,
                    size: 15,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.profile.city,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Bio
              Text(
                widget.profile.bio,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 14,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 14),

              // Interests
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.profile.interests.take(4).map((interest) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Text(
                      interest,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return AnimatedBuilder(
      animation: _verifiedPulseController,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(
                    0.3 + (_verifiedPulseController.value * 0.3)),
                blurRadius: 8 + (_verifiedPulseController.value * 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 16,
          ),
        );
      },
    );
  }
}
