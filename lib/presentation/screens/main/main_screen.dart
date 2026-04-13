// lib/presentation/screens/main/main_screen.dart

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../set/set_screen.dart';
import '../rize/rize_screen.dart';
import '../shop/shop_screen.dart';
import '../dating/dating_screen.dart';
import '../live/live_screen.dart';
import '../music/music_screen.dart';
import '../profile/profile_screen.dart';
import '../messages/messages_screen.dart';
import '../search/search_screen.dart';
import '../alerts/alerts_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  
  // ---------- الحالة الأساسية ----------
  int _contentTab = 0; // 0=Set 1=Rize 2=Shop 3=Date 4=Live 5=Music
  bool _panelOpen = false;
  late AnimationController _panelCtrl;
  late Animation<double> _panelAnim;
  
  // ✅ (1) نظام القفل / Safe Run
  bool _isProcessing = false;
  
  // ✅ (2) سرعة الأنيميشن التكيفية
  DateTime _lastInteractionTime = DateTime.now();
  static const Duration _normalDuration = Duration(milliseconds: 260);
  static const Duration _fastDuration = Duration(milliseconds: 150);
  
  // ✅ (3) PageView Controller
  late PageController _pageController;
  
  static const _tabLabels = ['Set', 'Rize', 'Shop', 'Date', 'Live', 'Music'];

  @override
  void initState() {
    super.initState();
    
    // تهيئة PageController
    _pageController = PageController(initialPage: _contentTab);
    
    // تهيئة AnimationController مع المدة الافتراضية
    _panelCtrl = AnimationController(
      vsync: this,
      duration: _normalDuration,
    );
    _panelAnim = CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOutCubic);
    _panelCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _panelCtrl.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // ✅ (4) دالة آمنة لتنفيذ الأوامر (Safe Run)
  Future<void> _safeRun(Future<void> Function() action) async {
    if (_isProcessing) return;
    _isProcessing = true;
    try {
      await action();
    } finally {
      _isProcessing = false;
    }
  }

  // ✅ (5) تحديث سرعة الأنيميشن بناءً على وقت آخر تفاعل
  void _updateAnimationSpeed() {
    final now = DateTime.now();
    final diff = now.difference(_lastInteractionTime);
    final isFast = diff.inMilliseconds < 200;
    
    _panelCtrl.duration = isFast ? _fastDuration : _normalDuration;
    _lastInteractionTime = now;
  }

  // ✅ (6) فتح/إغلاق البانل مع تأثير زجاجي وسرعة متكيفة
  void _togglePanel() {
    _safeRun(() async {
      _updateAnimationSpeed();
      HapticFeedback.lightImpact();
      if (_panelOpen) {
        await _panelCtrl.reverse();
      } else {
        await _panelCtrl.forward();
      }
      setState(() => _panelOpen = !_panelOpen);
    });
  }

  void _closePanel() {
    if (!_panelOpen) return;
    _safeRun(() async {
      _updateAnimationSpeed();
      await _panelCtrl.reverse();
      setState(() => _panelOpen = false);
    });
  }

  // ✅ (7) بناء المحتوى الرئيسي باستخدام PageView مع إيماءة السحب
  Widget _buildContent() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        if (_contentTab != index) {
          setState(() => _contentTab = index);
        }
        // ✅ إغلاق البانل تلقائياً عند تغيير الصفحة (Panel Conflict Fix)
        _closePanel();
      },
      children: const [
        SetScreen(),
        RizeScreen(),
        ShopScreen(),
        DatingScreen(),
        LiveScreen(),
        MusicScreen(),
      ],
    );
  }

  // ✅ (8) التنقل بين التبويبات مع مزامنة PageView
  void _selectTab(int index) {
    _safeRun(() async {
      if (_contentTab == index) return;
      _updateAnimationSpeed();
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _contentTab = index);
    });
  }

  // ✅ (9) معالجة النقر على الـ Bottom Navigation Bar
  void _onNavTap(int i) {
    _safeRun(() async {
      _closePanel(); // إغلاق البانل أولاً (Panel Conflict Fix)
      
      if (i == 2) {
        _showCreateSheet();
        return;
      }

      // ✅ زر Home (i == 4) يفتح/يغلق البانل بدلاً من العودة لـ Set
      if (i == 4) {
        _togglePanel();
        return;
      }

      final screens = [
        const ProfileScreen(),
        const MessagesScreen(),
        null,
        const AlertsScreen(),
      ];
      final s = i < screens.length ? screens[i] : null;
      if (s != null) {
        // ✅ استخدام انتقال مخصص (Page Transition Controller)
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => s,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 0.03);
              const end = Offset.zero;
              const curve = Curves.easeOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 280),
          ),
        );
      }
    });
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D0D0D),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => _CreateSheet(),
    );
  }

  void _showMenuSheet() {
    _closePanel();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D0D0D),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => _MenuSheet(
        onProfile:  () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())); },
        onMessages: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const MessagesScreen())); },
        onAlerts:   () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const AlertsScreen())); },
        onSearch:   () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())); },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_panelOpen) { _closePanel(); return false; }
        if (_contentTab != 0) { _selectTab(0); return false; }
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(children: [

          // ── 1. المحتوى (PageView مع السحب) ──
          _buildContent(),

          // ── 2. تأثير الزجاج (Glass/Blur) + تعتيم الخلفية ──
          if (_panelAnim.value > 0)
            Positioned.fill(
              child: GestureDetector(
                onTap: _closePanel,
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: 8.0 * _panelAnim.value,
                    sigmaY: 8.0 * _panelAnim.value,
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.35 * _panelAnim.value),
                  ),
                ),
              ),
            ),

          // ── 3. البانل المنسدل مع إمكانية السحب للإغلاق ──
          Positioned(
            top: -320 + (320 * _panelAnim.value),
            left: 0,
            right: 0,
            child: GestureDetector(
              // ✅ السحب العمودي للإغلاق (Drag to Close)
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! > 15) {
                  _closePanel();
                }
              },
              child: _PullDownPanel(
                labels: _tabLabels,
                activeTab: _contentTab,
                onTabSelect: (i) {
                  _selectTab(i);
                  _closePanel();
                },
              ),
            ),
          ),

          // ── 4. TopBar ثابت فوق كل شيء ──
          SafeArea(
            child: _TopBar(
              panelOpen: _panelOpen,
              onSetRizeTap: _togglePanel,
              onMenuTap: _showMenuSheet,
              onSearchTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen())),
            ),
          ),

        ]),

        bottomNavigationBar: _BottomNav(onTap: _onNavTap),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TOP BAR — ☰ SetRize ˅  (يسار) | 🔍 (يمين)
