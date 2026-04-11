import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../set/set_screen.dart';
import '../profile/profile_screen.dart';
import '../messages/messages_screen.dart';
import '../search/search_screen.dart';
import '../alerts/alerts_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; // Start with SET

  final List<Widget> _screens = const [
    ProfileScreen(),
    MessagesScreen(),
    SetScreen(),
    AlertsScreen(),
    SearchScreen(),
  ];

  void _showCreateSheet() {
    showModalBottomSheet(context: context,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text('Create', style: AppTextStyles.h5.copyWith(color: AppColors.white, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          _createItem(Icons.videocam_outlined, 'Video', 'Post a short video', AppColors.neonRed),
          _createItem(Icons.image_outlined, 'Photo', 'Share a photo', AppColors.electricBlue),
          _createItem(Icons.mic_outlined, 'Voice Rize', 'Start a voice post', AppColors.neonGreen),
          _createItem(Icons.live_tv_outlined, 'Go Live', 'Start a live stream', AppColors.live),
        ])));
  }

  Widget _createItem(IconData icon, String title, String subtitle, Color color) {
    return GestureDetector(onTap: () => Navigator.pop(context),
      child: Container(margin: const EdgeInsets.only(bottom: 12),
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
            Text(title, style: AppTextStyles.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
            Text(subtitle, style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
          ]),
          const Spacer(),
          Icon(Icons.chevron_right, color: color.withOpacity(0.6), size: 20),
        ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.97)])),
        child: SafeArea(top: false, child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _navItem(0, Icons.person_outline, Icons.person, 'Profile'),
            _navItem(1, Icons.chat_bubble_outline, Icons.chat_bubble, 'Messages'),
            _createBtn(),
            _navItem(3, Icons.notifications_outlined, Icons.notifications, 'Alerts'),
            _navItem(4, Icons.search, Icons.search, 'Search'),
          ]),
        )),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final sel = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(sel ? activeIcon : icon, color: sel ? AppColors.white : AppColors.grey2, size: 26),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.labelSmall.copyWith(
          color: sel ? AppColors.white : AppColors.grey2)),
      ]));
  }

  Widget _createBtn() => GestureDetector(
    onTap: _showCreateSheet,
    child: Container(width: 52, height: 34,
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: AppColors.white.withOpacity(0.2), blurRadius: 10)]),
      child: const Center(child: Text('+', style: TextStyle(color: AppColors.black, fontSize: 26, fontWeight: FontWeight.bold)))));
}
