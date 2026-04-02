// lib/presentation/providers/music_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/service_locator.dart';
import '../../domain/usecases/music/get_tracks_usecase.dart';
import '../../domain/usecases/music/get_trending_tracks_usecase.dart';
import '../../domain/usecases/music/like_track_usecase.dart';
import '../../domain/usecases/music/get_favorite_tracks_usecase.dart';
import '../../data/models/music_track_model.dart';

final musicProvider = StateNotifierProvider<MusicNotifier, MusicState>((ref) {
  return MusicNotifier();
});

class MusicState {
  final List<MusicTrackModel> tracks;
  final List<MusicTrackModel> trendingTracks;
  final List<MusicTrackModel> favoriteTracks;
  final MusicTrackModel? currentTrack;
  final bool isLoading;
  final bool isPlaying;
  final String? error;

  MusicState({
    required this.tracks,
    required this.trendingTracks,
    required this.favoriteTracks,
    this.currentTrack,
    required this.isLoading,
    required this.isPlaying,
    this.error,
  });

  MusicState copyWith({
    List<MusicTrackModel>? tracks,
    List<MusicTrackModel>? trendingTracks,
    List<MusicTrackModel>? favoriteTracks,
    MusicTrackModel? currentTrack,
    bool? isLoading,
    bool? isPlaying,
    String? error,
  }) {
    return MusicState(
      tracks: tracks ?? this.tracks,
      trendingTracks: trendingTracks ?? this.trendingTracks,
      favoriteTracks: favoriteTracks ?? this.favoriteTracks,
      currentTrack: currentTrack ?? this.currentTrack,
      isLoading: isLoading ?? this.isLoading,
      isPlaying: isPlaying ?? this.isPlaying,
      error: error ?? this.error,
    );
  }
}

class MusicNotifier extends StateNotifier<MusicState> {
  final _getTracksUsecase = getIt<GetTracksUsecase>();
  final _getTrendingTracksUsecase = getIt<GetTrendingTracksUsecase>();
  final _likeTrackUsecase = getIt<LikeTrackUsecase>();
  final _getFavoriteTracksUsecase = getIt<GetFavoriteTracksUsecase>();

  MusicNotifier()
      : super(MusicState(
          tracks: _generateMockTracks(),
          trendingTracks: [],
          favoriteTracks: [],
          isLoading: false,
          isPlaying: false,
        ));

  static List<MusicTrackModel> _generateMockTracks() {
    return List.generate(10, (i) => MusicTrackModel(
      id: '$i',
      title: 'Track ${i + 1}',
      artist: 'Artist ${i + 1}',
      albumCover: 'https://via.placeholder.com/300x300?text=Album+${i + 1}',
      audioUrl: 'https://example.com/track${i + 1}.mp3',
      duration: 180 + (i * 30),
      plays: (i + 1) * 10000,
      likes: (i + 1) * 500,
      isLiked: false,
      isFavorite: false,
      genre: 'Pop',
    ));
  }

  Future<void> loadTracks() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getTracksUsecase(0);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (tracks) {
        state = state.copyWith(
          tracks: tracks.cast<MusicTrackModel>(),
          isLoading: false,
        );
      },
    );
  }

  Future<void> loadTrendingTracks() async {
    final result = await _getTrendingTracksUsecase();
    result.fold(
      (failure) {},
      (tracks) {
        state = state.copyWith(
          trendingTracks: tracks.cast<MusicTrackModel>(),
        );
      },
    );
  }

  void playTrack(MusicTrackModel track) {
    state = state.copyWith(currentTrack: track, isPlaying: true);
  }

  void pauseTrack() {
    state = state.copyWith(isPlaying: false);
  }

  void toggleLike(String trackId) async {
    final track = state.tracks.firstWhere((t) => t.id == trackId);
    if (!track.isLiked) {
      final result = await _likeTrackUsecase(trackId);
      result.fold(
        (failure) {},
        (updatedTrack) {
          final index = state.tracks.indexWhere((t) => t.id == trackId);
          final updatedTracks = [...state.tracks];
          updatedTracks[index] = updatedTrack as MusicTrackModel;
          state = state.copyWith(tracks: updatedTracks);
        },
      );
    }
  }

  Future<void> loadFavoriteTracks() async {
    final result = await _getFavoriteTracksUsecase();
    result.fold(
      (failure) {},
      (tracks) {
        state = state.copyWith(
          favoriteTracks: tracks.cast<MusicTrackModel>(),
        );
      },
    );
  }
}
