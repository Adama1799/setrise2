import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/story_model.dart';
import 'post_detail_screen.dart';
import 'story_viewer_screen.dart';
import 'widgets/post_card.dart';
import 'widgets/stories_bar.dart';
import 'widgets/top_bar.dart';

class SetScreen extends StatefulWidget {
  const SetScreen({super.key});

  @override
  State<SetScreen> createState() => _SetScreenState();
}

class _SetScreenState extends State<SetScreen> {
  final PageController _pageController = PageController();
  final ScrollController _searchScrollController = ScrollController();

  bool _showStoriesPanel = true;
  int _currentIndex = 0;

  late final List<PostModel> _posts = PostModel.getMockPosts();
  late final List<StoryModel> _stories = StoryModel.getMockStories();

  @override
  void dispose() {
    _pageController.dispose();
    _searchScrollController.dispose();
    super.dispose();
  }

  void _toggleLike(int index) {
    final current = _posts[index];
    setState(() {
      _posts[index] = current.copyWith(
        isLiked: !current.isLiked,
        likesCount: current.isLiked ? current.likesCount - 1 : current.likesCount + 1,
      );
    });
  }

  void _toggleStories() {
    setState(() => _showStoriesPanel = !_showStoriesPanel);
  }

  void _openSearchSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SearchSheet(),
    );
  }

  void _openInfoSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _InfoSheet(),
    );
  }

  void _goHome() {
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _openStoryViewer(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StoryViewerScreen(
          stories: _stories,
          initialIndex: index,
        ),
      ),
    );
  }

  void _openPost(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostDetailScreen(post: _posts[index]),
      ),
    );
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
            physics: const BouncingScrollPhysics(),
            itemCount: _posts.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return PostCard(
                post: _posts[index],
                onLikeTap: () => _toggleLike(index),
                onOpenDetails: () => _openPost(index),
                onUpdate: (updatedPost) {
                  setState(() => _posts[index] = updatedPost);
                },
              );
            },
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TopBar(
                  onHomeTap: _goHome,
                  onTitleTap: _toggleStories,
                  onSearchTap: _openSearchSheet,
                  onInfoTap: _openInfoSheet,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: _showStoriesPanel
                      ? StoriesBar(
                          key: const ValueKey('stories_on'),
                          stories: _stories,
                          onStoryTap: _openStoryViewer,
                        )
                      : const SizedBox.shrink(
                          key: ValueKey('stories_off'),
                        ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _Chip(
                        label: 'For You',
                        selected: true,
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      _Chip(
                        label: 'Trending',
                        selected: false,
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      _Chip(
                        label: 'Saved',
                        selected: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 14,
            bottom: 110,
            child: Column(
              children: [
                _FloatingMiniButton(
                  icon: Icons.message_rounded,
                  label: 'Comment',
                  onTap: _openInfoSheet,
                ),
                const SizedBox(height: 10),
                _FloatingMiniButton(
                  icon: Icons.favorite_rounded,
                  label: 'Info',
                  onTap: _openInfoSheet,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.white : Colors.white10;
    final fg = selected ? Colors.black : AppColors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _FloatingMiniButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FloatingMiniButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 74,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF101010).withOpacity(0.92),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.white, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchSheet extends StatelessWidget {
  const _SearchSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.42,
      maxChildSize: 0.92,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0E0E0E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Search',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث عن فيديو، صورة، شخص، أو موضوع',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _SearchChip(text: 'طبخ'),
                  _SearchChip(text: 'سياسة'),
                  _SearchChip(text: 'رياضة'),
                  _SearchChip(text: 'موسيقى'),
                  _SearchChip(text: 'ترند'),
                  _SearchChip(text: 'لايف'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchChip extends StatelessWidget {
  final String text;

  const _SearchChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.white10,
      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      side: const BorderSide(color: Colors.white12),
    );
  }
}

class _InfoSheet extends StatelessWidget {
  const _InfoSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        18,
        16,
        18,
        18 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0E0E0E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 18),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Feed Info',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(icon: Icons.info_outline_rounded, text: 'ضغط على Setrise يفتح/يغلق الستوريز'),
          _InfoRow(icon: Icons.home_rounded, text: 'زر Home يرجع لأول منشور'),
          _InfoRow(icon: Icons.favorite_rounded, text: 'الضغط مرتين يعمل لايك'),
          _InfoRow(icon: Icons.message_rounded, text: 'التعليقات موجودة من داخل البطاقة'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
