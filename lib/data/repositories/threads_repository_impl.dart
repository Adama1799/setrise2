// lib/data/repositories/threads_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/repositories/threads_repository.dart';
import '../../domain/entities/thread_entity.dart';
import '../datasources/remote/threads_remote_datasource.dart';

class ThreadsRepositoryImpl implements ThreadsRepository {
  final ThreadsRemoteDataSource remoteDataSource;

  ThreadsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ThreadEntity>>> getThreads(int page) async {
    try {
      final threads = await remoteDataSource.getThreads(page);
      return Right(threads);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ThreadEntity>> getThread(String threadId) async {
    try {
      final thread = await remoteDataSource.getThread(threadId);
      return Right(thread);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ThreadEntity>>> getThreadReplies(String threadId) async {
    try {
      final replies = await remoteDataSource.getThreadReplies(threadId);
      return Right(replies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ThreadEntity>> createThread(String content) async {
    try {
      final thread = await remoteDataSource.createThread(content);
      return Right(thread);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ThreadEntity>> replyToThread(String threadId, String content) async {
    try {
      final reply = await remoteDataSource.replyToThread(threadId, content);
      return Right(reply);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteThread(String threadId) async {
    try {
      await remoteDataSource.deleteThread(threadId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ThreadEntity>> likeThread(String threadId) async {
    try {
      final thread = await remoteDataSource.likeThread(threadId);
      return Right(thread);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ThreadEntity>> unlikeThread(String threadId) async {
    try {
      final thread = await remoteDataSource.unlikeThread(threadId);
      return Right(thread);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ThreadEntity>> repostThread(String threadId) async {
    try {
      final thread = await remoteDataSource.repostThread(threadId);
      return Right(thread);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ThreadEntity>> unrepostThread(String threadId) async {
    try {
      final thread = await remoteDataSource.unrepostThread(threadId);
      return Right(thread);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
