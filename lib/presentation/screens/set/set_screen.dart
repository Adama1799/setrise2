import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/colors.dart';
import '../widgets/stories_widget.dart';
import 'rize_screen.dart';
import 'music_screen.dart';
import 'shop_screen.dart';
import 'dating_screen.dart';
import 'live_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  int _navIndex = 0;
  int _tabIndex = 0;
  int _currentPage = 0;
  final PageController _feedCtrl = PageController();

  // ===== PULL DOWN PANEL =====
  double _panelOffset = 0;
  bool _panelOpen = false;
  late AnimationController _panelCtrl;
  late Animation<double> _panelAnim;

  @override
  void initState() {
    super.initState();
    _panelCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _panelAnim = CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOutCubic);
    _panelCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _panelCtrl.dispose();
    _feedCtrl.dispose();
    super.dispose();
  }

  void _openPanel() {
    HapticFeedback.lightImpact();
    _panelCtrl.forward();
    setState(() { _panelOpen = true; _panelOffset = 1; });
  }

  void _closePanel() {
    _panelCtrl.reverse();
    setState(() { _panelOpen = false; _panelOffset = 0; });
  }

  void _onVerticalDragUpdate(DragUpdateDetails d) {
    if (d.delta.dy > 0 && !_panelOpen) {
      setState(() => _panelOffset = (_panelOffset + d.delta.dy / 280).clamp(0.0, 1.0));
    } else if (d.delta.dy < 0 && _panelOpen) {
      setState(() => _panelOffset = (_panelOffset + d.delta.dy / 280).clamp(0.0, 1.0));
    }
  }

  void _onVerticalDragEnd(DragEndDetails d) {
    if (_panelOffset > 0.4) { _openPanel(); } else { _closePanel(); }
  }

  final List<Map<String, dynamic>> _posts = List.generate(10, (i) => {
    'username': '@user_$i',
    'title': 'Amazing content title that grabs attention right away',
    'hashtags': '#trending #explore #setrise #viral',
    'likes': (i + 1) * 1200,
    'comments': (i + 1) * 340,
    'shares': (i + 1) * 210,
    'sends': (i + 1) * 100,
    'saves': (i + 1) * 510,
    'isLiked': false,
    'isCommented': false,
    'isShared': false,
    'isSent': false,
    'isSaved': false,
    'isFollowing': false,
    'isPlaying': true,
    'color': [
      const Color(0xFF1A0A2E),
      const Color(0xFF0A1628),
      const Color(0xFF1A0A0A),
      const Color(0xFF0A1A0A),
      const Color(0xFF1A1A0A),
    ][i % 5],
  });

  void _switchTab(int index) => setState(() => _tabIndex = index);

  void _showMenuSheet() {
    showModalBottomSheet(
      context: context, backgroundColor: kWhite, isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _MenuSheet(onApply: () => setState(() {})),
    );
  }

  void _showCommentsSheet(Map post) {
    showModalBottomSheet(
      context: context, backgroundColor: kWhite, isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _CommentsSheet(post: post),
    );
  }

  void _showInfoSheet(Map post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kWhite,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.92,
          builder: (_, ctrl) => SingleChildScrollView(
            controller: ctrl,
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Row(children: [
                CircleAvatar(radius: 28, backgroundColor: Colors.grey.shade200,
                    child: Image.asset(aAvatar, width: 40,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.person, color: kBlack, size: 28))),
                const SizedBox(width: 14),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(post['username'], style: const TextStyle(
                      color: kBlack, fontWeight: FontWeight.bold,
                      fontSize: 16, fontFamily: 'HarmonyOS')),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() => post['isFollowing'] = !post['isFollowing']);
                      setModal(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: post['isFollowing'] ? Colors.grey.shade200 : kBlack,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        post['isFollowing'] ? 'Following ✓' : 'Follow',
                        style: TextStyle(
                            color: post['isFollowing'] ? kBlack : kWhite,
                            fontSize: 13, fontWeight: FontWeight.bold,
                            fontFamily: 'HarmonyOS'),
                      ),
                    ),
                  ),
                ]),
              ]),
              const SizedBox(height: 20),
              Text(post['title'], style: const TextStyle(
                  color: kBlack, fontSize: 16,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'HarmonyOS', height: 1.5)),
              const SizedBox(height: 10),
              Text(post['hashtags'],
                  style: const TextStyle(
                      color: kElectricBlue, fontSize: 14,
                      fontFamily: 'HarmonyOS')),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final panelProgress = _panelOpen ? _panelCtrl.value : _panelOffset;
    final panelHeight = 320.0;

    return Scaffold(
      backgroundColor: kBg,
      body: GestureDetector(
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Stack(children: [

          // ===== FEED =====
          PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _feedCtrl,
            itemCount: _posts.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            physics: _panelOpen ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
            itemBuilder: (_, i) {
              final p = _posts[i];
              return _PostItem(
                post: p,
                onLike: () => setState(() {
                  p['isLiked'] = !p['isLiked'];
                  p['likes'] += p['isLiked'] ? 1 : -1;
                }),
                onComment: () => _showCommentsSheet(p),
                onShare: () => setState(() => p['isShared'] = !p['isShared']),
                onSend: () => setState(() => p['isSent'] = !p['isSent']),
                onFollow: () => setState(() => p['isFollowing'] = !p['isFollowing']),
                onPlayPause: () => setState(() => p['isPlaying'] = !p['isPlaying']),
                onInfo: () => _showInfoSheet(p),
              );
            },
          ),

          // ===== OVERLAY تعتيم =====
          if (panelProgress > 0)
            Positioned.fill(
              child: GestureDetector(
                onTap: _closePanel,
                child: Container(color: Colors.black.withOpacity(0.45 * panelProgress)),
              ),
            ),

          // ===== PANEL اللوحة =====
          Positioned(
            top: -panelHeight + (panelHeight * panelProgress),
            left: 0, right: 0,
            child: Container(
              height: panelHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D0D),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: SafeArea(
                bottom: false,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  // ✅ مساحة كافية تحت الشريط العلوي
                  const SizedBox(height: 56),
                  // التابات داخل اللوحة
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: List.generate(kTabs.length, (i) {
                        final isActive = _tabIndex == i;
                        final tab = kTabs[i];
                        final label = tab['label'] as String;
                        final activeColor = tab['color'] as Color;
                        return GestureDetector(
                          onTap: () {
                            _switchTab(i);
                            _closePanel();
                            Widget? screen;
                            if (label == 'Rize')  screen = const RizeScreen();
                            if (label == 'Music') screen = const MusicScreen();
                            if (label == 'Shop')  screen = const ShopScreen();
                            if (label == 'Date')  screen = const DatingScreen();
                            if (label == 'Live')  screen = const LiveScreen();
                            if (screen != null) {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => screen!));
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            // ✅ تباعد 9px بين الكلمات بدون خلفية
                            margin: const EdgeInsets.only(right: 9),
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Text(label, style: TextStyle(
                              color: isActive ? kWhite : kWhite.withOpacity(0.5),
                              fontSize: 16,
                              fontWeight: isActive ? FontWeight.w900 : FontWeight.w500,
                              fontFamily: 'HarmonyOS',
                            )),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // الستوريات داخل اللوحة
                  const StoriesBar(),
                  const SizedBox(height: 8),
                  Container(width: 40, height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(2)),
                  ),
                ]),
              ),
            ),
          ),

          // ===== TOP BAR ثابت =====
          SafeArea(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(children: [
              GestureDetector(
                onTap: _showMenuSheet,
                child: const Icon(Icons.menu, color: kWhite, size: 26),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _panelOpen ? _closePanel : _openPanel,
                child: Row(children: [
                  const Text('SetRize', style: TextStyle(
                    color: kWhite, fontSize: 18,
                    fontWeight: FontWeight.w900, fontFamily: 'HarmonyOS',
                  )),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _panelOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(Icons.keyboard_arrow_down, color: kWhite, size: 20),
                  ),
                ]),
              ),
            ]),
          )),

          // ===== BOTTOM NAV =====
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.96)],
                ),
              ),
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _nb(aProfileOff, aProfileOn, 'Profile', 0),
                    _nb(aMsgOff, aMsgOn, 'Messages', 1),
                    GestureDetector(
                      onTap: () => setState(() => _navIndex = 2),
                      child: Container(
                        width: 52, height: 34,
                        decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10)),
                        child: const Center(child: Text('+', style: TextStyle(color: kBlack, fontSize: 26, fontWeight: FontWeight.bold))),
                      ),
                    ),
                    _nb(aAlertOff, aAlertOn, 'Alerts', 3),
                    GestureDetector(
                      onTap: () => setState(() => _navIndex = 4),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.search, color: _navIndex == 4 ? kWhite : kGrey2, size: 26),
                        const SizedBox(height: 2),
                        Text('Search', style: TextStyle(color: _navIndex == 4 ? kWhite : kGrey2, fontSize: 10, fontFamily: 'HarmonyOS')),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _nb(String offPath, String onPath, String label, int i) {
    final sel = _navIndex == i;
    return GestureDetector(
      onTap: () => setState(() => _navIndex = i),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Image.asset(sel ? onPath : offPath, width: 26, height: 26, color: sel ? kWhite : kGrey2,
            errorBuilder: (_, __, ___) => Icon(Icons.person, color: sel ? kWhite : kGrey2, size: 26)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: sel ? kWhite : kGrey2, fontSize: 10, fontFamily: 'HarmonyOS')),
      ]),
    );
  }
}

