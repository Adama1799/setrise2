// lib/domain/usecases/threads/get_thread_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/thread_entity.dart';
import '../../repositories/threads_repository.dart';
import '../../../core/errors/failures.dart';

class GetThreadUsecase {
  final ThreadsRepository repository;

  GetThreadUsecase(this.repository);

  Future<Either<Failure, ThreadEntity>> call(String threadId) async {
    return repository.getThread(threadId);
  }
}
