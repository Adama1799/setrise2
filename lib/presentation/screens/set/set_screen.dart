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
  final List<PostModel> _posts = PostModel.getMockPosts();
  final List<StoryModel> _stories = StoryModel.getMockStories();

  // Pull-down panel
  bool _panelOpen = false;
  late AnimationController _panelCtrl;
  late Animation<double> _panelAnim;

  @override
  void initState() {
    super.initState();
    _panelCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _panelAnim =
        CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOutCubic);
    _panelCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _panelCtrl.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _openPanel() {
    HapticFeedback.lightImpact();
    _panelCtrl.forward();
    setState(() => _panelOpen = true);
  }

  void _closePanel() {
    _panelCtrl.reverse();
    setState(() => _panelOpen = false);
  }

  void _updatePost(int index, PostModel updatedPost) =>
      setState(() => _posts[index] = updatedPost);

  // ───── Filter sheet (hamburger menu) ─────────────────────────────────────
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final panelH = MediaQuery.of(context).size.height * 0.52;

    return PopScope(
      canPop: false, // fix back button
      onPopInvoked: (didPop) {
        if (_panelOpen) {
          _closePanel();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(children: [

          // ── MAIN FEED ──────────────────────────────────────────────────
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _posts.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            physics: _panelOpen
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            itemBuilder: (_, i) => PostCard(
              post: _posts[i],
              onUpdate: (p) => _updatePost(i, p),
              onSwipeNext: () {
                if (_currentPage < _posts.length - 1) {
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic);
                }
              },
            ),
          ),

          // ── PANEL OVERLAY ──────────────────────────────────────────────
          if (_panelCtrl.value > 0)
            Positioned.fill(
              child: GestureDetector(
                onTap: _closePanel,
                child: Container(
                    color:
                        Colors.black.withOpacity(0.45 * _panelCtrl.value)),
              ),
            ),

          // ── PANEL CONTENT ──────────────────────────────────────────────
          AnimatedBuilder(
            animation: _panelAnim,
            builder: (_, __) => Positioned(
              top: -panelH + panelH * _panelAnim.value,
              left: 0,
              right: 0,
              child: _PanelContent(
                stories: _stories,
                onClose: _closePanel,
              ),
            ),
          ),

          // ── TOP BAR (fixed) ────────────────────────────────────────────
          SafeArea(
            child: _TopBar(
              panelOpen: _panelOpen,
              onMenuTap: _showFilterSheet,
              onSetrizeTap: _panelOpen ? _closePanel : _openPanel,
            ),
          ),
        ]),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// TOP BAR
// ═════════════════════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  final bool panelOpen;
  final VoidCallback onMenuTap;
  final VoidCallback onSetrizeTap;

  const _TopBar(
      {required this.panelOpen,
      required this.onMenuTap,
      required this.onSetrizeTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(children: [
        // Hamburger → filter sheet
        GestureDetector(
          onTap: onMenuTap,
          child: const Icon(Icons.menu, color: AppColors.white, size: 26),
        ),
        const SizedBox(width: 12),
        // SetRize button → pull-down panel
        GestureDetector(
          onTap: onSetrizeTap,
          child: Row(children: [
            Text('SetRize',
                style: AppTextStyles.h5.copyWith(
                    color: AppColors.white, fontWeight: FontWeight.w900)),
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: panelOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.keyboard_arrow_down,
                  color: AppColors.white, size: 20),
            ),
          ]),
        ),
        const Spacer(),
        // Search moved to top right
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/search'),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.search, color: AppColors.white, size: 20),
          ),
        ),
      ]),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// PULL-DOWN PANEL  (SetRize → tabs + stories)
// ═════════════════════════════════════════════════════════════════════════════
class _PanelContent extends StatelessWidget {
  final List<StoryModel> stories;
  final VoidCallback onClose;

  const _PanelContent({required this.stories, required this.onClose});

