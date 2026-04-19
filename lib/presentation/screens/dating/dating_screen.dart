// lib/presentation/screens/dating/dating_screen.dart
// ✅ FIXED: Removed duplicate file references (search_screen / date_search_screen)
// ✅ FIXED: All imports now use correct paths
// ✅ STYLE: iPhone 17 Pro Max — liquid glass cards, Cupertino icons, smooth animations

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
// Uncomment once dating_profile_model.dart is confirmed correct:
// import '../../../data/models/dating_profile_model.dart';
import 'widgets/swipeable_card.dart';
// ✅ FIXED: Only ONE filter_sheet import (removed duplicate date_filter_sheet)
import 'filter_sheet.dart';
// ✅ FIXED: Only ONE search_screen import (removed duplicate date_search_screen)
import 'search_screen.dart';
import 'profile_detail_screen.dart';
import 'icebreaker_sheet.dart';
import 'matches_screen.dart';

// ── Mock profile (replace with DatingProfileModel from your data layer) ─────
class _MockProfile {
  final String id;
  final String name;
  final int age;
  final String emoji;
  final String bio;
  final List<String> interests;
  final String distance;
  final bool isOnline;
  final Color color;

  const _MockProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.emoji,
    required this.bio,
    required this.interests,
    required this.distance,
    this.isOnline = false,
    required this.color,
  });
}

class DatingScreen extends StatefulWidget {
  const DatingScreen({super.key});

  @override
  State<DatingScreen> createState() => _DatingScreenState();
}

