import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/story_model.dart';
import 'widgets/top_bar.dart';
import 'widgets/stories_bar.dart';
import 'widgets/post_card.dart';

class SetScreen extends StatefulWidget {
  const SetScreen({super.key});

  @override
  State<SetScreen> createState() => _SetScreenState();
}

class _SetScreenState extends State<SetScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<PostModel> _posts = PostModel.getMockPosts();
  final List<StoryModel> _stories = StoryModel.getMockStories();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updatePost(int index, PostModel updatedPost) {
    setState(() {
      _posts[index] = updatedPost;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main Feed
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _posts.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return PostCard(
                post: _posts[index],
                onUpdate: (updatedPost) => _updatePost(index, updatedPost),
                onSwipeNext: () {
                  if (_currentPage < _posts.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                    );
                  }
                },
              );
            },
          ),

          // Top Bar with Stories
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TopBar(),
                const SizedBox(height: 12),
                StoriesBar(stories: _stories),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
