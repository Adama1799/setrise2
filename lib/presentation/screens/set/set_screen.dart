import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/story_model.dart';
import 'widgets/post_card.dart';

class SetScreen extends StatefulWidget {
  const SetScreen({super.key});

  @override
  State<SetScreen> createState() => _SetScreenState();
}

class _SetScreenState extends State<SetScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showStoriesPanel = false;

  final List<PostModel> _posts = PostModel.getMockPosts();
  final List<StoryModel> _stories = StoryModel.getMockStories();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updatePost(int index, PostModel updatedPost) {
    setState(() => _posts[index] = updatedPost);
  }

  void _toggleStoriesPanel() {
    HapticFeedback.lightImpact();
    setState(() => _showStoriesPanel = !_showStoriesPanel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _posts.length,
            physics: _showStoriesPanel
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
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            top: _showStoriesPanel ? 0 : -260,
            left: 0,
            right: 0,
            child: _StoriesPanel(
              stories: _stories,
              onClose: _toggleStoriesPanel,
            ),
          ),

          if (_showStoriesPanel)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleStoriesPanel,
                child: Container(
                  margin: const EdgeInsets.only(top: 260),
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),

          SafeArea(
            child: _TopBar(
              isPanelOpen: _showStoriesPanel,
              onSetRizeTap: _toggleStoriesPanel,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool isPanelOpen;
  final VoidCallback onSetRizeTap;

  const _TopBar({
    required this.isPanelOpen,
    required this.onSetRizeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.search_rounded, color: Colors.white, size: 20),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onSetRizeTap,
            child: Row(
              children: [
                const Text(
                  'SetRise',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: isPanelOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(width: 36, height: 36),
        ],
      ),
    );
  }
}

class _StoriesPanel extends StatelessWidget {
  final List<StoryModel> stories;
  final VoidCallback onClose;

  const _StoriesPanel({
    required this.stories,
    required this.onClose,
  });

  static const _categories = [
    {'label': 'Following', 'icon': Icons.people_rounded},
    {'label': 'Cooking', 'icon': Icons.restaurant_rounded},
    {'label': 'Sports', 'icon': Icons.sports_soccer_rounded},
    {'label': 'Politics', 'icon': Icons.gavel_rounded},
    {'label': 'Music', 'icon': Icons.music_note_rounded},
    {'label': 'Travel', 'icon': Icons.flight_rounded},
    {'label': 'Tech', 'icon': Icons.memory_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
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
        child: Column(
          children: [
            const SizedBox(height: 8),
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: _categories.length,
                itemBuilder: (_, i) {
                  final cat = _categories[i];
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: i == 0 ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: i == 0 ? Colors.white.withOpacity(0.5) : Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(cat['icon'] as IconData, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          cat['label'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: stories.length,
                itemBuilder: (ctx, i) => _StoryCard(
                  story: stories[i],
                  onTap: () => _openStory(ctx, stories, i),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _openStory(BuildContext ctx, List<StoryModel> stories, int startIndex) {
    Navigator.push(
      ctx,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => _StoryViewer(
          stories: stories,
          initialIndex: startIndex,
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final StoryModel story;
  final VoidCallback onTap;

  const _StoryCard({
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 120,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: story.isLive ? Colors.redAccent : Colors.white,
            width: story.isLive ? 2.5 : 2,
          ),
          color: AppColors.grey,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.grey,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                child: const Icon(Icons.person_rounded, color: Colors.white54, size: 40),
              ),
              if (story.isLive)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(6, 16, 6, 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                    ),
                  ),
                  child: Text(
                    story.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

class _StoryViewerState extends State<_StoryViewer> with SingleTickerProviderStateMixin {
  late PageController _pageCtrl;
  late AnimationController _progressCtrl;
  int _currentIndex = 0;
  bool _paused = false;
  final _commentCtrl = TextEditingController();

  static const _duration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageCtrl = PageController(initialPage: widget.initialIndex);
    _progressCtrl = AnimationController(
      vsync: this,
      duration: _duration,
    )..addStatusListener((s) {
        if (s == AnimationStatus.completed) _nextStory();
      })
      ..forward();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _progressCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      setState(() => _currentIndex++);
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
      _progressCtrl.reset();
      _progressCtrl.forward();
    } else {
      Navigator.pop(context);
    }
  }

  void _prevStory() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
      _progressCtrl.reset();
      _progressCtrl.forward();
    }
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
    if (_paused) {
      _progressCtrl.stop();
    } else {
      _progressCtrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (d) {
          final x = d.globalPosition.dx;
          final w = MediaQuery.of(context).size.width;
          if (x < w * 0.33) {
            _prevStory();
          } else if (x > w * 0.67) {
            _nextStory();
          } else {
            _togglePause();
          }
        },
        onLongPressStart: (_) {
          _paused = true;
          _progressCtrl.stop();
          setState(() {});
        },
        onLongPressEnd: (_) {
          _paused = false;
          _progressCtrl.forward();
          setState(() {});
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _pageCtrl,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              itemBuilder: (_, i) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _storyColor(i),
                      Colors.black,
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.person_rounded, color: Colors.white24, size: 120),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                            valueColor: const AlwaysStoppedAnimation(Colors.white),
                            minHeight: 2.5,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        color: AppColors.grey,
                      ),
                      child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 10),
                    Column(
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
                          style: const TextStyle(color: Colors.white60, fontSize: 11),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (story.isLive)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 26),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(21),
                            border: Border.all(color: Colors.white24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: TextField(
                            controller: _commentCtrl,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: const InputDecoration(
                              hintText: 'Reply...',
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                            ),
                            onTap: () {
                              _paused = true;
                              _progressCtrl.stop();
                            },
                            onSubmitted: (_) {
                              _commentCtrl.clear();
                              _paused = false;
                              _progressCtrl.forward();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ...['❤️', '🔥', '😂'].map(
                        (e) => GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(e, style: const TextStyle(fontSize: 26)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.send_rounded, color: Colors.black, size: 18),
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

  Color _storyColor(int i) {
    const colors = [
      Color(0xFF1A0A2E),
      Color(0xFF0A1628),
      Color(0xFF1A0A0A),
      Color(0xFF0A1A0A),
      Color(0xFF1A1A0A),
      Color(0xFF2E0A1A),
    ];
    return colors[i % colors.length];
  }
}
