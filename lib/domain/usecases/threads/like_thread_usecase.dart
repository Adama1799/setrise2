// lib/domain/usecases/threads/like_thread_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/thread_entity.dart';
import '../../repositories/threads_repository.dart';
import '../../../core/errors/failures.dart';

class LikeThreadUsecase {
  final ThreadsRepository repository;

  LikeThreadUsecase(this.repository);

  Future<Either<Failure, ThreadEntity>> call(String threadId) async {
    return repository.likeThread(threadId);
  }
}
