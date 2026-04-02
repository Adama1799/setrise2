// lib/presentation/providers/users_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/service_locator.dart';
import '../../domain/usecases/users/get_user_usecase.dart';
import '../../domain/usecases/users/search_users_usecase.dart';
import '../../domain/usecases/users/follow_user_usecase.dart';
import '../../domain/usecases/users/unfollow_user_usecase.dart';
import '../../data/models/user_model.dart';

final usersProvider = StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  return UsersNotifier();
});

class UsersState {
  final UserModel? currentUser;
  final List<UserModel> searchResults;
  final bool isLoading;
  final bool isSearching;
  final String? error;

  UsersState({
    this.currentUser,
    required this.searchResults,
    required this.isLoading,
    required this.isSearching,
    this.error,
  });

  UsersState copyWith({
    UserModel? currentUser,
    List<UserModel>? searchResults,
    bool? isLoading,
    bool? isSearching,
    String? error,
  }) {
    return UsersState(
      currentUser: currentUser ?? this.currentUser,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      error: error ?? this.error,
    );
  }
}

class UsersNotifier extends StateNotifier<UsersState> {
  final _getUserUsecase = getIt<GetUserUsecase>();
  final _searchUsersUsecase = getIt<SearchUsersUsecase>();
  final _followUserUsecase = getIt<FollowUserUsecase>();
  final _unfollowUserUsecase = getIt<UnfollowUserUsecase>();

  UsersNotifier()
      : super(UsersState(
          searchResults: [],
          isLoading: false,
          isSearching: false,
        ));

  Future<void> getUser(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getUserUsecase(userId);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (user) {
        state = state.copyWith(
          currentUser: user as UserModel,
          isLoading: false,
        );
      },
    );
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchResults: [], isSearching: false);
      return;
    }

    state = state.copyWith(isSearching: true, error: null);
    final result = await _searchUsersUsecase(query);
    result.fold(
      (failure) {
        state = state.copyWith(
          isSearching: false,
          error: failure.message,
        );
      },
      (users) {
        state = state.copyWith(
          searchResults: users.cast<UserModel>(),
          isSearching: false,
        );
      },
    );
  }

  Future<void> toggleFollow(String userId) async {
    final user = state.currentUser;
    if (user == null) return;

    if (user.isFollowing) {
      final result = await _unfollowUserUsecase(userId);
      result.fold(
        (failure) {},
        (updatedUser) {
          state = state.copyWith(
            currentUser: updatedUser as UserModel,
          );
        },
      );
    } else {
      final result = await _followUserUsecase(userId);
      result.fold(
        (failure) {},
        (updatedUser) {
          state = state.copyWith(
            currentUser: updatedUser as UserModel,
          );
        },
      );
    }
  }
}
