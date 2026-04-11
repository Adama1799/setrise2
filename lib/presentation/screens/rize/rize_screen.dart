import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/rize_model.dart';
import 'rize_post_detail_screen.dart';
import 'widgets/rize_post_card.dart';

class RizeScreen extends StatefulWidget {
  const RizeScreen({super.key});

  @override
  State<RizeScreen> createState() => _RizeScreenState();
}

class _RizeScreenState extends State<RizeScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<RizePostModel> _posts;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _posts = RizePostModel.getMockPosts().asMap().entries.map((entry) {
      if (entry.key % 3 == 0) {
        return entry.value.copyWith(isFollowing: true);
      }
      return entry.value;
    }).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openPost(RizePostModel post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RizePostDetailScreen(post: post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final forYou = _posts;
    final following = _posts.where((p) => p.isFollowing).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'Rize',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w900),
          tabs: const [
            Tab(text: 'لك'),
            Tab(text: 'تتابعه'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _RizeFeed(
            posts: forYou,
            onTapPost: _openPost,
          ),
          _RizeFeed(
            posts: following.isEmpty ? forYou.take(6).toList() : following,
            onTapPost: _openPost,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.white,
        foregroundColor: Colors.black,
        onPressed: () {},
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _RizeFeed extends StatelessWidget {
  final List<RizePostModel> posts;
  final ValueChanged<RizePostModel> onTapPost;

  const _RizeFeed({
    required this.posts,
    required this.onTapPost,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final post = posts[index];
        return RizePostCard(
          post: post,
          onOpenDetails: () => onTapPost(post),
          onUpdate: (_) {},
        );
      },
    );
  }
}
