// lib/features/stories/presentation/widgets/stories_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/story_entity.dart';
import '../providers/stories_provider.dart';
import '../screens/story_viewer_screen.dart';
import 'story_card.dart';

class StoriesBar extends ConsumerWidget {
  const StoriesBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storiesProvider);

    if (state.isLoading) {
      return const _StoriesBarSkeleton();
    }

    final stories = state.stories.isNotEmpty
        ? state.stories
        : _mockStories; // fallback للعرض

    return SizedBox(
      // ✅ Fix: حسبنا الارتفاع بشكل صحيح
      // Card width=108, AspectRatio=9/14 → height = 108*(14/9) = 168
      // padding vertical 10 + 10 = 20
      // total = 188
      height: 188,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        // ✅ Fix: padding أوضح وثابت
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        physics: const BouncingScrollPhysics(),
        itemCount: stories.length,
        // ✅ Fix: spacing أكبر قليلاً بين الكروت لتجنب التداخل البصري
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final story = stories[index];
          return StoryCard(
            story: story,
            onTap: () => _openViewer(context, stories, index, ref),
          );
        },
      ),
    );
  }

  void _openViewer(
    BuildContext context,
    List<StoryEntity> stories,
    int index,
    WidgetRef ref,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => StoryViewerScreen(
          stories: stories,
          initialIndex: index,
          onStoryViewed: (storyId) =>
              ref.read(storiesProvider.notifier).markAsViewed(storyId),
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}

// ─── Skeleton Loading ─────────────────────────────────────────────────────────

class _StoriesBarSkeleton extends StatelessWidget {
  const _StoriesBarSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 188,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, __) => SizedBox(
          width: 108,
          child: AspectRatio(
            aspectRatio: 9 / 14,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: const Color(0xFF1E1E1E),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Mock fallback ────────────────────────────────────────────────────────────

final _now = DateTime.now();
final _exp = DateTime.now().add(const Duration(hours: 24));

final _mockStories = <StoryEntity>[
  StoryEntity(id: 's0', userId: 'me', username: 'Your Story',  status: StoryStatus.own,         createdAt: _now, expiresAt: _exp),
  StoryEntity(id: 's1', userId: 'u1', username: '@sara_live',  status: StoryStatus.live,         createdAt: _now, expiresAt: _exp, isLive: true),
  StoryEntity(id: 's2', userId: 'u2', username: '@ahmed_99',   status: StoryStatus.closeFriend,  createdAt: _now, expiresAt: _exp),
  StoryEntity(id: 's3', userId: 'u3', username: '@nora_m',     status: StoryStatus.unseen,       createdAt: _now, expiresAt: _exp),
  StoryEntity(id: 's4', userId: 'u4', username: '@khalid_x',   status: StoryStatus.unseen,       createdAt: _now, expiresAt: _exp),
  StoryEntity(id: 's5', userId: 'u5', username: '@layla_23',   status: StoryStatus.seen,         createdAt: _now, expiresAt: _exp),
];
