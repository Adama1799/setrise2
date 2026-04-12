import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/story_model.dart';
import 'widgets/post_card.dart';

class SetScreen extends StatefulWidget {
  const SetScreen({super.key});
  @override
  State<SetScreen> createState() => _SetScreenState();
}

class _SetScreenState extends State<SetScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showPanel = false;
  bool _isDraggingHorizontal = false;

  final List<PostModel> _posts = PostModel.getMockPosts();
  final List<StoryModel> _stories = StoryModel.getMockStories();

  // للسحب اليدوي من الشريط
  double _dragOffset = 0;
  bool _dragging = false;
  static const double _panelH = 280.0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updatePost(int i, PostModel p) => setState(() => _posts[i] = p);

  void _openPanel() {
    HapticFeedback.lightImpact();
    setState(() => _showPanel = true);
  }

  void _closePanel() => setState(() { _showPanel = false; _dragOffset = 0; });

  void _goNextPage() {
    if (_currentPage < _posts.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  // ── حساب offset اللوحة (للسحب اليدوي) ────────────────────────────
  double get _panelTop {
    if (_showPanel) {
      // مفتوحة: اسمح بسحب للأعلى
      return (_dragging ? -_dragOffset.clamp(0, _panelH) : 0);
    } else {
      // مغلقة: اسمح بسحب للأسفل
      return -_panelH + (_dragging ? _dragOffset.clamp(0, _panelH) : 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(children: [

        // ── FEED ──────────────────────────────────────────────────────
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: _posts.length,
          physics: (_showPanel || _isDraggingHorizontal)
              ? const NeverScrollableScrollPhysics()
              : const BouncingScrollPhysics(),
          onPageChanged: (i) => setState(() => _currentPage = i),
          itemBuilder: (ctx, i) => PostCard(
            post: _posts[i],
            onUpdate: (p) => _updatePost(i, p),
            onSwipeNext: _goNextPage,
            onSwipeRight: () => HapticFeedback.mediumImpact(),
            onSwipeLeft: () => HapticFeedback.lightImpact(),
            onSwipeStart: () =>
                setState(() => _isDraggingHorizontal = true),
            onSwipeEnd: () =>
                setState(() => _isDraggingHorizontal = false),
          ),
        ),

        // ── DIM overlay ───────────────────────────────────────────────
        if (_showPanel || _dragging && _dragOffset > 20)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closePanel,
              child: AnimatedOpacity(
                opacity: _showPanel ? 0.55 : (_dragOffset / _panelH) * 0.55,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  margin: EdgeInsets.only(
                      top: _showPanel ? _panelH : _dragOffset),
                  color: Colors.black,
                ),
              ),
            ),
          ),

        // ── PULL PANEL ────────────────────────────────────────────────
        AnimatedPositioned(
          duration: _dragging
              ? Duration.zero
              : const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          top: _panelTop,
          left: 0,
          right: 0,
          child: _PullPanel(
            stories: _stories,
            isOpen: _showPanel,
            onClose: _closePanel,
            onTabTap: (label) {
              _closePanel();
              // التابات تُعالج في MainNavigationScreen
            },
          ),
        ),

        // ── TOP BAR (ثابت دائماً) ─────────────────────────────────────
        SafeArea(
          child: GestureDetector(
            // سحب للأسفل من أي مكان في الـ TopBar يفتح اللوحة
            onVerticalDragStart: (_) {
              if (!_showPanel) setState(() => _dragging = true);
            },
            onVerticalDragUpdate: (d) {
              if (!_showPanel && _dragging) {
                setState(() => _dragOffset =
                    (_dragOffset + d.delta.dy).clamp(0, _panelH));
              } else if (_showPanel) {
                setState(() {
                  _dragging = true;
                  _dragOffset =
                      (_dragOffset + (-d.delta.dy)).clamp(0, _panelH);
                });
              }
            },
            onVerticalDragEnd: (d) {
              if (!_showPanel) {
                if (_dragOffset > _panelH * 0.35) {
                  _openPanel();
                } else {
                  setState(() { _dragging = false; _dragOffset = 0; });
                }
              } else {
                if (_dragOffset > _panelH * 0.35) {
                  _closePanel();
                } else {
                  setState(() { _dragging = false; _dragOffset = 0; });
                }
              }
              setState(() => _dragging = false);
            },
            child: _TopBar(
              isOpen: _showPanel,
              onTap: _showPanel ? _closePanel : _openPanel,
            ),
          ),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  TOP BAR — "SetRize ▼" + خطان
// ═══════════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onTap;

  const _TopBar({required this.isOpen, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            // صورة البحث
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.search_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
            const Spacer(),
            // SetRize + سهم
            Row(children: [
              Text('SetRize',
                  style: AppTextStyles.h5.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w900)),
              const SizedBox(width: 4),
              AnimatedRotation(
                turns: isOpen ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.white, size: 22),
              ),
            ]),
            const Spacer(),
            const SizedBox(width: 36), // توازن
          ]),
          // خطان صغيران — مؤشر اللوحة (مثل ريدو)
          const SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 28, height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isOpen
                    ? Colors.white
                    : Colors.white.withOpacity(0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 28, height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isOpen
                    ? Colors.white
                    : Colors.white.withOpacity(0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  PULL PANEL — التابات + الستوريات
// ═══════════════════════════════════════════════════════════════════
class _PullPanel extends StatefulWidget {
  final List<StoryModel> stories;
  final bool isOpen;
  final VoidCallback onClose;
  final ValueChanged<String> onTabTap;

  const _PullPanel({
    required this.stories,
    required this.isOpen,
    required this.onClose,
    required this.onTabTap,
  });

  @override
  State<_PullPanel> createState() => _PullPanelState();
}

class _PullPanelState extends State<_PullPanel> {
  int _storyTab = 0; // 0=Following, 1=ForYou

  static const _tabs = [
    {'label': 'Set',   'color': Colors.white},
    {'label': 'Rize',  'color': AppColors.electricBlue},
    {'label': 'Shop',  'color': AppColors.shop},
    {'label': 'Date',  'color': AppColors.dating},
    {'label': 'Live',  'color': AppColors.live},
    {'label': 'Music', 'color': AppColors.music},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(children: [
          const SizedBox(height: 10),

          // ── خط الفلترة العلوي (Set, Rize, Shop...) ───────────────
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: _tabs.map((t) {
                final label = t['label'] as String;
                final color = t['color'] as Color;
                final isSet = label == 'Set';
                return GestureDetector(
                  onTap: () => widget.onTabTap(label),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSet
                          ? AppColors.white
                          : color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSet
                            ? AppColors.white
                            : color.withOpacity(0.5),
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isSet ? AppColors.black : Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          // ── خط الفلترة السفلي (Following / For You) ──────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(children: [
              _storyTabBtn(0, 'Following'),
              const SizedBox(width: 16),
              _storyTabBtn(1, 'For You'),
              const Spacer(),
              // زر إضافة ستوري
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.electricBlue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.electricBlue.withOpacity(0.4)),
                  ),
                  child: const Row(children: [
                    Icon(Icons.add_rounded,
                        color: AppColors.electricBlue, size: 14),
                    SizedBox(width: 4),
                    Text('Story',
                        style: TextStyle(
                          color: AppColors.electricBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        )),
                  ]),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 10),

          // ── الستوريات المستطيلة ───────────────────────────────────
          SizedBox(
            height: 148,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: widget.stories.length,
              itemBuilder: (ctx, i) => _StoryCard(
                story: widget.stories[i],
                onTap: () => _openStory(ctx, i),
              ),
            ),
          ),

          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  Widget _storyTabBtn(int idx, String label) {
    final active = _storyTab == idx;
    return GestureDetector(
      onTap: () => setState(() => _storyTab = idx),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: TextStyle(
              color: active ? Colors.white : AppColors.grey2,
              fontSize: 13,
              fontWeight:
                  active ? FontWeight.w800 : FontWeight.w400,
              fontFamily: 'Inter',
            )),
        const SizedBox(height: 3),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 2,
          width: active ? label.length * 7.5 : 0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ]),
    );
  }

  void _openStory(BuildContext ctx, int startIndex) {
    Navigator.push(
      ctx,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => _StoryViewer(
          stories: widget.stories,
          initialIndex: startIndex,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  STORY CARD — مستطيل عمودي (2:3 تقريباً)
// ═══════════════════════════════════════════════════════════════════
class _StoryCard extends StatelessWidget {
  final StoryModel story;
  final VoidCallback onTap;

  const _StoryCard({required this.story, required this.onTap});

  Color get _borderColor {
    switch (story.status) {
      case StoryStatus.live:        return AppColors.storyLive;
      case StoryStatus.own:         return AppColors.storyOwn;
      case StoryStatus.closeFriend: return AppColors.storyCloseFriend;
      case StoryStatus.unseen:      return AppColors.storyUnseen;
      case StoryStatus.seen:        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSeen = story.status == StoryStatus.seen;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 86,
        height: 140,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _borderColor,
            width: isSeen ? 0 : 2.5,
          ),
          color: AppColors.grey,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(fit: StackFit.expand, children: [

            // خلفية متدرجة
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _bgColor().withOpacity(0.8),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),

            // أيقونة الشخص
            const Center(
              child: Icon(Icons.person_rounded,
                  color: Colors.white38, size: 36),
            ),

            // LIVE badge
            if (story.isLive)
              Positioned(
                top: 8, left: 0, right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.storyLive,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text('LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Inter',
                        )),
                  ),
                ),
              ),

            // Own: زر +
            if (story.status == StoryStatus.own)
              Positioned(
                bottom: 28, right: 6,
                child: Container(
                  width: 20, height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.electricBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_rounded,
                      color: Colors.white, size: 14),
                ),
              ),

            // اسم المستخدم
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(6, 18, 6, 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.85),
                    ],
                  ),
                ),
                child: Text(
                  story.status == StoryStatus.own
                      ? 'Your Story'
                      : story.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Color _bgColor() {
    switch (story.status) {
      case StoryStatus.live:        return const Color(0xFF2E0A0A);
      case StoryStatus.own:         return const Color(0xFF0A2E0A);
      case StoryStatus.closeFriend: return const Color(0xFF2E1A0A);
      case StoryStatus.unseen:      return const Color(0xFF0A1A2E);
      case StoryStatus.seen:        return const Color(0xFF1A1A1A);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
//  STORY VIEWER — مثل إنستقرام/تيكتوك
// ═══════════════════════════════════════════════════════════════════
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
  bool _liked = false;
  final _replyCtrl = TextEditingController();

  static const _duration = Duration(seconds: 6);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageCtrl = PageController(initialPage: widget.initialIndex);
    _progressCtrl = AnimationController(vsync: this, duration: _duration)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) _next();
      })
      ..addListener(() => setState(() {}))
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
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeIn);
      _progressCtrl.reset();
      _progressCtrl.forward();
    } else {
      Navigator.pop(context);
    }
  }

  void _prev() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _pageCtrl.previousPage(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeIn);
      _progressCtrl.reset();
      _progressCtrl.forward();
    }
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
    _paused ? _progressCtrl.stop() : _progressCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_currentIndex];
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTapDown: (d) {
          final x = d.globalPosition.dx;
          if (x < size.width * 0.33) _prev();
          else if (x > size.width * 0.67) _next();
          else _togglePause();
        },
        onLongPressStart: (_) {
          setState(() => _paused = true);
          _progressCtrl.stop();
        },
        onLongPressEnd: (_) {
          setState(() => _paused = false);
          _progressCtrl.forward();
        },
        child: Stack(fit: StackFit.expand, children: [

          // ── خلفية القصة ─────────────────────────────────────────────
          PageView.builder(
            controller: _pageCtrl,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.stories.length,
            itemBuilder: (_, i) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_color(i), Colors.black],
                ),
              ),
              child: const Center(
                child: Icon(Icons.person_rounded,
                    color: Colors.white12, size: 120),
              ),
            ),
          ),

          // ── شرائط التقدم ────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: List.generate(widget.stories.length, (i) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: i < _currentIndex
                              ? 1.0
                              : i == _currentIndex
                                  ? _progressCtrl.value
                                  : 0.0,
                          backgroundColor: Colors.white30,
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.white),
                          minHeight: 2.5,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ── هيدر: أفاتار + اسم + X ──────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 22, 14, 0),
              child: Row(children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    color: AppColors.grey,
                  ),
                  child: const Icon(Icons.person_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(story.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'Inter',
                      )),
                  Text(
                    _paused ? 'Paused ⏸' : '· Just now',
                    style: const TextStyle(
                        color: Colors.white60, fontSize: 11,
                        fontFamily: 'Inter'),
                  ),
                ]),
                const Spacer(),
                if (story.isLive)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.storyLive,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('LIVE',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            fontFamily: 'Inter')),
                  ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 26),
                ),
              ]),
            ),
          ),

          // ── شريط التفاعل السفلي ──────────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: Row(children: [
                  // حقل الرد
                  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(color: Colors.white24),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14),
                      child: TextField(
                        controller: _replyCtrl,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Inter'),
                        decoration: const InputDecoration(
                          hintText: 'Reply...',
                          hintStyle: TextStyle(
                              color: Colors.white54, fontFamily: 'Inter'),
                          border: InputBorder.none,
                        ),
                        onTap: () {
                          _paused = true;
                          _progressCtrl.stop();
                        },
                        onSubmitted: (_) {
                          _replyCtrl.clear();
                          _paused = false;
                          _progressCtrl.forward();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // ردود سريعة (قلب + نار)
                  GestureDetector(
                    onTap: () => setState(() => _liked = !_liked),
                    child: Icon(
                      _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: _liked ? AppColors.neonRed : Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {},
                    child: const Text('🔥',
                        style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 8),
                  // إرسال
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 38, height: 38,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.black, size: 18),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Color _color(int i) {
    const colors = [
      Color(0xFF1A0A2E), Color(0xFF0A1628), Color(0xFF1A0A0A),
      Color(0xFF0A1A0A), Color(0xFF1A1A0A), Color(0xFF2E0A1A),
    ];
    return colors[i % colors.length];
  }
}
