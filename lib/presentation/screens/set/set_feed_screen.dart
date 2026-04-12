// lib/presentation/screens/set/set_feed_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/posts_provider.dart';
import '../../widgets/post/post_card.dart';

class SetFeedScreen extends ConsumerStatefulWidget {
  const SetFeedScreen({super.key});

  @override
  ConsumerState<SetFeedScreen> createState() => _SetFeedScreenState();
}

class _SetFeedScreenState extends ConsumerState<SetFeedScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postsProvider.notifier).loadPosts();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(postsProvider.notifier).loadMorePosts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(postsProvider.notifier).loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(postsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: postsState.isLoading && postsState.posts.isEmpty
            ? const Center(child: CircularProgressIndicator())

            : ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: postsState.posts.length + 1,
                itemBuilder: (context, index) {
                  // Loading more indicator
                  if (index == postsState.posts.length) {
                    return postsState.hasMorePosts
                        ? const Padding(
                            padding: EdgeInsets.all(20),
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
    );
  }
}
