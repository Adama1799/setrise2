import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'set/set_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = const [
    SetScreen(),
    _PlaceholderScreen(title: 'Alerts'),
    _PlaceholderScreen(title: 'Create'),
    _PlaceholderScreen(title: 'Messages'),
    _PlaceholderScreen(title: 'Profile'),
  ];

  void _selectTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.08),
                width: 0.8,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                selected: _selectedIndex == 0,
                onTap: () => _selectTab(0),
              ),
              _NavItem(
                icon: Icons.notifications_none_rounded,
                label: 'Alerts',
                selected: _selectedIndex == 1,
                onTap: () => _selectTab(1),
              ),
              _CreateButton(
                selected: _selectedIndex == 2,
                onTap: () => _selectTab(2),
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Messages',
                selected: _selectedIndex == 3,
                onTap: () => _selectTab(3),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                selected: _selectedIndex == 4,
                onTap: () => _selectTab(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? Colors.white : Colors.white54;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _CreateButton({
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 56,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.black, size: 30),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
