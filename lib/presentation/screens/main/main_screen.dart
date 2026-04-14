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
import '../map/map_screen.dart';
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

// ===== بيانات الفلترة =====
const Map<String, List<String>> kRegions = {
  '🔥 Trending': ['🇩🇿 Algeria','🇺🇸 USA','🇧🇷 Brazil','🇯🇵 Japan','🇫🇷 France','🇸🇦 Saudi Arabia'],
  '🌍 Africa': ['🇩🇿 Algeria','🇹🇳 Tunisia','🇪🇬 Egypt','🇲🇦 Morocco','🇳🇬 Nigeria','🇰🇪 Kenya','🇿🇦 South Africa','🇬🇭 Ghana','🇸🇳 Senegal','🇪🇹 Ethiopia','🇹🇿 Tanzania','🇺🇬 Uganda','🇨🇲 Cameroon','🇨🇮 Ivory Coast','🇱🇾 Libya','🇸🇩 Sudan','🇲🇿 Mozambique','🇦🇴 Angola'],
  '🇪🇺 Europe': ['🇫🇷 France','🇩🇪 Germany','🇬🇧 UK','🇮🇹 Italy','🇪🇸 Spain','🇳🇱 Netherlands','🇵🇹 Portugal','🇷🇺 Russia','🇧🇪 Belgium','🇨🇭 Switzerland','🇸🇪 Sweden','🇳🇴 Norway','🇩🇰 Denmark','🇵🇱 Poland','🇺🇦 Ukraine','🇬🇷 Greece','🇦🇹 Austria','🇨🇿 Czech Republic','🇷🇴 Romania','🇭🇺 Hungary','🇫🇮 Finland'],
  '🌎 Americas': ['🇺🇸 USA','🇧🇷 Brazil','🇲🇽 Mexico','🇨🇦 Canada','🇦🇷 Argentina','🇨🇴 Colombia','🇨🇱 Chile','🇵🇪 Peru','🇻🇪 Venezuela','🇨🇺 Cuba','🇩🇴 Dominican Republic','🇵🇦 Panama','🇪🇨 Ecuador','🇧🇴 Bolivia','🇺🇾 Uruguay','🇵🇾 Paraguay','🇬🇹 Guatemala','🇭🇳 Honduras'],
  '🌏 Asia': ['🇸🇦 Saudi Arabia','🇦🇪 UAE','🇯🇵 Japan','🇰🇷 South Korea','🇨🇳 China','🇮🇳 India','🇹🇷 Turkey','🇮🇩 Indonesia','🇵🇰 Pakistan','🇧🇩 Bangladesh','🇹🇭 Thailand','🇻🇳 Vietnam','🇲🇾 Malaysia','🇵🇭 Philippines','🇮🇶 Iraq','🇸🇾 Syria','🇱🇧 Lebanon','🇯🇴 Jordan','🇮🇷 Iran','🇰🇼 Kuwait','🇶🇦 Qatar','🇧🇭 Bahrain','🇴🇲 Oman','🇾🇪 Yemen','🇦🇫 Afghanistan','🇰🇿 Kazakhstan','🇺🇿 Uzbekistan'],
  '🌊 Oceania': ['🇦🇺 Australia','🇳🇿 New Zealand','🇫🇯 Fiji','🇵🇬 Papua New Guinea','🇸🇧 Solomon Islands','🇼🇸 Samoa'],
};

const List<String> kCategories = ['💻 Technology','🏛️ Politics','🎬 Movies','🎵 Music','📖 Stories','💰 Business','🎓 Education','😂 Comedy','🍳 Cooking','🎭 Adventure','❤️ Dating','🛍️ Shop','🔴 Live','🌿 Nature','✈️ Travel','🎨 Art'];
const List<String> kSports     = ['⚽ Football','🏀 Basketball','🎾 Tennis','🏋️ Fitness','🥊 Boxing','🏊 Swimming','🏃 Running','🚴 Cycling','🎯 E-Sports','🏈 American Football','🏐 Volleyball','⚾ Baseball','🏒 Hockey','🎱 Billiards','🥋 Martial Arts'];
const List<String> kMoods      = ['😴 Chill','😤 Hyped','😞 Sad','🧘 Focus','💪 Motivated'];

