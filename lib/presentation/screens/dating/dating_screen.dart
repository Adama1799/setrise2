// lib/presentation/screens/date/dating_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/dating_profile_model.dart';
import 'widgets/swipeable_card.dart';
import 'filter_sheet.dart';
import 'search_screen.dart';
import 'profile_detail_screen.dart';
import 'icebreaker_sheet.dart';

class DatingScreen extends StatefulWidget {
  const DatingScreen({super.key});

  @override
  State<DatingScreen> createState() => _DatingScreenState();
}

class _DatingScreenState extends State<DatingScreen>
    with TickerProviderStateMixin {
  late List<DatingProfileModel> _allProfiles;
  late List<DatingProfileModel> _filteredProfiles;
  late List<DatingProfileModel> _swipedLeft;
  int _currentIndex = 0;
  final Set<String> _matches = {};
  int _keys = 3;
  bool _isAnimating = false;

  // --- Filter state ---
  int _maxDistance = 100;
  int _ageFrom = 18;
  int _ageTo = 35;
  bool _sortBySharedInterests = false;
  bool _incognitoMode = false;
  bool _showOnlineOnly = false;

  final List<String> _myInterests = [
    'Travel',
    'Music',
    'Tech',
    'Photography'
  ];

  // --- Animation controllers ---
  late AnimationController _headerSlideController;
  late AnimationController _cardEntryController;
  late AnimationController _matchPulseController;
  late AnimationController _fabScaleController;

  @override
  void initState() {
    super.initState();
    _allProfiles = DatingProfileModel.getMockProfiles();
    _swipedLeft = [];

    // Header slide-in animation
    _headerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    // Card fade-in animation
    _cardEntryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    // Match pulse animation
    _matchPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.8,
      upperBound: 1.2,
    );

    // FAB scale animation
    _fabScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _applyFilter();
  }

  @override
  void dispose() {
    _headerSlideController.dispose();
    _cardEntryController.dispose();
    _matchPulseController.dispose();
    _fabScaleController.dispose();
    super.dispose();
  }

  // =========================================================================
  //  DATA LOGIC
  // =========================================================================

  void _applyFilter() {
    setState(() {
      _filteredProfiles = _allProfiles.where((profile) {
        final distance =
            int.tryParse(profile.distance.replaceAll(RegExp(r'[^0-9]'), '')) ??
                0;
        if (distance > _maxDistance) return false;
        if (profile.age < _ageFrom || profile.age > _ageTo) return false;
        return true;
      }).toList();

      if (_sortBySharedInterests) {
        _filteredProfiles.sort((a, b) {
          final aShared =
              a.interests.where((i) => _myInterests.contains(i)).length;
          final bShared =
              b.interests.where((i) => _myInterests.contains(i)).length;
          return bShared.compareTo(aShared);
        });
      }

      _currentIndex = 0;
    });
    _playCardEntryAnimation();
  }

  void _shuffleProfiles() {
    setState(() {
      _filteredProfiles.shuffle();
      _currentIndex = 0;
    });
    _playCardEntryAnimation();
  }

  void _resetProfiles() {
    setState(() {
      _allProfiles = DatingProfileModel.getMockProfiles();
      _swipedLeft.clear();
      _applyFilter();
    });
    _playCardEntryAnimation();
  }

  void _undoLastSwipe() {
    if (_swipedLeft.isEmpty || _currentIndex == 0) return;
    setState(() {
      _currentIndex--;
      _swipedLeft.removeLast();
    });
    _playCardEntryAnimation();
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Swipe undone! ↩️'),
        backgroundColor: AppColors.neonGreen,
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  // =========================================================================
  //  SWIPE HANDLING
  // =========================================================================

  void _handleSwipe(bool isLiked) {
    if (_currentIndex >= _filteredProfiles.length || _isAnimating) return;

    _isAnimating = true;

    final profile = _filteredProfiles[_currentIndex];

    if (!isLiked) {
      _swipedLeft.add(profile);
    }

    if (isLiked) {
      if (_currentIndex % 2 == 0) {
        _matches.add(profile.id);
        _isAnimating = false;
        _showMatchDialog(profile);
        return;
      }
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() => _currentIndex++);
        _isAnimating = false;
        _playCardEntryAnimation();
      }
    });
  }

  void _handleSuperLike(DatingProfileModel profile) {
    if (_isAnimating) return;
    _isAnimating = true;
    setState(() => _currentIndex++);
    _isAnimating = false;
    _showMatchDialog(profile, isSuperLike: true);
  }

  void _playCardEntryAnimation() {
    _cardEntryController.reset();
    _cardEntryController.forward();
  }

  // =========================================================================
  //  MATCH DIALOG
  // =========================================================================

  void _showMatchDialog(DatingProfileModel profile,
      {bool isSuperLike = false}) {
    HapticFeedback.mediumImpact();
    _matchPulseController.repeat(reverse: true);

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      isSuperLike
                          ? AppColors.neonYellow.withOpacity(0.95)
                          : AppColors.neonRed.withOpacity(0.95),
                      AppColors.dating.withOpacity(0.95),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: (isSuperLike
                              ? AppColors.neonYellow
                              : AppColors.neonRed)
                          .withOpacity(0.4),
                      blurRadius: 40,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated emoji
                    AnimatedBuilder(
                      animation: _matchPulseController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _matchPulseController.value,
                          child: child,
                        );
                      },
                      child: Text(
                        isSuperLike ? '🌟' : '💛',
                        style: const TextStyle(fontSize: 64),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Profile mini avatar
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      backgroundImage: NetworkImage(
                        profile.imageUrls.isNotEmpty
                            ? profile.imageUrls.first
                            : '',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isSuperLike ? 'Super Match!' : "It's a Match!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'You and ${profile.name} liked each other!',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    // Send Message button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _matchPulseController.stop();
                          _showIcebreakerSheet(profile);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Send Message 💬',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Keep swiping link
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _matchPulseController.stop();
                        setState(() => _currentIndex++);
                        _playCardEntryAnimation();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Keep Swiping',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white.withOpacity(0.4),
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
      ),
    ).then((_) => _matchPulseController.stop());
  }

  // =========================================================================
  //  ICEBREAKER SHEET
  // =========================================================================

  void _showIcebreakerSheet(DatingProfileModel profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => IcebreakerSheet(
        matchName: profile.name,
        onSend: () {
          Navigator.pop(context);
          setState(() => _currentIndex++);
          _playCardEntryAnimation();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Message sent to ${profile.name}! 💬'),
              backgroundColor: AppColors.dating,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      ),
    );
  }

  // =========================================================================
  //  UNLOCK PROFILE
  // =========================================================================

  void _unlockProfile(DatingProfileModel profile) {
    if (_keys <= 0) {
      _showNoKeysDialog();
      return;
    }
    HapticFeedback.lightImpact();
    setState(() {
      _keys--;
      final index = _allProfiles.indexWhere((p) => p.id == profile.id);
      if (index != -1) {
        _allProfiles[index] = DatingProfileModel(
          id: profile.id,
          name: profile.name,
          age: profile.age,
          city: profile.city,
          distance: profile.distance,
          bio: profile.bio,
          imageUrls: profile.imageUrls,
          interests: profile.interests,
          isVerified: profile.isVerified,
          isLocked: false,
          isBoosted: profile.isBoosted,
        );
        _applyFilter();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile unlocked! 🔑 $_keys keys remaining.'),
        backgroundColor: AppColors.neonGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showNoKeysDialog() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.8, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) =>
              Transform.scale(scale: scale, child: child),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                  color: AppColors.neonRed.withOpacity(0.3), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_rounded,
                    color: AppColors.neonRed, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'No Keys Left!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Watch a short ad to earn more keys and unlock premium profiles.',
                  style: TextStyle(
                      color: AppColors.grey2, fontSize: 14, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => _keys += 3);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You earned 3 keys! 🎉'),
                          backgroundColor: AppColors.neonGreen,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'Watch Ad (+3 Keys)',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Maybe Later',
                    style: TextStyle(color: AppColors.grey2, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  //  NAVIGATION
  // =========================================================================

  void _openProfileDetail(DatingProfileModel profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileDetailScreen(
          profile: profile,
          onUnlock: () => _unlockProfile(profile),
          onSuperLike: () => _handleSuperLike(profile),
        ),
      ),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => DateFilterSheet(
        maxDistance: _maxDistance,
        ageFrom: _ageFrom,
        ageTo: _ageTo,
        sortBySharedInterests: _sortBySharedInterests,
        incognitoMode: _incognitoMode,
        onApply:
            (distance, ageFrom, ageTo, sortByShared, incognito) {
          setState(() {
            _maxDistance = distance;
            _ageFrom = ageFrom;
            _ageTo = ageTo;
            _sortBySharedInterests = sortByShared;
            _incognitoMode = incognito;
          });
          _applyFilter();
          HapticFeedback.selectionClick();
        },
      ),
    );
  }

  void _openSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DateSearchScreen(
          profiles: _allProfiles,
          onMatchFound: (profile) {},
        ),
      ),
    );
  }

  // =========================================================================
  //  BUILD
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
            if (_swipedLeft.isNotEmpty) _buildUndoBar(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _headerSlideController,
        curve: Curves.easeOutCubic,
      )),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background,
              AppColors.dating.withOpacity(0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
        child: Row(
          children: [
            // Title
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.dating, AppColors.neonRed],
              ).createShader(bounds),
              child: Text(
                'Date',
                style: AppTextStyles.h4.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Incognito badge
            if (_incognitoMode) _buildIncognitoBadge(),

            // Match counter
            if (_matches.isNotEmpty) ...[
              const SizedBox(width: 6),
              _buildMatchBadge(),
            ],

            const Spacer(),

            // Keys indicator
            _buildKeysIndicator(),
            const SizedBox(width: 4),

            // Search
            _HeaderIconButton(
              icon: Icons.search_rounded,
              onTap: _openSearchScreen,
            ),

            // Shuffle
            _HeaderIconButton(
              icon: Icons.shuffle_rounded,
              onTap: () {
                _shuffleProfiles();
                HapticFeedback.selectionClick();
              },
            ),

            // Filter
            _HeaderIconButton(
              icon: Icons.tune_rounded,
              onTap: _openFilterSheet,
              isActive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncognitoBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.visibility_off_rounded,
              color: Colors.purple, size: 13),
          const SizedBox(width: 4),
          Text('INCOGNITO',
              style: AppTextStyles.labelSmall
                  .copyWith(color: Colors.purple, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildMatchBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.dating.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.dating.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_rounded,
              color: AppColors.dating, size: 13),
          const SizedBox(width: 4),
          Text('${_matches.length}',
              style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.dating, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildKeysIndicator() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You have $_keys keys to unlock profiles 🔑'),
            backgroundColor: AppColors.dating.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.dating.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: AppColors.dating.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.vpn_key_rounded,
                color: AppColors.dating, size: 15),
            const SizedBox(width: 5),
            Text('$_keys',
                style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.dating,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  BODY
  // ---------------------------------------------------------------------------

  Widget _buildBody() {
    if (_filteredProfiles.isEmpty) return _buildEmptyFilterState();
    if (_currentIndex >= _filteredProfiles.length) {
      return _buildNoMoreProfilesState();
    }
    return _buildCardStack();
  }

  Widget _buildCardStack() {
    final visibleCount =
        min(3, _filteredProfiles.length - _currentIndex);

    return FadeTransition(
      opacity: _cardEntryController,
      child: Stack(
        children: [
          // Background cards (stacked with peek effect)
          for (int i = visibleCount - 1; i >= 1; i--)
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    16.0 - (i * 2.0),
                    16.0 + (i * 4.0),
                    16.0 - (i * 2.0),
                    100.0 + (i * 8.0)),
                child: Opacity(
                  opacity: 0.5 - (i * 0.15),
                  child: SwipeableCard(
                    profile: _filteredProfiles[_currentIndex + i],
                    isBackground: true,
                    onTap: () => _openProfileDetail(
                        _filteredProfiles[_currentIndex + i]),
                  ),
                ),
              ),
            ),

          // Foreground card
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 90),
              child: SwipeableCard(
                profile: _filteredProfiles[_currentIndex],
                onSwipeLeft: () => _handleSwipe(false),
                onSwipeRight: () => _handleSwipe(true),
                onTap: () =>
                    _openProfileDetail(_filteredProfiles[_currentIndex]),
              ),
            ),
          ),

          // Card counter
          Positioned(
            top: 20,
            right: 24,
            child: _buildCardCounter(),
          ),

          // Current profile quick info
          Positioned(
            bottom: 96,
            left: 20,
            right: 20,
            child: _buildProfileQuickInfo(),
          ),

          // Action buttons
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: _buildActionButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildCardCounter() {
    final total = _filteredProfiles.length;
    final current = _currentIndex + 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        backdropFilter: null,
      ),
      child: Text(
        '$current / $total',
        style: AppTextStyles.labelSmall.copyWith(
          color: Colors.white.withOpacity(0.8),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProfileQuickInfo() {
    final profile = _filteredProfiles[_currentIndex];
    return IgnorePointer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.85),
            ],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (profile.isVerified) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.neonGreen,
                          ),
                          child: const Icon(Icons.check_rounded,
                              color: Colors.black, size: 14),
                        ),
                      ],
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${profile.age}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          color: AppColors.dating, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${profile.city} • ${profile.distance}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (profile.isBoosted) ...[
                        const Icon(Icons.bolt_rounded,
                            color: AppColors.neonYellow, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Boosted',
                          style: TextStyle(
                            color: AppColors.neonYellow.withOpacity(0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (profile.isLocked)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_rounded,
                        color: AppColors.dating, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Locked',
                      style: TextStyle(
                          color: AppColors.dating,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Dislike
          _AnimatedActionButton(
            icon: Icons.close_rounded,
            label: 'Nope',
            color: AppColors.neonRed,
            onTap: () {
              HapticFeedback.lightImpact();
              _handleSwipe(false);
            },
          ),

          // Super Like
          _AnimatedActionButton(
            icon: Icons.star_rounded,
            label: 'Super',
            color: AppColors.neonYellow,
            size: 68,
            iconSize: 32,
            onTap: () {
              HapticFeedback.mediumImpact();
              _handleSuperLike(_filteredProfiles[_currentIndex]);
            },
          ),

          // Like
          _AnimatedActionButton(
            icon: Icons.favorite_rounded,
            label: 'Like',
            color: AppColors.dating,
            onTap: () {
              HapticFeedback.lightImpact();
              _handleSwipe(true);
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  UNDO BAR
  // ---------------------------------------------------------------------------

  Widget _buildUndoBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.neonGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.neonGreen.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.undo_rounded,
              color: AppColors.neonGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${_swipedLeft.last.name} was skipped',
              style: TextStyle(
                color: AppColors.neonGreen.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: _undoLastSwipe,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.neonGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Undo',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  EMPTY STATES
  // ---------------------------------------------------------------------------

  Widget _buildEmptyFilterState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated empty icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.08)),
                ),
                child: const Icon(Icons.person_off_rounded,
                    color: AppColors.grey2, size: 56),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No profiles match your filters',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Try broadening your search criteria to discover more people nearby.',
              style: TextStyle(
                color: AppColors.grey2,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _openFilterSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dating,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Adjust Filters',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                setState(() {
                  _maxDistance = 100;
                  _ageFrom = 18;
                  _ageTo = 35;
                  _showOnlineOnly = false;
                });
                _applyFilter();
              },
              child: Text(
                'Reset to Default',
                style: TextStyle(
                  color: AppColors.grey2,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMoreProfilesState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Celebration animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: const Text('🎯', style: TextStyle(fontSize: 72)),
            ),
            const SizedBox(height: 20),
            const Text(
              'You\'re all caught up!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You\'ve seen all available profiles.\nCheck back later for new faces!',
              style: TextStyle(
                color: AppColors.grey2,
                fontSize: 14,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            if (_matches.isNotEmpty) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.dating.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.dating.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite_rounded,
                        color: AppColors.dating, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '${_matches.length} new matches today',
                      style: const TextStyle(
                        color: AppColors.dating,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ] else
              const SizedBox(height: 32),
            // Start over button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _resetProfiles,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text(
                  'Start Over',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dating,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
//  WIDGETS
// =============================================================================

/// Animated action button with label and press feedback
class _AnimatedActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final double size;
  final double iconSize;
  final VoidCallback onTap;

  const _AnimatedActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.size = 58,
    this.iconSize = 26,
  });

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color.withOpacity(0.15),
                    widget.color.withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                    color: widget.color.withOpacity(0.6), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.2),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(widget.icon,
                  color: widget.color, size: widget.iconSize),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.label,
            style: TextStyle(
              color: widget.color.withOpacity(0.7),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Header icon button with subtle hover effect
class _HeaderIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<_HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<_HeaderIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isActive
              ? (_isPressed
                  ? AppColors.dating.withOpacity(0.25)
                  : AppColors.dating.withOpacity(0.12))
              : (_isPressed
                  ? Colors.white.withOpacity(0.1)
                  : Colors.transparent),
          border: widget.isActive
              ? Border.all(
                  color: AppColors.dating.withOpacity(0.3), width: 1)
              : null,
        ),
        child: Icon(
          widget.icon,
          color: widget.isActive
              ? AppColors.dating
              : Colors.white.withOpacity(0.8),
          size: 22,
        ),
      ),
    );
  }
}
