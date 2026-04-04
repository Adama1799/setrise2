import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/posts/create_post_usecase.dart';
import '../../domain/usecases/posts/delete_post_usecase.dart';
import '../../domain/usecases/posts/get_feed_usecase.dart';
import '../../domain/usecases/posts/like_post_usecase.dart';
import '../../core/usecases/usecase.dart';

/// Posts state
class PostsState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<PostEntity> posts;
  final String? error;
  final bool hasMore;
  final int currentPage;

  const PostsState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.posts = const [],
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  PostsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<PostEntity>? posts,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return PostsState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      posts: posts ?? this.posts,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Posts state notifier
class PostsNotifier extends StateNotifier<PostsState> {
  final GetFeedUseCase _getFeedUseCase;
  final CreatePostUseCase _createPostUseCase;
  final LikePostUseCase _likePostUseCase;
  final DeletePostUseCase _deletePostUseCase;

  PostsNotifier(
    this._getFeedUseCase,
    this._createPostUseCase,
    this._likePostUseCase,
    this._deletePostUseCase,
  ) : super(const PostsState());

  /// Get feed
  Future<void> getFeed({bool refresh = false}) async {
    if (refresh) {
      state = const PostsState(isLoading: true);
    } else if (state.isLoadingMore || !state.hasMore) {
      return;
    } else {
      state = state.copyWith(isLoadingMore: true);
    }

    final page = refresh ? 1 : state.currentPage + 1;

    final result = await _getFeedUseCase(
      PaginationParams(page: page, limit: 20),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: failure.message,
        );
      },
      (newPosts) {
        final posts = refresh ? newPosts : [...state.posts, ...newPosts];
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          posts: posts,
          hasMore: newPosts.length >= 20,
          currentPage: page,
          error: null,
        );
      },
    );
  }

  /// Create post
  Future<bool> createPost({
    required String content,
    List<String>? mediaUrls,
  }) async {
    state = state.copyWith(isLoading: true);

    final result = await _createPostUseCase(
      CreatePostParams(
        content: content,
        mediaUrls: mediaUrls,
      ),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (post) {
        state = state.copyWith(
          isLoading: false,
          posts: [post, ...state.posts],
          error: null,
        );
        return true;
      },
    );
  }

  /// Like post
  Future<void> likePost(String postId) async {
    // Optimistic update
    final updatedPosts = state.posts.map((post) {
      if (post.id == postId) {
        return post.copyWith(
          isLiked: !post.isLiked,
          likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
        );
      }
      return post;
    }).toList();

    state = state.copyWith(posts: updatedPosts);

    final result = await _likePostUseCase(IdParams(postId));

    result.fold(
      (failure) {
        // Revert on failure
        final revertedPosts = state.posts.map((post) {
          if (post.id == postId) {
            return post.copyWith(
              isLiked: !post.isLiked,
              likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
            );
          }
          return post;
        }).toList();
        state = state.copyWith(posts: revertedPosts);
      },
      (_) {
        // Success - already updated optimistically
      },
    );
  }

  /// Delete post
  Future<bool> deletePost(String postId) async {
    final result = await _deletePostUseCase(IdParams(postId));

    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        final updatedPosts = state.posts.where((p) => p.id != postId).toList();
        state = state.copyWith(posts: updatedPosts);
        return true;
      },
    );
  }

  /// Refresh feed
  Future<void> refresh() async {
    await getFeed(refresh: true);
  }

  /// Load more
  Future<void> loadMore() async {
    await getFeed(refresh: false);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Posts provider
final postsProvider = StateNotifierProvider<PostsNotifier, PostsState>(
  (ref) => PostsNotifier(
    getIt<GetFeedUseCase>(),
    getIt<CreatePostUseCase>(),
    getIt<LikePostUseCase>(),
    getIt<DeletePostUseCase>(),
  ),
);
