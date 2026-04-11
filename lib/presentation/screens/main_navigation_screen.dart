import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import 'set/set_screen.dart';
import 'rize/rize_screen.dart';
import 'live/live_screen.dart';
import 'shop/shop_screen.dart';
import 'dating/dating_screen.dart';
import 'music/music_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  DateTime? _lastBackPress;

  final List<Widget> _pages = const [
    SetScreen(),
    RizeScreen(),
    LiveScreen(),
    ShopScreen(),
    DatingScreen(),
    MusicScreen(),
  ];

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home_rounded, label: 'Set'),
    _NavItem(icon: Icons.chat_bubble_rounded, label: 'Rize'),
    _NavItem(icon: Icons.live_tv_rounded, label: 'Live'),
    _NavItem(icon: Icons.shopping_bag_rounded, label: 'Shop'),
    _NavItem(icon: Icons.favorite_rounded, label: 'Date'),
    _NavItem(icon: Icons.music_note_rounded, label: 'Music'),
  ];

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() => _selectedIndex = 0);
      return false;
    }
    final now = DateTime.now();
    if (_lastBackPress == null ||
        now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
      _lastBackPress = now;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Press back again to exit',
            style: TextStyle(fontFamily: 'Inter')),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.grey,
      ));
      return false;
    }
    await SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => _onWillPop(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border(
                top: BorderSide(color: AppColors.grey.withOpacity(0.4))),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_navItems.length, (i) {
                  final item = _navItems[i];
                  final isSelected = _selectedIndex == i;
                  final activeColor = _getColor(i);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(item.icon,
                              color:
                                  isSelected ? activeColor : AppColors.grey2,
                              size: isSelected ? 26 : 22),
                          const SizedBox(height: 2),
                          Text(item.label,
                              style: TextStyle(
                                  color: isSelected
                                      ? activeColor
                                      : AppColors.grey2,
                                  fontSize: 9,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  fontFamily: 'Inter')),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(int i) {
    switch (i) {
      case 0: return AppColors.white;
      case 1: return AppColors.electricBlue;
      case 2: return AppColors.live;
      case 3: return AppColors.shop;
      case 4: return AppColors.dating;
      case 5: return AppColors.music;
      default: return AppColors.white;
    }
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
