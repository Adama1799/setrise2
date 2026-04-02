// lib/presentation/screens/dating/matches_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/dating_provider.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(datingProvider.notifier).loadMatches();
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
        title: const Text('❤️ Matches', style: AppTypography.h2),
      ),
      body: datingState.matches.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_outline,
                    size: 80,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text('No matches yet', style: AppTypography.h3),
                  const SizedBox(height: 8),
                  Text(
                    'Start liking profiles to make matches',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: datingState.matches.length,
              itemBuilder: (context, index) {
                final match = datingState.matches[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to chat
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: match.photos[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                match.name,
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.favorite,
                                    color: AppColors.dateColor,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Matched',
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.dateColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
