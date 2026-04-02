// lib/domain/usecases/threads/get_threads_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/thread_entity.dart';
import '../../repositories/threads_repository.dart';
import '../../../core/errors/failures.dart';

class GetThreadsUsecase {
  final ThreadsRepository repository;

  GetThreadsUsecase(this.repository);

  Future<Either<Failure, List<ThreadEntity>>> call(int page) async {
    return repository.getThreads(page);
  }
}
