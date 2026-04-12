here// lib/features/stories/data/repositories/story_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/story_repository.dart';
import '../datasources/story_remote_datasource.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource remoteDataSource;

  const StoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<StoryEntity>>> getFeedStories() async {
    try {
      final stories = await remoteDataSource.getFeedStories();
      return Right(stories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<StoryEntity>>> getUserStories(String userId) async {
    try {
      final stories = await remoteDataSource.getUserStories(userId);
      return Right(stories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, StoryEntity>> createStory({
    required String mediaPath,
    required StoryMediaType mediaType,
  }) async {
    try {
      final story = await remoteDataSource.createStory(
        mediaPath: mediaPath,
        mediaType: mediaType,
      );
      return Right(story);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteStory(String storyId) async {
    try {
      final result = await remoteDataSource.deleteStory(storyId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> viewStory(String storyId) async {
    try {
      final result = await remoteDataSource.viewStory(storyId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
