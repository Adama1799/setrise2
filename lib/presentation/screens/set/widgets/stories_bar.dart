import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/story_model.dart';

class StoriesBar extends StatelessWidget {
  final List<StoryModel> stories;

  const StoriesBar({
    super.key,
    required this.stories,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: stories.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final story = stories[index];
          return _StoryItem(story: story);
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
    return GestureDetector(
      onTap: () {
        // TODO: Open story viewer
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening ${story.username}\'s story')),
        );
      },
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Stack(
              children: [
                // Story Circle
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: story.borderColor,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: Container(
                      color: AppColors.grey,
                      child: const Icon(
                        Icons.person,
                        color: AppColors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                // Live Badge
                if (story.isLive)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.live,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.background,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'LIVE',
                        style: AppTextStyles.overline.copyWith(
                          color: AppColors.white,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              story.status == StoryStatus.own
                  ? 'Your Story'
                  : story.username,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