// ══════════════════════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  final bool panelOpen;
  final VoidCallback onSetRizeTap;
  final VoidCallback onMenuTap;
  final VoidCallback onSearchTap;

  const _TopBar({
    required this.panelOpen,
    required this.onSetRizeTap,
    required this.onMenuTap,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: onMenuTap,
            child: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSetRizeTap,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Text(
                'SetRize',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 2),
              AnimatedRotation(
                turns: panelOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 260),
                child: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.white, size: 20),
              ),
            ]),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onSearchTap,
            child: const Icon(Icons.search_rounded, color: Colors.white, size: 26),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PULL-DOWN PANEL
// ✅ تمت إضافة قسم الستوريات (Stories) داخل البانل
// ══════════════════════════════════════════════════════════════════════════════
class _PullDownPanel extends StatelessWidget {
  final List<String> labels;
  final int activeTab;
  final Function(int) onTabSelect;

  const _PullDownPanel({
    required this.labels,
    required this.activeTab,
    required this.onTabSelect,
  });

  // بيانات وهمية للقصص
  static const _storyColors = [
    AppColors.electricBlue, AppColors.neonGreen, AppColors.neonYellow,
    AppColors.cyan, AppColors.neonRed, AppColors.live,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.92),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 44),

            // صف التبويبات
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: List.generate(labels.length, (i) {
                  final active = activeTab == i;
                  return GestureDetector(
                    onTap: () => onTabSelect(i),
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: i < labels.length - 1 ? 10 : 0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            labels[i],
                            style: TextStyle(
                              color: active ? Colors.white : Colors.white54,
                              fontSize: active ? 16 : 15,
                              fontWeight: active ? FontWeight.w800 : FontWeight.w400,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 2,
                            width: active ? 20 : 0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // ✅ قسم الستوريات (Stories) الجديد
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 8,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final color = _storyColors[index % _storyColors.length];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        padding: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(0.6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[850],
                          child: Icon(
                            Icons.person,
                            color: color,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'user_$index',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 40), // فراغ قبل المقبض

            // مقبض السحب (Drag Handle)
            Container(
              width: 32,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// BOTTOM NAV — Profile | Messages | + | Alerts | Home
// ══════════════════════════════════════════════════════════════════════════════
class _BottomNav extends StatelessWidget {
  final Function(int) onTap;
  const _BottomNav({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.07))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.person_rounded, 'Profile'),
              _navItem(1, Icons.chat_bubble_rounded, 'Messages'),
              _createButton(),
              _navItem(3, Icons.notifications_rounded, 'Alerts'),
              _navItem(4, Icons.home_rounded, 'Home'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: AppColors.grey2, size: 26),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: AppColors.grey2, fontSize: 10)),
        ]),
      ),
    );
  }

  Widget _createButton() {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        width: 52,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            '+',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// CREATE SHEET
// ══════════════════════════════════════════════════════════════════════════════
class _CreateSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 40, height: 4,
          decoration: BoxDecoration(
              color: AppColors.grey, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(height: 20),
        Text('Create',
            style: AppTextStyles.h5
                .copyWith(color: AppColors.white, fontWeight: FontWeight.w900)),
        const SizedBox(height: 20),
        _item(context, Icons.videocam_rounded, 'Video', 'Post a short video', AppColors.live),
        _item(context, Icons.image_rounded, 'Photo', 'Share a photo', AppColors.electricBlue),
        _item(context, Icons.mic_rounded, 'Voice Rize', 'Start a voice post', AppColors.neonGreen),
        _item(context, Icons.live_tv_rounded, 'Go Live', 'Start a live stream', AppColors.neonRed),
      ]),
    );
  }

  Widget _item(BuildContext ctx, IconData icon, String title, String sub, Color color) {
    return GestureDetector(
      onTap: () => Navigator.pop(ctx),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.22)),
        ),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
                color: color.withOpacity(0.14), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: AppTextStyles.labelLarge
                    .copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
            Text(sub,
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
          ]),
          const Spacer(),
          Icon(Icons.chevron_right_rounded, color: color.withOpacity(0.5), size: 20),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// MENU SHEET
// ══════════════════════════════════════════════════════════════════════════════
class _MenuSheet extends StatelessWidget {
  final VoidCallback onProfile, onMessages, onAlerts, onSearch;
  const _MenuSheet({
    required this.onProfile,
    required this.onMessages,
    required this.onAlerts,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 40, height: 4,
          decoration: BoxDecoration(
              color: AppColors.grey, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _item(Icons.person_rounded, 'Profile', AppColors.electricBlue, onProfile),
          _item(Icons.chat_bubble_rounded, 'Messages', AppColors.neonGreen, onMessages),
          _item(Icons.notifications_rounded, 'Alerts', AppColors.neonYellow, onAlerts),
          _item(Icons.search_rounded, 'Search', AppColors.cyan, onSearch),
        ]),
        const SizedBox(height: 16),
      ]),
    );
  }

  Widget _item(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.28)),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.white)),
      ]),
    );
  }
}
