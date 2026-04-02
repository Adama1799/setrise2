// lib/domain/usecases/auth/change_password_usecase.dart
import 'package:dartz/dartz.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';

class ChangePasswordUsecase {
  final AuthRepository repository;

  ChangePasswordUsecase(this.repository);

  Future<Either<Failure, void>> call(String oldPassword, String newPassword) async {
    return repository.changePassword(oldPassword, newPassword);
  }
}
