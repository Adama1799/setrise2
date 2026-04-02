// lib/domain/usecases/auth/logout_usecase.dart
import 'package:dartz/dartz.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  Future<Either<Failure, void>> call() async {
    return repository.logout();
  }
}
