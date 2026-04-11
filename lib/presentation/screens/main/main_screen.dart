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
  @override State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _navIndex = 0; // 0=Set 1=Rize 2=Date 3=Live 4=Shop 5=Music

  // Bottom nav tabs: Set Rize Date Live Shop Music
  static const _tabs = [
    {'label': 'Set',   'icon': Icons.home_rounded,       'color': AppColors.white},
    {'label': 'Rize',  'icon': Icons.article_rounded,    'color': AppColors.white},
    {'label': 'Date',  'icon': Icons.favorite_rounded,   'color': AppColors.dating},
    {'label': 'Live',  'icon': Icons.live_tv_rounded,    'color': AppColors.live},
    {'label': 'Shop',  'icon': Icons.storefront_rounded, 'color': AppColors.shop},
    {'label': 'Music', 'icon': Icons.music_note_rounded, 'color': AppColors.music},
  ];

  Widget _buildScreen() {
    switch (_navIndex) {
      case 0: return const SetScreen();
      case 1: return const RizeScreen();
      case 2: return const DatingScreen();
      case 3: return const LiveScreen();
      case 4: return const ShopScreen();
      case 5: return const MusicScreen();
      default: return const SetScreen();
    }
  }

  void _showTopSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _TopSheet(
        onProfile: () { Navigator.pop(context); _pushScreen(const ProfileScreen()); },
        onMessages: () { Navigator.pop(context); _pushScreen(const MessagesScreen()); },
        onAlerts: () { Navigator.pop(context); _pushScreen(const AlertsScreen()); },
        onSearch: () { Navigator.pop(context); _pushScreen(const SearchScreen()); },
      ),
    );
  }

  void _pushScreen(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  void _showCreate() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D0D0D),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => _CreateSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Handle Android back button — never exit app, go to Set tab
    return WillPopScope(
      onWillPop: () async {
        if (_navIndex != 0) {
          setState(() => _navIndex = 0);
          return false; // don't exit
        }
        return false; // never exit app from main screen
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: _buildScreen(),
        bottomNavigationBar: _BottomNav(
          currentIndex: _navIndex,
          tabs: _tabs,
          onTap: (i) => setState(() => _navIndex = i),
          onMenu: _showTopSheet,
          onCreate: _showCreate,
        ),
      ),
    );
  }
}

// ─── Bottom Nav ───────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final List<Map<String, dynamic>> tabs;
  final Function(int) onTap;
  final VoidCallback onMenu;
  final VoidCallback onCreate;

  const _BottomNav({
    required this.currentIndex,
    required this.tabs,
    required this.onTap,
    required this.onMenu,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.95),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Menu (Profile/Messages/Alerts/Search)
              _menuBtn(onMenu),
              // 6 tabs
              ...List.generate(tabs.length, (i) {
                final tab = tabs[i];
                final sel = currentIndex == i;
                final color = tab['color'] as Color;
                return GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: sel ? 36 : 28,
                        height: sel ? 36 : 28,
                        decoration: sel ? BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: color.withOpacity(0.4)),
                        ) : null,
                        child: Icon(
                          tab['icon'] as IconData,
                          color: sel ? color : AppColors.grey2,
                          size: sel ? 20 : 22,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(tab['label'] as String,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: sel ? color : AppColors.grey2,
                          fontWeight: sel ? FontWeight.w800 : FontWeight.w400,
                          fontSize: 9,
                        )),
                    ]),
                  ),
                );
              }),
              // Create +
              _createBtn(onCreate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuBtn(VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.grid_view_rounded, color: AppColors.grey2, size: 22),
        const SizedBox(height: 3),
        Text('More', style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.grey2, fontSize: 9)),
      ]),
    ),
  );

  Widget _createBtn(VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 38, height: 28,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text('+', style: TextStyle(
          color: AppColors.black, fontSize: 22, fontWeight: FontWeight.bold)),
      ),
    ),
  );
}

// ─── Top Sheet (Profile/Messages/Search/Alerts) ───────────────────────────────
class _TopSheet extends StatelessWidget {
  final VoidCallback onProfile, onMessages, onAlerts, onSearch;
  const _TopSheet({
    required this.onProfile, required this.onMessages,
    required this.onAlerts, required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4,
          decoration: BoxDecoration(color: AppColors.grey,
            borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _item(Icons.person_rounded, 'Profile', AppColors.electricBlue, onProfile),
          _item(Icons.chat_bubble_rounded, 'Messages', AppColors.neonGreen, onMessages),
          _item(Icons.notifications_rounded, 'Alerts', AppColors.neonYellow, onAlerts),
          _item(Icons.search_rounded, 'Search', AppColors.cyan, onSearch),
        ]),
      ]),
    );
  }

  Widget _item(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 58, height: 58,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.white)),
      ]),
    );
  }
}

// ─── Create Sheet ─────────────────────────────────────────────────────────────
class _CreateSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4,
          decoration: BoxDecoration(color: AppColors.grey,
            borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        Text('Create', style: AppTextStyles.h5.copyWith(
          color: AppColors.white, fontWeight: FontWeight.w900)),
        const SizedBox(height: 20),
        _item(context, Icons.videocam_rounded, 'Video', 'Post a short video', AppColors.neonRed),
        _item(context, Icons.image_rounded, 'Photo', 'Share a photo', AppColors.electricBlue),
        _item(context, Icons.mic_rounded, 'Voice Rize', 'Start a voice post', AppColors.neonGreen),
        _item(context, Icons.live_tv_rounded, 'Go Live', 'Start a live stream', AppColors.live),
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
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25))),
        child: Row(children: [
          Container(width: 42, height: 42,
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22)),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.white, fontWeight: FontWeight.bold)),
            Text(sub, style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
          ]),
          const Spacer(),
          Icon(Icons.chevron_right_rounded, color: color.withOpacity(0.6), size: 20),
        ]),
      ),
    );
  }
}
