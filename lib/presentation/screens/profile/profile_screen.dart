// lib/presentation/screens/profile/profile_screen.dart
// FIX: Was an empty file — completed with full profile screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/auth_provider.dart';
import '../../providers/posts_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final postsState = ref.watch(postsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        // ===== APP BAR =====
        SliverAppBar(
          backgroundColor: AppColors.background,
          pinned: true, elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => _showSettingsSheet(context, ref),
            ),
          ],
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Avatar & Stats
              Row(children: [
                Stack(children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: AppColors.primary.withOpacity(0.12),
                    child: const Icon(Icons.person, size: 48, color: AppColors.primary),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary, shape: BoxShape.circle,
                        border: Border.all(color: AppColors.background, width: 2),
                      ),
                      child: const Icon(Icons.add, color: AppColors.white, size: 16),
                    ),
                  ),
                ]),
                const SizedBox(width: 24),
                Expanded(
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    _stat('Posts', '${postsState.posts.length}'),
                    _stat('Followers', '12.4K'),
                    _stat('Following', '380'),
                  ]),
                ),
              ]),

              const SizedBox(height: 14),
              Text('My Profile', style: AppTypography.headlineMedium),
              Text('@setrise_user', style: AppTypography.caption),
              const SizedBox(height: 8),
              Text('Building something amazing 🚀 | SetRise Creator\nDM for collabs!',
                  style: AppTypography.bodySmall),
              const SizedBox(height: 14),

              // Edit Profile button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () {},
                  child: const Text('Edit Profile',
                      style: TextStyle(fontFamily: 'Inter',
                          fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(color: AppColors.border),
            ]),
          ),
        ),

        // ===== POSTS GRID =====
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2,
          ),
          delegate: SliverChildBuilderDelegate(
            (_, i) {
              if (i >= postsState.posts.length) {
                return Container(
                  color: AppColors.border.withOpacity(0.2),
                  child: Center(child: Icon(Icons.add_photo_alternate_outlined,
                      color: AppColors.textTertiary, size: 30)),
                );
              }
              return Container(
                color: AppColors.border.withOpacity(0.3),
                child: const Center(child: Icon(Icons.image_outlined,
                    color: AppColors.textTertiary)),
              );
            },
            childCount: 12,
          ),
        ),
      ]),
    );
  }

  Widget _stat(String label, String value) {
    return Column(children: [
      Text(value, style: AppTypography.headlineMedium),
      Text(label, style: AppTypography.caption),
    ]);
  }

  void _showSettingsSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text('Settings', style: AppTypography.h3),
          const SizedBox(height: 20),
          _settingItem(Icons.person_outline, 'Edit Profile', () => Navigator.pop(context)),
          _settingItem(Icons.notifications_outlined, 'Notifications', () => Navigator.pop(context)),
          _settingItem(Icons.privacy_tip_outlined, 'Privacy', () => Navigator.pop(context)),
          _settingItem(Icons.help_outline, 'Help & Support', () => Navigator.pop(context)),
          const Divider(color: AppColors.border),
          _settingItem(Icons.logout, 'Sign Out', () {
            Navigator.pop(context);
            ref.read(authProvider.notifier).logout();
          }, color: AppColors.primary),
        ]),
      ),
    );
  }

  Widget _settingItem(IconData icon, String label, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: Text(label, style: TextStyle(
          fontFamily: 'Inter', color: color ?? AppColors.textPrimary)),
      onTap: onTap,
    );
  }
}
