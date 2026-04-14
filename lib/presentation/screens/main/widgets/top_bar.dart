// lib/presentation/screens/main/widgets/top_bar.dart

import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final bool panelOpen;
  final VoidCallback onSetRizeTap;
  final VoidCallback onProfileTap;
  final String activeTabName;

  const TopBar({
    super.key,
    required this.panelOpen,
    required this.onSetRizeTap,
    required this.onProfileTap,
    required this.activeTabName,
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
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 8),
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
        ],
      ),
    );
  }
}
