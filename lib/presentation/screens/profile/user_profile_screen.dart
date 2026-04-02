// lib/presentation/screens/profile/user_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/users_provider.dart';
import '../../providers/posts_provider.dart';
import '../../widgets/post/post_card.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const UserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(usersProvider.notifier).getUser(widget.userId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(usersProvider);
    final user = usersState.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  // Cover Image
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      image: user.coverImage.isNotEmpty
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(user.coverImage),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                  // Avatar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Transform.translate(
                      offset: const Offset(0, -30),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.surface,
                        backgroundImage:
                            CachedNetworkImageProvider(user.avatar),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // User Info
                  Text(user.name, style: AppTypography.h3),
                  Text(user.username, style: AppTypography.caption),
                  const SizedBox(height: 8),
                  Text(
                    user.bio,
                    style: AppTypography.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Follow Button
                  ElevatedButton(
                    onPressed: () {
                      ref.read(usersProvider.notifier).toggleFollow(user.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: user.isFollowing
                          ? AppColors.surface
                          : AppColors.textPrimary,
                    ),
                    child: Text(
                      user.isFollowing ? 'Following' : 'Follow',
                      style: TextStyle(
                        color: user.isFollowing
                            ? AppColors.textPrimary
                            : AppColors.background,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: Column(
          children: [
            // Stats
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn(
                    Formatters.formatNumber(user.followers),
                    'Followers',
                  ),
                  _buildStatColumn(
                    Formatters.formatNumber(user.following),
                    'Following',
                  ),
                  _buildStatColumn(
                    Formatters.formatNumber(user.postsCount),
                    'Posts',
                  ),
                ],
              ),
            ),
            // Tabs
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Posts'),
                Tab(text: 'Replies'),
              ],
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textTertiary,
              indicatorColor: AppColors.textPrimary,
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Posts Tab
                  ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return PostCard(
                        post: null,
                        onLike: () {},
                        onComment: () {},
                        onShare: () {},
                        onSave: () {},
                        onFollow: () {},
                      );
                    },
                  ),
                  // Replies Tab
                  Center(
                    child: Text(
                      'No replies yet',
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(count, style: AppTypography.labelLarge),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}
