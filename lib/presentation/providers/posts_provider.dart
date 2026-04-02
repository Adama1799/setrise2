// lib/presentation/providers/posts_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/service_locator.dart';
import '../../domain/usecases/posts/get_posts_usecase.dart';
import '../../domain/usecases/posts/create_post_usecase.dart';
import '../../domain/usecases/posts/like_post_usecase.dart';
import '../../domain/usecases/posts/unlike_post_usecase.dart';
import '../../domain/usecases/posts/save_post_usecase.dart';
import '../../domain/usecases/posts/get_saved_posts_usecase.dart';
import '../../data/models/post_model.dart';

final postsProvider = StateNotifierProvider<PostsNotifier, PostsState>((ref) {
  return PostsNotifier();
});

class PostsState {
  final List<PostModel> posts;
  final List<PostModel> savedPosts;
  final bool isLoading;
  final bool isSavingPost;
  final String? error;
  final int currentPage;
  final bool hasMorePosts;

  PostsState({
    required this.posts,
    required this.savedPosts,
    required this.isLoading,
    required this.isSavingPost,
    this.error,
    required this.currentPage,
    required this.hasMorePosts,
  });

  PostsState copyWith({
    List<PostModel>? posts,
    List<PostModel>? savedPosts,
    bool? isLoading,
    bool? isSavingPost,
    String? error,
    int? currentPage,
    bool? hasMorePosts,
  }) {
    return PostsState(
      posts: posts ?? this.posts,
      savedPosts: savedPosts ?? this.savedPosts,
      isLoading: isLoading ?? this.isLoading,
      isSavingPost: isSavingPost ?? this.isSavingPost,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      hasMorePosts: hasMorePosts ?? this.hasMorePosts,
    );
  }
}

class PostsNotifier extends StateNotifier<PostsState> {
  final _getPostsUsecase = getIt<GetPostsUsecase>();
  final _createPostUsecase = getIt<CreatePostUsecase>();
  final _likePostUsecase = getIt<LikePostUsecase>();
  final _unlikePostUsecase = getIt<UnlikePostUsecase>();
  final _savePostUsecase = getIt<SavePostUsecase>();
  final _getSavedPostsUsecase = getIt<GetSavedPostsUsecase>();

  PostsNotifier()
      : super(PostsState(
          posts: _generateMockPosts(),
          savedPosts: [],
          isLoading: false,
          isSavingPost: false,
          currentPage: 0,
          hasMorePosts: true,
        ));

  static List<PostModel> _generateMockPosts() {
    return List.generate(10, (i) => PostModel(
      id: '$i',
      authorId: 'user_$i',
      authorName: 'User ${i + 1}',
      authorUsername: '@user${i + 1}',
      authorAvatar: 'https://i.pravatar.cc/150?img=$i',
      content: 'This is an amazing post! Check out this incredible content. #setrise #viral #trending',
      mediaUrls: ['https://via.placeholder.com/500x300?text=Post+${i + 1}'],
      createdAt: DateTime.now().subtract(Duration(hours: i)),
      likes: (i + 1) * 234,
      comments: (i + 1) * 45,
      shares: (i + 1) * 12,
      saves: (i + 1) * 8,
      isLiked: false,
      isShared: false,
      isSaved: false,
      isFollowing: false,
      mentionedUsers: [],
      hashtags: ['setrise', 'viral', 'trending'],
    ));
  }

  Future<void> loadPosts() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getPostsUsecase(state.currentPage);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (posts) {
        state = state.copyWith(
          posts: posts.cast<PostModel>(),
          isLoading: false,
          hasMorePosts: posts.length >= 20,
        );
      },
    );
  }

  Future<void> loadMorePosts() async {
    if (!state.hasMorePosts || state.isLoading) return;
    
    final newPage = state.currentPage + 1;
    final result = await _getPostsUsecase(newPage);
    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (posts) {
        state = state.copyWith(
          posts: [...state.posts, ...posts.cast<PostModel>()],
          currentPage: newPage,
          hasMorePosts: posts.length >= 20,
        );
      },
    );
  }

  Future<void> createPost(String content, List<String> mediaUrls) async {
    state = state.copyWith(isSavingPost: true);
    final result = await _createPostUsecase(content, mediaUrls);
    result.fold(
      (failure) {
        state = state.copyWith(
          isSavingPost: false,
          error: failure.message,
        );
      },
      (post) {
        state = state.copyWith(
          posts: [post as PostModel, ...state.posts],
          isSavingPost: false,
        );
      },
    );
  }

  void toggleLike(String postId) async {
    final post = state.posts.firstWhere((p) => p.id == postId);
    if (post.isLiked) {
      final result = await _unlikePostUsecase(postId);
      result.fold(
        (failure) {},
        (updatedPost) {
          final index = state.posts.indexWhere((p) => p.id == postId);
          final updatedPosts = [...state.posts];
          updatedPosts[index] = updatedPost as PostModel;
          state = state.copyWith(posts: updatedPosts);
        },
      );
    } else {
      final result = await _likePostUsecase(postId);
      result.fold(
        (failure) {},
        (updatedPost) {
          final index = state.posts.indexWhere((p) => p.id == postId);
          final updatedPosts = [...state.posts];
          updatedPosts[index] = updatedPost as PostModel;
          state = state.copyWith(posts: updatedPosts);
        },
      );
    }
  }

  void toggleSave(String postId) async {
    final post = state.posts.firstWhere((p) => p.id == postId);
    if (post.isSaved) {
      // Unsave
    } else {
      final result = await _savePostUsecase(postId);
      result.fold(
        (failure) {},
        (updatedPost) {
          final index = state.posts.indexWhere((p) => p.id == postId);
          final updatedPosts = [...state.posts];
          updatedPosts[index] = updatedPost as PostModel;
          state = state.copyWith(posts: updatedPosts);
        },
      );
    }
  }

  Future<void> loadSavedPosts() async {
    state = state.copyWith(isLoading: true);
    final result = await _getSavedPostsUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (posts) {
        state = state.copyWith(
          savedPosts: posts.cast<PostModel>(),
          isLoading: false,
        );
      },
    );
  }
}
