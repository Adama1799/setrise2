// lib/domain/usecases/dating/update_dating_profile_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/dating_profile_entity.dart';
import '../../repositories/dating_repository.dart';
import '../../../core/errors/failures.dart';

class UpdateDatingProfileUsecase {
  final DatingRepository repository;

  UpdateDatingProfileUsecase(this.repository);

  Future<Either<Failure, DatingProfileEntity>> call(Map<String, dynamic> data) async {
    return repository.updateProfile(data);
  }
}
