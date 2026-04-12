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
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            top: _showStoriesPanel ? 0 : -270,
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
                  margin: const EdgeInsets.only(top: 270),
                  color: Colors.black.withOpacity(0.45),
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
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.search_rounded, color: Colors.white, size: 20),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onSetRizeTap,
            child: Row(
              children: [
                const Text(
                  'SetRize',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: isPanelOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
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
          const SizedBox(width: 38, height: 38),
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
    {'label': 'Set', 'icon': Icons.home_rounded},
    {'label': 'Rize', 'icon': Icons.short_text_rounded},
    {'label': 'Shop', 'icon': Icons.shopping_bag_rounded},
    {'label': 'Date', 'icon': Icons.favorite_rounded},
    {'label': 'Live', 'icon': Icons.videocam_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 18,
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
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: i == 0
                          ? Colors.white.withOpacity(0.15)
                          : Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: i == 0
                            ? Colors.white.withOpacity(0.35)
                            : Colors.white.withOpacity(0.10),
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
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: stories.length,
                itemBuilder: (ctx, i) => _StoryCard(
                  story: stories[i],
                  onTap: () {},
                ),
              ),
            ),
          ],
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
        width: 95,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: story.isLive ? Colors.redAccent : Colors.white,
            width: 2,
          ),
          color: const Color(0xFF1A1A1A),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white10,
                      Colors.black.withOpacity(0.85),
                    ],
                  ),
                ),
                child: const Icon(Icons.person_rounded, color: Colors.white54, size: 40),
              ),
            ),
            if (story.isLive)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
              left: 0,
              right: 0,
              bottom: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  story.username,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
