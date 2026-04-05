import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../set/set_screen.dart';
import '../rize/rize_screen.dart';
import '../profile/profile_screen.dart';
import '../messages/messages_screen.dart';
import '../search/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ProfileScreen(),
    MessagesScreen(),
    SetScreen(),  // Default screen
    SearchScreen(),
    SearchScreen(), // Temporary - will be Notifications later
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.96),
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  label: 'Messages',
                ),
                _buildCreateButton(),
                _buildNavItem(
                  index: 3,
                  icon: Icons.notifications_outlined,
                  activeIcon: Icons.notifications,
                  label: 'Alerts',
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.search,
                  activeIcon: Icons.search,
                  label: 'Search',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? AppColors.white : AppColors.grey2,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: isSelected ? AppColors.white : AppColors.grey2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: () {
        // TODO: Open create post sheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Create post - Coming soon!')),
        );
      },
      child: Container(
        width: 52,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.white.withOpacity(0.2),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '+',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