class FilterState {
  static String? mood, category, sport, region, country;
  static void reset() => mood = category = sport = region = country = null;
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  
  int _contentTab = 0; // 0=SetRize 1=News 2=Shop 3=Date 4=Live 5=Music 6=Map
  bool _panelOpen = false;
  late AnimationController _panelCtrl;
  late Animation<double> _panelAnim;
  
  bool _isProcessing = false;
  DateTime _lastInteractionTime = DateTime.now();
  static const Duration _normalDuration = Duration(milliseconds: 260);
  static const Duration _fastDuration = Duration(milliseconds: 150);
  
  late PageController _pageController;
  Brightness _statusBarBrightness = Brightness.light;
  
  static const _tabLabels = ['SetRize', 'News', 'Shop', 'Date', 'Live', 'Music', 'Map'];

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

  Future<void> _safeRun(Future<void> Function() action) async {
    if (_isProcessing) return;
    _isProcessing = true;
    try {
      await action();
    } finally {
      _isProcessing = false;
    }
  }

  void _updateAnimationSpeed() {
    final now = DateTime.now();
    final diff = now.difference(_lastInteractionTime);
    final isFast = diff.inMilliseconds < 200;
    
    _panelCtrl.duration = isFast ? _fastDuration : _normalDuration;
    _lastInteractionTime = now;
  }

