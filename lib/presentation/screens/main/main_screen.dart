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
  
  late PageController _pageController;
  Brightness _statusBarBrightness = Brightness.light;
  
  static const _tabLabels = ['SetRize', 'News', 'Shop', 'Date', 'Live', 'Music', 'Map'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController(initialPage: _contentTab);
    _panelCtrl = AnimationController(vsync: this, duration: _normalDuration);
    _panelAnim = CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOutCubic);
    _panelCtrl.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateStatusBar());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _panelCtrl.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _updateStatusBar() { /* ... بدون تغيير ... */ }

  Future<void> _safeRun(Future<void> Function() action) async { /* ... بدون تغيير ... */ }

  void _updateAnimationSpeed() { /* ... بدون تغيير ... */ }

  void _togglePanel() { /* ... بدون تغيير ... */ }

  void _closePanel() { /* ... بدون تغيير ... */ }

  Widget _buildContent() { /* ... بدون تغيير ... */ }

  Widget _getPageByIndex(int index) { /* ... بدون تغيير ... */ }

  void _selectTab(int index) { /* ... بدون تغيير ... */ }

  void _onNavTap(int i) { /* ... بدون تغيير ... */ }

  void _showCreateSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D0D0D),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => ProfileMenuSheet(
        onViewProfile: () {
          Navigator.pop(context);
          Navigator.push(context, CupertinoPageRoute(builder: (_) => const ProfileScreen()));
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => FilterSheet(onApply: () => setState(() {})),
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
        onWillPop: () async { /* ... بدون تغيير ... */ },
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
                    filter: ui.ImageFilter.blur(sigmaX: 12.0 * _panelAnim.value, sigmaY: 12.0 * _panelAnim.value),
                    child: Container(color: Colors.black.withOpacity(0.4 * _panelAnim.value)),
                  ),
                ),
              ),
            Positioned(
              top: -340 + (340 * _panelAnim.value),
              left: 0, right: 0,
              child: GestureDetector(
                onVerticalDragUpdate: (details) { if (details.primaryDelta! > 15) _closePanel(); },
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
                  child: Container(width: 140, height: 5, decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(100))),
                ),
              ),
            ),
          ]),
          bottomNavigationBar: BottomNav(onTap: _onNavTap, showAlertBadge: true),
        ),
      ),
    );
  }
}
