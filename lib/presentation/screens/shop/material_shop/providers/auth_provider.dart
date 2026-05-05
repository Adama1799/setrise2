import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated, error }

class AuthState {
  final AuthStatus status;
  final String? email;
  final String? error;
  const AuthState({this.status = AuthStatus.unauthenticated, this.email, this.error});
  AuthState copyWith({AuthStatus? status, String? email, String? error}) =>
      AuthState(status: status ?? this.status, email: email ?? this.email, error: error);
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> loginEmail(String email, String password) async {
    state = state.copyWith(status: AuthStatus.authenticating);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(status: AuthStatus.authenticated, email: email);
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(status: AuthStatus.authenticating);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(status: AuthStatus.authenticated, email: email);
  }

  Future<void> loginGoogle() async {
    state = state.copyWith(status: AuthStatus.authenticating);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(status: AuthStatus.authenticated, email: 'google@user.com');
  }

  Future<void> loginApple() async {
    state = state.copyWith(status: AuthStatus.authenticating);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(status: AuthStatus.authenticated, email: 'apple@user.com');
  }

  void logout() => state = const AuthState();
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());
