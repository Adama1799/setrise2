import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import 'set/set_screen.dart';
import 'rize/rize_screen.dart';
import 'dating/dating_screen.dart';
import 'live/live_screen.dart';
import 'shop/shop_screen.dart';
import 'music/music_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  DateTime? _lastBackPress;

  // الصفحات الأساسية — Set فقط في الـ IndexedStack
  // باقي التابات تُفتح من شريط السحب العلوي
  final List<Widget> _pages = const [
    SetScreen(),
    RizeScreen(),
    DatingScreen(),
    LiveScreen(),
    ShopScreen(),
    MusicScreen(),
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
        SnackBar(
          content: const Text('Press back again to exit',
              style: TextStyle(fontFamily: 'Inter')),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.grey,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    SystemNavigator.pop();
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
        // ── شريط سفلي جديد: Home | Alerts | + | Messages | Profile ──
        bottomNavigationBar: _BottomBar(
          selectedIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  BOTTOM BAR  —  5 أزرار فقط
// ═══════════════════════════════════════════════════════════════════
class _BottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomBar({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.grey.withOpacity(0.35), width: 0.8),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home
              _BottomBtn(
                icon: Icons.home_rounded,
                label: 'Home',
                active: selectedIndex == 0,
                activeColor: AppColors.white,
                onTap: () => onTap(0),
              ),
              // Alerts
              _BottomBtn(
                icon: Icons.notifications_outlined,
                activeIcon: Icons.notifications_rounded,
                label: 'Alerts',
                active: false,
                activeColor: AppColors.neonYellow,
                badge: 3,
                onTap: () {},
              ),
              // + زر وسط
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 48,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add_rounded,
                      color: AppColors.black, size: 26),
                ),
              ),
              // Messages
              _BottomBtn(
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
                label: 'Messages',
                active: false,
                activeColor: AppColors.electricBlue,
                badge: 2,
                onTap: () {},
              ),
              // Profile
              _BottomBtn(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                active: false,
                activeColor: AppColors.white,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBtn extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool active;
  final Color activeColor;
  final int? badge;
  final VoidCallback onTap;

  const _BottomBtn({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.active,
    required this.activeColor,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  active ? (activeIcon ?? icon) : icon,
                  color: active ? activeColor : AppColors.grey2,
                  size: 26,
                ),
                if (badge != null && badge! > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.neonRed,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$badge',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: active ? activeColor : AppColors.grey2,
                fontSize: 9,
                fontWeight:
                    active ? FontWeight.w700 : FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