// ===== POST ITEM =====
class _PostItem extends StatefulWidget {
  final Map<String, dynamic> post;
  final VoidCallback onLike, onComment, onShare, onSend, onFollow, onPlayPause, onInfo;
  const _PostItem({required this.post, required this.onLike, required this.onComment,
    required this.onShare, required this.onSend,
    required this.onFollow, required this.onPlayPause, required this.onInfo});
  @override
  State<_PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<_PostItem> with SingleTickerProviderStateMixin {
  bool _showHeart = false;
  late AnimationController _heartCtrl;
  late Animation<double> _heartAnim;

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _heartAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _heartCtrl, curve: Curves.elasticOut));
    _heartCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) setState(() => _showHeart = false);
          _heartCtrl.reset();
        });
      }
    });
  }

  @override
  void dispose() { _heartCtrl.dispose(); super.dispose(); }

  void _triggerHeart() {
    setState(() => _showHeart = true);
    _heartCtrl.forward();
    if (!widget.post['isLiked']) widget.onLike();
  }

  @override
  Widget build(BuildContext context) {
    final isFollowing = widget.post['isFollowing'] as bool;
    return GestureDetector(
      onTap: widget.onPlayPause,
      onDoubleTap: _triggerHeart,
      child: Stack(fit: StackFit.expand, children: [
        Container(color: widget.post['color']),
        if (!widget.post['isPlaying'])
          Center(child: Container(
            width: 70, height: 70,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
            child: const Icon(Icons.play_arrow, color: kWhite, size: 44),
          )),
        Positioned(bottom: 0, left: 0, right: 0, height: 320,
          child: DecoratedBox(decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.95)]),
          )),
        ),
        if (_showHeart)
          Center(child: ScaleTransition(scale: _heartAnim,
            child: const Icon(Icons.favorite, color: kNeonRed, size: 120))),

        // RIGHT ACTIONS
        Positioned(right: 10, bottom: 90,
          child: Column(children: [
            _ab(off: aLikeOff, on: aLikeOn, label: fmt(widget.post['likes']),
                activeColor: kNeonRed, active: widget.post['isLiked'], onTap: widget.onLike),
            _ab(off: aCommentOff, on: aCommentOn, label: fmt(widget.post['comments']),
                activeColor: kWhite, active: widget.post['isCommented'], onTap: widget.onComment),
            // ✅ مثلث بدل مشاركة
            _triangleBtn(
              active: widget.post['isShared'],
              label: fmt(widget.post['shares']),
              onTap: widget.onShare,
            ),
            _ab(off: aSendOff, on: aSendOn, label: fmt(widget.post['sends']),
                activeColor: kNeonGreen, active: widget.post['isSent'], onTap: widget.onSend),
            // ❌ حذف Save
            const SizedBox(height: 6),
            _MusicDisk(),
            const SizedBox(height: 6),
            // ✅ Info button
            GestureDetector(
              onTap: widget.onInfo,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Column(children: [
                  Image.asset(aInfo, width: 28, height: 28, color: kWhite,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.keyboard_arrow_up, color: kWhite, size: 28)),
                  const Text('Info', style: TextStyle(
                      color: kWhite, fontSize: 10, fontFamily: 'HarmonyOS')),
                ]),
              ),
            ),
          ]),
        ),

        // BOTTOM INFO
        Positioned(bottom: 70, left: 12, right: 80,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(radius: 16, backgroundColor: kGrey,
                child: ClipOval(child: Image.asset(aAvatar, width: 32, height: 32,
                  errorBuilder: (_, __, ___) => const Icon(Icons.person, color: kWhite, size: 18)))),
              const SizedBox(width: 8),
              Expanded(child: Text(widget.post['username'],
                style: const TextStyle(color: kWhite, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'HarmonyOS'))),
              if (!isFollowing)
                GestureDetector(
                  onTap: widget.onFollow,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(border: Border.all(color: kWhite, width: 1.5), borderRadius: BorderRadius.circular(6)),
                    child: const Text('Follow', style: TextStyle(color: kWhite, fontSize: 11, fontWeight: FontWeight.w500, fontFamily: 'HarmonyOS')),
                  ),
                ),
            ]),
            const SizedBox(height: 8),
            Text(widget.post['title'],
              style: const TextStyle(color: kWhite, fontSize: 14, fontWeight: FontWeight.w900, height: 1.4, fontFamily: 'HarmonyOS'),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          ]),
        ),
      ]),
    );
  }

  Widget _ab({required String off, required String on, required String label,
    required Color activeColor, required bool active, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(children: [
          Image.asset(active ? on : off, width: 30, height: 30, color: active ? activeColor : kIcon,
            errorBuilder: (_, __, ___) => Icon(Icons.star, color: active ? activeColor : kIcon, size: 30)),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(color: kWhite, fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'HarmonyOS')),
        ]),
      ),
    );
  }

  // ✅ مثلث بدل مشاركة - مثل Vero
  Widget _triangleBtn({required bool active, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 30, height: 30,
            child: CustomPaint(
              painter: _TrianglePainter(
                color: active ? kCyan : kIcon,
                filled: active,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(
              color: kWhite, fontSize: 12,
              fontWeight: FontWeight.w500, fontFamily: 'HarmonyOS')),
        ]),
      ),
    );
  }
}

