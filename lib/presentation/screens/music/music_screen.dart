// lib/presentation/screens/music/music_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen>
    with SingleTickerProviderStateMixin {
  // ─── Mock Track Data ────────────────────────────────────────────────
  final List<Map<String, dynamic>> _allTracks = [
    {
      'id': '1',
      'title': 'Midnight Vibes',
      'artist': 'DJ SetRise',
      'duration': '3:24',
      'coverColor': const Color(0xFF1A0A2E),
      'isLiked': true,
    },
    {
      'id': '2',
      'title': 'Desert Rose',
      'artist': 'Karim_beats',
      'duration': '4:12',
      'coverColor': const Color(0xFF2E1A0A),
      'isLiked': false,
    },
    {
      'id': '3',
      'title': 'Neon Dreams',
      'artist': 'SynthWave_X',
      'duration': '3:48',
      'coverColor': const Color(0xFF0A1A2E),
      'isLiked': true,
    },
    {
      'id': '4',
      'title': 'Street Poetry',
      'artist': 'Lyric_A',
      'duration': '2:59',
      'coverColor': const Color(0xFF0A2E1A),
      'isLiked': false,
    },
    {
      'id': '5',
      'title': 'Ocean Calm',
      'artist': 'Relax_Mode',
      'duration': '5:30',
      'coverColor': const Color(0xFF002E2E),
      'isLiked': true,
    },
    {
      'id': '6',
      'title': 'Fire Dance',
      'artist': 'BeatMaker_Z',
      'duration': '3:15',
      'coverColor': const Color(0xFF2E0A0A),
      'isLiked': false,
    },
    {
      'id': '7',
      'title': 'Solar Flare',
      'artist': 'AstroBeats',
      'duration': '4:02',
      'coverColor': const Color(0xFF2E2E0A),
      'isLiked': true,
    },
    {
      'id': '8',
      'title': 'Velvet Night',
      'artist': 'Luna_Sound',
      'duration': '3:36',
      'coverColor': const Color(0xFF1A002E),
      'isLiked': false,
    },
    {
      'id': '9',
      'title': 'Crystal Waves',
      'artist': 'AquaTone',
      'duration': '4:44',
      'coverColor': const Color(0xFF0A0A2E),
      'isLiked': true,
    },
    {
      'id': '10',
      'title': 'Urban Echo',
      'artist': 'CityPulse',
      'duration': '3:08',
      'coverColor': const Color(0xFF0E1E0E),
      'isLiked': false,
    },
  ];

  // ─── State ───────────────────────────────────────────────────────────
  Map<String, dynamic>? _currentTrack;
  bool _isPlaying = false;

  List<Map<String, dynamic>> get _likedTracks =>
      _allTracks.where((t) => t['isLiked'] == true).toList();

  // ─── Actions ─────────────────────────────────────────────────────────
  void _playTrack(Map<String, dynamic> track) {
    setState(() {
      _currentTrack = track;
      _isPlaying = true;
    });
  }

  void _togglePlayPause() {
    setState(() => _isPlaying = !_isPlaying);
  }

  void _toggleLike(Map<String, dynamic> track) {
    setState(() {
      track['isLiked'] = !(track['isLiked'] as bool);
    });
  }

  void _closeMiniPlayer() {
    setState(() {
      _isPlaying = false;
      _currentTrack = null;
    });
  }

  Future<void> _showTrackOptions(BuildContext context, Map<String, dynamic> track) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.grey.withOpacity(0.15),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.play_arrow),
                title: const Text('Play Next'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added "${track['title']}" to play next')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.queue_music),
                title: const Text('Add to Queue'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added "${track['title']}" to queue')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.playlist_add),
                title: const Text('Add to Playlist'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added "${track['title']}" to playlist')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sharing "${track['title']}"')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openFullScreenPlayer() {
    if (_currentTrack == null) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: _FullScreenPlayer(
          track: _currentTrack!,
          isPlaying: _isPlaying,
          onTogglePlayPause: _togglePlayPause,
          onClose: () {
            Navigator.pop(context);
            _closeMiniPlayer();
          },
          onToggleLike: () => _toggleLike(_currentTrack!),
        ),
      ),
    );
  }

  // ─── Build ───────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // ── Tab Bar ──────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              indicatorColor: AppColors.music,
              indicatorWeight: 2.5,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: AppColors.music,
              unselectedLabelColor: AppColors.grey2,
              labelStyle: AppTextStyles.labelLarge,
              unselectedLabelStyle: AppTextStyles.labelMedium,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'For You'),
                Tab(text: 'My Music'),
              ],
            ),
          ),

          // ── Tab Content ──────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              children: [
                _TrackList(
                  tracks: _allTracks,
                  currentTrack: _currentTrack,
                  isPlaying: _isPlaying,
                  onTrackTap: _playTrack,
                  onLikeTap: _toggleLike,
                  onLongPress: (track) => _showTrackOptions(context, track),
                ),
                _TrackList(
                  tracks: _likedTracks,
                  currentTrack: _currentTrack,
                  isPlaying: _isPlaying,
                  onTrackTap: _playTrack,
                  onLikeTap: _toggleLike,
                  onLongPress: (track) => _showTrackOptions(context, track),
                ),
              ],
            ),
          ),

          // ── Mini Player (conditional) ────────────────────────────────
          if (_currentTrack != null)
            _MiniPlayer(
              track: _currentTrack!,
              isPlaying: _isPlaying,
              onTogglePlayPause: _togglePlayPause,
              onClose: _closeMiniPlayer,
              onTap: _openFullScreenPlayer,
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Track List Widget
// ═══════════════════════════════════════════════════════════════════════

class _TrackList extends StatelessWidget {
  final List<Map<String, dynamic>> tracks;
  final Map<String, dynamic>? currentTrack;
  final bool isPlaying;
  final ValueChanged<Map<String, dynamic>> onTrackTap;
  final ValueChanged<Map<String, dynamic>> onLikeTap;
  final ValueChanged<Map<String, dynamic>> onLongPress;

  const _TrackList({
    required this.tracks,
    required this.currentTrack,
    required this.isPlaying,
    required this.onTrackTap,
    required this.onLikeTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 64, color: AppColors.grey2),
            const SizedBox(height: 16),
            Text(
              'No songs liked yet',
              style: AppTextStyles.h5.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Songs you like will appear here',
              style: AppTextStyles.body2.copyWith(color: AppColors.grey2),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: tracks.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        indent: 74,
        endIndent: 16,
        color: AppColors.grey.withOpacity(0.1),
      ),
      itemBuilder: (context, index) {
        final track = tracks[index];
        final isCurrent = currentTrack != null &&
            currentTrack!['id'] == track['id'];
        final liked = track['isLiked'] as bool;

        return _TrackRow(
          track: track,
          isCurrent: isCurrent,
          isCurrentlyPlaying: isCurrent && isPlaying,
          liked: liked,
          onTap: () => onTrackTap(track),
          onLikeTap: () => onLikeTap(track),
          onLongPress: () => onLongPress(track),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Track Row Widget
// ═══════════════════════════════════════════════════════════════════════

class _TrackRow extends StatelessWidget {
  final Map<String, dynamic> track;
  final bool isCurrent;
  final bool isCurrentlyPlaying;
  final bool liked;
  final VoidCallback onTap;
  final VoidCallback onLikeTap;
  final VoidCallback onLongPress;

  const _TrackRow({
    required this.track,
    required this.isCurrent,
    required this.isCurrentlyPlaying,
    required this.liked,
    required this.onTap,
    required this.onLikeTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final coverColor = track['coverColor'] as Color;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color:
            isCurrent ? AppColors.music.withOpacity(0.08) : Colors.transparent,
        child: Row(
          children: [
            // ── Cover Art ──────────────────────────────────────────────
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: coverColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  if (isCurrent)
                    BoxShadow(
                      color: AppColors.music.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Center(
                child: isCurrentlyPlaying
                    ? const _PlayingAnimation()
                    : Icon(
                        Icons.music_note,
                        color: isCurrent
                            ? AppColors.music
                            : AppColors.white.withOpacity(0.6),
                        size: 22,
                      ),
              ),
            ),
            const SizedBox(width: 14),

            // ── Track Info ─────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track['title'] as String,
                    style: AppTextStyles.body1.copyWith(
                      color: isCurrent ? AppColors.music : AppColors.white,
                      fontWeight:
                          isCurrent ? FontWeight.w700 : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    track['artist'] as String,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.grey2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ── Duration ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                track['duration'] as String,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.grey2,
                ),
              ),
            ),

            // ── Like Button ────────────────────────────────────────────
            GestureDetector(
              onTap: onLikeTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  color: liked ? AppColors.neonRed : AppColors.grey2,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Playing Animation (equalizer bars)
// ═══════════════════════════════════════════════════════════════════════

class _PlayingAnimation extends StatefulWidget {
  const _PlayingAnimation();

  @override
  State<_PlayingAnimation> createState() => _PlayingAnimationState();
}

class _PlayingAnimationState extends State<_PlayingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final delay = i * 0.2;
            final value = ((_controller.value + delay) % 1.0);
            final height = 6.0 + (value * 14.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 3,
              height: height,
              decoration: BoxDecoration(
                color: AppColors.music,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Mini Player Widget
// ═══════════════════════════════════════════════════════════════════════

class _MiniPlayer extends StatefulWidget {
  final Map<String, dynamic> track;
  final bool isPlaying;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onClose;
  final VoidCallback onTap;

  const _MiniPlayer({
    required this.track,
    required this.isPlaying,
    required this.onTogglePlayPause,
    required this.onClose,
    required this.onTap,
  });

  @override
  State<_MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<_MiniPlayer> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        if (widget.isPlaying) {
          _animationController.forward();
        }
      }
    });

    if (widget.isPlaying) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _MiniPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPlaying != widget.isPlaying) {
      if (widget.isPlaying) {
        _animationController.forward();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coverColor = widget.track['coverColor'] as Color;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.grey.withOpacity(0.15),
            border: Border(
              top: BorderSide(
                color: AppColors.grey.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: GestureDetector(
            onTap: widget.onTap,
            behavior: HitTestBehavior.opaque,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    // ── Cover Art ──────────────────────────────────────────
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: coverColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.music.withOpacity(0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          widget.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // ── Track Info ─────────────────────────────────────────
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.track['title'] as String,
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.track['artist'] as String,
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.grey2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // ── Play / Pause Button ────────────────────────────────
                    GestureDetector(
                      onTap: widget.onTogglePlayPause,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.music.withOpacity(0.15),
                        ),
                        child: Icon(
                          widget.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: AppColors.music,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // ── Close Button ───────────────────────────────────────
                    GestureDetector(
                      onTap: widget.onClose,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.grey.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColors.grey2,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // ── Top Progress Bar ──────────────────────────────────────────────
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: widget.isPlaying ? _progressAnimation.value : 0,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.music),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Full-Screen Player (Modal Bottom Sheet)
// ═══════════════════════════════════════════════════════════════════════

class _FullScreenPlayer extends StatefulWidget {
  final Map<String, dynamic> track;
  final bool isPlaying;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onClose;
  final VoidCallback onToggleLike;

  const _FullScreenPlayer({
    required this.track,
    required this.isPlaying,
    required this.onTogglePlayPause,
    required this.onClose,
    required this.onToggleLike,
  });

  @override
  State<_FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<_FullScreenPlayer> {
  late bool _isPlaying;
  late bool _isShuffleActive;
  late bool _isRepeatActive;
  double _progress = 0.35;
  double _dragOffset = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.isPlaying;
    _isShuffleActive = false;
    _isRepeatActive = false;
  }

  @override
  void didUpdateWidget(covariant _FullScreenPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isPlaying = widget.isPlaying;
  }

  void _handleDragStart(DragStartDetails details) {
    _isDragging = true;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_isDragging) {
      setState(() {
        _dragOffset += details.delta.dy;
        _dragOffset = _dragOffset.clamp(0.0, 150.0);
      });
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_isDragging) {
      if (_dragOffset > 100) {
        widget.onClose();
      } else {
        setState(() {
          _dragOffset = 0.0;
        });
      }
      _isDragging = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final coverColor = widget.track['coverColor'] as Color;
    final liked = widget.track['isLiked'] as bool;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: Transform.translate(
        offset: Offset(0, _dragOffset),
        child: Container(
          height: screenHeight * 0.92,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // ── Handle Bar ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey2,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Close Button (top-right) ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Now Playing',
                        style: AppTextStyles.h5.copyWith(color: AppColors.grey2),
                      ),
                      GestureDetector(
                        onTap: widget.onClose,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.grey.withOpacity(0.15),
                          ),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),

                // ── Album Art ──────────────────────────────────────────────
                Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    color: coverColor,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: coverColor.withOpacity(0.5),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                      BoxShadow(
                        color: AppColors.music.withOpacity(0.15),
                        blurRadius: 60,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.music_note,
                      color: AppColors.white.withOpacity(0.8),
                      size: 80,
                    ),
                  ),
                ),
                const Spacer(flex: 2),

                // ── Track Info ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.track['title'] as String,
                              style: AppTextStyles.h4.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.track['artist'] as String,
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.grey2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onToggleLike,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: liked
                                ? AppColors.neonRed.withOpacity(0.12)
                                : AppColors.grey.withOpacity(0.1),
                          ),
                          child: Icon(
                            liked ? Icons.favorite : Icons.favorite_border,
                            color: liked ? AppColors.neonRed : AppColors.grey2,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Progress Slider ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape:
                              const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape:
                              const RoundSliderOverlayShape(overlayRadius: 14),
                          activeTrackColor: AppColors.music,
                          inactiveTrackColor: AppColors.grey.withOpacity(0.25),
                          thumbColor: AppColors.music,
                        ),
                        child: Slider(
                          value: _progress,
                          onChanged: (value) => setState(() => _progress = value),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '1:12',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.grey2,
                              ),
                            ),
                            Text(
                              widget.track['duration'] as String,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.grey2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Playback Controls ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _controlButton(
                        icon: Icons.shuffle,
                        color: _isShuffleActive ? AppColors.music : AppColors.grey2,
                        size: 22,
                        onTap: () {
                          setState(() {
                            _isShuffleActive = !_isShuffleActive;
                          });
                        },
                      ),
                      _controlButton(
                        icon: Icons.skip_previous,
                        color: AppColors.white,
                        size: 32,
                        onTap: () {},
                      ),
                      // ── Play / Pause (main) ─────────────────────────────
                      GestureDetector(
                        onTap: () {
                          setState(() => _isPlaying = !_isPlaying);
                          widget.onTogglePlayPause();
                        },
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.music,
                                AppColors.electricBlue,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.music.withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: AppColors.white,
                            size: 34,
                          ),
                        ),
                      ),
                      _controlButton(
                        icon: Icons.skip_next,
                        color: AppColors.white,
                        size: 32,
                        onTap: () {},
                      ),
                      _controlButton(
                        icon: Icons.repeat,
                        color: _isRepeatActive ? AppColors.music : AppColors.grey2,
                        size: 22,
                        onTap: () {
                          setState(() {
                            _isRepeatActive = !_isRepeatActive;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onTap,
  }) {
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
