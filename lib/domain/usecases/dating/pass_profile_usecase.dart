// lib/domain/usecases/dating/pass_profile_usecase.dart
import 'package:dartz/dartz.dart';
import '../../repositories/dating_repository.dart';
import '../../../core/errors/failures.dart';

class PassProfileUsecase {
  final DatingRepository repository;

  PassProfileUsecase(this.repository);

  Future<Either<Failure, void>> call(String profileId) async {
    return repository.passProfile(profileId);
  }
}
