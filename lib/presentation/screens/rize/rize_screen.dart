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

class _RizeScreenState extends State<RizeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final List<RizePostModel> _posts = RizePostModel.getMockPosts();
  bool _barsVisible = true;
  final ScrollController _scrollCtrl = ScrollController();
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    final delta = _scrollCtrl.offset - _lastOffset;
    _lastOffset = _scrollCtrl.offset;
    if (delta > 6 && _barsVisible) setState(() => _barsVisible = false);
    if (delta < -6 && !_barsVisible) setState(() => _barsVisible = true);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _updatePost(int index, RizePostModel updatedPost) =>
      setState(() => _posts[index] = updatedPost);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(children: [
        // Feed
        ListView.separated(
          controller: _scrollCtrl,
          padding: EdgeInsets.only(
              top: _barsVisible ? 100 : 0, bottom: 20),
          itemCount: _posts.length,
          separatorBuilder: (_, __) =>
              Divider(color: AppColors.grey.withOpacity(0.4), height: 1),
          itemBuilder: (_, i) => RizePostCard(
            post: _posts[i],
            onUpdate: (p) => _updatePost(i, p),
          ),
        ),

        // Top bar (hide on scroll)
        AnimatedSlide(
          offset: _barsVisible ? Offset.zero : const Offset(0, -1),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: Container(
            color: AppColors.background,
            child: SafeArea(
              bottom: false,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Row(children: [
                    const Spacer(),
                    Text('Rize',
                        style: AppTextStyles.h4
                            .copyWith(color: AppColors.white)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.tune,
                          color: AppColors.white, size: 22),
                      onPressed: () {},
                    ),
                  ]),
                ),
                TabBar(
                  controller: _tabCtrl,
                  indicatorColor: AppColors.electricBlue,
                  indicatorWeight: 2.5,
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.grey2,
                  labelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Inter'),
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter'),
                  tabs: const [
                    Tab(text: 'For You'),
                    Tab(text: 'Following'),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.electricBlue,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
