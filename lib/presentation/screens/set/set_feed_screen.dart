import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/posts_provider.dart';
import '../../widgets/post/post_card.dart';
import '../../../data/models/story_model.dart';
import 'widgets/top_bar.dart';
import 'widgets/stories_bar.dart';

class SetFeedScreen extends ConsumerStatefulWidget {
  const SetFeedScreen({super.key});

  @override
  ConsumerState<SetFeedScreen> createState() => _SetFeedScreenState();
}

class _SetFeedScreenState extends ConsumerState<SetFeedScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postsProvider.notifier).loadPosts();
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(postsProvider.notifier).loadMorePosts();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(postsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const TopBar(),
            StoriesBar(
              stories: const <StoryModel>[],
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(postsProvider.notifier).loadPosts();
                },
                child: postsState.isLoading && postsState.posts.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 220),
                          Center(child: CircularProgressIndicator()),
                        ],
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: postsState.posts.length + 1,
                        itemBuilder: (context, index) {
                          if (index == postsState.posts.length) {
                            return postsState.hasMorePosts
                                ? const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          }

                          final post = postsState.posts[index];

                          return PostCard(
                            post: post,
                            onLike: () {
                              ref
                                  .read(postsProvider.notifier)
                                  .toggleLike(post.id);
                            },
                            onComment: () {},
                            onShare: () {},
                            onSave: () {
                              ref
                                  .read(postsProvider.notifier)
                                  .toggleSave(post.id);
                            },
                            onFollow: () {},
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
