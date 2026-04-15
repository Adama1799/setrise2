// lib/presentation/screens/rize/rize_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/rize_model.dart';

// Mock comment model
class RizeCommentModel {
  final String id;
  final String username;
  final String name;
  final String text;
  int likes;
  bool isLiked;
  final DateTime createdAt;

  RizeCommentModel({
    required this.id,
    required this.username,
    required this.name,
    required this.text,
    required this.likes,
    required this.isLiked,
    required this.createdAt,
  });

  static List<RizeCommentModel> getMockComments() {
    return [
      RizeCommentModel(
        id: '1',
        username: '@ahmed_codes',
        name: 'Ahmed',
        text: 'This is exactly what I was looking for! Great breakdown.',
        likes: 24,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      RizeCommentModel(
        id: '2',
        username: '@flutter_dev',
        name: 'Flutter Dev',
        text: 'Thanks for sharing this insight. Very helpful for beginners.',
        likes: 12,
        isLiked: true,
        createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      RizeCommentModel(
        id: '3',
        username: '@ui_designer',
        name: 'Sarah',
        text: 'The design patterns you mentioned are spot on.',
        likes: 8,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      RizeCommentModel(
        id: '4',
        username: '@meta_fan',
        name: 'Khalid',
        text: 'Feels like Threads indeed! Love the clean UI.',
        likes: 15,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      RizeCommentModel(
        id: '5',
        username: '@mobile_guru',
        name: 'Fatima',
        text: 'Smooth animations make such a difference. Great work!',
        likes: 31,
        isLiked: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      RizeCommentModel(
        id: '6',
        username: '@dart_lover',
        name: 'Omar',
        text: 'The state management here is clean and efficient.',
        likes: 7,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      RizeCommentModel(
        id: '7',
        username: '@social_app',
        name: 'Layla',
        text: 'This could easily become my go-to social app.',
        likes: 19,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      RizeCommentModel(
        id: '8',
        username: '@threads_clone',
        name: 'Ali',
        text: 'Perfect clone! The attention to detail is impressive.',
        likes: 42,
        isLiked: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ];
  }
}

class RizeScreen extends StatefulWidget {
  const RizeScreen({super.key});

  @override
  State<RizeScreen> createState() => _RizeScreenState();
}

class _RizeScreenState extends State<RizeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final List<RizePostModel> _posts = RizePostModel.getMockPosts();
  final _scrollCtrl = ScrollController();
  final ValueNotifier<bool> _fabVisible = ValueNotifier<bool>(true);
  double _lastScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollCtrl.offset;
    if (offset > _lastScrollOffset && offset > 50) {
      // Scrolling down
      _fabVisible.value = false;
    } else {
      // Scrolling up
      _fabVisible.value = true;
    }
    _lastScrollOffset = offset;
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _scrollCtrl.dispose();
    _fabVisible.dispose();
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
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Row(
                  children: [
                    Text(
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
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.grey2,
                      size: 22,
                    ),
                  ],
                ),
              ),
              // Tabs
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
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: _fabVisible,
          builder: (context, visible, _) => AnimatedOpacity(
            opacity: visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: AnimatedScale(
              scale: visible ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 200),
              child: FloatingActionButton.extended(
                onPressed: () => _showCreateSheet(context),
                backgroundColor: AppColors.electricBlue,
                icon: const Icon(
                  Icons.add_rounded,
                  color: AppColors.white,
                ),
                label: Text(
                  'Rize',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
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
      builder: (_) => const _CreateRizeSheet(),
    );
  }
}

// ─── Rize Feed ────────────────────────────────────────────────────────────────
class _RizeFeed extends StatefulWidget {
  final List<RizePostModel> posts;
  final Function(int, RizePostModel) onUpdate;

  const _RizeFeed({required this.posts, required this.onUpdate});

  @override
  State<_RizeFeed> createState() => _RizeFeedState();
}

class _RizeFeedState extends State<_RizeFeed> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  late List<RizePostModel> _localPosts;

  @override
  void initState() {
    super.initState();
    _localPosts = List.from(widget.posts);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMore() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    final newPosts = RizePostModel.getMockPosts()
        .map((e) => e.copyWith(id: '${DateTime.now().millisecondsSinceEpoch}${e.id}'))
        .toList();
    setState(() {
      _localPosts.addAll(newPosts);
      _isLoading = false;
    });
  }

  void _updateLocalPost(int index, RizePostModel updated) {
    setState(() => _localPosts[index] = updated);
    widget.onUpdate(index, updated);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _localPosts = List.from(widget.posts);
        });
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 500 &&
              !_isLoading) {
            _loadMore();
          }
          return false;
        },
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _localPosts.length + (_isLoading ? 1 : 0),
          separatorBuilder: (_, __) => Divider(
            color: AppColors.grey.withOpacity(0.15),
            height: 1,
          ),
          itemBuilder: (ctx, i) {
            if (i >= _localPosts.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return _RizeCard(
              post: _localPosts[i],
              onUpdate: (p) => _updateLocalPost(i, p),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _RizeDetailScreen(
                    post: _localPosts[i],
                    onUpdate: (updated) => _updateLocalPost(i, updated),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Rize Card (Threads style) ─────────────────────────────
class _RizeCard extends StatefulWidget {
  final RizePostModel post;
  final Function(RizePostModel) onUpdate;
  final VoidCallback onTap;

  const _RizeCard({
    required this.post,
    required this.onUpdate,
    required this.onTap,
  });

  @override
  State<_RizeCard> createState() => _RizeCardState();
}

class _RizeCardState extends State<_RizeCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
                        widget.post.name,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.post.username} · ${Formatters.timeAgo(widget.post.createdAt)}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.grey2,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showPostMenu(context),
                  child: const Icon(
                    Icons.more_horiz_rounded,
                    color: AppColors.grey2,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              widget.post.title,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            // Body
            Text(
              widget.post.body,
              style: AppTextStyles.body2.copyWith(
                color: Colors.white70,
                height: 1.45,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            // Media
            if (widget.post.hasMedia) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: (MediaQuery.of(context).size.width - 32) * 0.8,
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
                        child: Container(
                          padding: const EdgeInsets.symmetric(
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
            // Actions
            Row(
              children: [
                _likeBtn(),
                const SizedBox(width: 16),
                _actionBtn(
                  Icons.chat_bubble_outline_rounded,
                  Formatters.formatCount(widget.post.comments),
                  AppColors.grey2,
                  () => _showCommentsSheet(context),
                ),
                const SizedBox(width: 16),
                _actionBtn(
                  Icons.repeat_rounded,
                  Formatters.formatCount(widget.post.shares),
                  AppColors.grey2,
                  () => _showRepostSheet(context),
                ),
                const Spacer(),
                _actionBtn(
                  widget.post.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  '',
                  widget.post.isBookmarked ? AppColors.white : AppColors.grey2,
                  () => widget.onUpdate(widget.post.copyWith(
                    isBookmarked: !widget.post.isBookmarked,
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _likeBtn() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) => _animationController.reverse(),
          onTapCancel: () => _animationController.reverse(),
          onTap: () {
            widget.onUpdate(widget.post.copyWith(
              isUpvoted: !widget.post.isUpvoted,
              upvotes: widget.post.isUpvoted ? widget.post.upvotes - 1 : widget.post.upvotes + 1,
            ));
          },
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.labelSmall.copyWith(
                color: widget.post.isUpvoted ? AppColors.neonRed : AppColors.grey2,
                fontWeight: FontWeight.w600,
              ),
              child: Row(
                children: [
                  Icon(
                    widget.post.isUpvoted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: widget.post.isUpvoted ? AppColors.neonRed : AppColors.grey2,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      Formatters.formatCount(widget.post.upvotes),
                      key: ValueKey<int>(widget.post.upvotes),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
              label,
              style: AppTextStyles.labelSmall.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }

  void _showPostMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D0D0D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _menuOption(Icons.volume_off_rounded, 'Mute @${widget.post.username}', () {}),
            _menuOption(Icons.block_rounded, 'Block @${widget.post.username}', () {}),
            _menuOption(Icons.flag_rounded, 'Report', () {}),
            _menuOption(Icons.link_rounded, 'Copy link', () {}),
            _menuOption(Icons.do_not_disturb_on_rounded, 'Not interested in this', () {}),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _menuOption(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grey2),
      title: Text(
        label,
        style: AppTextStyles.body2.copyWith(color: AppColors.white),
      ),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label)));
      },
    );
  }

  void _showRepostSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D0D0D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _repostOption(Icons.repeat_rounded, 'Repost', () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reposted!')));
            }),
            _repostOption(Icons.edit_note_rounded, 'Quote Rize', () {
              Navigator.pop(context);
              _showCreateSheetWithQuote(context);
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _repostOption(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grey2),
      title: Text(
        label,
        style: AppTextStyles.body2.copyWith(color: AppColors.white),
      ),
      onTap: onTap,
    );
  }

  void _showCreateSheetWithQuote(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D0D0D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _CreateRizeSheet(quotedPost: widget.post),
    );
  }

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D0D0D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (context, scrollController) {
          return _CommentsSheet(
            post: widget.post,
            scrollController: scrollController,
            onCommentAdded: (comment) {
              widget.onUpdate(widget.post.copyWith(
                comments: widget.post.comments + 1,
              ));
            },
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 🔹 نهاية الجزء الأول 🔹
// ═══════════════════════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════════════════════
// 🔹 بداية الجزء الثاني 🔹
// ═══════════════════════════════════════════════════════════════════════════════

// ─── Comments Sheet ────────────────────────────────────────────────────────
class _CommentsSheet extends StatefulWidget {
  final RizePostModel post;
  final ScrollController scrollController;
  final Function(RizeCommentModel)? onCommentAdded;

  const _CommentsSheet({
    required this.post,
    required this.scrollController,
    this.onCommentAdded,
  });

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<RizeCommentModel> _comments = [];

  @override
  void initState() {
    super.initState();
    _comments = RizeCommentModel.getMockComments();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendComment() {
    if (_textController.text.trim().isEmpty) return;
    final newComment = RizeCommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: '@you',
      name: 'You',
      text: _textController.text.trim(),
      likes: 0,
      isLiked: false,
      createdAt: DateTime.now(),
    );
    setState(() {
      _comments.insert(0, newComment);
      _textController.clear();
    });
    if (widget.onCommentAdded != null) {
      widget.onCommentAdded!(newComment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Replies',
                  style: AppTextStyles.h5.copyWith(color: AppColors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${_comments.length})',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.grey2,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.grey),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.grey,
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.white,
                          size: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment.username,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '· ${Formatters.timeAgo(comment.createdAt)}',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.grey2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              comment.text,
                              style: AppTextStyles.body2.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      comment.isLiked = !comment.isLiked;
                                      comment.likes += comment.isLiked ? 1 : -1;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        comment.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                        color: comment.isLiked ? AppColors.neonRed : AppColors.grey2,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        Formatters.formatCount(comment.likes),
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: AppColors.grey2,
                                        ),
                                      ),
                                    ],
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF0D0D0D),
              border: Border(
                top: BorderSide(color: AppColors.grey, width: 0.5),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: AppColors.grey,
                    child: const Icon(
                      Icons.person_rounded,
                      color: AppColors.white,
                      size: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Reply to @${widget.post.username}...',
                          hintStyle: AppTextStyles.body2.copyWith(
                            color: AppColors.grey2,
                          ),
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _textController.text.trim().isNotEmpty ? _sendComment : null,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _textController.text.trim().isNotEmpty
                            ? AppColors.electricBlue
                            : AppColors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Rize Detail Screen ────────────────────────────────────────────
class _RizeDetailScreen extends StatefulWidget {
  final RizePostModel post;
  final Function(RizePostModel) onUpdate;

  const _RizeDetailScreen({
    required this.post,
    required this.onUpdate,
  });

  @override
  State<_RizeDetailScreen> createState() => _RizeDetailScreenState();
}

class _RizeDetailScreenState extends State<_RizeDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  bool _isPlaying = false;
  late RizePostModel _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _progressController = AnimationController(
      duration: const Duration(seconds: 24),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_progressController);
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _updatePost(RizePostModel updated) {
    setState(() => _post = updated);
    widget.onUpdate(updated);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
            pinned: true,
            expandedHeight: size.height * 0.4,
            flexibleSpace: FlexibleSpaceBar(
              background: _post.hasMedia
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          color: AppColors.grey,
                          child: const Center(
                            child: Icon(
                              Icons.play_circle_outline_rounded,
                              color: Colors.white24,
                              size: 64,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '0:24',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) => LinearProgressIndicator(
                              value: _progressAnimation.value,
                              backgroundColor: Colors.transparent,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(color: Colors.black),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                        _post.name,
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
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _post.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _post.body,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Action row
                  Row(
                    children: [
                      _likeBtn(),
                      const SizedBox(width: 16),
                      _actionBtn(
                        Icons.chat_bubble_outline_rounded,
                        Formatters.formatCount(_post.comments),
                        AppColors.grey2,
                        () => _showCommentsSheet(context),
                      ),
                      const SizedBox(width: 16),
                      _actionBtn(
                        Icons.repeat_rounded,
                        Formatters.formatCount(_post.shares),
                        AppColors.grey2,
                        () => _showRepostSheet(context),
                      ),
                      const Spacer(),
                      _actionBtn(
                        _post.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        '',
                        _post.isBookmarked ? AppColors.white : AppColors.grey2,
                        () => _updatePost(_post.copyWith(
                          isBookmarked: !_post.isBookmarked,
                        )),
                      ),
                    ],
                  ),
                  const Divider(height: 16, color: AppColors.grey),
                  // Comments section
                  Text(
                    '${Formatters.formatCount(_post.comments)} replies',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.grey2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Comments list
                  ...RizeCommentModel.getMockComments().take(5).map(
                    (comment) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: AppColors.grey,
                            child: const Icon(
                              Icons.person_rounded,
                              color: AppColors.white,
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      comment.username,
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '· ${Formatters.timeAgo(comment.createdAt)}',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.grey2,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  comment.text,
                                  style: AppTextStyles.body2.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          comment.isLiked = !comment.isLiked;
                                          comment.likes += comment.isLiked ? 1 : -1;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            comment.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                            color: comment.isLiked ? AppColors.neonRed : AppColors.grey2,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            Formatters.formatCount(comment.likes),
                                            style: AppTextStyles.labelSmall.copyWith(
                                              color: AppColors.grey2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(
            top: BorderSide(color: AppColors.grey, width: 0.5),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.grey,
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.white,
                  size: 15,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Reply to @${_post.username}...',
                      hintStyle: AppTextStyles.body2.copyWith(
                        color: AppColors.grey2,
                      ),
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.electricBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _likeBtn() {
    return GestureDetector(
      onTap: () => _updatePost(_post.copyWith(
        isUpvoted: !_post.isUpvoted,
        upvotes: _post.isUpvoted ? _post.upvotes - 1 : _post.upvotes + 1,
      )),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: AppTextStyles.labelSmall.copyWith(
          color: _post.isUpvoted ? AppColors.neonRed : AppColors.grey2,
          fontWeight: FontWeight.w600,
        ),
        child: Row(
          children: [
            Icon(
              _post.isUpvoted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _post.isUpvoted ? AppColors.neonRed : AppColors.grey2,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              Formatters.formatCount(_post.upvotes),
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
              label,
              style: AppTextStyles.labelSmall.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D0D0D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (context, scrollController) {
          return _CommentsSheet(
            post: _post,
            scrollController: scrollController,
            onCommentAdded: (comment) {
              _updatePost(_post.copyWith(comments: _post.comments + 1));
            },
          );
        },
      ),
    );
  }

  void _showRepostSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D0D0D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _repostOption(Icons.repeat_rounded, 'Repost', () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reposted!')));
            }),
            _repostOption(Icons.edit_note_rounded, 'Quote Rize', () {
              Navigator.pop(context);
              _showCreateSheetWithQuote(context);
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _repostOption(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grey2),
      title: Text(
        label,
        style: AppTextStyles.body2.copyWith(color: AppColors.white),
      ),
      onTap: onTap,
    );
  }

  void _showCreateSheetWithQuote(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D0D0D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _CreateRizeSheet(quotedPost: _post),
    );
  }
}

// ─── Create Rize Sheet ────────────────────────────────────────────────────────
class _CreateRizeSheet extends StatefulWidget {
  final RizePostModel? quotedPost;

  const _CreateRizeSheet({this.quotedPost});

  @override
  State<_CreateRizeSheet> createState() => _CreateRizeSheetState();
}

class _CreateRizeSheetState extends State<_CreateRizeSheet> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasPoll = false;
  final TextEditingController _pollOption1Ctrl = TextEditingController();
  final TextEditingController _pollOption2Ctrl = TextEditingController();
  final List<TextEditingController> _extraOptionsCtrls = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _pollOption1Ctrl.dispose();
    _pollOption2Ctrl.dispose();
    for (var ctrl in _extraOptionsCtrls) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _addPollOption() {
    _extraOptionsCtrls.add(TextEditingController());
    setState(() {});
  }

  void _submitRize() {
    if (_textController.text.trim().isEmpty) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rize posted!')));
  }

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
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.grey,
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  style: AppTextStyles.body1.copyWith(color: AppColors.white),
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'What\'s on your mind?',
                    hintStyle: AppTextStyles.body1.copyWith(color: AppColors.grey2),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          if (widget.quotedPost != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.quotedPost!.name,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.quotedPost!.title,
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_hasPoll) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _pollOption1Ctrl,
              style: AppTextStyles.body1.copyWith(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Choice 1',
                hintStyle: AppTextStyles.body1.copyWith(color: AppColors.grey2),
                filled: true,
                fillColor: AppColors.grey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _pollOption2Ctrl,
              style: AppTextStyles.body1.copyWith(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Choice 2',
                hintStyle: AppTextStyles.body1.copyWith(color: AppColors.grey2),
                filled: true,
                fillColor: AppColors.grey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            ..._extraOptionsCtrls.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(
                  controller: controller,
                  style: AppTextStyles.body1.copyWith(color: AppColors.white),
                  decoration: InputDecoration(
                    hintText: 'Choice ${index + 3}',
                    hintStyle: AppTextStyles.body1.copyWith(color: AppColors.grey2),
                    filled: true,
                    fillColor: AppColors.grey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _addPollOption,
                child: Text(
                  '+ Add option',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.grey2,
                  ),
                ),
              ),
            ),
          ],
          const Divider(height: 1, color: AppColors.grey),
          Row(
            children: [
              _mediaBtn(Icons.image_rounded, 'Photo', () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coming soon')))),
              const SizedBox(width: 8),
              _mediaBtn(Icons.videocam_rounded, 'Video', () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coming soon')))),
              const SizedBox(width: 8),
              _mediaBtn(Icons.poll_rounded, 'Poll', () {
                setState(() {
                  _hasPoll = !_hasPoll;
                });
              }),
              const SizedBox(width: 8),
              _mediaBtn(Icons.link_rounded, 'Link', () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coming soon')))),
              const Spacer(),
              if (_textController.text.length > 400)
                Text(
                  '${_textController.text.length}/500',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _textController.text.length > 500 ? Colors.red : AppColors.grey2,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: _textController.text.trim().isNotEmpty ? _submitRize : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _textController.text.trim().isNotEmpty ? AppColors.electricBlue : AppColors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Post',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: _textController.text.trim().isNotEmpty ? AppColors.white : AppColors.grey2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _mediaBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
