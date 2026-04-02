// lib/domain/usecases/dating/like_profile_usecase.dart
import 'package:dartz/dartz.dart';
import '../../repositories/dating_repository.dart';
import '../../../core/errors/failures.dart';

class LikeProfileUsecase {
  final DatingRepository repository;

  LikeProfileUsecase(this.repository);

  Future<Either<Failure, void>> call(String profileId) async {
    return repository.likeProfile(profileId);
  }
}
