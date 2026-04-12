import 'package:flutter/material.dart';
import '../widgets/post/create_post_bottom_sheet.dart';
import 'set/set_feed_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentPageIndex = 0;

  List<Widget> get _pages => const [
        SetFeedScreen(),
        _PlaceholderScreen(
          title: 'Notifications',
          subtitle: 'Your alerts will appear here.',
          icon: Icons.notifications_none_rounded,
        ),
        _PlaceholderScreen(
          title: 'Messages',
          subtitle: 'Your chats will appear here.',
          icon: Icons.chat_bubble_outline_rounded,
        ),
        _PlaceholderScreen(
          title: 'Profile',
          subtitle: 'Your profile will appear here.',
          icon: Icons.person_outline_rounded,
        ),
      ];

  int get _bottomNavIndex {
    if (_currentPageIndex < 2) return _currentPageIndex;
    return _currentPageIndex + 1;
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      _openCreatePostSheet();
      return;
    }

    setState(() {
      _currentPageIndex = index < 2 ? index : index - 1;
    });
  }

  void _openCreatePostSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreatePostBottomSheet(
        onPost: (content, mediaUrls) {
          // اربطها هنا مع provider الخاص بالنشر إذا أردت
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentPageIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottomNavIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF0F0F10),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_rounded),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PlaceholderScreen({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0C),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 64, color: Colors.white70),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