// ===== TRIANGLE PAINTER =====
class _TrianglePainter extends CustomPainter {
  final Color color;
  final bool filled;

  _TrianglePainter({required this.color, required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter old) =>
      old.color != color || old.filled != filled;
}

class _MusicDisk extends StatefulWidget {
  @override
  State<_MusicDisk> createState() => _MusicDiskState();
}

class _MusicDiskState extends State<_MusicDisk> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() { super.initState(); _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(); }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => RotationTransition(
    turns: _ctrl,
    child: Container(
      width: 36, height: 36,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: kWhite, width: 2), color: kGrey),
      child: ClipOval(child: Image.asset(aMusic, width: 36, height: 36, color: kWhite,
        errorBuilder: (_, __, ___) => const Icon(Icons.music_note, color: kWhite, size: 18))),
    ),
  );
}

// ===== MENU SHEET =====
class _MenuSheet extends StatefulWidget {
  final VoidCallback onApply;
  const _MenuSheet({required this.onApply});
  @override
  State<_MenuSheet> createState() => _MenuSheetState();
}

class _MenuSheetState extends State<_MenuSheet> {
  String? _mood, _category, _sport, _region, _country;
  bool _showCountries = false;
  static const moods = ['😴 Chill','😤 Hyped','😞 Sad','🧘 Focus','💪 Motivated'];
  static const categories = ['💻 Technology','🏛️ Politics','🎬 Movies','🎵 Music','📖 Stories','💰 Business','🎓 Education','😂 Comedy','🍳 Cooking','🎭 Adventure','❤️ Dating','🛍️ Shop','🔴 Live','🌿 Nature','✈️ Travel','🎨 Art'];
  static const sports = ['⚽ Football','🏀 Basketball','🎾 Tennis','🏋️ Fitness','🥊 Boxing','🏊 Swimming','🏃 Running','🚴 Cycling','🎯 E-Sports','🏈 American Football','🏐 Volleyball'];
  static const Map<String, List<String>> regions = {
    '🔥 Trending': ['🇩🇿 Algeria','🇺🇸 USA','🇧🇷 Brazil','🇯🇵 Japan','🇫🇷 France'],
    '🌍 Africa': ['🇩🇿 Algeria','🇹🇳 Tunisia','🇪🇬 Egypt','🇲🇦 Morocco','🇳🇬 Nigeria'],
    '🇪🇺 Europe': ['🇫🇷 France','🇩🇪 Germany','🇬🇧 UK','🇮🇹 Italy','🇪🇸 Spain'],
    '🌎 Americas': ['🇺🇸 USA','🇧🇷 Brazil','🇲🇽 Mexico','🇨🇦 Canada','🇦🇷 Argentina'],
    '🌏 Asia': ['🇸🇦 Saudi Arabia','🇦🇪 UAE','🇯🇵 Japan','🇰🇷 South Korea','🇨🇳 China'],
    '🌊 Oceania': ['🇦🇺 Australia','🇳🇿 New Zealand','🇫🇯 Fiji'],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhite,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          _title('😊 Mood'), const SizedBox(height: 8),
          _chips(moods, _mood, (v) => setState(() => _mood = v)),
          const SizedBox(height: 14),
          _title('🎯 Category'), const SizedBox(height: 8),
          _chips(categories, _category, (v) => setState(() => _category = v)),
          const SizedBox(height: 14),
          _title('🏆 Sports'), const SizedBox(height: 8),
          _chips(sports, _sport, (v) => setState(() => _sport = v)),
          const SizedBox(height: 14),
          _title('🌍 Region'), const SizedBox(height: 8),
          _chips(regions.keys.toList(), _region, (v) { setState(() { _region = v; _country = null; _showCountries = true; }); }),
          if (_showCountries && _region != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('🗺️ $_region', style: const TextStyle(color: kBlack, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'HarmonyOS')),
                const SizedBox(height: 8),
                _chips(regions[_region] ?? [], _country, (v) => setState(() => _country = v)),
              ]),
            ),
          ],
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: GestureDetector(
              onTap: () => setState(() { _mood = _category = _sport = _region = _country = null; _showCountries = false; }),
              child: Container(height: 48, decoration: BoxDecoration(border: Border.all(color: kBlack, width: 1.5), borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('Reset All', style: TextStyle(color: kBlack, fontWeight: FontWeight.bold, fontFamily: 'HarmonyOS')))),
            )),
            const SizedBox(width: 12),
            Expanded(child: GestureDetector(
              onTap: () { widget.onApply(); Navigator.pop(context); },
              child: Container(height: 48, decoration: BoxDecoration(color: kBlack, borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('Apply', style: TextStyle(color: kWhite, fontWeight: FontWeight.bold, fontFamily: 'HarmonyOS')))),
            )),
          ]),
        ]),
      ),
    );
  }

  Widget _title(String t) => Text(t, style: const TextStyle(color: kBlack, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'HarmonyOS'));
  Widget _chips(List<String> items, String? selected, Function(String) onTap) {
    return Wrap(spacing: 6, runSpacing: 6, children: items.map((item) {
      final isSel = selected == item;
      return GestureDetector(
        onTap: () => onTap(item),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: isSel ? kBlack : Colors.grey.shade100, borderRadius: BorderRadius.circular(20), border: Border.all(color: isSel ? kBlack : Colors.grey.shade300)),
          child: Text(item, style: TextStyle(color: isSel ? kWhite : kBlack, fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'HarmonyOS')),
        ),
      );
    }).toList());
  }
}

