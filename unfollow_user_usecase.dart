// lib/domain/usecases/users/unfollow_user_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/user_entity.dart';
import '../../repositories/users_repository.dart';
import '../../../core/errors/failures.dart';

class UnfollowUserUsecase {
  final UsersRepository repository;

  UnfollowUserUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call(String userId) async {
    return repository.unfollowUser(userId);
  }
}
