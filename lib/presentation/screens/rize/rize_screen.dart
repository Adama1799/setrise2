import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/rize_model.dart';
import 'widgets/rize_post_card.dart';

class RizeScreen extends StatefulWidget {
  const RizeScreen({super.key});

  @override
  State<RizeScreen> createState() => _RizeScreenState();
}

class _RizeScreenState extends State<RizeScreen> {
  final List<RizePostModel> _posts = RizePostModel.getMockPosts();

  void _updatePost(int index, RizePostModel updatedPost) {
    setState(() {
      _posts[index] = updatedPost;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Rize',
          style: AppTextStyles.h4.copyWith(color: AppColors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.white),
            onPressed: () {
              // TODO: Filters
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _posts.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return RizePostCard(
            post: _posts[index],
            onUpdate: (updatedPost) => _updatePost(index, updatedPost),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Create new post
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create post - Coming soon!')),
          );
        },
        backgroundColor: AppColors.electricBlue,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
