// lib/presentation/screens/rize/rize_screen.dart
// نسخة نهائية مضمونة - Threads UI + Twitter Features

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/rize_model.dart';
import 'widgets/media_fullscreen.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// 🔹 نموذج التعليق المتداخل (Threaded) 🔹
// ═══════════════════════════════════════════════════════════════════════════════
class RizeCommentModel {
  final String id;
  final String userId;
  final String username;
  final String name;
  final String text;
  int likes;
  bool isLiked;
  final DateTime createdAt;
  final List<RizeCommentModel> replies;

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
        text: 'This is exactly what I was looking for! Great breakdown 🔥',
        likes: 24,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        replies: [
          RizeCommentModel(
            id: '1-1',
            userId: 'user2',
            username: '@flutter_dev',
            name: 'Flutter Dev',
            text: 'Totally agree! The new features are amazing',
            likes: 8,
            isLiked: true,
            createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
            replies: [
              RizeCommentModel(
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
        text: 'The design patterns you mentioned are spot on. Love the dark mode!',
        likes: 8,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        replies: [
          RizeCommentModel(
            id: '3-1',
            userId: 'user1',
            username: '@ahmed_codes',
            name: 'Ahmed',
            text: 'Glad you liked it! Dark mode is the way to go.',
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
        text: 'Feels like Threads indeed! Love the clean UI and smooth animations.',
        likes: 15,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 🔹 RizeScreen الرئيسية 🔹
// ═══════════════════════════════════════════════════════════════════════════════
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
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      floatingActionButton: const _CreateButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Column(
          children: [
            _buildGlassHeader(),
            _buildTabs(),
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
        ),
      ),
    );
  }

  Widget _buildGlassHeader() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showTopBar,
      builder: (context, visible, _) => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: visible ? 56 : 0,
        child: visible
            ? ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Rize',
                          style: AppTextStyles.h4.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),
                        _GlassIconButton(
                          icon: CupertinoIcons.search,
                          onTap: () => HapticFeedback.lightImpact(),
                        ),
                        const SizedBox(width: 12),
                        _GlassIconButton(
                          icon: CupertinoIcons.bell,
                          onTap: () => HapticFeedback.lightImpact(),
                          badge: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabCtrl,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 2.5, color: Colors.white),
          insets: EdgeInsets.symmetric(horizontal: 80),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white38,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          letterSpacing: -0.3,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        tabs: const [
          Tab(text: 'For You'),
          Tab(text: 'Following'),
        ],
        onTap: (_) => HapticFeedback.selectionClick(),
      ),
    );
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CreateRizeSheet(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 🔹 زر الإنشاء الاحترافي 🔹
// ═══════════════════════════════════════════════════════════════════════════════
class _CreateButton extends StatelessWidget {
  const _CreateButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        final state = context.findAncestorStateOfType<_RizeScreenState>();
        state?._showCreateSheet(context);
      },
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF007AFF).withOpacity(0.5),
              blurRadius: 25,
              offset: const Offset(0, 10),
              spreadRadius: 3,
            ),
          ],
        ),
        child: const Icon(
          CupertinoIcons.plus,
          color: Colors.white,
          size: 32,
          weight: 700,
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final int? badge;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            if (badge != null)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 🔹 RizeFeed 🔹
// ═══════════════════════════════════════════════════════════════════════════════
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.electricBlue,
      backgroundColor: const Color(0xFF1C1C1E),
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() => _localPosts = List.from(widget.posts));
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 500 && !_isLoading) {
            _loadMore();
          }
          return false;
        },
        child: ListView.separated(
          controller: widget.scrollController,
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: _localPosts.length + (_isLoading ? 1 : 0),
          separatorBuilder: (_, __) => Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.white.withOpacity(0.08),
          ),
          itemBuilder: (ctx, i) {
            if (i >= _localPosts.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CupertinoActivityIndicator()),
              );
            }
            return _RizeCard(
              post: _localPosts[i],
              onUpdate: (p) {
                setState(() => _localPosts[i] = p);
                widget.onUpdate(i, p);
              },
            );
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 🔹 RizeCard - بطاقة المنشور الاحترافية 🔹
// ═══════════════════════════════════════════════════════════════════════════════
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

