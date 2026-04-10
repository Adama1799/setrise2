// lib/domain/usecases/users/get_user_followers_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/user_entity.dart';
import '../../repositories/users_repository.dart';
import '../../../core/errors/failures.dart';

class GetUserFollowersUsecase {
  final UsersRepository repository;

  GetUserFollowersUsecase(this.repository);

  Future<Either<Failure, List<UserEntity>>> call(String userId) async {
    return repository.getUserFollowers(userId);
  }
}
