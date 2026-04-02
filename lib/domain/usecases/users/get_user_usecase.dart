// lib/domain/usecases/users/get_user_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/user_entity.dart';
import '../../repositories/users_repository.dart';
import '../../../core/errors/failures.dart';

class GetUserUsecase {
  final UsersRepository repository;

  GetUserUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call(String userId) async {
    return repository.getUser(userId);
  }
}