  static const _tabs = [
    {'label': 'Set',   'route': null},
    {'label': 'Rize',  'route': '/rize'},
    {'label': 'Shop',  'route': '/shop'},
    {'label': 'Date',  'route': '/date'},
    {'label': 'Live',  'route': '/live'},
    {'label': 'Music', 'route': '/music'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 12),
          // Tabs row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(children: _tabs.map((t) {
              final label = t['label'] as String;
              final route = t['route'] as String?;
              return GestureDetector(
                onTap: () {
                  onClose();
                  if (route != null) {
                    Navigator.pushNamed(context, route);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: label == 'Set'
                        ? AppColors.white
                        : Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(label,
                      style: TextStyle(
                          color: label == 'Set'
                              ? AppColors.black
                              : AppColors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter')),
                ),
              );
            }).toList()),
          ),
          const SizedBox(height: 14),
          // Stories inside panel
          _PanelStories(stories: stories),
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2)),
          ),
        ]),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STORIES  (rectangular vertical, 2×3 cm ratio)
// ═════════════════════════════════════════════════════════════════════════════
class _PanelStories extends StatelessWidget {
  final List<StoryModel> stories;
  const _PanelStories({required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: stories.length,
        itemBuilder: (_, i) => _StoryCard(story: stories[i]),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final StoryModel story;
  const _StoryCard({required this.story});

  Color get _border {
    switch (story.status) {
      case StoryStatus.live:
        return AppColors.storyLive;
      case StoryStatus.own:
        return AppColors.storyOwn;
      case StoryStatus.closeFriend:
        return AppColors.storyCloseFriend;
      case StoryStatus.unseen:
        return AppColors.storyUnseen;
      case StoryStatus.seen:
        return AppColors.storySeen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openStory(context),
      child: Container(
        width: 56,   // ~2 cm
        height: 90,  // ~3 cm
        margin: const EdgeInsets.only(right: 10),
        child: Column(children: [
          // Rectangle story thumbnail
          Container(
            width: 54,
            height: 78,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: story.status == StoryStatus.seen
                    ? Colors.transparent
                    : _border,
                width: 2.5,
              ),
              color: AppColors.grey,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(fit: StackFit.expand, children: [
                const Icon(Icons.person, color: AppColors.white, size: 28),
                if (story.isLive)
                  Positioned(
                    bottom: 4,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: AppColors.storyLive,
                            borderRadius: BorderRadius.circular(4)),
                        child: const Text('LIVE',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Inter')),
                      ),
                    ),
                  ),
                if (story.status == StoryStatus.own)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                          color: AppColors.electricBlue,
                          shape: BoxShape.circle),
                      child: const Icon(Icons.add,
                          color: Colors.white, size: 12),
                    ),
                  ),
              ]),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            story.status == StoryStatus.own ? 'You' : story.username,
            style: const TextStyle(
                color: AppColors.white,
                fontSize: 9,
                fontFamily: 'Inter'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ]),
      ),
    );
  }

  void _openStory(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => _StoryViewScreen(story: story)));
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STORY VIEWER  (TikTok/Instagram style)
// ═════════════════════════════════════════════════════════════════════════════
class _StoryViewScreen extends StatefulWidget {
  final StoryModel story;
  const _StoryViewScreen({required this.story});
  @override
  State<_StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<_StoryViewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressCtrl;
  bool _paused = false;
  bool _liked = false;
  int _likes = 0;
  final _commentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 6))
      ..forward()
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) Navigator.pop(context);
      });
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
    _paused ? _progressCtrl.stop() : _progressCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _togglePause,
        child: Stack(fit: StackFit.expand, children: [
          // Story background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepPurple.shade900,
                  Colors.black,
                ],
              ),
            ),
            child: const Center(
                child:
                    Icon(Icons.person, color: Colors.white30, size: 120)),
          ),

          // Progress bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                child: AnimatedBuilder(
                  animation: _progressCtrl,
                  builder: (_, __) => LinearProgressIndicator(
                    value: _progressCtrl.value,
                    backgroundColor: Colors.white30,
                    valueColor:
                        const AlwaysStoppedAnimation(Colors.white),
                    minHeight: 2.5,
                  ),
                ),
              ),
            ),
          ),

          // Header
          Positioned(
            top: 50,
            left: 14,
            right: 14,
            child: Row(children: [
              CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.grey,
                  child: const Icon(Icons.person,
                      color: Colors.white, size: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(widget.story.username,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Inter')),
              ),
              if (_paused)
                const Icon(Icons.pause_circle_outline,
                    color: Colors.white, size: 22),
              const SizedBox(width: 8),
              GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close,
                      color: Colors.white, size: 24)),
            ]),
          ),

          // Pause indicator
          if (_paused)
            const Center(
                child: Icon(Icons.pause_circle_outline,
                    color: Colors.white54, size: 80)),

          // Bottom actions (like/comment)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: Row(children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white38),
                          borderRadius: BorderRadius.circular(21)),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14),
                      child: TextField(
                        controller: _commentCtrl,
                        style: const TextStyle(
                            color: Colors.white, fontFamily: 'Inter'),
                        decoration: const InputDecoration(
                            hintText: 'Reply...',
                            hintStyle: TextStyle(
                                color: Colors.white54,
                                fontFamily: 'Inter'),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _liked = !_liked),
                    child: Column(children: [
                      Icon(
                          _liked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _liked
                              ? AppColors.neonRed
                              : Colors.white,
                          size: 28),
                      if (_likes > 0)
                        Text('$_likes',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: 'Inter')),
                    ]),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.send_outlined,
                      color: Colors.white, size: 26),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// FILTER SHEET  (hamburger → filters like before)
