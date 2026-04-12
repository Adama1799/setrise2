// lib/presentation/screens/set/set_feed_screen.dart (Updated)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../presentation/utils/responsive_builder.dart';
import '../../../presentation/utils/universal_platform.dart';
import '../../providers/posts_provider.dart';
import '../../widgets/post/post_card.dart';
import '../../widgets/post/create_post_bottom_sheet.dart';

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
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postsProvider.notifier).loadPosts();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(postsProvider.notifier).loadMorePosts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(postsProvider);
    final isWeb = UniversalPlatform.isWeb;
    final isMobile = ResponsiveBuilder.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0.5,
        surfaceTintColor: Colors.transparent,
        title: Text('Set', style: AppTypography.h2),
        centerTitle: !isWeb,
        actions: isWeb ? null : [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => ref.read(postsProvider.notifier).loadSavedPosts(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar for Web
          if (isWeb && !isMobile)
            Container(
              width: 250,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: AppColors.border),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Set', style: AppTypography.h2),
                      const SizedBox(height: 24),
                      _buildSidebarButton(Icons.home, 'Home'),
                      _buildSidebarButton(Icons.explore, 'Explore'),
                      _buildSidebarButton(Icons.bookmark, 'Saved'),
                      _buildSidebarButton(Icons.person, 'Profile'),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => CreatePostBottomSheet(
                                onPost: (content, mediaUrls) {
                                  ref.read(postsProvider.notifier).createPost(content, mediaUrls);
                                },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: const Text(
                            'Create Post',
                            style: TextStyle(color: AppColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Main Feed
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveBuilder.getMaxWidth(context),
                ),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(postsProvider.notifier).loadPosts();
                  },
                  child: postsState.isLoading && postsState.posts.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: postsState.posts.length + 1,
                          itemBuilder: (context, index) {
                            if (index == postsState.posts.length) {
                              return postsState.hasMorePosts
                                  ? const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CircularProgressIndicator(),
                                    )
                                  : const SizedBox.shrink();
                            }

                            final post = postsState.posts[index];
                            return PostCard(
                              post: post,
                              onLike: () {
                                ref.read(postsProvider.notifier).toggleLike(post.id);
                              },
                              onComment: () {},
                              onShare: () {},
                              onSave: () {
                                ref.read(postsProvider.notifier).toggleSave(post.id);
                              },
                              onFollow: () {},
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
          // Right Sidebar for Web
          if (isWeb && !isMobile)
            Container(
              width: 300,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppColors.border),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Box
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search Set',
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.search),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Trending Section
                      Text('Trending', style: AppTypography.h3),
                      const SizedBox(height: 12),
                      ...[1, 2, 3, 4, 5].map((i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '#trending$i',
                                style: AppTypography.labelLarge,
                              ),
                              Text(
                                '${i * 100}K posts',
                                style: AppTypography.caption,
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => CreatePostBottomSheet(
                    onPost: (content, mediaUrls) {
                      ref.read(postsProvider.notifier).createPost(content, mediaUrls);
                    },
                  ),
                );
              },
              child: const Icon(Icons.add, color: AppColors.background),
            )
          : null,
    );
  }

  Widget _buildSidebarButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textPrimary),
          const SizedBox(width: 12),
          Text(label, style: AppTypography.labelLarge),
        ],
      ),
    );
  }
}
