// lib/presentation/screens/main/widgets/top_bar.dart

import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final bool panelOpen;
  final VoidCallback onSetRizeTap;
  final VoidCallback onMenuTap;
  final String activeTabName;
  final bool showSearchIcon;
  final VoidCallback? onSearchTap;

  const TopBar({
    super.key,
    required this.panelOpen,
    required this.onSetRizeTap,
    required this.onMenuTap,
    required this.activeTabName,
    this.showSearchIcon = false,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = (activeTabName == 'SetRize') 
        ? 'SetRize' 
        : 'SetRize $activeTabName';

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Row(
        children: [
          // أقصى اليسار: ☰ (يفتح الفلترة)
          GestureDetector(
            onTap: onMenuTap,
            child: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 8),
          // SetRize + سهم
          AnimatedScale(
            scale: panelOpen ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 260),
            child: GestureDetector(
              onTap: onSetRizeTap,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  displayText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 2),
                AnimatedRotation(
                  turns: panelOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 260),
                  child: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.white, size: 20),
                ),
              ]),
            ),
          ),
          const Spacer(),
          // أيقونة البحث تظهر فقط في تبويب SetRize
          if (showSearchIcon && onSearchTap != null)
            GestureDetector(
              onTap: onSearchTap,
              child: const Icon(Icons.search_rounded, color: Colors.white, size: 26),
            ),
        ],
      ),
    );
  }
}
