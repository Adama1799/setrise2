// lib/presentation/screens/rize/rize_feed_screen.dart (Updated)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../presentation/utils/responsive_builder.dart';
import '../../../presentation/utils/universal_platform.dart';
import '../../providers/threads_provider.dart';
import '../../widgets/rize/thread_card_vertical.dart';
import '../../widgets/rize/create_thread_sheet.dart';

class RizeFeedScreen extends ConsumerStatefulWidget {
  const RizeFeedScreen({super.key});

  @override
  ConsumerState<RizeFeedScreen> createState() => _RizeFeedScreenState();
}

class _RizeFeedScreenState extends ConsumerState<RizeFeedScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(threadsProvider.notifier).loadThreads();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final threadsState = ref.watch(threadsProvider);
    final isWeb = UniversalPlatform.isWeb;
    final isMobile = ResponsiveBuilder.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Rize', style: AppTypography.h2),
        centerTitle: true,
      ),
      body: threadsState.isLoading && threadsState.threads.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : isWeb && !isMobile
              ? // Web Layout - Grid
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: threadsState.threads.length,
                        itemBuilder: (context, index) {
                          final thread = threadsState.threads[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (thread.mediaUrl != null)
                                  Image.network(
                                    thread.mediaUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        AppColors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  right: 12,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        thread.content,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: AppColors.white,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 14,
                                            backgroundImage:
                                                NetworkImage(thread.authorAvatar),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              thread.authorName,
                                              style: AppTypography.caption
                                                  .copyWith(
                                                color: AppColors.white,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              : // Mobile Layout - PageView
              PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: threadsState.threads.length,
                  itemBuilder: (context, index) {
                    final thread = threadsState.threads[index];
                    return ThreadCardVertical(
                      thread: thread,
                      onLike: () {
                        ref.read(threadsProvider.notifier).toggleLike(thread.id);
                      },
                      onReply: () {},
                      onRepost: () {
                        ref.read(threadsProvider.notifier).toggleRepost(thread.id);
                      },
                      onShare: () {},
                      onAuthorTap: () {},
                    );
                  },
                ),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => CreateThreadSheet(
                    onPost: (content, mediaUrl) {
                      ref.read(threadsProvider.notifier).createThread(content);
                    },
                  ),
                );
              },
              child: const Icon(Icons.add, color: AppColors.background),
            )
          : null,
    );
  }
}
