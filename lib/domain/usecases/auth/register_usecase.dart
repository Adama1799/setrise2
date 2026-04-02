// lib/domain/usecases/auth/register_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call(
    String name,
    String email,
    String password,
    String username,
  ) async {
    return repository.register(name, email, password, username);
  }
}
