// lib/presentation/screens/music/music_screen.dart
// ✅ FIXED: Full iPhone 17 Pro Max style — glassmorphism, dynamic album art, SF-feel
// ✅ FIXED: Consistent AppTextStyles usage (no body1 confusion)
// ✅ FIXED: Removed dart:ui import conflict — kept only as 'dart:ui'

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen>
    with TickerProviderStateMixin {

  final List<Map<String, dynamic>> _allTracks = [
    {'id': '1',  'title': 'Midnight Vibes',  'artist': 'DJ SetRise',   'duration': '3:24', 'coverColor': const Color(0xFF1A0A2E), 'accentColor': const Color(0xFF9B59B6), 'isLiked': true},
    {'id': '2',  'title': 'Desert Rose',     'artist': 'Karim_beats',  'duration': '4:12', 'coverColor': const Color(0xFF2E1A0A), 'accentColor': const Color(0xFFE67E22), 'isLiked': false},
    {'id': '3',  'title': 'Neon Dreams',     'artist': 'SynthWave_X',  'duration': '3:48', 'coverColor': const Color(0xFF0A1A2E), 'accentColor': const Color(0xFF007AFF), 'isLiked': true},
    {'id': '4',  'title': 'Street Poetry',   'artist': 'Lyric_A',      'duration': '2:59', 'coverColor': const Color(0xFF0A2E1A), 'accentColor': const Color(0xFF34C759), 'isLiked': false},
    {'id': '5',  'title': 'Ocean Calm',      'artist': 'Relax_Mode',   'duration': '5:30', 'coverColor': const Color(0xFF002E2E), 'accentColor': const Color(0xFF00C6FF), 'isLiked': true},
    {'id': '6',  'title': 'Fire Dance',      'artist': 'BeatMaker_Z',  'duration': '3:15', 'coverColor': const Color(0xFF2E0A0A), 'accentColor': const Color(0xFFFF3B30), 'isLiked': false},
    {'id': '7',  'title': 'Solar Flare',     'artist': 'AstroBeats',   'duration': '4:02', 'coverColor': const Color(0xFF2E2E0A), 'accentColor': const Color(0xFFFFCC00), 'isLiked': true},
    {'id': '8',  'title': 'Velvet Night',    'artist': 'Luna_Sound',   'duration': '3:36', 'coverColor': const Color(0xFF1A002E), 'accentColor': const Color(0xFFFF2D55), 'isLiked': false},
    {'id': '9',  'title': 'Crystal Waves',   'artist': 'AquaTone',     'duration': '4:44', 'coverColor': const Color(0xFF0A0A2E), 'accentColor': const Color(0xFF5AC8FA), 'isLiked': true},
    {'id': '10', 'title': 'Urban Echo',      'artist': 'CityPulse',    'duration': '3:08', 'coverColor': const Color(0xFF0E1E0E), 'accentColor': const Color(0xFF30D158), 'isLiked': false},
  ];

  int _currentTrackIndex = 0;
  bool _isPlayerOpen = false;
  String _currentTab = 'ForYou';

  Map<String, dynamic> get _currentTrack => _allTracks[_currentTrackIndex];

  late AnimationController _rotationController;
  late AnimationController _playerSlideController;
  late Animation<Offset>   _playerSlideAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    _playerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _playerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _playerSlideController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _playerSlideController.dispose();
    super.dispose();
  }

  void _openPlayer(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _currentTrackIndex = index;
      _isPlayerOpen = true;
    });
    _playerSlideController.forward();
    _rotationController.repeat();
  }

  void _closePlayer() {
    _playerSlideController.reverse().then((_) {
      if (mounted) setState(() => _isPlayerOpen = false);
    });
    _rotationController.stop();
  }

  void _toggleLike(int index) {
    HapticFeedback.impactOccurred(HapticFeedbackType.lightImpact);
    setState(() {
      _allTracks[index]['isLiked'] = !(_allTracks[index]['isLiked'] as bool);
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final accent = _currentTrack['accentColor'] as Color;
    final cover  = _currentTrack['coverColor'] as Color;
    final topPad = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        // ── Dynamic background ──────────────────────────────────────────
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.0, -0.6),
              radius: 1.2,
              colors: [cover.withOpacity(0.55), const Color(0xFF010101)],
            ),
          ),
        ),

        // ── Main scroll content ─────────────────────────────────────────
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: topPad + 64)),

            // ── Tab selector ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Row(
                  children: [
                    _TabPill(
                      label: 'For You',
                      isActive: _currentTab == 'ForYou',
                      onTap: () => setState(() => _currentTab = 'ForYou'),
                    ),
                    const SizedBox(width: 8),
                    _TabPill(
                      label: 'Trending',
                      isActive: _currentTab == 'Trending',
                      onTap: () => setState(() => _currentTab = 'Trending'),
                    ),
                    const SizedBox(width: 8),
                    _TabPill(
                      label: 'Liked',
                      isActive: _currentTab == 'Liked',
                      onTap: () => setState(() => _currentTab = 'Liked'),
                    ),
                    const Spacer(),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        CupertinoIcons.slider_horizontal_3,
                        color: Colors.white54,
                        size: 22,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            // ── Featured / Now Playing banner ─────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: GestureDetector(
                  onTap: () => _openPlayer(_currentTrackIndex),
                  child: _FeaturedCard(
                    track: _currentTrack,
                    rotationController: _rotationController,
                  ),
                ),
              ),
            ),

            // ── Section title ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Tracks',
                      style: AppTextStyles.h5.copyWith(color: Colors.white),
                    ),
                    Text(
                      'See All',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Track list ────────────────────────────────────────────
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final track   = _allTracks[index];
                  final isCurrent = index == _currentTrackIndex;
                  return _TrackRow(
                    track: track,
                    index: index,
                    isCurrent: isCurrent,
                    onTap: () => _openPlayer(index),
                    onLike: () => _toggleLike(index),
                  );
                },
                childCount: _allTracks.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),

        // ── Mini player (bottom persistent bar) ─────────────────────
        if (!_isPlayerOpen)
          Positioned(
            left: 16,
            right: 16,
            bottom: 90,
            child: _MiniPlayer(
              track: _currentTrack,
              onTap: () => _openPlayer(_currentTrackIndex),
            ),
          ),

        // ── Full screen player ────────────────────────────────────────
        if (_isPlayerOpen)
          SlideTransition(
            position: _playerSlideAnimation,
            child: _FullPlayer(
              track: _currentTrack,
              allTracks: _allTracks,
              currentIndex: _currentTrackIndex,
              rotationController: _rotationController,
              onClose: _closePlayer,
              onToggleLike: () => _toggleLike(_currentTrackIndex),
              onPrevious: () {
                if (_currentTrackIndex > 0) {
                  setState(() => _currentTrackIndex--);
                }
              },
              onNext: () {
                if (_currentTrackIndex < _allTracks.length - 1) {
                  setState(() => _currentTrackIndex++);
                }
              },
            ),
          ),
      ],
    );
  }
}

