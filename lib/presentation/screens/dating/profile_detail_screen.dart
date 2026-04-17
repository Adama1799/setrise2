import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/models/dating_profile_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileDetailScreen extends StatefulWidget {
  final DatingProfileModel profile;
  final VoidCallback onUnlock;
  final VoidCallback onSuperLike;

  const ProfileDetailScreen({
    super.key,
    required this.profile,
    required this.onUnlock,
    required this.onSuperLike,
  });

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen>
    with TickerProviderStateMixin {
  // --- Photo gallery ---
  late PageController _pageController;
  int _currentPhotoIndex = 0;

  // --- Animation ---
  late AnimationController _entryController;
  late AnimationController _heartController;
  late AnimationController _unlockController;

  // --- Scroll ---
  final ScrollController _scrollController = ScrollController();
  bool _showPhotoOverlay = true;

  // --- Action state ---
  bool _isLiked = false;
  bool _isSuperLiked = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    // Entry animation
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Heart pulse for like button
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 1.0,
      upperBound: 1.3,
    );

    // Unlock animation
    _unlockController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entryController.dispose();
    _heartController.dispose();
    _unlockController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // =========================================================================
  //  GETTERS
  // =========================================================================

  int get _photoCount => widget.profile.imageUrls.length;
  bool get _isLocked => widget.profile.isLocked;
  bool get _isBoosted => widget.profile.isBoosted;
  bool get _isVerified => widget.profile.isVerified;

  // =========================================================================
  //  ACTIONS
  // =========================================================================

  void _onLike() {
    HapticFeedback.lightImpact();
    setState(() => _isLiked = !_isLiked);
    _heartController.forward().then((_) => _heartController.reverse());
  }

  void _onSuperLike() {
    HapticFeedback.mediumImpact();
    setState(() => _isSuperLiked = true);
    widget.onSuperLike();
  }

  void _onUnlock() {
    HapticFeedback.heavyImpact();
    _unlockController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      widget.onUnlock();
    });
  }

  void _onShare() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ رابط ملف ${widget.profile.name} 🔗'),
        backgroundColor: AppColors.dating,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _onReport() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey2.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'الإبلاغ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              _buildReportOption(Icons.block_rounded, 'حظر هذا الشخص'),
              _buildReportOption(Icons.flag_rounded, 'إبلاغ عن محتوى غير لائق'),
              _buildReportOption(Icons.person_off_rounded, 'ملف مزيف'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.06),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('إلغاء'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportOption(IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم الإبلاغ عن ${widget.profile.name}'),
            backgroundColor: AppColors.neonRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0x1AFFFFFF)),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.neonRed, size: 22),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  //  BUILD
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Photo gallery app bar
              _buildPhotoAppBar(),

              // Content
              SliverToBoxAdapter(child: _buildContent()),
            ],
          ),

          // Bottom action bar (floating)
          if (!_isLocked) _buildBottomActionBar(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  PHOTO APP BAR
  // ---------------------------------------------------------------------------

  Widget _buildPhotoAppBar() {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.52,
      pinned: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: _buildBackButton(),
      actions: [
        _buildShareButton(),
        _buildMoreButton(),
      ],
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          // Photo gallery
          if (_photoCount > 1)
            PageView.builder(
              controller: _pageController,
              itemCount: _photoCount,
              onPageChanged: (index) {
                setState(() => _currentPhotoIndex = index);
              },
              itemBuilder: (_, index) {
                return _buildPhoto(widget.profile.imageUrls[index]);
              },
            )
          else
            _buildPhoto(
              _photoCount > 0 ? widget.profile.imageUrls[0] : '',
            ),

          // Photo indicator dots
          if (_photoCount > 1) _buildPhotoIndicators(),

          // Photo counter
          if (_photoCount > 1 && _showPhotoOverlay)
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentPhotoIndex + 1} / $_photoCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // Gradient overlay (bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Boosted badge
          if (_isBoosted)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              ),
            ),

          // Locked overlay
          if (_isLocked) _buildLockedOverlay(),
        ],
      ),
    );
  }

  Widget _buildPhoto(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.dating.withOpacity(0.15),
              AppColors.background,
            ],
          ),
        ),
        child: const Center(
          child: Icon(Icons.person_rounded, size: 80, color: AppColors.grey2),
        ),
      ),
    );
  }

  Widget _buildPhotoIndicators() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_photoCount, (index) {
          final isActive = index == _currentPhotoIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: isActive ? 28 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white
                  : Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLockedOverlay() {
    return AnimatedBuilder(
      animation: _unlockController,
      builder: (context, child) {
        final opacity = 1.0 - _unlockController.value;
        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lock icon with glow
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      color: Colors.white70,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'الملف الشخصي مقفل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'استخدم مفتاحاً لرؤية الصور والتفاصيل كاملة',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  // Unlock button inside overlay
                  GestureDetector(
                    onTap: _onUnlock,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.dating, AppColors.neonRed],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.dating.withOpacity(0.3),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.vpn_key_rounded,
                              color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'فتح الملف',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
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

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.4),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return GestureDetector(
      onTap: _onShare,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 8, 4, 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.4),
        ),
        child: const Icon(
          Icons.share_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMoreButton() {
    return GestureDetector(
      onTap: _onReport,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 8, 12, 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.4),
        ),
        child: const Icon(
          Icons.more_vert_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  CONTENT SECTION
  // ---------------------------------------------------------------------------

  Widget _buildContent() {
    return FadeTransition(
      opacity: _entryController,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name, Age, Verification
            _buildNameSection(),
            const SizedBox(height: 12),

            // Location & Distance
            _buildLocationSection(),
            const SizedBox(height: 24),

            // Divider
            _buildDivider(),
            const SizedBox(height: 20),

            // Bio section
            if (!_isLocked) ...[
              _buildBioSection(),
              const SizedBox(height: 24),

              // Interests section
              _buildInterestsSection(),
              const SizedBox(height: 24),

              // Stats section
              _buildStatsSection(),
            ] else
              _buildLockedContentHint(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameSection() {
    return Row(
      children: [
        Text(
          widget.profile.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(width: 10),

        // Age pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
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

        // Verified badge
        if (_isVerified) ...[
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],

        const Spacer(),

        // Online indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.neonGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.neonGreen.withOpacity(0.2),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, color: AppColors.neonGreen, size: 8),
              SizedBox(width: 5),
              Text(
                'متصل',
                style: TextStyle(
                  color: AppColors.neonGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.dating.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: AppColors.dating,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.profile.city,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'يبعد ${widget.profile.distance} عنك',
                  style: TextStyle(
                    color: AppColors.grey2,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Distance badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.dating.withOpacity(0.12),
                  AppColors.dating.withOpacity(0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.dating.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.near_me_rounded,
                    color: AppColors.dating, size: 14),
                const SizedBox(width: 4),
                Text(
                  widget.profile.distance,
                  style: const TextStyle(
                    color: AppColors.dating,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.08),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  BIO SECTION
  // ---------------------------------------------------------------------------

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.edit_note_rounded,
                color: Colors.white70,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'نبذة عني',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Text(
            widget.profile.bio,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 15,
              height: 1.7,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  //  INTERESTS SECTION
  // ---------------------------------------------------------------------------

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.interests_rounded,
                color: Colors.white70,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'الاهتمامات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '${widget.profile.interests.length}',
              style: TextStyle(
                color: AppColors.grey2,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.profile.interests.asMap().entries.map((entry) {
            final index = entry.key;
            final interest = entry.value;
            return _buildInterestChip(interest, index);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInterestChip(String interest, int index) {
    // Assign colors based on index for visual variety
    final colors = [
      AppColors.dating,
      AppColors.neonYellow,
      AppColors.neonGreen,
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
    ];
    final color = colors[index % colors.length];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 60)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.85 + (value * 0.15),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getInterestEmoji(interest),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 6),
            Text(
              interest,
              style: TextStyle(
                color: color.withOpacity(0.9),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInterestEmoji(String interest) {
    final map = {
      'Travel': '✈️',
      'Music': '🎵',
      'Tech': '💻',
      'Photography': '📸',
      'Cooking': '🍳',
      'Fitness': '💪',
      'Reading': '📚',
      'Movies': '🎬',
      'Art': '🎨',
      'Sports': '⚽',
      'Dancing': '💃',
      'Gaming': '🎮',
      'Nature': '🌿',
      'Coffee': '☕',
      'Food': '🍕',
      'Fashion': '👗',
    };
    return map[interest] ?? '✨';
  }

  // ---------------------------------------------------------------------------
  //  STATS SECTION
  // ---------------------------------------------------------------------------

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(Icons.photo_library_rounded, '$_photoCount', 'صورة'),
          _buildDividerVertical(),
          _buildStatItem(
              Icons.interests_rounded, '${widget.profile.interests.length}', 'اهتمام'),
          _buildDividerVertical(),
          _buildStatItem(
              Icons.star_rounded, '${Random().nextInt(50) + 50}%', 'تطابق'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.dating, size: 22),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: AppColors.grey2,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDividerVertical() {
    return Container(
      width: 1,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  LOCKED CONTENT HINT
  // ---------------------------------------------------------------------------

  Widget _buildLockedContentHint() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.dating.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.dating,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'محتوى مقفل',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'افتح الملف الشخصي لرؤية النبذة والاهتمامات',
                          style: TextStyle(
                            color: AppColors.grey2,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Blurred preview lines
              ...List.generate(3, (_) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Unlock button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _onUnlock,
            icon: const Icon(Icons.vpn_key_rounded, size: 20),
            label: const Text(
              'فتح الملف الشخصي',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dating,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  //  BOTTOM ACTION BAR
  // ---------------------------------------------------------------------------

  Widget _buildBottomActionBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.background.withOpacity(0.8),
                AppColors.background,
              ],
            ),
          ),
        ),
      ),
    );
  }
}


