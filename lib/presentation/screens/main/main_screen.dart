// lib/presentation/screens/main/main_screen.dart

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

  int _contentTab = 0; // 0=Set 1=Rize 2=Shop 3=Date 4=Live 5=Music
  bool _panelOpen = false;
  late AnimationController _panelCtrl;
  late Animation<double> _panelAnim;

  static const _tabLabels = ['Set', 'Rize', 'Shop', 'Date', 'Live', 'Music'];

  @override
  void initState() {
    super.initState();
    _panelCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _panelAnim = CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOutCubic);
    _panelCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _panelCtrl.dispose();
    super.dispose();
  }

  void _togglePanel() {
    HapticFeedback.lightImpact();
    _panelOpen ? _panelCtrl.reverse() : _panelCtrl.forward();
    setState(() => _panelOpen = !_panelOpen);
  }

  void _closePanel() {
    if (!_panelOpen) return;
    _panelCtrl.reverse();
    setState(() => _panelOpen = false);
  }

  Widget _buildContent() {
    switch (_contentTab) {
      case 0: return const SetScreen();
      case 1: return const RizeScreen();
      case 2: return const ShopScreen();
      case 3: return const DatingScreen();
      case 4: return const LiveScreen();
      case 5: return const MusicScreen();
      default: return const SetScreen();
    }
  }

  void _onNavTap(int i) {
    _closePanel();
    if (i == 2) { _showCreateSheet(); return; }
    final screens = [
      const ProfileScreen(),
      const MessagesScreen(),
      null,
      const AlertsScreen(),
      const SearchScreen(),
    ];
    final s = screens[i];
    if (s != null) Navigator.push(context, MaterialPageRoute(builder: (_) => s));
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
    // Panel height: text tabs only
    const panelH = 90.0;

    return WillPopScope(
      onWillPop: () async {
        if (_panelOpen) { _closePanel(); return false; }
        if (_contentTab != 0) { setState(() => _contentTab = 0); return false; }
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(children: [

          // 1. Content
          _buildContent(),

          // 2. Dark overlay when panel open
          if (_panelAnim.value > 0)
            Positioned.fill(
              child: GestureDetector(
                onTap: _closePanel,
                child: Container(color: Colors.black.withOpacity(0.45 * _panelAnim.value)),
              ),
            ),

          // 3. Pull-down panel — text words only, no icons
          Positioned(
            top: -panelH + (panelH * _panelAnim.value),
            left: 0, right: 0,
            child: _PullDownPanel(
              labels: _tabLabels,
              activeTab: _contentTab,
              onTabSelect: (i) {
                setState(() => _contentTab = i);
                _closePanel();
              },
            ),
          ),

          // 4. Top bar — pushed to very top
          SafeArea(
            child: _TopBar(
              panelOpen: _panelOpen,
              onSetRizeTap: _togglePanel,
              onMenuTap: _showMenuSheet,
              onSearchTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const SearchScreen())),
            ),
          ),

        ]),
        bottomNavigationBar: _BottomNav(onTap: _onNavTap),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TOP BAR — ☰ SetRize (far left together) | 🔍 (far right)
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
      // Push to very top — minimal vertical padding
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Row(
        children: [

          // ☰ — far left
          GestureDetector(
            onTap: _showMenuSheet(context),
            child: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
          ),

          const SizedBox(width: 8),

          // SetRize ˅ — right next to ☰
          GestureDetector(
            onTap: onSetRizeTap,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(
                'SetRize',
                style: const TextStyle(
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

          // 🔍 — far right
          GestureDetector(
            onTap: onSearchTap,
            child: const Icon(Icons.search_rounded, color: Colors.white, size: 26),
          ),

        ],
      ),
    );
  }

  // Returns a no-op tap handler; menu is handled in parent via onMenuTap
  VoidCallback _showMenuSheet(BuildContext context) => onMenuTap;
}

// ══════════════════════════════════════════════════════════════════════════════
// PULL-DOWN PANEL — plain text words, 10px gap, TikTok style
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
      height: 90,
      color: Colors.black.withOpacity(0.92),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 6),

            // Text-only tab row — like TikTok
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: List.generate(labels.length, (i) {
                  final active = activeTab == i;
                  return GestureDetector(
                    onTap: () => onTabSelect(i),
                    child: Padding(
                      // 10px gap between words
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
                          // Active underline — like TikTok
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

            const SizedBox(height: 6),

            // Drag handle
            Container(
              width: 32, height: 3,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// BOTTOM NAV
// ══════════════════════════════════════════════════════════════════════════════
class _BottomNav extends StatelessWidget {
  final Function(int) onTap;
  const _BottomNav({required this.onTap});

  static const _items = [
    {'icon': Icons.person_rounded,        'label': 'Profile'},
    {'icon': Icons.chat_bubble_rounded,   'label': 'Messages'},
    {'icon': null,                        'label': 'Create'},
    {'icon': Icons.notifications_rounded, 'label': 'Alerts'},
    {'icon': Icons.search_rounded,        'label': 'Search'},
  ];

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
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final isCreate = item['icon'] == null;

              if (isCreate) {
                return GestureDetector(
                  onTap: () => onTap(i),
                  child: Container(
                    width: 52, height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: Text('+',
                      style: TextStyle(color: AppColors.black,
                          fontSize: 24, fontWeight: FontWeight.bold, height: 1.1))),
                  ),
                );
              }

              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(item['icon'] as IconData, color: AppColors.grey2, size: 26),
                    const SizedBox(height: 2),
                    Text(item['label'] as String,
                      style: TextStyle(color: AppColors.grey2, fontSize: 10)),
                  ]),
                ),
              );
            }),
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
        Container(width: 40, height: 4,
          decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        Text('Create', style: AppTextStyles.h5.copyWith(
            color: AppColors.white, fontWeight: FontWeight.w900)),
        const SizedBox(height: 20),
        _item(context, Icons.videocam_rounded,  'Video',      'Post a short video',   AppColors.live),
        _item(context, Icons.image_rounded,     'Photo',      'Share a photo',        AppColors.electricBlue),
        _item(context, Icons.mic_rounded,       'Voice Rize', 'Start a voice post',   AppColors.neonGreen),
        _item(context, Icons.live_tv_rounded,   'Go Live',    'Start a live stream',  AppColors.neonRed),
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
          Container(width: 42, height: 42,
            decoration: BoxDecoration(color: color.withOpacity(0.14), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22)),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.white, fontWeight: FontWeight.bold)),
            Text(sub, style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
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
    required this.onProfile, required this.onMessages,
    required this.onAlerts, required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4,
          decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _item(Icons.person_rounded,        'Profile',  AppColors.electricBlue, onProfile),
          _item(Icons.chat_bubble_rounded,   'Messages', AppColors.neonGreen,    onMessages),
          _item(Icons.notifications_rounded, 'Alerts',   AppColors.neonYellow,   onAlerts),
          _item(Icons.search_rounded,        'Search',   AppColors.cyan,         onSearch),
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
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.white)),
      ]),
    );
  }
}
