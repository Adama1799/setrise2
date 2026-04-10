import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../rize/rize_screen.dart';
import '../../shop/shop_screen.dart';
import '../../dating/dating_screen.dart';
import '../../live/live_screen.dart';
import '../../music/music_screen.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});
  @override State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  int _selectedTab = 0;

  final List<Map<String, dynamic>> _tabs = const [
    {'label': 'Set',   'color': AppColors.white,   'isPill': true},
    {'label': 'Rize',  'color': AppColors.white,   'isPill': true},
    {'label': 'Shop',  'color': AppColors.shop,    'isPill': false},
    {'label': 'Date',  'color': AppColors.dating,  'isPill': false},
    {'label': 'Live',  'color': AppColors.live,    'isPill': false},
    {'label': 'Music', 'color': AppColors.music,   'isPill': false},
  ];

  void _onTabTap(int index, String label) {
    setState(() => _selectedTab = index);
    Widget? screen;
    if (label == 'Rize')  screen = const RizeScreen();
    if (label == 'Shop')  screen = const ShopScreen();
    if (label == 'Date')  screen = const DatingScreen();
    if (label == 'Live')  screen = const LiveScreen();
    if (label == 'Music') screen = const MusicScreen();
    if (screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen!))
        .then((_) => setState(() => _selectedTab = 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(children: [
        const Icon(Icons.menu, color: AppColors.white, size: 26),
        const SizedBox(width: 12),
        Expanded(child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(_tabs.length, (i) {
              final isActive = _selectedTab == i;
              final tab = _tabs[i];
              final label = tab['label'] as String;
              final isPill = tab['isPill'] as bool;
              final activeColor = tab['color'] as Color;
              return GestureDetector(
                onTap: () => _onTabTap(i, label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding: EdgeInsets.symmetric(horizontal: isActive ? 12.0 : 0.0, vertical: 5),
                  decoration: BoxDecoration(
                    color: isActive ? (isPill ? AppColors.white : activeColor) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10)),
                  child: Text(label, style: AppTextStyles.labelLarge.copyWith(
                    color: isActive && isPill ? AppColors.black : AppColors.white,
                    fontWeight: isActive ? FontWeight.w900 : FontWeight.w600))));
            }),
          ),
        )),
      ]),
    );
  }
}
