// lib/presentation/screens/main/main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/story_model.dart';
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

  int _contentTab = 0; // 0=Set 1=Rize 2=Date 3=Live 4=Shop 5=Music
  bool _panelOpen = false;
  late AnimationController _panelCtrl;
  late Animation<double> _panelAnim;
  final List<StoryModel> _stories = StoryModel.getMockStories();

  static const _tabs = [
    {'label': 'Set',   'icon': Icons.home_rounded,       'color': AppColors.white},
    {'label': 'Rize',  'icon': Icons.article_rounded,    'color': AppColors.white},
    {'label': 'Date',  'icon': Icons.favorite_rounded,   'color': AppColors.dating},
    {'label': 'Live',  'icon': Icons.live_tv_rounded,    'color': AppColors.live},
    {'label': 'Shop',  'icon': Icons.storefront_rounded, 'color': AppColors.shop},
    {'label': 'Music', 'icon': Icons.music_note_rounded, 'color': AppColors.music},
  ];

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
      case 2: return const DatingScreen();
      case 3: return const LiveScreen();
      case 4: return const ShopScreen();
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
    const panelH = 290.0;
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

          // 2. Dark overlay
          if (_panelAnim.value > 0)
            Positioned.fill(
              child: GestureDetector(
                onTap: _closePanel,
                child: Container(color: Colors.black.withOpacity(0.5 * _panelAnim.value)),
              ),
            ),

          // 3. Pull-down panel
          Positioned(
            top: -panelH + (panelH * _panelAnim.value),
            left: 0, right: 0,
            child: _PullDownPanel(
              stories: _stories,
              tabs: _tabs,
              activeTab: _contentTab,
              onTabSelect: (i) { setState(() => _contentTab = i); _closePanel(); },
            ),
          ),

          // 4. Top bar
          SafeArea(
            child: _TopBar(
              panelOpen: _panelOpen,
              onSetRizeTap: _togglePanel,
              onMenuTap: _showMenuSheet,
            ),
          ),

        ]),
        bottomNavigationBar: _BottomNav(onTap: _onNavTap),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TOP BAR
// ══════════════════════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  final bool panelOpen;
  final VoidCallback onSetRizeTap;
  final VoidCallback onMenuTap;
  const _TopBar({required this.panelOpen, required this.onSetRizeTap, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(children: [
        // ☰
        GestureDetector(
          onTap: onMenuTap,
          child: Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.menu_rounded, color: AppColors.white, size: 22),
          ),
        ),
        const Spacer(),
        // SetRize ˅
        GestureDetector(
          onTap: onSetRizeTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('SetRize',
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.white, fontWeight: FontWeight.w900)),
              const SizedBox(width: 4),
              AnimatedRotation(
                turns: panelOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.white, size: 20),
              ),
            ]),
          ),
        ),
        const Spacer(),
        // 🔍
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SearchScreen())),
          child: Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.search_rounded, color: AppColors.white, size: 22),
          ),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PULL-DOWN PANEL
// ══════════════════════════════════════════════════════════════════════════════
class _PullDownPanel extends StatelessWidget {
  final List<StoryModel> stories;
  final List<Map<String, dynamic>> tabs;
  final int activeTab;
  final Function(int) onTabSelect;
  const _PullDownPanel({
    required this.stories, required this.tabs,
    required this.activeTab, required this.onTabSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [BoxShadow(color: Colors.black87, blurRadius: 24, offset: Offset(0, 10))],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(children: [

          const SizedBox(height: 8),

          // Tabs
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: tabs.length,
              itemBuilder: (_, i) {
                final tab = tabs[i];
                final active = activeTab == i;
                final color = tab['color'] as Color;
                return GestureDetector(
                  onTap: () => onTabSelect(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? color.withOpacity(0.15) : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active ? color.withOpacity(0.55) : Colors.white.withOpacity(0.08),
                        width: active ? 1.5 : 1,
                      ),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(tab['icon'] as IconData,
                          color: active ? color : Colors.white38, size: 14),
                      const SizedBox(width: 6),
                      Text(tab['label'] as String,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: active ? color : Colors.white38,
                          fontWeight: active ? FontWeight.w800 : FontWeight.w400,
                        )),
                    ]),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Stories
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: stories.length,
              itemBuilder: (_, i) => _StoryCard(story: stories[i]),
            ),
          ),

          const SizedBox(height: 6),

          // Handle
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
          ),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// STORY CARD
// ══════════════════════════════════════════════════════════════════════════════
class _StoryCard extends StatelessWidget {
  final StoryModel story;
  const _StoryCard({required this.story});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: story.borderColor, width: 2.2),
        color: AppColors.grey,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(fit: StackFit.expand, children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.grey, Colors.black87],
              ),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white30, size: 38),
          ),
          if (story.isLive)
            Positioned(top: 6, left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.live, borderRadius: BorderRadius.circular(4)),
                child: const Text('LIVE', style: TextStyle(
                    color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
              )),
          Positioned(bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(6, 18, 6, 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.88)],
                ),
              ),
              child: Text(story.username,
                style: const TextStyle(color: Colors.white,
                    fontSize: 9.5, fontWeight: FontWeight.bold),
                maxLines: 1, overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center),
            )),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// BOTTOM NAV  ─  Profile | Messages | [+] | Alerts | Search
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
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.97)],
        ),
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
                      boxShadow: [BoxShadow(
                        color: AppColors.white.withOpacity(0.18), blurRadius: 12)],
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
                      style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.grey2, fontSize: 10)),
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
// MENU SHEET  (زر ☰)
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

