// lib/domain/repositories/threads_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/thread_entity.dart';
import '../../core/errors/failures.dart';

abstract class ThreadsRepository {
  Future<Either<Failure, List<ThreadEntity>>> getThreads(int page);
  Future<Either<Failure, ThreadEntity>> getThread(String threadId);
  Future<Either<Failure, List<ThreadEntity>>> getThreadReplies(String threadId);
  Future<Either<Failure, ThreadEntity>> createThread(String content);
  Future<Either<Failure, ThreadEntity>> replyToThread(String threadId, String content);
  Future<Either<Failure, void>> deleteThread(String threadId);
  Future<Either<Failure, ThreadEntity>> likeThread(String threadId);
  Future<Either<Failure, ThreadEntity>> unlikeThread(String threadId);
  Future<Either<Failure, ThreadEntity>> repostThread(String threadId);
  Future<Either<Failure, ThreadEntity>> unrepostThread(String threadId);
}