class _RizeCardState extends State<_RizeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeCtrl;
  late Animation<double> _likeScale;
  bool _showHeartOverlay = false;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _likeCtrl = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _likeScale = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _likeCtrl, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _likeCtrl.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    HapticFeedback.mediumImpact();
    if (!widget.post.isUpvoted) {
      _triggerLike();
    }
    setState(() => _showHeartOverlay = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _showHeartOverlay = false);
    });
  }

  void _triggerLike() {
    _likeCtrl.forward().then((_) => _likeCtrl.reverse());
    widget.onUpdate(widget.post.copyWith(
      isUpvoted: true,
      upvotes: widget.post.upvotes + 1,
    ));
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
    // التحقق من وجود isVerified في الموديل، إذا لم يكن موجوداً نستخدم false
    final bool isVerified = (post as dynamic).isVerified ?? false;
    
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصف العلوي: الاسم + Views
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _navigateToProfile(context),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isVerified ? AppColors.electricBlue : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF2C2C2E),
                      backgroundImage: post.userAvatar.isNotEmpty ? NetworkImage(post.userAvatar) : null,
                      child: post.userAvatar.isEmpty
                          ? const Icon(CupertinoIcons.person_fill, color: Colors.white54, size: 18)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _navigateToProfile(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              post.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                letterSpacing: -0.2,
                              ),
                            ),
                            if (isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                CupertinoIcons.check_mark_circled_solid,
                                color: Color(0xFF007AFF),
                                size: 14,
                              ),
                            ],
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              post.username,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
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
            const SizedBox(height: 8),
            // النص والمحتوى
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.title.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        post.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  Text(
                    post.body,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (post.mediaUrls.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _buildMediaGallery(context),
                  ],
                  const SizedBox(height: 12),
                  _buildActionBar(post),
                ],
              ),
            ),
            if (_showHeartOverlay)
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: 1 - value,
                      child: Transform.scale(
                        scale: 0.5 + (value * 0.5),
                        child: const Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.redAccent,
                          size: 100,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaGallery(BuildContext context) {
    final mediaUrls = widget.post.mediaUrls;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 320,
        color: const Color(0xFF1C1C1E),
        child: PageView.builder(
          itemCount: mediaUrls.length,
          onPageChanged: (index) => setState(() => _currentImageIndex = index),
          itemBuilder: (context, index) {
            final isVideo = widget.post.mediaType == 'video';
            return GestureDetector(
              onTap: () => _openMediaFullScreen(context, index),
              child: Hero(
                tag: 'media_${widget.post.id}_$index',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      mediaUrls[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        );
                      },
                    ),
                    if (isVideo)
                      Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.play_fill,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    if (mediaUrls.length > 1)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${index + 1}/${mediaUrls.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionBar(RizePostModel post) {
    return Row(
      children: [
        _ActionButton(
          icon: post.isUpvoted ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
          label: Formatters.formatCount(post.upvotes),
          color: post.isUpvoted ? Colors.redAccent : Colors.white54,
          onTap: () {
            HapticFeedback.lightImpact();
            _likeCtrl.forward().then((_) => _likeCtrl.reverse());
            widget.onUpdate(post.copyWith(
              isUpvoted: !post.isUpvoted,
              upvotes: post.isUpvoted ? post.upvotes - 1 : post.upvotes + 1,
            ));
          },
          animation: _likeScale,
        ),
        const SizedBox(width: 20),
        _ActionButton(
          icon: CupertinoIcons.chat_bubble,
          label: Formatters.formatCount(post.comments),
          color: Colors.white54,
          onTap: () {
            HapticFeedback.lightImpact();
            _showCommentsSheet(context);
          },
        ),
        const SizedBox(width: 20),
        _ActionButton(
          icon: CupertinoIcons.arrow_2_squarepath,
          label: Formatters.formatCount(post.shares),
          color: Colors.white54,
          onTap: () {
            HapticFeedback.lightImpact();
            _showRepostSheet(context);
          },
        ),
        const Spacer(),
        _ActionButton(
          icon: post.isBookmarked ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
          label: '',
          color: post.isBookmarked ? const Color(0xFF007AFF) : Colors.white54,
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onUpdate(post.copyWith(isBookmarked: !post.isBookmarked));
          },
        ),
      ],
    );
  }

  void _showPostMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mute @username'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Block @username'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            isDestructiveAction: true,
            child: const Text('Report Post'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDefaultAction: true,
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showRepostSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Share'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              widget.onUpdate(widget.post.copyWith(shares: widget.post.shares + 1));
              HapticFeedback.mediumImpact();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.repeat, size: 20),
                SizedBox(width: 8),
                Text('Repost'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showCreateQuoteSheet(context);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.pencil, size: 20),
                SizedBox(width: 8),
                Text('Quote'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.share, size: 20),
                SizedBox(width: 8),
                Text('Share via...'),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDefaultAction: true,
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showCreateQuoteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateRizeSheet(quotedPost: widget.post),
    );
  }

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final Animation<double>? animation;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        if (label.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ],
    );

    if (animation != null) {
      child = AnimatedBuilder(
        animation: animation!,
        builder: (_, __) => Transform.scale(scale: animation!.value, child: child),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 🔹 CommentsSheet - تعليقات على شكل حرف L 🔹
// ═══════════════════════════════════════════════════════════════════════════════
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
  String? _replyingToName;

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
    HapticFeedback.mediumImpact();
    
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
      _replyingToName = null;
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
    HapticFeedback.heavyImpact();
    setState(() {
      _removeCommentById(_comments, commentId);
    });
  }

  bool _removeCommentById(List<RizeCommentModel> comments, String id) {
    for (var i = 0; i < comments.length; i++) {
      if (comments[i].id == id) {
        comments.removeAt(i);
        return true;
      }
      if (_removeCommentById(comments[i].replies, id)) return true;
    }
    return false;
  }

  void _likeComment(String commentId) {
    HapticFeedback.lightImpact();
    setState(() {
      final comment = _findCommentById(_comments, commentId);
      if (comment != null) {
        comment.isLiked = !comment.isLiked;
        comment.likes += comment.isLiked ? 1 : -1;
      }
    });
  }

  RizeCommentModel? _findCommentById(List<RizeCommentModel> comments, String id) {
    for (final comment in comments) {
      if (comment.id == id) return comment;
      final found = _findCommentById(comment.replies, id);
      if (found != null) return found;
    }
    return null;
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
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Thread',
                  style: AppTextStyles.h5.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${_comments.length})',
                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 15),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(CupertinoIcons.xmark, color: Colors.white54, size: 20),
                ),
              ],
            ),
          ),
          Divider(height: 24, thickness: 0.5, color: Colors.white.withOpacity(0.1)),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _comments.length,
              itemBuilder: (context, index) => _CommentTile(
                comment: _comments[index],
                onReply: (id, name) {
                  setState(() {
                    _replyingToId = id;
                    _replyingToName = name;
                  });
                  _focusNode.requestFocus();
                },
                onDelete: (id) => _deleteComment(id),
                onLike: (id) => _likeComment(id),
                depth: 0,
              ),
            ),
          ),
          if (_replyingToId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFF1C1C1E),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to $_replyingToName',
                      style: const TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      _replyingToId = null;
                      _replyingToName = null;
                    }),
                    child: const Icon(CupertinoIcons.xmark, color: Colors.white54, size: 16),
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
              child: Icon(CupertinoIcons.person_fill, color: Colors.white54, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: _replyingToId != null ? 'Write a reply...' : 'Post your reply...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _textController.text.trim().isNotEmpty ? _sendComment : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _textController.text.trim().isNotEmpty
                      ? const Color(0xFF007AFF)
                      : const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Reply',
                  style: TextStyle(
                    color: _textController.text.trim().isNotEmpty ? Colors.white : Colors.white38,
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

// ═══════════════════════════════════════════════════════════════════════════════
// 🔹 CommentTile - خط L للردود المتداخلة 🔹
// ═══════════════════════════════════════════════════════════════════════════════
class _CommentTile extends StatelessWidget {
  final RizeCommentModel comment;
  final Function(String id, String name) onReply;
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
    final hasReplies = comment.replies.isNotEmpty;

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
                  child: const Icon(CupertinoIcons.person_fill, color: Colors.white54, size: 14),
                ),
                if (hasReplies)
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
                          fontWeight: FontWeight.w700,
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
                      if (isOwnComment)
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
                              comment.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                              color: comment.isLiked ? Colors.redAccent : Colors.white54,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              Formatters.formatCount(comment.likes),
                              style: TextStyle(
                                color: comment.isLiked ? Colors.redAccent : Colors.white54,
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
        // الردود المتداخلة مع خط L
        if (hasReplies)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              children: comment.replies.map((reply) {
                return Stack(
                  children: [
                    // الخط الأفقي (جزء L)
                    Positioned(
                      left: 0,
                      top: 16,
                      child: Container(
                        width: 20,
                        height: 2,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                    // الخط العمودي الممتد
                    if (reply.replies.isNotEmpty)
                      Positioned(
                        left: 0,
                        top: 18,
                        bottom: 0,
                        child: Container(
                          width: 2,
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: _CommentTile(
                        comment: reply,
                        onReply: onReply,
                        onDelete: onDelete,
                        onLike: onLike,
                        depth: depth + 1,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 🔹 CreateRizeSheet 🔹
// ═══════════════════════════════════════════════════════════════════════════════
class _CreateRizeSheet extends StatefulWidget {
  final RizePostModel? quotedPost;
  const _CreateRizeSheet({this.quotedPost});

  @override
  State<_CreateRizeSheet> createState() => _CreateRizeSheetState();
}

class _CreateRizeSheetState extends State<_CreateRizeSheet> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isPosting = false;

 
