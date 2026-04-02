// lib/domain/usecases/threads/repost_thread_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/thread_entity.dart';
import '../../repositories/threads_repository.dart';
import '../../../core/errors/failures.dart';

class RepostThreadUsecase {
  final ThreadsRepository repository;

  RepostThreadUsecase(this.repository);

  Future<Either<Failure, ThreadEntity>> call(String threadId) async {
    return repository.repostThread(threadId);
  }
}