class _DatingScreenState extends State<DatingScreen>
    with TickerProviderStateMixin {

  // ── Mock data ─────────────────────────────────────────────────────────────
  final List<_MockProfile> _allProfiles = const [
    _MockProfile(id: '1', name: 'Yasmine',  age: 24, emoji: '🌸', bio: 'Loves travel & coffee ☕', interests: ['Travel', 'Coffee', 'Art'],    distance: '0.8 km', isOnline: true,  color: Color(0xFF2E1A3A)),
    _MockProfile(id: '2', name: 'Sara',     age: 22, emoji: '😎', bio: 'Photographer & music lover', interests: ['Music', 'Photography'],    distance: '2.1 km', isOnline: true,  color: Color(0xFF1A2E1A)),
    _MockProfile(id: '3', name: 'Nour',     age: 26, emoji: '📚', bio: 'Reading is my cardio 📖',  interests: ['Books', 'Yoga', 'Tech'],     distance: '3.4 km', isOnline: false, color: Color(0xFF1A1A2E)),
    _MockProfile(id: '4', name: 'Amira',    age: 23, emoji: '🎬', bio: 'Film fan & foodie 🍕',     interests: ['Cinema', 'Food', 'Travel'],  distance: '5.2 km', isOnline: true,  color: Color(0xFF2E2E1A)),
    _MockProfile(id: '5', name: 'Lina',     age: 25, emoji: '🎸', bio: 'Rock guitarist 🎵',        interests: ['Music', 'Travel', 'Tech'],   distance: '1.7 km', isOnline: false, color: Color(0xFF2E1A1A)),
    _MockProfile(id: '6', name: 'Ines',     age: 21, emoji: '🌿', bio: 'Plant mom & yoga 🧘',     interests: ['Yoga', 'Nature', 'Coffee'],  distance: '4.0 km', isOnline: true,  color: Color(0xFF1A2E2E)),
  ];

  List<_MockProfile> _filteredProfiles = [];
  List<_MockProfile> _swipedLeft = [];
  int _currentIndex = 0;
  final Set<String> _matches = {};

  // ── Filter state ──────────────────────────────────────────────────────────
  int _maxDistance = 100;
  int _ageFrom = 18;
  int _ageTo = 35;
  bool _showOnlineOnly = false;
  bool _incognitoMode = false;

  // ── Animation controllers ─────────────────────────────────────────────────
  late AnimationController _headerSlideController;
  late AnimationController _matchBurstController;

  @override
  void initState() {
    super.initState();

    _headerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _matchBurstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _applyFilter();
  }

  @override
  void dispose() {
    _headerSlideController.dispose();
    _matchBurstController.dispose();
    super.dispose();
  }

  // ── Logic ─────────────────────────────────────────────────────────────────

  void _applyFilter() {
    setState(() {
      _filteredProfiles = _allProfiles.where((p) {
        final dist = double.tryParse(
              p.distance.replaceAll(RegExp(r'[^0-9.]'), ''),
            ) ?? 0;
        if (dist > _maxDistance) return false;
        if (p.age < _ageFrom || p.age > _ageTo) return false;
        if (_showOnlineOnly && !p.isOnline) return false;
        return true;
      }).toList();
      _currentIndex = 0;
    });
  }

  void _onSwipeRight(String id) {
    HapticFeedback.mediumImpact();
    setState(() {
      final profile = _filteredProfiles.firstWhere((p) => p.id == id);
      if (Random().nextBool()) {
        _matches.add(id);
        _showMatchAnimation(profile);
      }
      _currentIndex++;
    });
  }

  void _onSwipeLeft(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      final profile = _filteredProfiles.firstWhere((p) => p.id == id);
      _swipedLeft.add(profile);
      _currentIndex++;
    });
  }

  void _undoLastSwipe() {
    if (_swipedLeft.isEmpty || _currentIndex == 0) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _swipedLeft.removeLast();
      _currentIndex--;
    });
  }

  void _showMatchAnimation(_MockProfile profile) {
    _matchBurstController.forward(from: 0);
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _MatchDialog(profile: profile),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSheet(
        maxDistance: _maxDistance,
        ageFrom: _ageFrom,
        ageTo: _ageTo,
        showOnlineOnly: _showOnlineOnly,
        onApply: (dist, from, to, online) {
          setState(() {
            _maxDistance = dist;
            _ageFrom = from;
            _ageTo = to;
            _showOnlineOnly = online;
          });
          _applyFilter();
        },
      ),
    );
  }

  void _resetProfiles() {
    setState(() {
      _currentIndex = 0;
      _swipedLeft.clear();
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final accent = AppColors.dating; // neonYellow = 0xFFFFB300

    return Stack(
      children: [
        // Dynamic background
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.8),
              radius: 1.0,
              colors: [
                accent.withOpacity(0.08),
                const Color(0xFF010101),
              ],
            ),
          ),
        ),

        Column(
          children: [
            SizedBox(height: topPad + 56), // below TopBar

            // ── Header ───────────────────────────────────────────────
            _buildHeader(accent),

            const SizedBox(height: 8),

            // ── Undo snackbar ────────────────────────────────────────
            if (_swipedLeft.isNotEmpty && _currentIndex > 0)
              _buildUndoBar(accent),

            // ── Card stack ───────────────────────────────────────────
            Expanded(
              child: _buildCardArea(accent),
            ),

            // ── Action buttons ────────────────────────────────────────
            if (_currentIndex < _filteredProfiles.length)
              _buildActionRow(accent),

            const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader(Color accent) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero)
          .animate(CurvedAnimation(
        parent: _headerSlideController,
        curve: Curves.easeOutCubic,
      )),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          children: [
            // Incognito toggle
            _GlassIconBtn(
              icon: _incognitoMode
                  ? CupertinoIcons.eye_slash_fill
                  : CupertinoIcons.eye,
              isActive: _incognitoMode,
              activeColor: const Color(0xFF8E8E93),
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _incognitoMode = !_incognitoMode);
              },
            ),
            const Spacer(),
            // Title
            Column(
              children: [
                Text(
                  'Discover',
                  style: AppTextStyles.h4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${_filteredProfiles.length} profiles nearby',
                  style: AppTextStyles.caption.copyWith(color: Colors.white38),
                ),
              ],
            ),
            const Spacer(),
            // Matches + Filter
            Row(
              children: [
                _GlassIconBtn(
                  icon: CupertinoIcons.heart_fill,
                  badge: _matches.isNotEmpty,
                  badgeCount: _matches.length,
                  activeColor: accent,
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(builder: (_) => const MatchesScreen()),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _GlassIconBtn(
                  icon: CupertinoIcons.slider_horizontal_3,
                  onTap: _openFilterSheet,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUndoBar(Color accent) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.10)),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.arrow_counterclockwise,
                    color: Colors.white54, size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${_swipedLeft.last.name} was skipped',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white60),
                  ),
                ),
                GestureDetector(
                  onTap: _undoLastSwipe,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Undo',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildCardArea(Color accent) {
    if (_filteredProfiles.isEmpty) return _buildEmptyFilterState(accent);
    if (_currentIndex >= _filteredProfiles.length) return _buildNoMoreState(accent);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background cards (stack effect)
          ...List.generate(
            min(2, _filteredProfiles.length - _currentIndex - 1),
            (i) {
              final idx = _currentIndex + i + 1;
              final profile = _filteredProfiles[idx];
              return Positioned.fill(
                child: Transform.translate(
                  offset: Offset(0, (i + 1) * 8.0),
                  child: Transform.scale(
                    scale: 1.0 - (i + 1) * 0.04,
                    child: _DatingCard(profile: profile, isBackground: true),
                  ),
                ),
              );
            },
          ).reversed.toList(),

          // Top card
          SwipeableCard(
            key: ValueKey(_filteredProfiles[_currentIndex].id),
            onSwipeRight: () => _onSwipeRight(_filteredProfiles[_currentIndex].id),
            onSwipeLeft: () => _onSwipeLeft(_filteredProfiles[_currentIndex].id),
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (_) => ProfileDetailScreen(
                    profileId: _filteredProfiles[_currentIndex].id,
                  ),
                ),
              );
            },
            child: _DatingCard(
              profile: _filteredProfiles[_currentIndex],
              isBackground: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Skip
          _ActionCircle(
            icon: CupertinoIcons.xmark,
            color: const Color(0xFF8E8E93),
            size: 56,
            onTap: () => _onSwipeLeft(_filteredProfiles[_currentIndex].id),
          ),
          // Super Like
          _ActionCircle(
            icon: CupertinoIcons.star_fill,
            color: AppColors.primary,
            size: 48,
            onTap: () {
              HapticFeedback.mediumImpact();
              _onSwipeRight(_filteredProfiles[_currentIndex].id);
            },
          ),
          // Like
          _ActionCircle(
            icon: CupertinoIcons.heart_fill,
            color: accent,
            size: 56,
            onTap: () => _onSwipeRight(_filteredProfiles[_currentIndex].id),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFilterState(Color accent) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 700),
              curve: Curves.elasticOut,
              builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: const Icon(CupertinoIcons.person_crop_circle_badge_xmark,
                    color: Colors.white38, size: 56),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No profiles match your filters',
              style: AppTextStyles.h5.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Try broadening your search to discover more people.',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white38, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            CupertinoButton.filled(
              borderRadius: BorderRadius.circular(18),
              onPressed: _openFilterSheet,
              child: const Text('Adjust Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMoreState(Color accent) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 700),
              curve: Curves.elasticOut,
              builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
              child: const Text('🎯', style: TextStyle(fontSize: 72)),
            ),
            const SizedBox(height: 20),
            Text(
              "You're all caught up!",
              style: AppTextStyles.h4.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              "You've seen everyone nearby.\nCheck back later for new faces!",
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white38, height: 1.6),
              textAlign: TextAlign.center,
            ),
            if (_matches.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: accent.withOpacity(0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.heart_fill, color: accent, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${_matches.length} matches today',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 28),
            CupertinoButton(
              color: accent,
              borderRadius: BorderRadius.circular(18),
              onPressed: _resetProfiles,
              child: Text(
                'Start Over',
                style: AppTextStyles.labelLarge.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dating Card ──────────────────────────────────────────────────────────────

class _DatingCard extends StatelessWidget {
  final _MockProfile profile;
  final bool isBackground;

  const _DatingCard({required this.profile, required this.isBackground});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: profile.color,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: isBackground
            ? null
            : [
                BoxShadow(
                  color: profile.color.withOpacity(0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
      ),
      child: Stack(
        children: [
          // Emoji portrait
          Center(
            child: Text(
              profile.emoji,
              style: TextStyle(fontSize: isBackground ? 80 : 110),
            ),
          ),

          // Online badge
          if (profile.isOnline && !isBackground)
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF34C759).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF34C759).withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF34C759),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Online',
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF34C759),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom info
          if (!isBackground)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              profile.name,
                              style: AppTextStyles.h3.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Text(
                                '${profile.age}',
                                style: AppTextStyles.h5.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(CupertinoIcons.location_fill,
                                size: 13, color: Colors.white38),
                            const SizedBox(width: 4),
                            Text(
                              profile.distance,
                              style: AppTextStyles.caption.copyWith(color: Colors.white38),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          profile.bio,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white70,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: profile.interests.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.18)),
                              ),
                              child: Text(
                                tag,
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Action Circle Button ─────────────────────────────────────────────────────

class _ActionCircle extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _ActionCircle({
    required this.icon,
    required this.color,
    required this.size,
    required this.onTap,
  });

  @override
  State<_ActionCircle> createState() => _ActionCircleState();
}

class _ActionCircleState extends State<_ActionCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withOpacity(0.12),
            border: Border.all(color: widget.color.withOpacity(0.35), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.22),
                blurRadius: 16,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(widget.icon, color: widget.color, size: widget.size * 0.42),
        ),
      ),
    );
  }
}

