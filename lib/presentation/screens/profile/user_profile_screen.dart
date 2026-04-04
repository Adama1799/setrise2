import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class UserProfileScreen extends ConsumerWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = userId == 'me';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: AppColors.background, pinned: true, elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
          actions: [IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {})],
        ),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(radius: 40, backgroundColor: AppColors.primary.withOpacity(0.1),
                child: const Icon(Icons.person, size: 44, color: AppColors.primary)),
              const SizedBox(width: 20),
              Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _stat('Posts', '42'),
                _stat('Followers', '12.4K'),
                _stat('Following', '380'),
              ])),
            ]),
            const SizedBox(height: 12),
            Text(isMe ? 'My Profile' : 'User $userId', style: AppTypography.headlineMedium),
            Text(isMe ? '@me' : '@user$userId', style: AppTypography.caption),
            const SizedBox(height: 8),
            Text('Building something amazing 🚀 | SetRise Creator', style: AppTypography.bodySmall),
            const SizedBox(height: 16),
            if (!isMe) Row(children: [
              Expanded(child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () {},
                child: const Text('Follow', style: TextStyle(color: AppColors.white, fontFamily: 'Inter')))),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () {},
                child: const Text('Message', style: TextStyle(fontFamily: 'Inter')))),
            ]),
            if (isMe) SizedBox(width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () {},
                child: const Text('Edit Profile', style: TextStyle(fontFamily: 'Inter')))),
            const SizedBox(height: 16),
            const Divider(color: AppColors.border),
          ]),
        )),
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
          delegate: SliverChildBuilderDelegate(
            (_, i) => Container(color: AppColors.border.withOpacity(0.3),
              child: Center(child: Icon(Icons.image_outlined, color: AppColors.textTertiary))),
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
}
