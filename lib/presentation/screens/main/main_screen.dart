// lib/presentation/screens/main/main_screen.dart

import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
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
import 'widgets/top_bar.dart';
import 'widgets/bottom_nav.dart';
import 'widgets/pull_down_panel.dart';
import 'widgets/create_sheet.dart';
import 'widgets/profile_menu_sheet.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/filter_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  
  int _contentTab = 0;
  bool _panelOpen = false;
  late AnimationController _panelCtrl;
  late Animation<double> _panelAnim;
  
  bool _isProcessing = false;
  DateTime _lastInteractionTime = DateTime.now();
  static const Duration _normalDuration = Duration(milliseconds: 260);
  static const Duration _fastDuration = Duration(milliseconds: 150);
  
  Brightness _statusBarBrightness = Brightness.light;
  
  static const _tabLabels = ['SetRize', 'News', 'Shop', 'Date', 'Live', 'Music', 'Map'];

  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    7,
    (_) => GlobalKey<NavigatorState>(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
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

  Widget _buildTabNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => _getPageByIndex(index),
        );
      },
    );
  }

  Widget _buildContent() {
    return IndexedStack(
      index: _contentTab,
      children: List.generate(7, (index) => _buildTabNavigator(index)),
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
      case 6: return const MapScreen();
      default: return const SetScreen();
    }
  }

  void _selectTab(int index) {
    _safeRun(() async {
      if (_contentTab == index) return;
      _closePanel();
      setState(() => _contentTab = index);
      _updateStatusBar();
    });
  }

  void _onNavTap(int i) {
    _safeRun(() async {
      _closePanel();
      
      // 2: زر الإضافة (+) - لم يتغير
      if (i == 2) {
        _showCreateSheet();
        return;
      }

      // 4: Home - يرجع للتبويب الرئيسي أو يفتح البانل
      if (i == 4) {
        if (_contentTab == 0) {
          _navigatorKeys[0].currentState?.popUntil((route) => route.isFirst);
          _togglePanel();
        } else {
          HapticFeedback.selectionClick();
          _selectTab(0);
        }
        return;
      }

      // 3: Search - يفتح شاشة البحث
      if (i == 3) {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(builder: (_) => const SearchScreen()),
        );
        return;
      }

      // 0: Messages
      // 1: Notifications (Alerts)
      final screens = [
        const MessagesScreen(),  // index 0
        const AlertsScreen(),    // index 1
        null,                   // index 2 (Create)
        null,                   // index 3 (Search)
        null,                   // index 4 (Home)
      ];
      
      final s = i < screens.length ? screens[i] : null;
      if (s != null) {
        Navigator.of(context, rootNavigator: true).push(
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
      builder: (_) => const CreateSheet(),
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
      builder: (_) => ProfileMenuSheet(
        onViewProfile: () {
          Navigator.pop(context);
          Navigator.of(context, rootNavigator: true).push(
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
      builder: (_) => FilterSheet(onApply: () {
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
          final currentNavigator = _navigatorKeys[_contentTab].currentState;
          if (currentNavigator != null && currentNavigator.canPop()) {
            currentNavigator.pop();
            return false;
          }
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
              left: 0, right: 0,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta! > 15) _closePanel();
                },
                child: PullDownPanel(
                  labels: _tabLabels,
                  activeTab: _contentTab,
                  onTabSelect: (i) { _selectTab(i); _closePanel(); },
                ),
              ),
            ),
            SafeArea(
              child: TopBar(
                panelOpen: _panelOpen,
                onSetRizeTap: _togglePanel,
                onProfileTap: _showProfileMenuSheet,
                activeTabName: _tabLabels[_contentTab],
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
                    width: 140, height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ),
          ]),
          bottomNavigationBar: BottomNav(
            onTap: _onNavTap,
            showAlertBadge: true,
          ),
        ),
      ),
    );
  }
}
