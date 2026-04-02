// lib/domain/usecases/threads/reply_thread_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/thread_entity.dart';
import '../../repositories/threads_repository.dart';
import '../../../core/errors/failures.dart';

class ReplyThreadUsecase {
  final ThreadsRepository repository;

  ReplyThreadUsecase(this.repository);

  Future<Either<Failure, ThreadEntity>> call(String threadId, String content) async {
    return repository.replyToThread(threadId, content);
  }
}
