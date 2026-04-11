import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/story_model.dart';

class StoriesBar extends StatelessWidget {
  final List<StoryModel> stories;
  final ValueChanged<int> onStoryTap;

  const StoriesBar({
    super.key,
    required this.stories,
    required this.onStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 138,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final story = stories[index];
          return _StoryCard(
            story: story,
            onTap: () => onStoryTap(index),
          );
        },
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
    final isLive = story.isLive || story.status == StoryStatus.live;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 72,
        padding: const EdgeInsets.all(2),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 116,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isLive ? AppColors.storyLive : story.borderColor,
                  width: isLive ? 2.4 : 2,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isLive
                      ? [const Color(0xFFFF2D2D), const Color(0xFF5A0000)]
                      : [
                          Colors.white10,
                          Colors.white10,
                        ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: story.borderColor.withOpacity(0.22),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              story.borderColor.withOpacity(0.35),
                              const Color(0xFF111111),
                            ],
                            center: Alignment.topCenter,
                            radius: 0.95,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.95),
                            ),
                            child: const Icon(Icons.person_rounded, size: 12, color: Colors.black),
                          ),
                          const Spacer(),
                          if (isLive)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'LIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 8,
                      right: 8,
                      bottom: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.username,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isLive ? 'Open' : 'Story',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
