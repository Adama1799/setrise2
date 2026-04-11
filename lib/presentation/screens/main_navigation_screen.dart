import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'set/set_screen.dart';
import 'rize/rize_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  DateTime? _lastBackPress;

  late final List<Widget> _pages = const [
    SetScreen(),
    RizeScreen(),
    _FeaturePlaceholderScreen(
      title: 'Live',
      subtitle: 'بث مباشر، غرف، ومشاهدة فورية',
      icon: Icons.videocam_rounded,
    ),
    _FeaturePlaceholderScreen(
      title: 'Shop',
      subtitle: 'متجر سريع وبطاقات منتجات',
      icon: Icons.shopping_bag_rounded,
    ),
    _FeaturePlaceholderScreen(
      title: 'Date',
      subtitle: 'مطابقة وتعارف بشكل نظيف',
      icon: Icons.favorite_rounded,
    ),
    _FeaturePlaceholderScreen(
      title: 'Music',
      subtitle: 'موسيقى ومقاطع صوتية',
      icon: Icons.music_note_rounded,
    ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اضغط رجوع مرة ثانية للخروج')),
      );
      return false;
    }

    SystemNavigator.pop();
    return false;
  }

  void _select(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D0D),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.45),
                  blurRadius: 18,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Set',
                  selected: _selectedIndex == 0,
                  onTap: () => _select(0),
                ),
                _NavItem(
                  icon: Icons.short_text_rounded,
                  label: 'Rize',
                  selected: _selectedIndex == 1,
                  onTap: () => _select(1),
                ),
                _NavItem(
                  icon: Icons.live_tv_rounded,
                  label: 'Live',
                  selected: _selectedIndex == 2,
                  onTap: () => _select(2),
                ),
                _NavItem(
                  icon: Icons.shopping_bag_rounded,
                  label: 'Shop',
                  selected: _selectedIndex == 3,
                  onTap: () => _select(3),
                ),
                _NavItem(
                  icon: Icons.favorite_rounded,
                  label: 'Date',
                  selected: _selectedIndex == 4,
                  onTap: () => _select(4),
                ),
                _NavItem(
                  icon: Icons.music_note_rounded,
                  label: 'Music',
                  selected: _selectedIndex == 5,
                  onTap: () => _select(5),
                ),
              ],
            ),
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
    final fg = selected ? AppColors.white : AppColors.grey2;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: selected ? Colors.white10 : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: fg, size: 23),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturePlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _FeaturePlaceholderScreen({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF101010),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 58, color: AppColors.white),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
