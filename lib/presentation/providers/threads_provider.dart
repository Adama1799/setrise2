// lib/presentation/providers/threads_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/service_locator.dart';
import '../../domain/usecases/threads/get_threads_usecase.dart';
import '../../domain/usecases/threads/create_thread_usecase.dart';
import '../../domain/usecases/threads/reply_thread_usecase.dart';
import '../../domain/usecases/threads/like_thread_usecase.dart';
import '../../domain/usecases/threads/repost_thread_usecase.dart';
import '../../data/models/thread_model.dart';

final threadsProvider = StateNotifierProvider<ThreadsNotifier, ThreadsState>((ref) {
  return ThreadsNotifier();
});

class ThreadsState {
  final List<ThreadModel> threads;
  final bool isLoading;
  final bool isCreating;
  final String? error;
  final int currentPage;
  final bool hasMoreThreads;

  ThreadsState({
    required this.threads,
    required this.isLoading,
    required this.isCreating,
    this.error,
    required this.currentPage,
    required this.hasMoreThreads,
  });

  ThreadsState copyWith({
    List<ThreadModel>? threads,
    bool? isLoading,
    bool? isCreating,
    String? error,
    int? currentPage,
    bool? hasMoreThreads,
  }) {
    return ThreadsState(
      threads: threads ?? this.threads,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      hasMoreThreads: hasMoreThreads ?? this.hasMoreThreads,
    );
  }
}

class ThreadsNotifier extends StateNotifier<ThreadsState> {
  final _getThreadsUsecase = getIt<GetThreadsUsecase>();
  final _createThreadUsecase = getIt<CreateThreadUsecase>();
  final _replyThreadUsecase = getIt<ReplyThreadUsecase>();
  final _likeThreadUsecase = getIt<LikeThreadUsecase>();
  final _repostThreadUsecase = getIt<RepostThreadUsecase>();

  ThreadsNotifier()
      : super(ThreadsState(
          threads: _generateMockThreads(),
          isLoading: false,
          isCreating: false,
          currentPage: 0,
          hasMoreThreads: true,
        ));

  static List<ThreadModel> _generateMockThreads() {
    return List.generate(10, (i) => ThreadModel(
      id: '$i',
      authorId: 'user_$i',
      authorName: 'User ${i + 1}',
      authorUsername: '@user${i + 1}',
      authorAvatar: 'https://i.pravatar.cc/150?img=$i',
      content: 'This is an amazing thread! Check out this incredible discussion. #rize #threads',
      createdAt: DateTime.now().subtract(Duration(hours: i)),
      likes: (i + 1) * 234,
      replies: (i + 1) * 45,
      reposts: (i + 1) * 12,
      isLiked: false,
      isReposted: false,
      replyTo: null,
      threadReplies: [], hasMoreReplies: false,
    ));
  }

  Future<void> loadThreads() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getThreadsUsecase(state.currentPage);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (threads) {
        state = state.copyWith(
          threads: threads.cast<ThreadModel>(),
          isLoading: false,
          hasMoreThreads: threads.length >= 20,
        );
      },
    );
  }

  Future<void> loadMoreThreads() async {
    if (!state.hasMoreThreads || state.isLoading) return;
    
    final newPage = state.currentPage + 1;
    final result = await _getThreadsUsecase(newPage);
    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (threads) {
        state = state.copyWith(
          threads: [...state.threads, ...threads.cast<ThreadModel>()],
          currentPage: newPage,
          hasMoreThreads: threads.length >= 20,
        );
      },
    );
  }

  Future<void> createThread(String content) async {
    state = state.copyWith(isCreating: true, error: null);
    final result = await _createThreadUsecase(content);
    result.fold(
      (failure) {
        state = state.copyWith(
          isCreating: false,
          error: failure.message,
        );
      },
      (thread) {
        state = state.copyWith(
          threads: [thread as ThreadModel, ...state.threads],
          isCreating: false,
        );
      },
    );
  }

  Future<void> replyToThread(String threadId, String content) async {
    final result = await _replyThreadUsecase(threadId, content);
    result.fold(
      (failure) {},
      (reply) {
        // Handle reply
      },
    );
  }

  void toggleLike(String threadId) async {
    final thread = state.threads.firstWhere((t) => t.id == threadId);
    if (thread.isLiked) {
      // Unlike
    } else {
      final result = await _likeThreadUsecase(threadId);
      result.fold(
        (failure) {},
        (updatedThread) {
          final index = state.threads.indexWhere((t) => t.id == threadId);
          final updatedThreads = [...state.threads];
          updatedThreads[index] = updatedThread as ThreadModel;
          state = state.copyWith(threads: updatedThreads);
        },
      );
    }
  }

  void toggleRepost(String threadId) async {
    final thread = state.threads.firstWhere((t) => t.id == threadId);
    if (thread.isReposted) {
      // Unrepost
    } else {
      final result = await _repostThreadUsecase(threadId);
      result.fold(
        (failure) {},
        (updatedThread) {
          final index = state.threads.indexWhere((t) => t.id == threadId);
          final updatedThreads = [...state.threads];
          updatedThreads[index] = updatedThread as ThreadModel;
          state = state.copyWith(threads: updatedThreads);
        },
      );
    }
  }
}
