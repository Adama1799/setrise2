import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  int _selectedTab = 0;

  final List<Map<String, dynamic>> _tabs = const [
    {'label': 'Set', 'isPill': true, 'color': AppColors.white},
    {'label': 'Rize', 'isPill': true, 'color': AppColors.white},
    {'label': 'Shop', 'isPill': false, 'color': AppColors.shop},
    {'label': 'Date', 'isPill': false, 'color': AppColors.dating},
    {'label': 'Live', 'isPill': false, 'color': AppColors.live},
    {'label': 'Music', 'isPill': false, 'color': AppColors.music},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // TODO: Open menu
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu - Coming soon!')),
              );
            },
            child: const Icon(
              Icons.menu,
              color: AppColors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(_tabs.length, (index) {
                  final isActive = _selectedTab == index;
                  final tab = _tabs[index];
                  final isPill = tab['isPill'] as bool;
                  final activeColor = tab['color'] as Color;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedTab = index);
                      // TODO: Navigate to different tabs
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.only(right: 10),
                      padding: EdgeInsets.symmetric(
                        horizontal: isActive ? 12.0 : 0.0,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? (isPill ? AppColors.white : activeColor)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tab['label'] as String,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: isActive && isPill
                              ? AppColors.black
                              : AppColors.white,
                          fontWeight:
                              isActive ? FontWeight.w900 : FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
