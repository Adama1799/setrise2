// lib/presentation/screens/dating/dating_discover_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/dating_provider.dart';
import '../../widgets/dating/profile_card.dart';
import '../../widgets/dating/dating_actions.dart';

class DatingDiscoverScreen extends ConsumerStatefulWidget {
  const DatingDiscoverScreen({super.key});

  @override
  ConsumerState<DatingDiscoverScreen> createState() =>
      _DatingDiscoverScreenState();
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('🔥 Discover', style: AppTypography.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.dateColor),
            onPressed: () {
              Navigator.pushNamed(context, '/dating/matches');
            },
          ),
        ],
      ),
      body: datingState.isLoading && datingState.profiles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : datingState.profiles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_outline,
                        size: 80,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: 16),
                      Text('No more profiles', style: AppTypography.h3),
                      const SizedBox(height: 8),
                      Text(
                        'Check back later',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    // Profiles Stack
                    PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: datingState.profiles.length,
                      onPageChanged: (index) {},
                      itemBuilder: (context, index) {
                        final profile = datingState.profiles[index];
                        return ProfileCard(profile: profile);
                      },
                    ),
                    // Actions Bar
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
                ),
    );
  }
}
