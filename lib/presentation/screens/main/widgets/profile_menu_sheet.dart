// lib/presentation/screens/main/widgets/profile_menu_sheet.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileMenuSheet extends StatelessWidget {
  final VoidCallback onViewProfile;
  final VoidCallback onFilter;

  const ProfileMenuSheet({
    super.key,
    required this.onViewProfile,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.electricBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: AppColors.electricBlue, size: 28),
            ),
            title: const Text('View Profile', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('See your posts and activity'),
            onTap: onViewProfile,
          ),
          const Divider(height: 32),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.filter_list, color: AppColors.neonGreen, size: 28),
            ),
            title: const Text('Content Filter', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Filter by mood, region, and more'),
            onTap: onFilter,
          ),
        ],
      ),
    );
  }
}
