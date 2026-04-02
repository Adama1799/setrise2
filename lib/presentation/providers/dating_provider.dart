// lib/presentation/providers/dating_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/service_locator.dart';
import '../../domain/usecases/dating/get_profiles_usecase.dart';
import '../../domain/usecases/dating/get_matches_usecase.dart';
import '../../domain/usecases/dating/like_profile_usecase.dart';
import '../../domain/usecases/dating/pass_profile_usecase.dart';
import '../../data/models/dating_profile_model.dart';

final datingProvider = StateNotifierProvider<DatingNotifier, DatingState>((ref) {
  return DatingNotifier();
});

class DatingState {
  final List<DatingProfileModel> profiles;
  final List<DatingProfileModel> matches;
  final int currentProfileIndex;
  final bool isLoading;
  final String? error;

  DatingState({
    required this.profiles,
    required this.matches,
    required this.currentProfileIndex,
    required this.isLoading,
    this.error,
  });

  DatingState copyWith({
    List<DatingProfileModel>? profiles,
    List<DatingProfileModel>? matches,
    int? currentProfileIndex,
    bool? isLoading,
    String? error,
  }) {
    return DatingState(
      profiles: profiles ?? this.profiles,
      matches: matches ?? this.matches,
      currentProfileIndex: currentProfileIndex ?? this.currentProfileIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class DatingNotifier extends StateNotifier<DatingState> {
  final _getProfilesUsecase = getIt<GetProfilesUsecase>();
  final _getMatchesUsecase = getIt<GetMatchesUsecase>();
  final _likeProfileUsecase = getIt<LikeProfileUsecase>();
  final _passProfileUsecase = getIt<PassProfileUsecase>();

  DatingNotifier()
      : super(DatingState(
          profiles: _generateMockProfiles(),
          matches: [],
          currentProfileIndex: 0,
          isLoading: false,
        ));

  static List<DatingProfileModel> _generateMockProfiles() {
    return List.generate(10, (i) => DatingProfileModel(
      id: '$i',
      userId: 'user_$i',
      name: 'Person ${i + 1}',
      age: '${20 + i}',
      photos: ['https://i.pravatar.cc/300?img=${i + 200}'],
      bio: 'Love travel, music, and good conversations!',
      location: 'City ${i + 1}',
      interests: ['travel', 'music', 'sports'],
      lookingFor: 'Serious relationship',
      isOnline: i % 2 == 0,
      lastSeen: DateTime.now().subtract(Duration(hours: i)),
    ));
  }

  Future<void> loadProfiles() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getProfilesUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (profiles) {
        state = state.copyWith(
          profiles: profiles.cast<DatingProfileModel>(),
          isLoading: false,
        );
      },
    );
  }

  Future<void> likeProfile(String profileId) async {
    final result = await _likeProfileUsecase(profileId);
    result.fold(
      (failure) {},
      (_) {
        nextProfile();
      },
    );
  }

  Future<void> passProfile(String profileId) async {
    final result = await _passProfileUsecase(profileId);
    result.fold(
      (failure) {},
      (_) {
        nextProfile();
      },
    );
  }

  void nextProfile() {
    if (state.currentProfileIndex < state.profiles.length - 1) {
      state = state.copyWith(
        currentProfileIndex: state.currentProfileIndex + 1,
      );
    }
  }

  Future<void> loadMatches() async {
    final result = await _getMatchesUsecase();
    result.fold(
      (failure) {},
      (matches) {
        state = state.copyWith(
          matches: matches.cast<DatingProfileModel>(),
        );
      },
    );
  }
}