// ─── Glass Icon Button ────────────────────────────────────────────────────────

class _GlassIconBtn extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final bool badge;
  final int badgeCount;
  final Color? activeColor;
  final VoidCallback onTap;

  const _GlassIconBtn({
    required this.icon,
    this.isActive = false,
    this.badge = false,
    this.badgeCount = 0,
    this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isActive
                      ? color.withOpacity(0.15)
                      : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isActive
                        ? color.withOpacity(0.4)
                        : Colors.white.withOpacity(0.12),
                  ),
                ),
                child: Icon(
                  icon,
                  color: isActive ? color : Colors.white54,
                  size: 20,
                ),
              ),
            ),
          ),
          if (badge && badgeCount > 0)
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(color: const Color(0xFF010101), width: 1.5),
                ),
                child: Center(
                  child: Text(
                    badgeCount > 9 ? '9+' : '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Match Dialog ─────────────────────────────────────────────────────────────

class _MatchDialog extends StatelessWidget {
  final _MockProfile profile;
  const _MatchDialog({required this.profile});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('🎉 It\'s a Match!'),
      content: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text('You and ${profile.name} liked each other!'),
      ),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: false,
          onPressed: () => Navigator.pop(context),
          child: const Text('Keep Swiping'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Message'),
        ),
      ],
    );
  }
}
