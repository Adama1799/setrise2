// lib/presentation/screens/main/main_screen.dart

import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
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

/// الشاشة الرئيسية للتطبيق - تجربة مستخدم احترافية بمعايير iOS
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  
  // ---------- الحالة الأساسية ----------
  int _contentTab = 0; // 0=Set 1=Rize 2=Shop 3=Date 4=Live 5=Music
  bool _panelOpen = false;
  late AnimationController _panelCtrl;
  late Animation<double> _panelAnim;
  
  // ✅ (1) نظام القفل / Safe Run
  bool _isProcessing = false;
  
  // ✅ (2) سرعة الأنيميشن التكيفية (Adaptive Animation Speed)
  DateTime _lastInteractionTime = DateTime.now();
  static const Duration _normalDuration = Duration(milliseconds: 260);
  static const Duration _fastDuration = Duration(milliseconds: 150);
  
  // ✅ (3) PageView Controller (سحب أفقي بين التبويبات)
  late PageController _pageController;
  
  // ✅ (4) التحكم بحالة شريط الحالة (Smart Status Bar)
  Brightness _statusBarBrightness = Brightness.light;
  
  // ✅ (5) قائمة آخر البحوث (محاكاة)
  static final List<String> _recentSearches = ['Flutter UI', 'iOS Animations', 'Dark Mode'];
  
  static const _tabLabels = ['Set', 'Rize', 'Shop', 'Date', 'Live', 'Music'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _pageController = PageController(initialPage: _contentTab);
    
    _panelCtrl = AnimationController(
      vsync: this,
      duration: _normalDuration,
    );
    _panelAnim = CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOutCubic);
    _panelCtrl.addListener(() => setState(() {}));
    
    // تحديث شريط الحالة بعد بناء الواجهة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateStatusBar();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _panelCtrl.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    _updateStatusBar();
  }

  // تحديث شريط الحالة بناءً على فتح البانل
  void _updateStatusBar() {
    final brightness = _panelOpen ? Brightness.dark : Brightness.light;
    if (_statusBarBrightness != brightness) {
      _statusBarBrightness = brightness;
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: _panelOpen ? Brightness.light : Brightness.dark,
          statusBarBrightness: _panelOpen ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    }
  }

  // ✅ تنفيذ آمن للأوامر (يمنع التداخل)
  Future<void> _safeRun(Future<void> Function() action) async {
    if (_isProcessing) return;
    _isProcessing = true;
    try {
      await action();
    } finally {
      _isProcessing = false;
    }
  }

  // ✅ تحديث سرعة الأنيميشن بناءً على وتيرة المستخدم
  void _updateAnimationSpeed() {
    final now = DateTime.now();
    final diff = now.difference(_lastInteractionTime);
    final isFast = diff.inMilliseconds < 200;
    
    _panelCtrl.duration = isFast ? _fastDuration : _normalDuration;
    _lastInteractionTime = now;
  }

  // ✅ فتح/إغلاق البانل المنسدل مع Haptic
  void _togglePanel() {
    _safeRun(() async {
      _updateAnimationSpeed();
      HapticFeedback.mediumImpact(); // أقوى من lightImpact
      if (_panelOpen) {
        await _panelCtrl.reverse();
      } else {
        await _panelCtrl.forward();
      }
      setState(() {
        _panelOpen = !_panelOpen;
        _updateStatusBar();
      });
    });
  }

  // ✅ إغلاق البانل فقط
  void _closePanel() {
    if (!_panelOpen) return;
    _safeRun(() async {
      _updateAnimationSpeed();
      await _panelCtrl.reverse();
      setState(() {
        _panelOpen = false;
        _updateStatusBar();
      });
    });
  }

  // ✅ المحتوى الرئيسي: PageView مع سحب أفقي (Bouncy Physics) + تأثير Parallax بسيط
  Widget _buildContent() {
    return PageView.builder(
      controller: _pageController,
      physics: const BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.normal,
      ),
      onPageChanged: (index) {
        if (_contentTab != index) {
          setState(() => _contentTab = index);
        }
        _closePanel();
      },
      itemCount: 6,
      itemBuilder: (context, index) {
        // تأثير Parallax: العنصر يتحرك أبطأ قليلاً مع السحب
        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double pageOffset = 0.0;
            if (_pageController.hasClients) {
              pageOffset = _pageController.page! - index;
            }
            return Transform.translate(
              offset: Offset(pageOffset * 20, 0), // حركة خفيفة
              child: child,
            );
          },
          child: _getPageByIndex(index),
        );
      },
    );
  }

  Widget _getPageByIndex(int index) {
    switch (index) {
      case 0: return const SetScreen();
      case 1: return const RizeScreen();
      case 2: return const ShopScreen();
      case 3: return const DatingScreen();
      case 4: return const LiveScreen();
      case 5: return const MusicScreen();
      default: return const SetScreen();
    }
  }

  // ✅ اختيار تبويب مع أنيميشن سلس
  void _selectTab(int index) {
    _safeRun(() async {
      if (_contentTab == index) return;
      _updateAnimationSpeed();
      await _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
      setState(() => _contentTab = index);
    });
  }

  // ✅ النقر على الـ Bottom Navigation Bar
  void _onNavTap(int i) {
    _safeRun(() async {
      _closePanel();
      
      if (i == 2) {
        _showCreateSheet();
        return;
      }

      // ✅ زر Home الذكي (المحسن)
      if (i == 4) {
        if (_contentTab == 0) {
          _togglePanel();
        } else {
          HapticFeedback.selectionClick();
          _selectTab(0);
        }
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
        // ✅ استخدام CupertinoPageRoute لدعم إيماءة الرجوع من اليسار (iOS Swipe Back)
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => s,
            title: '',
          ),
        );
      }
    });
  }

  void _showCreateSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D0D0D),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const _CreateSheet(),
    );
  }

  void _showMenuSheet() {
    _closePanel();
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D0D0D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _MenuSheet(
        onProfile:  () { Navigator.pop(context); Navigator.push(context, CupertinoPageRoute(builder: (_) => const ProfileScreen())); },
        onMessages: () { Navigator.pop(context); Navigator.push(context, CupertinoPageRoute(builder: (_) => const MessagesScreen())); },
        onAlerts:   () { Navigator.pop(context); Navigator.push(context, CupertinoPageRoute(builder: (_) => const AlertsScreen())); },
        onSearch:   () { Navigator.pop(context); Navigator.push(context, CupertinoPageRoute(builder: (_) => const SearchScreen())); },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _panelOpen ? Brightness.light : Brightness.dark,
        statusBarBrightness: _panelOpen ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: WillPopScope(
        onWillPop: () async {
          if (_panelOpen) { _closePanel(); return false; }
          if (_contentTab != 0) { _selectTab(0); return false; }
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
              title: const Text('خروج'),
              content: const Text('هل تريد الخروج من التطبيق؟'),
              actions: [
                CupertinoDialogAction(child: const Text('لا'), onPressed: () => Navigator.pop(ctx, false)),
                CupertinoDialogAction(isDestructiveAction: true, child: const Text('نعم'), onPressed: () => Navigator.pop(ctx, true)),
              ],
            ),
          );
          return shouldExit ?? false;
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: Stack(children: [
            _buildContent(),
  
            // تأثير الزجاج (Glass/Blur) مع تعتيم الخلفية
            if (_panelAnim.value > 0)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closePanel,
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(
                      sigmaX: 12.0 * _panelAnim.value,
                      sigmaY: 12.0 * _panelAnim.value,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.4 * _panelAnim.value),
                    ),
                  ),
                ),
              ),
  
            // البانل المنسدل مع إمكانية السحب للإغلاق
            Positioned(
              top: -340 + (340 * _panelAnim.value),
              left: 0,
              right: 0,
              child: GestureDetector(
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
  
            // TopBar ثابت فوق كل شيء
            SafeArea(
              child: _TopBar(
                panelOpen: _panelOpen,
                onSetRizeTap: _togglePanel,
                onMenuTap: _showMenuSheet,
                onSearchTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => const SearchScreen()),
                ),
                recentSearches: _recentSearches, // لاستخدامها في long press
              ),
            ),
  
            // شريط المؤشر السفلي (Home Indicator) بنمط iOS
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: AnimatedOpacity(
                  opacity: _panelOpen ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 140,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ),
          ]),
  
          bottomNavigationBar: _BottomNav(
            onTap: _onNavTap,
            showAlertBadge: true, // ✅ تفعيل شارة الإشعارات
          ),
        ),
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
  final List<String> recentSearches; // لاستخدامها في الضغط المطول

  const _TopBar({
    required this.panelOpen,
    required this.onSetRizeTap,
    required this.onMenuTap,
    required this.onSearchTap,
    required this.recentSearches,
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
          // تأثير ديناميكي عند فتح/إغلاق البانل (مثل Dynamic Island)
          AnimatedScale(
            scale: panelOpen ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 260),
            child: GestureDetector(
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
          ),
          const Spacer(),
          // أيقونة البحث مع دعم الضغط المطول (Long Press)
          GestureDetector(
            onTap: onSearchTap,
            onLongPress: () {
              HapticFeedback.heavyImpact();
              _showRecentSearchesMenu(context);
            },
            child: const Icon(Icons.search_rounded, color: Colors.white, size: 26),
          ),
        ],
      ),
    );
  }

  void _showRecentSearchesMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(overlay.size.width - 120, 60, 0, 0),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      color: const Color(0xFF1C1C1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      items: [
        for (final search in recentSearches)
          PopupMenuItem<String>(
            value: search,
            child: Row(
              children: [
                const Icon(Icons.history, size: 18, color: Colors.white54),
                const SizedBox(width: 12),
                Text(search, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'clear',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
              SizedBox(width: 12),
              Text('مسح السجل', style: TextStyle(color: Colors.redAccent)),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'clear') {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم مسح سجل البحث'), duration: Duration(seconds: 1)),
        );
      } else if (value != null) {
        // ✅ الإصلاح: تمرير البحث عبر RouteSettings بدلاً من معامل في المُنشئ
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => const SearchScreen(),
            settings: RouteSettings(arguments: value), // يتم استقبالها في SearchScreen عبر ModalRoute
          ),
        );
      }
    });
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PULL-DOWN PANEL
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

            // ✅ مساحة محجوزة للستوريات (جاهزة للإضافة لاحقاً)
            const SizedBox(height: 100),

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
  final bool showAlertBadge;

  const _BottomNav({required this.onTap, this.showAlertBadge = false});

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
              _navItem(3, Icons.notifications_rounded, 'Alerts', showBadge: showAlertBadge),
              _navItem(4, Icons.home_rounded, 'Home'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label, {bool showBadge = false}) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: AppColors.grey2, size: 26),
              if (showBadge)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '3', // يمكن جعله ديناميكي
                        style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
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
          boxShadow: [
            BoxShadow(
              color: AppColors.white.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
  const _CreateSheet();

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
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pop(ctx);
      },
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
