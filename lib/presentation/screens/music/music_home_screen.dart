// lib/presentation/screens/music/music_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/music_provider.dart';
import '../../widgets/music/track_card.dart';
import '../../widgets/music/music_player_mini.dart';

class MusicHomeScreen extends ConsumerStatefulWidget {
  const MusicHomeScreen({super.key});

  @override
  ConsumerState<MusicHomeScreen> createState() => _MusicHomeScreenState();
}

class _MusicHomeScreenState extends ConsumerState<MusicHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(musicProvider.notifier).loadTracks();
      ref.read(musicProvider.notifier).loadTrendingTracks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final musicState = ref.watch(musicProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('🎵 Music', style: AppTypography.h2),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Mini Player
          if (musicState.currentTrack != null)
            MusicPlayerMini(track: musicState.currentTrack!),
          // Trending Section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trending Tracks
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Trending Now 🔥',
                      style: AppTypography.h3,
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: musicState.trendingTracks.length,
                      itemBuilder: (context, index) {
                        final track = musicState.trendingTracks[index];
                        return GestureDetector(
                          onTap: () {
                            ref.read(musicProvider.notifier).playTrack(track);
                          },
                          child: Container(
                            width: 140,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.surface,
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    track.albumCover,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
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
                                        track.title,
                                        style: AppTypography.labelSmall.copyWith(
                                          color: AppColors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        track.artist,
                                        style: AppTypography.caption.copyWith(
                                          color: AppColors.white.withOpacity(0.7),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.music.withOpacity(0.9),
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: AppColors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  // All Tracks
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'All Tracks',
                      style: AppTypography.h3,
                    ),
                  ),
                  ...musicState.tracks.map((track) => TrackCard(
                    track: track,
                    onTap: () {
                      ref.read(musicProvider.notifier).playTrack(track);
                    },
                    onLikeTap: () {
                      ref.read(musicProvider.notifier).toggleLike(track.id);
                    },
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
