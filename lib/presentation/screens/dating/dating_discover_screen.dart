// lib/presentation/screens/dating/dating_discover_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/dating_provider.dart';
import '../../widgets/dating/profile_card.dart';
import '../../widgets/dating/dating_actions.dart';

class DatingDiscoverScreen extends ConsumerStatefulWidget {
  const DatingDiscoverScreen({super.key});

  @override
  ConsumerState<DatingDiscoverScreen> createState() => _DatingDiscoverScreenState();
}

class _DatingDiscoverScreenState extends ConsumerState<DatingDiscoverScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(datingProvider.notifier).loadProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final datingState = ref.watch(datingProvider);

    // ✅ إزالة Scaffold، نعيد المحتوى مباشرة
    if (datingState.isLoading && datingState.profiles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (datingState.profiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline, size: 80, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text('No more profiles', style: AppTypography.h3),
            const SizedBox(height: 8),
            Text('Check back later', style: AppTypography.caption),
          ],
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: datingState.profiles.length,
          itemBuilder: (context, index) {
            final profile = datingState.profiles[index];
            return ProfileCard(profile: profile);
          },
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: DatingActions(
            onPass: () {
              ref.read(datingProvider.notifier).passProfile(
                datingState.profiles[datingState.currentProfileIndex].id,
              );
            },
            onLike: () {
              ref.read(datingProvider.notifier).likeProfile(
                datingState.profiles[datingState.currentProfileIndex].id,
              );
            },
          ),
        ),
      ],
    );
  }
}
