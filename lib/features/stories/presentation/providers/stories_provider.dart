// lib/features/stories/presentation/providers/stories_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/usecases/story_usecases.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class StoriesState {
  final bool isLoading;
  final List<StoryEntity> stories;
  final String? error;

  const StoriesState({
    this.isLoading = false,
    this.stories = const [],
    this.error,
  });

  StoriesState copyWith({
    bool? isLoading,
    List<StoryEntity>? stories,
    String? error,
  }) {
    return StoriesState(
      isLoading: isLoading ?? this.isLoading,
      stories: stories ?? this.stories,
      error: error,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class StoriesNotifier extends StateNotifier<StoriesState> {
  final GetFeedStoriesUseCase _getFeedStories;
  final CreateStoryUseCase _createStory;
  final DeleteStoryUseCase _deleteStory;
  final ViewStoryUseCase _viewStory;

  StoriesNotifier(
    this._getFeedStories,
    this._createStory,
    this._deleteStory,
    this._viewStory,
  ) : super(const StoriesState()) {
    loadFeedStories();
  }

  Future<void> loadFeedStories() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getFeedStories();
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (stories) => state = state.copyWith(
        isLoading: false,
        stories: stories,
      ),
    );
  }

  Future<bool> createStory({
    required String mediaPath,
    required StoryMediaType mediaType,
  }) async {
    final result = await _createStory(
      CreateStoryParams(mediaPath: mediaPath, mediaType: mediaType),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (story) {
        state = state.copyWith(stories: [story, ...state.stories]);
        return true;
      },
    );
  }

  Future<void> deleteStory(String storyId) async {
    final result = await _deleteStory(IdParams(storyId));
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) => state = state.copyWith(
        stories: state.stories.where((s) => s.id != storyId).toList(),
      ),
    );
  }

  Future<void> markAsViewed(String storyId) async {
    await _viewStory(IdParams(storyId));

    // تحديث الحالة محلياً فوراً
    state = state.copyWith(
      stories: state.stories.map((s) {
        if (s.id != storyId) return s;
        return s.copyWith(
          isViewed: true,
          status: s.status == StoryStatus.unseen ? StoryStatus.seen : s.status,
        );
      }).toList(),
    );
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final storiesProvider = StateNotifierProvider<StoriesNotifier, StoriesState>((ref) {
  return StoriesNotifier(
    getIt<GetFeedStoriesUseCase>(),
    getIt<CreateStoryUseCase>(),
    getIt<DeleteStoryUseCase>(),
    getIt<ViewStoryUseCase>(),
  );
});
