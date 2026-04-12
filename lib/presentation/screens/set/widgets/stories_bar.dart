import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/story_model.dart';
import '../story_viewer_screen.dart';

class StoriesBar extends StatelessWidget {
  final List<StoryModel> stories;

  const StoriesBar({
    super.key,
    required this.stories,
  });

  @override
  Widget build(BuildContext context) {
    final hasStories = stories.isNotEmpty;

    return SizedBox(
      height: 198,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        physics: const BouncingScrollPhysics(),
        itemCount: hasStories ? stories.length : _fallbackStories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (hasStories) {
            return _StoryItem(story: stories[index]);
          }
          final item = _fallbackStories[index];
          return _StaticStoryItem(
            title: item.title,
            isLive: item.isLive,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => StoryViewerScreen(
                    title: item.title,
                    isLive: item.isLive,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  final StoryModel story;

  const _StoryItem({required this.story});

  @override
  Widget build(BuildContext context) {
    final title =
        story.status == StoryStatus.own ? 'Your Story' : story.username;

    return _StoryCard(
      title: title,
      isLive: story.isLive,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => StoryViewerScreen(
              story: story,
              title: title,
              isLive: story.isLive,
            ),
          ),
        );
      },
    );
  }
}

class _StaticStoryItem extends StatelessWidget {
  final String title;
  final bool isLive;
  final VoidCallback onTap;

  const _StaticStoryItem({
    required this.title,
    required this.isLive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _StoryCard(
      title: title,
      isLive: isLive,
      onTap: onTap,
    );
  }
}

class _StoryCard extends StatelessWidget {
  final String title;
  final bool isLive;
  final VoidCallback onTap;

  const _StoryCard({
    required this.title,
    required this.isLive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF2B2B2B),
                          Color(0xFF101010),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.22),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF2B2B2B),
                                  Color(0xFF151515),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Icon(
                              Icons.photo_rounded,
                              size: 44,
                              color: Colors.white.withOpacity(0.72),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            right: 10,
                            bottom: 10,
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isLive)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FallbackStory {
  final String title;
  final bool isLive;

  const _FallbackStory({
    required this.title,
    required this.isLive,
  });
}

const List<_FallbackStory> _fallbackStories = [
  _FallbackStory(title: 'Your Story', isLive: false),
  _FallbackStory(title: 'For You', isLive: false),
  _FallbackStory(title: 'Trending', isLive: true),
  _FallbackStory(title: 'Watching', isLive: false),
  _FallbackStory(title: 'Live Now', isLive: true),
];
