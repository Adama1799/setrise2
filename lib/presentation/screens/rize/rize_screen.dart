import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/rize_model.dart';

class RizeScreen extends StatefulWidget {
  const RizeScreen({super.key});

  @override
  State<RizeScreen> createState() => _RizeScreenState();
}

class _RizeScreenState extends State<RizeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final List<RizePostModel> _posts = RizePostModel.getMockPosts();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _updatePost(int index, RizePostModel updated) {
    setState(() => _posts[index] = updated);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // handled by MainScreen
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Top bar - Minimal Threads-like header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Row(
                  children: [                    Text(
                      'Rize',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.search_rounded,
                      color: AppColors.grey2,
                      size: 22,
                    ),
                  ],
                ),
              ),
              // Tabs — For You / Following - Clean underline
              TabBar(
                controller: _tabCtrl,
                indicatorColor: AppColors.white,
                indicatorWeight: 2,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.grey2,
                labelStyle: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w900,
                ),
                tabs: const [
                  Tab(text: 'For You'),
                  Tab(text: 'Following'),
                ],
              ),
              // Feed
              Expanded(
                child: TabBarView(
                  controller: _tabCtrl,
                  children: [
                    _RizeFeed(posts: _posts, onUpdate: _updatePost),
                    _RizeFeed(posts: _posts.reversed.toList(), onUpdate: (i, p) {}),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateSheet(context),
          backgroundColor: AppColors.electricBlue,
          child: const Icon(
            Icons.add_rounded,
            color: AppColors.white,          ),
        ),
      ),
    );
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D0D0D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _CreateRizeSheet(),
    );
  }
}

// ─── Rize Feed - Cleaner spacing like Threads ────────────────────────────────────────────────────────────────
class _RizeFeed extends StatelessWidget {
  final List<RizePostModel> posts;
  final Function(int, RizePostModel) onUpdate;

  const _RizeFeed({required this.posts, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16), // Softer separation
      itemBuilder: (_, i) => _RizeCard(
        post: posts[i],
        onUpdate: (p) => onUpdate(i, p),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => _RizeDetailScreen(post: posts[i]),
          ),
        ),
      ),
    );
  }
}

// ─── Rize Card (Threads style) — Cleaner layout ─────────────────────────────
class _RizeCard extends StatelessWidget {
  final RizePostModel post;
  final Function(RizePostModel) onUpdate;  final VoidCallback onTap;

  const _RizeCard({
    required this.post,
    required this.onUpdate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - Profile pic, name, handle, time
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.grey,
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.name,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${post.username} · ${Formatters.timeAgo(post.createdAt)}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.grey2,
                        ),
                      ),
                    ],
                  ),
                ),                const Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.grey2,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Title (Main text content)
            Text(
              post.title,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            // Body (Additional content)
            Text(
              post.body,
              style: AppTextStyles.body2.copyWith(
                color: Colors.white70,
                height: 1.45,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            // Media — Slightly smaller and less dominant
            if (post.hasMedia) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  // aspect ratio 650:1000 = 0.65
                  height: (MediaQuery.of(context).size.width - 32) / 0.65 * 0.8, // Reduced height
                  constraints: const BoxConstraints(maxHeight: 350),
                  color: AppColors.grey,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const Icon(
                        Icons.play_circle_outline_rounded,
                        color: Colors.white24,
                        size: 64,
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '0:24',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            // Action buttons row - Like, Comment, Repost, Bookmark
            Row(
              children: [
                _likeBtn(),
                const SizedBox(width: 16),
                _actionBtn(
                  Icons.chat_bubble_outline_rounded,
                  Formatters.formatCount(post.comments),
                  AppColors.grey2,
                  () {},
                ),
                const SizedBox(width: 16),
                _actionBtn(
                  Icons.repeat_rounded,
                  Formatters.formatCount(post.shares),
                  AppColors.grey2,
                  () {},
                ),
                const Spacer(),
                _actionBtn(
                  Icons.bookmark_border_rounded,
                  '',
                  AppColors.grey2,
                  () {},
                ),
              ],
            ),          ],
        ),
      ),
    );
  }

  Widget _likeBtn() {
    return GestureDetector(
      onTap: () => onUpdate(post.copyWith(
        isUpvoted: !post.isUpvoted,
        upvotes: post.isUpvoted ? post.upvotes - 1 : post.upvotes + 1,
      )),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: AppTextStyles.labelSmall.copyWith(
          color: post.isUpvoted ? AppColors.neonRed : AppColors.grey2,
          fontWeight: FontWeight.w600,
        ),
        child: Row(
          children: [
            Icon(
              post.isUpvoted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: post.isUpvoted ? AppColors.neonRed : AppColors.grey2,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              Formatters.formatCount(post.upvotes),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(
              label,              style: AppTextStyles.labelSmall.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Rize Detail (Minimalist Threads-like view) ────────────────────────────
class _RizeDetailScreen extends StatefulWidget {
  final RizePostModel post;

  const _RizeDetailScreen({required this.post});

  @override
  State<_RizeDetailScreen> createState() => _RizeDetailScreenState();
}

class _RizeDetailScreenState extends State<_RizeDetailScreen> {
  bool _isPlaying = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Media full bleed
          GestureDetector(
            onTap: () => setState(() => _isPlaying = !_isPlaying),
            child: Container(
              color: AppColors.grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isPlaying)
                    const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white54,
                      size: 80,
                    )
                  else
                    const Icon(
                      Icons.pause_rounded,
                      color: Colors.transparent,
                      size: 80,
                    ),                ],
              ),
            ),
          ),
          // Gradient overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.4,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.95),
                  ],
                ),
              ),
            ),
          ),
          // Top bar
          SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Bottom info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.grey,
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.post.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Follow',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.post.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.post.body,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Create Rize Sheet ────────────────────────────────────────────────────────
class _CreateRizeSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey,              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'New Rize',
            style: AppTextStyles.h5.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            style: AppTextStyles.body1.copyWith(color: AppColors.white),
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'What\'s on your mind?',
              hintStyle: AppTextStyles.body1.copyWith(color: AppColors.grey2),
              filled: true,
              fillColor: AppColors.grey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _mediaBtn(context, Icons.image_rounded, 'Photo'),
              const SizedBox(width: 8),
              _mediaBtn(context, Icons.videocam_rounded, 'Video'),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.electricBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Post',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _mediaBtn(BuildContext ctx, IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.grey2,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.grey2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
