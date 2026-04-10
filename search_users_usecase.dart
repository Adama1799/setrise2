// lib/domain/usecases/users/search_users_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/user_entity.dart';
import '../../repositories/users_repository.dart';
import '../../../core/errors/failures.dart';

class SearchUsersUsecase {
  final UsersRepository repository;

  SearchUsersUsecase(this.repository);

  Future<Either<Failure, List<UserEntity>>> call(String query) async {
    return repository.searchUsers(query);
  }
}
