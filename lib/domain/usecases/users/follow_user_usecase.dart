// lib/domain/usecases/users/follow_user_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/user_entity.dart';
import '../../repositories/users_repository.dart';
import '../../../core/errors/failures.dart';

class FollowUserUsecase {
  final UsersRepository repository;

  FollowUserUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call(String userId) async {
    return repository.followUser(userId);
  }
}
