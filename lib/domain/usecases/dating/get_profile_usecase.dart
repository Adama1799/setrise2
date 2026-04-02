// lib/domain/usecases/dating/get_profile_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/dating_profile_entity.dart';
import '../../repositories/dating_repository.dart';
import '../../../core/errors/failures.dart';

class GetProfileUsecase {
  final DatingRepository repository;

  GetProfileUsecase(this.repository);

  Future<Either<Failure, DatingProfileEntity>> call(String profileId) async {
    return repository.getProfile(profileId);
  }
}
