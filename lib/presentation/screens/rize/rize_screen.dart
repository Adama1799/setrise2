import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/rize_model.dart';
import 'widgets/post_card.dart';

class RizeScreen extends StatefulWidget {
  const RizeScreen({super.key});

  @override
  State<RizeScreen> createState() => _RizeScreenState();
}

class _RizeScreenState extends State<RizeScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<RizePostModel> _posts = RizePostModel.getMockPosts();

  int _tabIndex = 0;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
    setState(() {});
  }

  void _updatePostById(String id, RizePostModel updated) {
    final index = _posts.indexWhere((p) => p.id == id);
    if (index == -1) return;
    setState(() => _posts[index] = updated);
  }

  List<RizePostModel> get _visiblePosts {
    if (_tabIndex == 1) {
      final following = _posts.where((p) => p.isFollowing).toList();
      return following.isEmpty ? _posts : following;
    }
    return _posts;
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
              expandedHeight: 128,
              flexibleSpace: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'SetRize',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.8,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _SearchBar(
                        onTap: () {
                          HapticFeedback.lightImpact();
                        },
                      ),
                      const SizedBox(height: 12),
                      _TabsHeader(
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
                    onUpdate: (updated) => _updatePostById(updated.id, updated),
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
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.search,
              color: Colors.white.withOpacity(0.45),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Search',
              style: TextStyle(
                color: Colors.white.withOpacity(0.35),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabsHeader extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onChanged;

  const _TabsHeader({
    required this.activeIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const tabs = ['For You', 'Following'];

    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selected = activeIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: selected ? Colors.black : Colors.white54,
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      letterSpacing: -0.1,
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