// ===== COMMENTS SHEET =====
class _CommentsSheet extends StatefulWidget {
  final Map post;
  const _CommentsSheet({required this.post});
  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final _ctrl = TextEditingController();
  final List<Map<String, dynamic>> _comments = [
    {'id':'1','user':'ahmed_99','text':'Amazing! 🔥','time':'2m','likes':24,'isLiked':false,'isOwn':false},
    {'id':'2','user':'sara_x','text':'Love this ❤️','time':'5m','likes':18,'isLiked':false,'isOwn':false},
    {'id':'3','user':'me','text':'My comment ✌️','time':'10m','likes':3,'isLiked':false,'isOwn':true},
  ];
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  void _send() {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() { _comments.add({'id': DateTime.now().toString(), 'user': 'me', 'text': _ctrl.text.trim(), 'time': 'now', 'likes': 0, 'isLiked': false, 'isOwn': true}); _ctrl.clear(); });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: const BoxDecoration(color: kWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(children: [
        const SizedBox(height: 12),
        Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 12),
        Text('${_comments.length} Comments', style: const TextStyle(color: kBlack, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'HarmonyOS')),
        Divider(color: Colors.grey.shade200),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _comments.length,
          itemBuilder: (_, i) {
            final c = _comments[i];
            final isOwn = c['isOwn'] as bool;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CircleAvatar(radius: 18, backgroundColor: isOwn ? kBlack : Colors.grey.shade200,
                  child: Icon(Icons.person, color: isOwn ? kWhite : kBlack, size: 20)),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(c['user'], style: const TextStyle(color: kBlack, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'HarmonyOS')),
                    const SizedBox(width: 6),
                    Text(c['time'], style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                  ]),
                  const SizedBox(height: 4),
                  Text(c['text'], style: const TextStyle(color: kBlack, fontSize: 14, fontFamily: 'HarmonyOS')),
                ])),
              ]),
            );
          },
        )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(color: kWhite, border: Border(top: BorderSide(color: Colors.grey.shade200))),
          child: Row(children: [
            Expanded(child: Container(
              height: 42,
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(21)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(controller: _ctrl, decoration: const InputDecoration(hintText: 'Add a comment...', hintStyle: TextStyle(fontFamily: 'HarmonyOS'), border: InputBorder.none)),
            )),
            const SizedBox(width: 10),
            GestureDetector(onTap: _send,
              child: Container(width: 40, height: 40, decoration: const BoxDecoration(color: kBlack, shape: BoxShape.circle),
                child: const Icon(Icons.send, color: kWhite, size: 18))),
          ]),
        ),
      ]),
    );
  }
}
