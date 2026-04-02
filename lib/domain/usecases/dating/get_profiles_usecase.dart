// lib/domain/usecases/dating/get_profiles_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/dating_profile_entity.dart';
import '../../repositories/dating_repository.dart';
import '../../../core/errors/failures.dart';

class GetProfilesUsecase {
  final DatingRepository repository;

  GetProfilesUsecase(this.repository);

  Future<Either<Failure, List<DatingProfileEntity>>> call() async {
    return repository.getProfiles();
  }
}
