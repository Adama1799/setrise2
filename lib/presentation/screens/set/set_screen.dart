// lib/presentation/screens/set/set_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/story_model.dart';
import 'widgets/post_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SET SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class SetScreen extends StatefulWidget {
  const SetScreen({super.key});

  @override
  State<SetScreen> createState() => _SetScreenState();
}

class _SetScreenState extends State<SetScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  bool _isDraggingHorizontal = false;

  final List<PostModel> _posts = PostModel.getMockPosts();
  final List<StoryModel> _stories = StoryModel.getMockStories();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updatePost(int index, PostModel updated) =>
      setState(() => _posts[index] = updated);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ① الشريط العلوي
            const _AppTopBar(),

            // ② مسافة 15px بين الشريط والستوريات
            const SizedBox(height: 15),

            // ③ شريط الستوريات
            _StoriesRow(
              stories: _stories,
              onStoryTap: (index) => _openStoryViewer(index),
            ),

            // ④ تابس: For You / Stories / Trending
            const SizedBox(height: 10),
            const _FeedTabs(),
            const SizedBox(height: 6),

            // ⑤ المحتوى
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: _posts.length,
                physics: _isDraggingHorizontal
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (ctx, i) => PostCard(
                  post: _posts[i],
                  onUpdate: (p) => _updatePost(i, p),
                  onSwipeNext: () {
                    if (_currentPage < _posts.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                      );
                    }
                  },
                  onSwipeRight: () => HapticFeedback.mediumImpact(),
                  onSwipeLeft:  () => HapticFeedback.lightImpact(),
                  onSwipeStart: () => setState(() => _isDraggingHorizontal = true),
                  onSwipeEnd:   () => setState(() => _isDraggingHorizontal = false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openStoryViewer(int index) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => _StoryViewer(
          stories: _stories,
          initialIndex: index,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ① APP TOP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _AppTopBar extends StatefulWidget {
  const _AppTopBar();

  @override
  State<_AppTopBar> createState() => _AppTopBarState();
}

class _AppTopBarState extends State<_AppTopBar>
    with SingleTickerProviderStateMixin {
  bool _expanded = true;
  int _selectedTab = 0;

  static const _tabs = [
    _Tab('Set',   Colors.white,                  pill: true),
    _Tab('Rize',  Colors.white,                  pill: true),
    _Tab('Shop',  Color(0xFF39FF14),              pill: false), // neonGreen
    _Tab('Date',  Color(0xFFFFB300),              pill: false), // neonYellow
    _Tab('Live',  Color(0xFFFF2200),              pill: false), // neonRed
    _Tab('Music', Color(0xFF00FFEE),              pill: false), // cyan
  ];

  void _toggle() {
    HapticFeedback.lightImpact();
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row: ☰  SetRize  ∨
            Row(
              children: [
                // ☰ Hamburger
                GestureDetector(
                  onTap: _toggle,
                  child: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),

                // SetRize (يختفي لما يُطوى)
                if (_expanded) ...[
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _toggle,
                    child: Row(
                      children: [
                        const Text(
                          'SetRize',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(width: 4),
                        AnimatedRotation(
                          turns: _expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),

            // Chips: Set | Rize | Shop | Date | Live | Music (ظاهرة فقط لو expanded)
            if (_expanded) ...[
              const SizedBox(height: 10),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _tabs.length,
                  // ✅ 10px بين كل أيقونة والثانية
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final tab    = _tabs[i];
                    final active = _selectedTab == i;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedTab = i);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: active
                              ? (tab.pill ? Colors.white : tab.color)
                              : Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: active
                                ? (tab.pill ? Colors.white : tab.color)
                                : Colors.white.withOpacity(0.18),
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          tab.label,
                          style: TextStyle(
                            color: active && tab.pill
                                ? Colors.black
                                : Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Tab {
  final String label;
  final Color color;
  final bool pill;
  const _Tab(this.label, this.color, {required this.pill});
}

// ─────────────────────────────────────────────────────────────────────────────
// ③ STORIES ROW
// ─────────────────────────────────────────────────────────────────────────────

class _StoriesRow extends StatelessWidget {
  final List<StoryModel> stories;
  final void Function(int index) onStoryTap;

  const _StoriesRow({
    required this.stories,
    required this.onStoryTap,
  });

  // ✅ 3cm × 4cm بالبكسل المنطقي (1cm ≈ 37.8dp)
  static const double _cardW = 113.0; // ~3cm
  static const double _cardH = 151.0; // ~4cm

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _cardH,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        physics: const BouncingScrollPhysics(),
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) => _StoryCard(
          story: stories[i],
          width: _cardW,
          height: _cardH,
          onTap: () => onStoryTap(i),
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final StoryModel story;
  final double width;
  final double height;
  final VoidCallback onTap;

  const _StoryCard({
    required this.story,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ بوردر أبيض للجميع ماعدا LIVE يكون أحمر
    final borderColor = story.isLive ? const Color(0xFFFF2200) : Colors.white;
    final borderWidth = story.isLive ? 2.5 : 2.0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: story.isLive
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF2200).withOpacity(0.35),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13.5),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background gradient
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF2B2B2B), Color(0xFF111111)],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 44,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),

                // Bottom gradient + username
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.88),
                        ],
                      ),
                    ),
                    child: Text(
                      story.status == StoryStatus.own
                          ? 'Your Story'
                          : story.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // LIVE badge
                if (story.isLive)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF2200),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                // + Button for own story
                if (story.status == StoryStatus.own)
                  Positioned(
                    bottom: 32,
                    right: 8,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFF39FF14),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.black, size: 16),
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

// ─────────────────────────────────────────────────────────────────────────────
// ④ FEED TABS (For You / Stories / Trending)
// ─────────────────────────────────────────────────────────────────────────────

class _FeedTabs extends StatefulWidget {
  const _FeedTabs();

  @override
  State<_FeedTabs> createState() => _FeedTabsState();
}

class _FeedTabsState extends State<_FeedTabs> {
  int _selected = 0;
  static const _labels = ['For You', 'Stories', 'Trending'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: List.generate(_labels.length, (i) {
          final active = _selected == i;
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selected = i);
            },
            child: Padding(
              padding: EdgeInsets.only(right: i < _labels.length - 1 ? 20 : 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _labels[i],
                    style: TextStyle(
                      color: active ? Colors.white : Colors.white38,
                      fontSize: 14,
                      fontWeight:
                          active ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 2,
                    width: active ? 28 : 0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STORY VIEWER — احترافي مثل إنستقرام وتيك توك
// ─────────────────────────────────────────────────────────────────────────────

class _StoryViewer extends StatefulWidget {
  final List<StoryModel> stories;
  final int initialIndex;

  const _StoryViewer({
    required this.stories,
    required this.initialIndex,
  });

  @override
  State<_StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<_StoryViewer>
    with SingleTickerProviderStateMixin {
  late PageController _pageCtrl;
  late AnimationController _progressCtrl;
  late int _currentIndex;
  bool _paused = false;
  final _replyCtrl = TextEditingController();
  bool _replyFocused = false;

  static const _duration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageCtrl     = PageController(initialPage: widget.initialIndex);
    _progressCtrl = AnimationController(vsync: this, duration: _duration)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) _next();
      })
      ..forward();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _progressCtrl.dispose();
    _replyCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentIndex < widget.stories.length - 1) {
      setState(() => _currentIndex++);
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
      _progressCtrl
        ..reset()
        ..forward();
    } else {
      Navigator.pop(context);
    }
  }

  void _prev() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
      _progressCtrl
        ..reset()
        ..forward();
    }
  }

  void _pause()  { if (!_paused) { _paused = true;  _progressCtrl.stop();    setState(() {}); } }
  void _resume() { if (_paused)  { _paused = false; _progressCtrl.forward(); setState(() {}); } }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_currentIndex];
    final size  = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onLongPressStart: (_) => _pause(),
        onLongPressEnd:   (_) => _resume(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Pages ──────────────────────────────────────────────────────
            PageView.builder(
              controller: _pageCtrl,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              itemBuilder: (_, i) => _buildStoryPage(i),
            ),

            // ── Tap zones (prev / next) ─────────────────────────────────
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _prev,
                      child: const ColoredBox(color: Colors.transparent),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _next,
                      child: const ColoredBox(color: Colors.transparent),
                    ),
                  ),
                ],
              ),
            ),

            // ── Top UI ─────────────────────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Column(
                  children: [
                    // Progress bars
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Row(
                        children: List.generate(widget.stories.length, (i) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: AnimatedBuilder(
                                animation: _progressCtrl,
                                builder: (_, __) => ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: LinearProgressIndicator(
                                    minHeight: 2.5,
                                    value: i < _currentIndex
                                        ? 1.0
                                        : i == _currentIndex
                                            ? _progressCtrl.value
                                            : 0.0,
                                    backgroundColor: Colors.white30,
                                    valueColor: const AlwaysStoppedAnimation(
                                        Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    // User row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: story.isLive
                                    ? const Color(0xFFFF2200)
                                    : Colors.white,
                                width: 2,
                              ),
                              color: AppColors.grey,
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  story.username,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  _paused ? 'Paused' : '5s ago',
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (story.isLive)
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF2200),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'LIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom reply bar ──────────────────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                  child: Row(
                    children: [
                      // Reply input
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.white24),
                          ),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 14),
                          child: TextField(
                            controller: _replyCtrl,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Reply to ${story.username}...',
                              hintStyle:
                                  const TextStyle(color: Colors.white38),
                              border: InputBorder.none,
                            ),
                            onTap: _pause,
                            onSubmitted: (_) {
                              _replyCtrl.clear();
                              _resume();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Emoji reactions
                      ...['❤️', '🔥', '😂'].map(
                        (e) => GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4),
                            child:
                                Text(e, style: const TextStyle(fontSize: 24)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Send button
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryPage(int i) {
    final colors = [
      const Color(0xFF1A0A2E),
      const Color(0xFF0A1628),
      const Color(0xFF1A0A0A),
      const Color(0xFF0A1A0A),
      const Color(0xFF1A1A0A),
      const Color(0xFF2E0A1A),
    ];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors[i % colors.length], Colors.black],
        ),
      ),
      child: const Center(
        child: Icon(Icons.person_rounded, color: Colors.white12, size: 120),
      ),
    );
  }
}