  void _togglePanel() {
    _safeRun(() async {
      _updateAnimationSpeed();
      HapticFeedback.mediumImpact();
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
      itemCount: 7,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double pageOffset = 0.0;
            if (_pageController.hasClients) {
              pageOffset = _pageController.page! - index;
            }
            return Transform.translate(
              offset: Offset(pageOffset * 20, 0),
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
      case 1: return const RizeScreen();   // News
      case 2: return const ShopScreen();
      case 3: return const DatingScreen();
      case 4: return const LiveScreen();
      case 5: return const MusicScreen();
      case 6: return const MapScreen();
      default: return const SetScreen();
    }
  }

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
}

  // ✅ تابع _MainScreenState
  void _onNavTap(int i) {
    _safeRun(() async {
      _closePanel();
      
      if (i == 2) { // زر الإضافة (+)
        _showCreateSheet();
        return;
      }

      if (i == 0) { // Home
        if (_contentTab == 0) {
          _togglePanel();
        } else {
          HapticFeedback.selectionClick();
          _selectTab(0);
        }
        return;
      }

      if (i == 1) { // Search
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => const SearchScreen()),
        );
        return;
      }

      // i == 3 -> Notifications (Alerts)
      // i == 4 -> Messages
      final screens = [
        null, // Home
        null, // Search
        null, // Create
        const AlertsScreen(),    // index 3
        const MessagesScreen(),  // index 4
      ];
      final s = i < screens.length ? screens[i] : null;
      if (s != null) {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => s),
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

  void _showProfileMenuSheet() {
    _closePanel();
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ProfileMenuSheet(
        onViewProfile: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (_) => const ProfileScreen()),
          );
        },
        onFilter: () {
          Navigator.pop(context);
          _showFilterSheet();
        },
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _FilterSheet(onApply: () {
        setState(() {});
      }),
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
  
            SafeArea(
              child: _TopBar(
                panelOpen: _panelOpen,
                onSetRizeTap: _togglePanel,
                onProfileTap: _showProfileMenuSheet,
              ),
            ),
  
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
            showAlertBadge: true,
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TOP BAR — 🧑 SetRize ˅  |  (يمين فارغ)
// ══════════════════════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  final bool panelOpen;
  final VoidCallback onSetRizeTap;
  final VoidCallback onProfileTap;

  const _TopBar({
    required this.panelOpen,
    required this.onSetRizeTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Row(
        children: [
          // أقصى اليسار: دائرة بروفايل
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 8),
          // SetRize + سهم
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
          // أقصى اليمين: فارغ تماماً
        ],
      ),
    );
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
            const SizedBox(height: 100), // مساحة الستوريات
            const SizedBox(height: 40),
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
// BOTTOM NAV — Home | Search | + | Notifications | Messages
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
              _navItem(0, Icons.home_rounded, 'Home'),
              _navItem(1, Icons.search_rounded, 'Search'),
              _createButton(),
              _navItem(3, Icons.notifications_rounded, 'Notifications', showBadge: showAlertBadge),
              _navItem(4, Icons.chat_bubble_rounded, 'Messages'),
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
                        '3',
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
// PROFILE MENU SHEET (بروفايل + فلترة)
// ══════════════════════════════════════════════════════════════════════════════
class _ProfileMenuSheet extends StatelessWidget {
  final VoidCallback onViewProfile;
  final VoidCallback onFilter;

  const _ProfileMenuSheet({
    required this.onViewProfile,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.electricBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: AppColors.electricBlue, size: 28),
            ),
            title: const Text('View Profile', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('See your posts and activity'),
            onTap: onViewProfile,
          ),
          const Divider(height: 32),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.filter_list, color: AppColors.neonGreen, size: 28),
            ),
            title: const Text('Content Filter', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Filter by mood, region, and more'),
            onTap: onFilter,
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// FILTER SHEET
// ══════════════════════════════════════════════════════════════════════════════
class _FilterSheet extends StatefulWidget {
  final VoidCallback onApply;
  const _FilterSheet({required this.onApply});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  String? _mood, _category, _sport, _region, _country;
  bool _showCountries = false;

  @override
  void initState() {
    super.initState();
    _mood     = FilterState.mood;
    _category = FilterState.category;
    _sport    = FilterState.sport;
    _region   = FilterState.region;
    _country  = FilterState.country;
    _showCountries = _region != null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),

          _title('😊 Mood'),
          const SizedBox(height: 8),
          _chips(kMoods, _mood, (v) => setState(() => _mood = v)),
          const SizedBox(height: 16),

          _title('🎯 Category'),
          const SizedBox(height: 8),
          _chips(kCategories, _category, (v) => setState(() => _category = v)),
          const SizedBox(height: 16),

          _title('🏆 Sports'),
          const SizedBox(height: 8),
          _chips(kSports, _sport, (v) => setState(() => _sport = v)),
          const SizedBox(height: 16),

          _title('🌍 Region & Country'),
          const SizedBox(height: 8),
          _chips(kRegions.keys.toList(), _region, (v) {
            setState(() { _region = v; _country = null; _showCountries = true; });
          }),

          if (_showCountries && _region != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('🗺️ $_region', style: const TextStyle(
                    color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _chips(kRegions[_region] ?? [], _country,
                        (v) => setState(() => _country = v)),
              ]),
            ),
          ],

          const SizedBox(height: 24),

          Row(children: [
            Expanded(child: GestureDetector(
              onTap: () {
                setState(() {
                  _mood = _category = _sport = _region = _country = null;
                  _showCountries = false;
                });
                FilterState.reset();
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('Reset All',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
              ),
            )),
            const SizedBox(width: 12),
            Expanded(child: GestureDetector(
              onTap: () {
                FilterState.mood     = _mood;
                FilterState.category = _category;
                FilterState.sport    = _sport;
                FilterState.region   = _region;
                FilterState.country  = _country;
                widget.onApply();
                Navigator.pop(context);
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                    color: Colors.black, borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('Apply',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ),
            )),
          ]),
        ]),
      ),
    );
  }

  Widget _title(String t) => Text(t,
      style: const TextStyle(color: Colors.black, fontSize: 14,
          fontWeight: FontWeight.bold));

  Widget _chips(List<String> items, String? selected, Function(String) onTap) {
    return Wrap(
      spacing: 6, runSpacing: 6,
      children: items.map((item) {
        final isSel = selected == item;
        return GestureDetector(
          onTap: () => onTap(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
                color: isSel ? Colors.black : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isSel ? Colors.black : Colors.grey.shade300)),
            child: Text(item, style: TextStyle(
                color: isSel ? Colors.white : Colors.black,
                fontSize: 12, fontWeight: FontWeight.w500)),
          ),
        );
      }).toList(),
    );
  }
}
