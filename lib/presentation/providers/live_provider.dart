// lib/presentation/providers/live_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/service_locator.dart';
import '../../domain/usecases/live/get_live_streams_usecase.dart';
import '../../domain/usecases/live/start_live_stream_usecase.dart';
import '../../domain/usecases/live/end_live_stream_usecase.dart';
import '../../domain/usecases/live/like_live_stream_usecase.dart';
import '../../data/models/live_stream_model.dart';

final liveProvider = StateNotifierProvider<LiveNotifier, LiveState>((ref) {
  return LiveNotifier();
});

class LiveState {
  final List<LiveStreamModel> liveStreams;
  final LiveStreamModel? currentStream;
  final bool isLoading;
  final bool isStreaming;
  final String? error;

  LiveState({
    required this.liveStreams,
    this.currentStream,
    required this.isLoading,
    required this.isStreaming,
    this.error,
  });

  LiveState copyWith({
    List<LiveStreamModel>? liveStreams,
    LiveStreamModel? currentStream,
    bool? isLoading,
    bool? isStreaming,
    String? error,
  }) {
    return LiveState(
      liveStreams: liveStreams ?? this.liveStreams,
      currentStream: currentStream ?? this.currentStream,
      isLoading: isLoading ?? this.isLoading,
      isStreaming: isStreaming ?? this.isStreaming,
      error: error ?? this.error,
    );
  }
}

class LiveNotifier extends StateNotifier<LiveState> {
  final _getLiveStreamsUsecase = getIt<GetLiveStreamsUsecase>();
  final _startLiveStreamUsecase = getIt<StartLiveStreamUsecase>();
  final _endLiveStreamUsecase = getIt<EndLiveStreamUsecase>();
  final _likeLiveStreamUsecase = getIt<LikeLiveStreamUsecase>();

  LiveNotifier()
      : super(LiveState(
          liveStreams: _generateMockStreams(),
          isLoading: false,
          isStreaming: false,
        ));

  static List<LiveStreamModel> _generateMockStreams() {
    return List.generate(5, (i) => LiveStreamModel(
      id: '$i',
      hostId: 'host_$i',
      hostName: 'Streamer ${i + 1}',
      hostUsername: '@streamer${i + 1}',
      hostAvatar: 'https://i.pravatar.cc/150?img=${i + 100}',
      title: 'Live Stream ${i + 1}',
      description: 'Amazing live streaming content',
      thumbnail: 'https://via.placeholder.com/500x300?text=Live+${i + 1}',
      viewersCount: (i + 1) * 1000,
      startedAt: DateTime.now().subtract(Duration(hours: i)),
      isLive: true,
      duration: (i + 1) * 3600,
      likes: (i + 1) * 500,
      isLiked: false,
    ));
  }

  Future<void> loadLiveStreams() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getLiveStreamsUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (streams) {
        state = state.copyWith(
          liveStreams: streams.cast<LiveStreamModel>(),
          isLoading: false,
        );
      },
    );
  }

  Future<void> startLiveStream(String title, String description) async {
    state = state.copyWith(isStreaming: true, error: null);
    final result = await _startLiveStreamUsecase(title, description);
    result.fold(
      (failure) {
        state = state.copyWith(
          isStreaming: false,
          error: failure.message,
        );
      },
      (stream) {
        state = state.copyWith(
          currentStream: stream as LiveStreamModel,
          isStreaming: false,
        );
      },
    );
  }

  Future<void> endLiveStream(String streamId) async {
    final result = await _endLiveStreamUsecase(streamId);
    result.fold(
      (failure) {},
      (_) {
        state = state.copyWith(currentStream: null);
      },
    );
  }

  void toggleLike(String streamId) async {
    final stream = state.liveStreams.firstWhere((s) => s.id == streamId);
    if (!stream.isLiked) {
      final result = await _likeLiveStreamUsecase(streamId);
      result.fold(
        (failure) {},
        (updatedStream) {
          final index = state.liveStreams.indexWhere((s) => s.id == streamId);
          final updatedStreams = [...state.liveStreams];
          updatedStreams[index] = updatedStream as LiveStreamModel;
          state = state.copyWith(liveStreams: updatedStreams);
        },
      );
    }
  }
}
