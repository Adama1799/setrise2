// lib/presentation/screens/main_navigation_screen.dart (Updated)
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'set/set_feed_screen.dart';
import 'rize/rize_feed_screen.dart';
import 'live/live_feed_screen.dart';
import 'shop/shop_home_screen.dart';
import 'dating/dating_discover_screen.dart';
import 'music/music_home_screen.dart';
import 'profile/user_profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const SetFeedScreen(),
    const RizeFeedScreen(),
    const LiveFeedScreen(),
    const ShopHomeScreen(),
    const DatingDiscoverScreen(),
    const MusicHomeScreen(),
    const UserProfileScreen(userId: 'me'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Set'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Rize'),
          BottomNavigationBarItem(icon: Icon(Icons.videocam), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Date'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Music'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
