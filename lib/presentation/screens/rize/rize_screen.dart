// lib/presentation/screens/rize/rize_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/rize_model.dart';
import 'widgets/media_fullscreen.dart';

// ─── نموذج التعليق (محسّن) ─────────────────────────────────────────────────
class RizeCommentModel {
  final String id;
  final String userId;
  final String username;
  final String name;
  final String text;
  int likes;
  bool isLiked;
  final DateTime createdAt;
  final List<RizeCommentModel> replies; // دعم الردود المتداخلة

  RizeCommentModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.name,
    required this.text,
    required this.likes,
    required this.isLiked,
    required this.createdAt,
    this.replies = const [],
  });

  RizeCommentModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? name,
    String? text,
    int? likes,
    bool? isLiked,
    DateTime? createdAt,
    List<RizeCommentModel>? replies,
  }) {
    return RizeCommentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      name: name ?? this.name,
      text: text ?? this.text,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      replies: replies ?? this.replies,
    );
  }

  static List<RizeCommentModel> getMockComments() {
    return [
      RizeCommentModel(
        id: '1',
        userId: 'user1',
        username: '@ahmed_codes',
        name: 'Ahmed',
        text: 'This is exactly what I was looking for! Great breakdown.',
        likes: 24,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        replies: [
          RizeCommentModel(
            id: '1-1',
            userId: 'user2',
            username: '@flutter_dev',
            name: 'Flutter Dev',
            text: 'Totally agree! The new features are 🔥',
            likes: 8,
            isLiked: true,
            createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
          ),
        ],
      ),
      RizeCommentModel(
        id: '2',
        userId: 'user2',
        username: '@flutter_dev',
        name: 'Flutter Dev',
        text: 'Thanks for sharing this insight. Very helpful for beginners.',
        likes: 12,
        isLiked: true,
        createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      RizeCommentModel(
        id: '3',
        userId: 'user3',
        username: '@ui_designer',
        name: 'Sarah',
        text: 'The design patterns you mentioned are spot on.',
        likes: 8,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        replies: [
          RizeCommentModel(
            id: '3-1',
            userId: 'user1',
            username: '@ahmed_codes',
            name: 'Ahmed',
            text: 'Glad you liked it!',
            likes: 2,
            isLiked: false,
            createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
        ],
      ),
      RizeCommentModel(
        id: '4',
        userId: 'user4',
        username: '@meta_fan',
        name: 'Khalid',
        text: 'Feels like Threads indeed! Love the clean UI.',
        likes: 15,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }
}

// ─── RizeScreen الرئيسية ────────────────────────────────────────────────────
class RizeScreen extends StatefulWidget {
  const RizeScreen({super.key});

  @override
  State<RizeScreen> createState() => _RizeScreenState();
}

class _RizeScreenState extends State<RizeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final List<RizePostModel> _posts = RizePostModel.getMockPosts();
  final ScrollController _scrollCtrl = ScrollController();
  final ValueNotifier<bool> _showTopBar = ValueNotifier<bool>(true);
  double _lastScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollCtrl.offset;
    // إخفاء الشريط العلوي عند التمرير للأسفل بمسافة كافية
    if (offset > _lastScrollOffset && offset > 80) {
      _showTopBar.value = false;
    } else {
      _showTopBar.value = true;
    }
    _lastScrollOffset = offset;
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _scrollCtrl.dispose();
    _showTopBar.dispose();
    super.dispose();
  }

  void _updatePost(int index, RizePostModel updated) {
    setState(() => _posts[index] = updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
              // شريط علوي متحرك
              ValueListenableBuilder<bool>(
                valueListenable: _showTopBar,
                builder: (context, visible, _) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: visible ? 56 : 0,
                  child: visible
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.notifications_none_rounded,
                                color: AppColors.grey2,
                                size: 24,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              // تبويبات For You / Following
              TabBar(
                controller: _tabCtrl,
                indicatorColor: Colors.white,
                indicatorWeight: 2,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white38,
                labelStyle: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                tabs: const [
                  Tab(text: 'For You'),
                  Tab(text: 'Following'),
                ],
              ),
              // المحتوى الرئيسي
              Expanded(
                child: TabBarView(
                  controller: _tabCtrl,
                  children: [
                    _RizeFeed(
                      posts: _posts,
                      onUpdate: _updatePost,
                      scrollController: _scrollCtrl,
                    ),
                    _RizeFeed(
                      posts: _posts.reversed.toList(),
                      onUpdate: (i, p) {},
                      scrollController: ScrollController(),
                    ),
                  ],
                ),
              ),
      ],
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

// ─── RizeFeed (قائمة المنشورات) ─────────────────────────────────────────────
class _RizeFeed extends StatefulWidget {
  final List<RizePostModel> posts;
  final Function(int, RizePostModel) onUpdate;
  final ScrollController scrollController;

  const _RizeFeed({
    required this.posts,
    required this.onUpdate,
    required this.scrollController,
  });

  @override
  State<_RizeFeed> createState() => _RizeFeedState();
}

class _RizeFeedState extends State<_RizeFeed> {
  bool _isLoading = false;
  late List<RizePostModel> _localPosts;

  @override
  void initState() {
    super.initState();
    _localPosts = List.from(widget.posts);
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
        setState(() => _localPosts = List.from(widget.posts));
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
          controller: widget.scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _localPosts.length + (_isLoading ? 1 : 0),
          separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
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
            );
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 🔹 نهاية الجزء الأول (تابع الجزء الثاني) 🔹
// ═══════════════════════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════════════════════
// 🔹 بداية الجزء الثاني 🔹
// ═══════════════════════════════════════════════════════════════════════════════

// ─── RizeCard (بطاقة المنشور) ────────────────────────────────────────────────
class _RizeCard extends StatefulWidget {
  final RizePostModel post;
  final Function(RizePostModel) onUpdate;

  const _RizeCard({
    required this.post,
    required this.onUpdate,
  });

  @override
  State<_RizeCard> createState() => _RizeCardState();
}

class _RizeCardState extends State<_RizeCard> with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimCtrl;
  late Animation<double> _likeScaleAnim;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _likeAnimCtrl = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _likeScaleAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _likeAnimCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _likeAnimCtrl.dispose();
    super.dispose();
  }

  void _openMediaFullScreen(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MediaFullScreen(
          mediaUrls: widget.post.mediaUrls,
          initialIndex: initialIndex,
          heroTag: 'media_${widget.post.id}_$initialIndex',
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/profile/${widget.post.userId}',
      arguments: {'username': widget.post.username},
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس البطاقة
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _navigateToProfile(context),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: post.userAvatar.isNotEmpty
                      ? NetworkImage(post.userAvatar)
                      : null,
                  child: post.userAvatar.isEmpty
                      ? const Icon(Icons.person_rounded, color: AppColors.grey2, size: 24)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _navigateToProfile(context),
                          child: Text(
                            post.name,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          post.username,
                          style: const TextStyle(
                            color: AppColors.grey2,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        if (!post.isFollowing)
                          GestureDetector(
                            onTap: () => widget.onUpdate(post.copyWith(isFollowing: true)),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'Follow',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        GestureDetector(
                          onTap: () => _showPostMenu(context),
                          child: const Icon(Icons.more_horiz_rounded, color: Colors.black38, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${Formatters.timeAgo(post.createdAt)} · ${post.views} views',
                      style: const TextStyle(color: Colors.black38, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // عنوان المنشور
          if (post.title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                post.title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          // نص المنشور
          Text(
            post.body,
            style: const TextStyle(color: AppColors.white, fontSize: 15, height: 1.4),
          ),
          // الوسائط (صور أو فيديوهات)
          if (post.mediaUrls.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildMediaGallery(context),
          ],
          const SizedBox(height: 12),
          // أزرار التفاعل
          Row(
            children: [
              _buildActionButton(
                icon: post.isUpvoted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                label: Formatters.formatCount(post.upvotes),
                color: post.isUpvoted ? Colors.redAccent : Colors.black45,
                onTap: () {
                  _likeAnimCtrl.forward().then((_) => _likeAnimCtrl.reverse());
                  widget.onUpdate(post.copyWith(
                    isUpvoted: !post.isUpvoted,
                    upvotes: post.isUpvoted ? post.upvotes - 1 : post.upvotes + 1,
                  ));
                },
                animationController: _likeAnimCtrl,
                scaleAnimation: _likeScaleAnim,
              ),
              const SizedBox(width: 24),
              _buildActionButton(
                icon: Icons.chat_bubble_outline_rounded,
                label: Formatters.formatCount(post.comments),
                color: AppColors.grey2,
                onTap: () => _showCommentsSheet(context),
              ),
              const SizedBox(width: 24),
              _buildActionButton(
                icon: Icons.share_outlined,
                label: Formatters.formatCount(post.shares),
                color: AppColors.grey2,
                onTap: () => _showRepostSheet(context),
              ),
              const Spacer(),
              _buildActionButton(
                icon: post.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                label: '',
                color: AppColors.grey2,
                onTap: () => widget.onUpdate(post.copyWith(isBookmarked: !post.isBookmarked)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaGallery(BuildContext context) {
    final mediaUrls = widget.post.mediaUrls;
    return Column(
      children: [
        GestureDetector(
          onTap: () => _openMediaFullScreen(context, _currentImageIndex),
          child: Hero(
            tag: 'media_${widget.post.id}_$_currentImageIndex',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 400,
                width: double.infinity,
                color: Colors.grey[200],
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      mediaUrls[_currentImageIndex],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 48, color: Colors.black26),
                      ),
                    ),
                    if (widget.post.mediaType == 'video')
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 48),
                      ),
                    if (mediaUrls.length > 1)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_currentImageIndex + 1}/${mediaUrls.length}',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (mediaUrls.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(mediaUrls.length, (index) {
              return Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == index ? Colors.black87 : Colors.black12,
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    AnimationController? animationController,
    Animation<double>? scaleAnimation,
  }) {
    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        if (label.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ],
    );

    if (animationController != null && scaleAnimation != null) {
      child = AnimatedBuilder(
        animation: animationController,
        builder: (context, _) => Transform.scale(
          scale: scaleAnimation.value,
          child: child,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: child,
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
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            _menuOption(Icons.volume_off_outlined, 'Mute @${widget.post.username}', () {}),
            _menuOption(Icons.block_outlined, 'Block @${widget.post.username}', () {}),
            _menuOption(Icons.flag_outlined, 'Report', () {}),
            _menuOption(Icons.link, 'Copy link', () {}),
            _menuOption(Icons.do_not_disturb_on, 'Not interested', () {}),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _menuOption(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(label, style: const TextStyle(color: AppColors.white, fontSize: 16)),
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
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            _repostOption(Icons.repeat_rounded, 'Repost', () {
              Navigator.pop(context);
              widget.onUpdate(widget.post.copyWith(shares: widget.post.shares + 1));
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
      leading: Icon(icon, color: Colors.black54),
      title: Text(label, style: const TextStyle(color: AppColors.white, fontSize: 16)),
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
            onCommentAdded: () {
              widget.onUpdate(widget.post.copyWith(comments: widget.post.comments + 1));
            },
          );
        },
      ),
    );
  }
}

// ─── CommentsSheet (ورقة التعليقات) ──────────────────────────────────────────
class _CommentsSheet extends StatefulWidget {
  final RizePostModel post;
  final ScrollController scrollController;
  final VoidCallback onCommentAdded;

  const _CommentsSheet({
    required this.post,
    required this.scrollController,
    required this.onCommentAdded,
  });

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<RizeCommentModel> _comments = [];
  String? _replyingToId;

  @override
  void initState() {
    super.initState();
    _comments = RizeCommentModel.getMockComments();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
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
      userId: 'current_user',
      username: '@you',
      name: 'You',
      text: _textController.text.trim(),
      likes: 0,
      isLiked: false,
      createdAt: DateTime.now(),
    );

    setState(() {
      if (_replyingToId != null) {
        _addReplyToComment(_comments, _replyingToId!, newComment);
      } else {
        _comments.insert(0, newComment);
      }
      _textController.clear();
      _replyingToId = null;
    });
    widget.onCommentAdded();
  }

  bool _addReplyToComment(List<RizeCommentModel> comments, String parentId, RizeCommentModel reply) {
    for (var i = 0; i < comments.length; i++) {
      if (comments[i].id == parentId) {
        comments[i] = comments[i].copyWith(replies: [...comments[i].replies, reply]);
        return true;
      }
      if (_addReplyToComment(comments[i].replies, parentId, reply)) return true;
    }
    return false;
  }

  void _deleteComment(String commentId) {
    setState(() {
      _comments.removeWhere((c) => c.id == commentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Replies', style: AppTextStyles.h5.copyWith(color: Colors.black87)),
                const SizedBox(width: 8),
                Text('(${_comments.length})', style: TextStyle(color: Colors.black45)),
                const Spacer(),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _comments.length,
              itemBuilder: (context, index) => _CommentTile(
                comment: _comments[index],
                onReply: (id) => setState(() => _replyingToId = id),
                onDelete: (id) => _deleteComment(id),
                onLike: (id) {
                  setState(() {
                    final comment = _findCommentById(_comments, id);
                    if (comment != null) {
                      comment.isLiked = !comment.isLiked;
                      comment.likes += comment.isLiked ? 1 : -1;
                    }
                  });
                },
                depth: 0,
              ),
            ),
          ),
          if (_replyingToId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to @${_findCommentById(_comments, _replyingToId!)?.username ?? ''}',
                      style: const TextStyle(color: AppColors.grey2, fontSize: 13),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _replyingToId = null),
                    child: const Icon(Icons.close, color: AppColors.grey2, size: 18),
                  ),
                ],
              ),
            ),
          _buildReplyBar(),
        ],
      ),
    );
  }

  Widget _buildReplyBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            const CircleAvatar(radius: 15, backgroundColor: Colors.black12, child: Icon(Icons.person, color: AppColors.grey2, size: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                style: const TextStyle(color: AppColors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: _replyingToId != null ? 'Write a reply...' : 'Add a comment...',
                  hintStyle: const TextStyle(color: Colors.black38),
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _textController.text.trim().isNotEmpty ? _sendComment : null,
              child: Icon(Icons.send_rounded, color: _textController.text.trim().isNotEmpty ? Colors.blue : Colors.black26, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  RizeCommentModel? _findCommentById(List<RizeCommentModel> comments, String id) {
    for (final comment in comments) {
      if (comment.id == id) return comment;
      final found = _findCommentById(comment.replies, id);
      if (found != null) return found;
    }
    return null;
  }
}

// ─── CommentTile (عرض تعليق مع الردود) ──────────────────────────────────────
class _CommentTile extends StatelessWidget {
  final RizeCommentModel comment;
  final Function(String) onReply;
  final Function(String) onDelete;
  final Function(String) onLike;
  final int depth;

  const _CommentTile({
    required this.comment,
    required this.onReply,
    required this.onDelete,
    required this.onLike,
    required this.depth,
  });

  @override
  Widget build(BuildContext context) {
    final isOwnComment = comment.userId == 'current_user';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (depth > 0) ...[
              SizedBox(width: 20.0 * depth),
              Container(width: 2, height: 30, color: Colors.black12, margin: const EdgeInsets.only(right: 12)),
            ],
            CircleAvatar(radius: 14, backgroundColor: Colors.black12, child: const Icon(Icons.person, color: AppColors.grey2, size: 16)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(comment.username, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(width: 6),
                      Text(Formatters.timeAgo(comment.createdAt), style: const TextStyle(color: Colors.black38, fontSize: 11)),
                      const Spacer(),
                      if (isOwnComment)
                        GestureDetector(
                          onTap: () => onDelete(comment.id),
                          child: const Icon(Icons.delete_outline, color: Colors.black26, size: 16),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(comment.text, style: const TextStyle(color: AppColors.white, fontSize: 14)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => onLike(comment.id),
                        child: Row(
                          children: [
                            Icon(comment.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: comment.isLiked ? Colors.redAccent : Colors.black45, size: 14),
                            const SizedBox(width: 4),
                            Text(Formatters.formatCount(comment.likes), style: TextStyle(color: AppColors.grey2, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => onReply(comment.id),
                        child: const Text('Reply', style: TextStyle(color: AppColors.grey2, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (comment.replies.isNotEmpty)
          ...comment.replies.map((reply) => _CommentTile(
                comment: reply,
                onReply: onReply,
                onDelete: onDelete,
                onLike: onLike,
                depth: depth + 1,
              )),
      ],
    );
  }
}

// ─── CreateRizeSheet (ورقة إنشاء منشور) ──────────────────────────────────────
class _CreateRizeSheet extends StatefulWidget {
  final RizePostModel? quotedPost;
  const _CreateRizeSheet({this.quotedPost});

  @override
  State<_CreateRizeSheet> createState() => _CreateRizeSheetState();
}

class _CreateRizeSheetState extends State<_CreateRizeSheet> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitRize() {
    if (_textController.text.trim().isEmpty) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rize posted!')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Row(
            children: [
              const CircleAvatar(radius: 20, backgroundColor: Colors.black12, child: Icon(Icons.person, color: Colors.black54)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  style: const TextStyle(color: AppColors.white, fontSize: 16),
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'What\'s on your mind?',
                    hintStyle: TextStyle(color: Colors.black38),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          if (widget.quotedPost != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.quotedPost!.name, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600)),
                  Text(widget.quotedPost!.body, style: const TextStyle(color: Colors.black54), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
          const Divider(height: 24),
          Row(
            children: [
              _mediaBtn(Icons.image_rounded, () {}),
              const SizedBox(width: 12),
              _mediaBtn(Icons.videocam_rounded, () {}),
              const Spacer(),
              if (_textController.text.length > 400)
                Text('${_textController.text.length}/500', style: TextStyle(color: _textController.text.length > 500 ? Colors.red : Colors.black45)),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: _textController.text.trim().isNotEmpty ? _submitRize : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: _textController.text.trim().isNotEmpty ? AppColors.electricBlue : Colors.black12,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text('Post', style: TextStyle(color: _textController.text.trim().isNotEmpty ? Colors.white : Colors.black38, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _mediaBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coming soon'))),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.grey2, size: 20),
      ),
    );
  }
}