// ─── Featured Card ─────────────────────────────────────────────────────────────

class _FeaturedCard extends StatelessWidget {
  final Map<String, dynamic> track;
  final AnimationController rotationController;

  const _FeaturedCard({required this.track, required this.rotationController});

  @override
  Widget build(BuildContext context) {
    final cover  = track['coverColor'] as Color;
    final accent = track['accentColor'] as Color;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cover, Color.lerp(cover, Colors.black, 0.5)!],
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Spinning vinyl disc decoration
            Positioned(
              right: -30,
              top: -30,
              child: AnimatedBuilder(
                animation: rotationController,
                builder: (_, child) => Transform.rotate(
                  angle: rotationController.value * 2 * math.pi,
                  child: child,
                ),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        accent.withOpacity(0.15),
                        Colors.transparent,
                        accent.withOpacity(0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: accent.withOpacity(0.35)),
                    ),
                    child: Text(
                      '♪ Now Playing',
                      style: AppTextStyles.labelSmall.copyWith(color: accent),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    track['title'] as String,
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    track['artist'] as String,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Track Row ────────────────────────────────────────────────────────────────

class _TrackRow extends StatelessWidget {
  final Map<String, dynamic> track;
  final int index;
  final bool isCurrent;
  final VoidCallback onTap;
  final VoidCallback onLike;

  const _TrackRow({
    required this.track,
    required this.index,
    required this.isCurrent,
    required this.onTap,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    final cover  = track['coverColor'] as Color;
    final accent = track['accentColor'] as Color;
    final liked  = track['isLiked'] as bool;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isCurrent
              ? accent.withOpacity(0.10)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCurrent
                ? accent.withOpacity(0.30)
                : Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Album cover
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cover,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: accent.withOpacity(0.25), blurRadius: 10),
                ],
              ),
              child: Icon(
                CupertinoIcons.music_note,
                color: Colors.white.withOpacity(0.7),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track['title'] as String,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: isCurrent ? accent : Colors.white,
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    track['artist'] as String,
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white38),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Duration
            Text(
              track['duration'] as String,
              style: AppTextStyles.caption.copyWith(color: Colors.white30),
            ),
            const SizedBox(width: 12),

            // Like
            GestureDetector(
              onTap: onLike,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: Icon(
                  liked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                  key: ValueKey(liked),
                  color: liked ? const Color(0xFFFF2D55) : Colors.white30,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tab Pill ─────────────────────────────────────────────────────────────────

class _TabPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabPill({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(30),
          border: isActive
              ? null
              : Border.all(color: Colors.white.withOpacity(0.10)),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: isActive ? Colors.white : Colors.white54,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ─── Mini Player ──────────────────────────────────────────────────────────────

class _MiniPlayer extends StatelessWidget {
  final Map<String, dynamic> track;
  final VoidCallback onTap;

  const _MiniPlayer({required this.track, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cover  = track['coverColor'] as Color;
    final accent = track['accentColor'] as Color;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.14)),
              boxShadow: [
                BoxShadow(color: accent.withOpacity(0.18), blurRadius: 20),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: cover,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(CupertinoIcons.music_note, color: Colors.white54, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track['title'] as String,
                        style: AppTextStyles.titleSmall.copyWith(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        track['artist'] as String,
                        style: AppTextStyles.caption.copyWith(color: Colors.white50),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                const Icon(CupertinoIcons.play_fill, color: Colors.white, size: 22),
                const SizedBox(width: 4),
                const Icon(CupertinoIcons.forward_fill, color: Colors.white54, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Full Player ──────────────────────────────────────────────────────────────

class _FullPlayer extends StatefulWidget {
  final Map<String, dynamic> track;
  final List<Map<String, dynamic>> allTracks;
  final int currentIndex;
  final AnimationController rotationController;
  final VoidCallback onClose;
  final VoidCallback onToggleLike;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _FullPlayer({
    required this.track,
    required this.allTracks,
    required this.currentIndex,
    required this.rotationController,
    required this.onClose,
    required this.onToggleLike,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  State<_FullPlayer> createState() => _FullPlayerState();
}

class _FullPlayerState extends State<_FullPlayer> {
  bool _isPlaying = true;
  bool _isShuffleActive = false;
  bool _isRepeatActive = false;
  double _progress = 0.32;

  @override
  Widget build(BuildContext context) {
    final track  = widget.track;
    final cover  = track['coverColor'] as Color;
    final accent = track['accentColor'] as Color;
    final liked  = track['isLiked'] as bool;
    final size   = MediaQuery.of(context).size;
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(cover, Colors.black, 0.3)!,
            const Color(0xFF010101),
          ],
          stops: const [0.0, 0.55],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.10),
                      ),
                      child: const Icon(
                        CupertinoIcons.chevron_down,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  Text(
                    'Now Playing',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.10),
                      ),
                      child: const Icon(
                        CupertinoIcons.ellipsis,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 2),

            // ── Album art (spinning disc) ──────────────────────────────
            AnimatedBuilder(
              animation: widget.rotationController,
              builder: (_, child) => Transform.rotate(
                angle: _isPlaying
                    ? widget.rotationController.value * 2 * math.pi
                    : 0,
                child: child,
              ),
              child: Container(
                width: size.width * 0.72,
                height: size.width * 0.72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color.lerp(cover, Colors.white, 0.1)!,
                      cover,
                      Colors.black,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.45),
                      blurRadius: 50,
                      spreadRadius: 5,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Vinyl grooves
                    ...List.generate(5, (i) {
                      final r = 0.3 + i * 0.12;
                      return Container(
                        width: size.width * 0.72 * r,
                        height: size.width * 0.72 * r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.04),
                            width: 1,
                          ),
                        ),
                      );
                    }),
                    // Center hole
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.music_note,
                      color: Colors.white.withOpacity(0.6),
                      size: 60,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(flex: 2),

            // ── Track info + like ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track['title'] as String,
                          style: AppTextStyles.h4.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          track['artist'] as String,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onToggleLike,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        liked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                        key: ValueKey(liked),
                        color: liked ? const Color(0xFFFF2D55) : Colors.white38,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Progress slider ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3.5,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                        elevation: 0,
                      ),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      activeTrackColor: accent,
                      inactiveTrackColor: Colors.white.withOpacity(0.15),
                      thumbColor: Colors.white,
                      overlayColor: accent.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: _progress,
                      onChanged: (v) => setState(() => _progress = v),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '1:12',
                          style: AppTextStyles.caption.copyWith(color: Colors.white38),
                        ),
                        Text(
                          track['duration'] as String,
                          style: AppTextStyles.caption.copyWith(color: Colors.white38),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Controls ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Shuffle
                  _PlayerCtrlBtn(
                    icon: CupertinoIcons.shuffle,
                    color: _isShuffleActive ? accent : Colors.white38,
                    size: 22,
                    onTap: () => setState(() => _isShuffleActive = !_isShuffleActive),
                  ),
                  // Previous
                  _PlayerCtrlBtn(
                    icon: CupertinoIcons.backward_end_fill,
                    color: Colors.white,
                    size: 34,
                    onTap: () {
                      widget.onPrevious();
                      HapticFeedback.selectionClick();
                    },
                  ),
                  // Play / Pause
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.impactOccurred(HapticFeedbackType.mediumImpact);
                      setState(() => _isPlaying = !_isPlaying);
                      _isPlaying
                          ? widget.rotationController.repeat()
                          : widget.rotationController.stop();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [accent, Color.lerp(accent, Colors.white, 0.15)!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withOpacity(0.45),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isPlaying
                            ? CupertinoIcons.pause_fill
                            : CupertinoIcons.play_fill,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  // Next
                  _PlayerCtrlBtn(
                    icon: CupertinoIcons.forward_end_fill,
                    color: Colors.white,
                    size: 34,
                    onTap: () {
                      widget.onNext();
                      HapticFeedback.selectionClick();
                    },
                  ),
                  // Repeat
                  _PlayerCtrlBtn(
                    icon: CupertinoIcons.repeat,
                    color: _isRepeatActive ? accent : Colors.white38,
                    size: 22,
                    onTap: () => setState(() => _isRepeatActive = !_isRepeatActive),
                  ),
                ],
              ),
            ),

            SizedBox(height: botPad + 24),
          ],
        ),
      ),
    );
  }
}

class _PlayerCtrlBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _PlayerCtrlBtn({
    required this.icon,
    required this.color,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}
