// lib/presentation/screens/rize/rize_screen.dart

import 'dart:ui';

import 'package:flutter/cupertino.dart';
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

class _RizeScreenState extends State<RizeScreen>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final TabController _tabController;

  final List<RizePostModel> _posts = RizePostModel.getMockPosts();
  int _tabIndex = 0;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isLoadingMore) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 320) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);

    await Future.delayed(const Duration(milliseconds: 900));

    final more = RizePostModel.getMockPosts()
        .map(
          (e) => e.copyWith(
            id: '${DateTime.now().millisecondsSinceEpoch}_${e.id}',
          ),
        )
        .toList();

    if (!mounted) return;
    setState(() {
      _posts.addAll(more);
      _isLoadingMore = false;
    });
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _tabIndex = _tabController.index;
    });
  }

  List<RizePostModel> get _visiblePosts {
    if (_tabIndex == 1) {
      final following = _posts.where((p) => p.isFollowing).toList();
      return following.isEmpty ? _posts : following;
    }
    return _posts;
  }

  void _updatePost(int index, RizePostModel updated) {
    setState(() {
      _posts[index] = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.electricBlue,
        backgroundColor: const Color(0xFF121212),
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
              collapsedHeight: 0,
              floating: true,
              snap: true,
              pinned: false,
              automaticallyImplyLeading: false,
              expandedHeight: 112,
              flexibleSpace: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SearchBar(
                        onTap: () {
                          HapticFeedback.lightImpact();
                        },
                      ),
                      const SizedBox(height: 12),
                      _TabsHeader(
                        controller: _tabController,
                        activeIndex: _tabIndex,
                        onChanged: (index) {
                          HapticFeedback.selectionClick();
                          setState(() => _tabIndex = index);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= _visiblePosts.length) {
                    return _isLoadingMore
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 22),
                            child: Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          )
                        : const SizedBox.shrink();
                  }

                  final post = _visiblePosts[index];
                  return RizePostCard(
                    key: ValueKey(post.id),
                    post: post,
                    onUpdate: (updated) => _updatePost(index, updated),
                  );
                },
                childCount: _visiblePosts.length + 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.search,
              color: Colors.white.withOpacity(0.45),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Search Rize...',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabsHeader extends StatelessWidget {
  final TabController controller;
  final int activeIndex;
  final ValueChanged<int> onChanged;

  const _TabsHeader({
    required this.controller,
    required this.activeIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = const ['For You', 'Following'];

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selected = activeIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                controller.animateTo(index);
                onChanged(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: selected ? Colors.black : Colors.white54,
                      fontSize: 15,
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class RizePostCard extends StatefulWidget {
  final RizePostModel post;
  final Function(RizePostModel) onUpdate;

  const RizePostCard({
    super.key,
    required this.post,
    required this.onUpdate,
  });

  @override
  State<RizePostCard> createState() => _RizePostCardState();
}

class _RizePostCardState extends State<RizePostCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _likeCtrl;
  late final Animation<double> _likeScale;

  bool _showFullBody = false;

  @override
  void initState() {
    super.initState();
    _likeCtrl = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _likeScale = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _likeCtrl, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _likeCtrl.dispose();
    super.dispose();
  }

  void _toggleUpvote() {
    _likeCtrl.forward().then((_) => _likeCtrl.reverse());
    widget.onUpdate(
      widget.post.copyWith(
        isUpvoted: !widget.post.isUpvoted,
        upvotes: widget.post.isUpvoted
            ? widget.post.upvotes - 1
            : widget.post.upvotes + 1,
      ),
    );
  }

  void _toggleFollow() {
    widget.onUpdate(
      widget.post.copyWith(isFollowing: !widget.post.isFollowing),
    );
  }

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CommentsSheet(post: widget.post),
    );
  }

  void _showPostMenu(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Copy link'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: Text(widget.post.isFollowing ? 'Unfollow' : 'Follow'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            isDestructiveAction: true,
            child: const Text('Report'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showRepostSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Share'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Repost'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Quote'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Share via...'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  Widget _buildAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    Animation<double>? animation,
  }) {
    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        if (label.isNotEmpty) ...[
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );

    if (animation != null) {
      child = AnimatedBuilder(
        animation: animation,
        builder: (_, __) => Transform.scale(
          scale: animation.value,
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

  Widget _buildMedia() {
    final urls = widget.post.mediaUrls;
    if (urls.isEmpty) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Icon(
            widget.post.mediaType == 'video'
                ? CupertinoIcons.videocam
                : CupertinoIcons.photo,
            color: Colors.white.withOpacity(0.35),
            size: 52,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 260,
        color: Colors.white.withOpacity(0.04),
        child: PageView.builder(
          itemCount: urls.length,
          itemBuilder: (context, index) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  urls[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.white.withOpacity(0.05),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.photo,
                        color: Colors.white.withOpacity(0.3),
                        size: 44,
                      ),
                    ),
                  ),
                ),
                if (widget.post.mediaType == 'video')
                  Center(
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.play_fill,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                if (urls.length > 1)
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${index + 1}/${urls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return GestureDetector(
      onDoubleTap: _toggleUpvote,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF2C2C2E),
                  child: Text(
                    post.userAvatar,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: _toggleFollow,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              post.username,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.42),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              CupertinoIcons.eye_fill,
                              size: 12,
                              color: Colors.white.withOpacity(0.4),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${Formatters.formatCount(post.views)} views',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showPostMenu(context),
                  child: Icon(
                    CupertinoIcons.ellipsis,
                    color: Colors.white.withOpacity(0.4),
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.title.isNotEmpty) ...[
                    Text(
                      post.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    _showFullBody || post.body.length <= 220
                        ? post.body
                        : '${post.body.substring(0, 220)}...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.92),
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),
                  if (post.body.length > 220) ...[
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => setState(() => _showFullBody = !_showFullBody),
                      child: Text(
                        _showFullBody ? 'Show less' : 'More',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.electricBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  _buildMedia(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: _likeScale,
                        builder: (_, child) => Transform.scale(
                          scale: _likeScale.value,
                          child: child,
                        ),
                        child: _buildAction(
                          icon: post.isUpvoted
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          label: Formatters.formatCount(post.upvotes),
                          color: post.isUpvoted
                              ? Colors.redAccent
                              : Colors.white54,
                          onTap: _toggleUpvote,
                        ),
                      ),
                      const SizedBox(width: 18),
                      _buildAction(
                        icon: CupertinoIcons.chat_bubble,
                        label: Formatters.formatCount(post.comments),
                        color: Colors.white54,
                        onTap: () => _showCommentsSheet(context),
                      ),
                      const SizedBox(width: 18),
                      _buildAction(
                        icon: CupertinoIcons.arrow_2_squarepath,
                        label: Formatters.formatCount(post.shares),
                        color: Colors.white54,
                        onTap: () => _showRepostSheet(context),
                      ),
                      const Spacer(),
                      _buildAction(
                        icon: post.isBookmarked
                            ? CupertinoIcons.bookmark_fill
                            : CupertinoIcons.bookmark,
                        label: '',
                        color: post.isBookmarked
                            ? AppColors.electricBlue
                            : Colors.white54,
                        onTap: () {
                          widget.onUpdate(
                            post.copyWith(isBookmarked: !post.isBookmarked),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentsSheet extends StatefulWidget {
  final RizePostModel post;

  const _CommentsSheet({required this.post});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<_ThreadComment> _comments = [
    _ThreadComment(
      id: '1',
      userId: 'u1',
      username: '@ahmed_codes',
      name: 'Ahmed',
      text: 'This is exactly what I was looking for! Great breakdown 🔥',
      likes: 24,
      isLiked: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      replies: [
        _ThreadComment(
          id: '1-1',
          userId: 'u2',
          username: '@flutter_dev',
          name: 'Flutter Dev',
          text: 'Totally agree! The new features are amazing',
          likes: 8,
          isLiked: true,
          createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
          replies: [
            _ThreadComment(
              id: '1-1-1',
              userId: 'current_user',
              username: '@you',
              name: 'You',
              text: 'Thanks for the feedback guys! 🙏',
              likes: 3,
              isLiked: false,
              createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
            ),
          ],
        ),
      ],
    ),
    _ThreadComment(
      id: '2',
      userId: 'u3',
      username: '@flutter_dev',
      name: 'Flutter Dev',
      text: 'Thanks for sharing this insight. Very helpful for beginners.',
      likes: 12,
      isLiked: true,
      createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
  ];

  String? _replyingToId;
  String? _replyingToName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      final comment = _ThreadComment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user',
        username: '@you',
        name: 'You',
        text: text,
        likes: 0,
        isLiked: false,
        createdAt: DateTime.now(),
      );

      if (_replyingToId != null) {
        _addReply(_comments, _replyingToId!, comment);
      } else {
        _comments.insert(0, comment);
      }

      _controller.clear();
      _replyingToId = null;
      _replyingToName = null;
    });
  }

  bool _addReply(
    List<_ThreadComment> comments,
    String parentId,
    _ThreadComment reply,
  ) {
    for (var i = 0; i < comments.length; i++) {
      if (comments[i].id == parentId) {
        comments[i] = comments[i].copyWith(
          replies: [...comments[i].replies, reply],
        );
        return true;
      }
      if (_addReply(comments[i].replies, parentId, reply)) return true;
    }
    return false;
  }

  void _like(String id) {
    setState(() {
      final comment = _find(_comments, id);
      if (comment != null) {
        comment.isLiked = !comment.isLiked;
        comment.likes += comment.isLiked ? 1 : -1;
      }
    });
  }

  _ThreadComment? _find(List<_ThreadComment> comments, String id) {
    for (final c in comments) {
      if (c.id == id) return c;
      final found = _find(c.replies, id);
      if (found != null) return found;
    }
    return null;
  }

  void _delete(String id) {
    setState(() {
      _remove(_comments, id);
    });
  }

  bool _remove(List<_ThreadComment> comments, String id) {
    for (var i = 0; i < comments.length; i++) {
      if (comments[i].id == id) {
        comments.removeAt(i);
        return true;
      }
      if (_remove(comments[i].replies, id)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Thread',
                  style: AppTextStyles.h5.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${_comments.length})',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    CupertinoIcons.xmark,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 24, thickness: 0.5, color: Colors.white.withOpacity(0.1)),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return _ThreadCommentTile(
                  comment: _comments[index],
                  onReply: (id, name) {
                    setState(() {
                      _replyingToId = id;
                      _replyingToName = name;
                    });
                    _focusNode.requestFocus();
                  },
                  onDelete: _delete,
                  onLike: _like,
                  depth: 0,
                );
              },
            ),
          ),
          if (_replyingToId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFF121212),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to $_replyingToName',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      _replyingToId = null;
                      _replyingToName = null;
                    }),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      color: Colors.white54,
                      size: 16,
                    ),
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
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF2C2C2E),
              child: Icon(
                CupertinoIcons.person_fill,
                color: Colors.white54,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: null,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: _replyingToId != null ? 'Write a reply...' : 'Post your reply...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _send,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Reply',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThreadComment {
  final String id;
  final String userId;
  final String username;
  final String name;
  final String text;
  int likes;
  bool isLiked;
  final DateTime createdAt;
  List<_ThreadComment> replies;

  _ThreadComment({
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

  _ThreadComment copyWith({
    String? id,
    String? userId,
    String? username,
    String? name,
    String? text,
    int? likes,
    bool? isLiked,
    DateTime? createdAt,
    List<_ThreadComment>? replies,
  }) {
    return _ThreadComment(
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
}

class _ThreadCommentTile extends StatelessWidget {
  final _ThreadComment comment;
  final Function(String id, String name) onReply;
  final Function(String id) onDelete;
  final Function(String id) onLike;
  final int depth;

  const _ThreadCommentTile({
    required this.comment,
    required this.onReply,
    required this.onDelete,
    required this.onLike,
    required this.depth,
  });

  @override
  Widget build(BuildContext context) {
    final isOwn = comment.userId == 'current_user';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF2C2C2E),
                  child: const Icon(
                    CupertinoIcons.person_fill,
                    color: Colors.white54,
                    size: 14,
                  ),
                ),
                if (comment.replies.isNotEmpty)
                  Container(
                    width: 2,
                    height: 40,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        comment.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        comment.username,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '· ${Formatters.timeAgo(comment.createdAt)}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      if (isOwn)
                        GestureDetector(
                          onTap: () => onDelete(comment.id),
                          child: Icon(
                            CupertinoIcons.trash,
                            color: Colors.redAccent.withOpacity(0.7),
                            size: 14,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => onLike(comment.id),
                        child: Row(
                          children: [
                            Icon(
                              comment.isLiked
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: comment.isLiked
                                  ? Colors.redAccent
                                  : Colors.white54,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              Formatters.formatCount(comment.likes),
                              style: TextStyle(
                                color: comment.isLiked
                                    ? Colors.redAccent
                                    : Colors.white54,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => onReply(comment.id, comment.username),
                        child: const Text(
                          'Reply',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              children: comment.replies.map((reply) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _ThreadCommentTile(
                    comment: reply,
                    onReply: onReply,
                    onDelete: onDelete,
                    onLike: onLike,
                    depth: depth + 1,
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
