// lib/domain/usecases/threads/create_thread_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/thread_entity.dart';
import '../../repositories/threads_repository.dart';
import '../../../core/errors/failures.dart';

class CreateThreadUsecase {
  final ThreadsRepository repository;

  CreateThreadUsecase(this.repository);

  Future<Either<Failure, ThreadEntity>> call(String content) async {
    return repository.createThread(content);
  }
}
