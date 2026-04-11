import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onTitleTap;
  final VoidCallback onSearchTap;
  final VoidCallback onInfoTap;

  const TopBar({
    super.key,
    required this.onHomeTap,
    required this.onTitleTap,
    required this.onSearchTap,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      child: Row(
        children: [
          _IconButton(
            icon: Icons.home_rounded,
            onTap: onHomeTap,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: onTitleTap,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.public_rounded, size: 18, color: AppColors.white),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Setrise',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _IconButton(
            icon: Icons.search_rounded,
            onTap: onSearchTap,
          ),
          const SizedBox(width: 8),
          _IconButton(
            icon: Icons.info_outline_rounded,
            onTap: onInfoTap,
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Icon(icon, color: AppColors.white, size: 22),
      ),
    );
  }
}
