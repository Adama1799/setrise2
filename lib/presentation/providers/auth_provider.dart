// lib/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/service_locator.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../data/models/user_model.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final UserModel? user;
  final String? error;
  final String? token;

  AuthState({
    required this.isAuthenticated,
    required this.isLoading,
    this.user,
    this.error,
    this.token,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    UserModel? user,
    String? error,
    String? token,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final _loginUsecase = getIt<LoginUsecase>();
  final _registerUsecase = getIt<RegisterUsecase>();
  final _logoutUsecase = getIt<LogoutUsecase>();

  AuthNotifier()
      : super(AuthState(
          isAuthenticated: false,
          isLoading: false,
        ));

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _loginUsecase(email, password);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (user) {
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          user: user as UserModel,
        );
      },
    );
  }

  Future<void> register(String name, String email, String password, String username) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _registerUsecase(name, email, password, username);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (user) {
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          user: user as UserModel,
        );
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _logoutUsecase();
    state = AuthState(isAuthenticated: false, isLoading: false);
  }
}