// ═════════════════════════════════════════════════════════════════════════════
class _FilterSheet extends StatefulWidget {
  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  String? _mood, _category, _region;
  static const moods = ['😴 Chill','😤 Hyped','😞 Sad','🧘 Focus','💪 Motivated'];
  static const categories = ['💻 Tech','🏛️ Politics','🎬 Movies','🎵 Music','📖 Stories','💰 Business','🎓 Education','😂 Comedy','🍳 Cooking','❤️ Dating','🛍️ Shop','🔴 Live','✈️ Travel','🎨 Art','⚽ Sports'];
  static const regions = ['🇩🇿 Algeria','🇺🇸 USA','🇸🇦 Saudi','🇦🇪 UAE','🇲🇦 Morocco','🇫🇷 France','🇯🇵 Japan','🇧🇷 Brazil','🌍 Worldwide'];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          _section('😊 Mood', moods, _mood, (v) => setState(() => _mood = v)),
          const SizedBox(height: 14),
          _section('🎯 Category', categories, _category, (v) => setState(() => _category = v)),
          const SizedBox(height: 14),
          _section('🌍 Region', regions, _region, (v) => setState(() => _region = v)),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: GestureDetector(
              onTap: () => setState(() { _mood = _category = _region = null; }),
              child: Container(height: 48, decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('Reset', style: TextStyle(color: Colors.white, fontFamily: 'Inter')))))),
            const SizedBox(width: 12),
            Expanded(child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(height: 48, decoration: BoxDecoration(
                color: AppColors.electricBlue, borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Inter')))))),
          ]),
        ]),
      ),
    );
  }

  Widget _section(String title, List<String> items, String? selected, Function(String) onTap) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
      const SizedBox(height: 8),
      Wrap(spacing: 6, runSpacing: 6, children: items.map((item) {
        final isSel = selected == item;
        return GestureDetector(
          onTap: () => onTap(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSel ? AppColors.electricBlue : Colors.white10,
              borderRadius: BorderRadius.circular(20)),
            child: Text(item, style: TextStyle(
                color: Colors.white, fontSize: 12,
                fontWeight: isSel ? FontWeight.w700 : FontWeight.w400,
                fontFamily: 'Inter')),
          ),
        );
      }).toList()),
    ]);
  }
}
