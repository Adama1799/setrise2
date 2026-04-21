// lib/features/stories/presentation/screens/story_viewer_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/story_entity.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<StoryEntity> stories;
  final int initialIndex;
  final void Function(String storyId)? onStoryViewed;

  const StoryViewerScreen({
    super.key,
    required this.stories,
    required this.initialIndex,
    this.onStoryViewed,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _progressController;
  late int _currentIndex;

  static const _storyDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.stories.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
    _progressController = AnimationController(
      vsync: this,
      duration: _storyDuration,
    )..addStatusListener(_onProgressStatus);

    _startStory(_currentIndex);
  }

  @override
  void dispose() {
    _progressController.removeStatusListener(_onProgressStatus);
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _startStory(int index) {
    _progressController.forward(from: 0);
    widget.onStoryViewed?.call(widget.stories[index].id);
  }

  void _onProgressStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _goNext();
    }
  }

  void _goNext() {
    if (_currentIndex >= widget.stories.length - 1) {
      Navigator.pop(context);
      return;
    }
    setState(() => _currentIndex++);
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    _startStory(_currentIndex);
  }

  void _goPrev() {
    if (_currentIndex <= 0) return;
    setState(() => _currentIndex--);
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    _startStory(_currentIndex);
  }

  void _pause()  => _progressController.stop();
  void _resume() => _progressController.forward();

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPressStart: (_) => _pause(),
        onLongPressEnd:   (_) => _resume(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ─── Story Pages ───────────────────────────────────────────────
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              itemBuilder: (_, index) {
                final s = widget.stories[index];
                return _StoryPage(story: s);
              },
            ),

            // ─── Tap Areas ─────────────────────────────────────────────────
            Row(
              children: [
                Expanded(child: GestureDetector(onTap: _goPrev)),
                Expanded(child: GestureDetector(onTap: _goNext)),
              ],
            ),

            // ─── Top UI ────────────────────────────────────────────────────
            SafeArea(
              child: Column(
                children: [
                  // Progress bars
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      children: List.generate(widget.stories.length, (i) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: AnimatedBuilder(
                              animation: _progressController,
                              builder: (_, __) {
                                double value;
                                if (i < _currentIndex) {
                                  value = 1.0;
                                } else if (i == _currentIndex) {
                                  value = _progressController.value;
                                } else {
                                  value = 0.0;
                                }
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: LinearProgressIndicator(
                                    value: value,
                                    minHeight: 2.5,
                                    backgroundColor: Colors.white.withOpacity(0.3),
                                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // User info row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: story.borderColor.withOpacity(0.3),
                          backgroundImage: story.avatar != null
                              ? NetworkImage(story.avatar!)
                              : null,
                          child: story.avatar == null
                              ? Icon(Icons.person, color: story.borderColor, size: 20)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          story.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        if (story.isLive) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
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

// ─── Story Page ───────────────────────────────────────────────────────────────

class _StoryPage extends StatelessWidget {
  final StoryEntity story;
  const _StoryPage({required this.story});

  @override
  Widget build(BuildContext context) {
    if (story.mediaUrl != null && story.mediaUrl!.isNotEmpty) {
      return Image.network(
        story.mediaUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _placeholder(story);
        },
        errorBuilder: (_, __, ___) => _placeholder(story),
      );
    }
    return _placeholder(story);
  }

  Widget _placeholder(StoryEntity s) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            s.borderColor.withOpacity(0.3),
            Colors.black,
          ],
        ),
      ),
      child: Center(
        child: Icon(Icons.person_rounded, size: 80, color: s.borderColor.withOpacity(0.5)),
      ),
    );
  }
}
