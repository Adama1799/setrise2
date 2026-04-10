// lib/domain/usecases/users/update_profile_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/user_entity.dart';
import '../../repositories/users_repository.dart';
import '../../../core/errors/failures.dart';

class UpdateProfileUsecase {
  final UsersRepository repository;

  UpdateProfileUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call(Map<String, dynamic> data) async {
    return repository.updateProfile(data);
  }
}
