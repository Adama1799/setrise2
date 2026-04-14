// lib/presentation/screens/main/widgets/bottom_nav.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class BottomNav extends StatelessWidget {
  final Function(int) onTap;
  final bool showAlertBadge;

  const BottomNav({super.key, required this.onTap, this.showAlertBadge = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.07))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 0: Messages
              _navItem(0, Icons.chat_bubble_rounded, 'Messages'),
              // 1: Notifications
              _navItem(1, Icons.notifications_rounded, 'Notifications', showBadge: showAlertBadge),
              // 2: Create (+)
              _createButton(),
              // 3: Profile
              _navItem(3, Icons.person_rounded, 'Profile'),
              // 4: Home
              _navItem(4, Icons.home_rounded, 'Home'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label, {bool showBadge = false}) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: AppColors.grey2, size: 26),
              if (showBadge)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '3',
                        style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: AppColors.grey2, fontSize: 10)),
        ]),
      ),
    );
  }

  Widget _createButton() {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        width: 52,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.white.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '+',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}    );
  }
}
