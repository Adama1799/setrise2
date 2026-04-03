// lib/data/repositories/posts_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/repositories/posts_repository.dart';
import '../../domain/entities/post_entity.dart';
import '../datasources/remote/posts_remote_datasource.dart';
import '../datasources/local/local_cache_datasource.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;
  final LocalCacheDataSource cacheDataSource;

  PostsRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheDataSource,
  });

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts(int page) async {
    try {
      final posts = await remoteDataSource.getPosts(page);
      await cacheDataSource.cachePosts(posts.map((e) => e.toJson()).toList());
      return Right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      // Try to get cached data
      try {
        final cached = await cacheDataSource.getCachedPosts();
        if (cached.isNotEmpty) return Right(cached.map((e) {}).toList() as List<PostEntity>);
      } catch (_) {}
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPost(String postId) async {
    try {
      final post = await remoteDataSource.getPost(postId);
      return Right(post);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getPostsByHashtag(String hashtag) async {
    try {
      final posts = await remoteDataSource.getPostsByHashtag(hashtag);
      return Right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> createPost(String content, List<String> mediaUrls) async {
    try {
      final post = await remoteDataSource.createPost(content, mediaUrls);
      return Right(post);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      await remoteDataSource.deletePost(postId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> likePost(String postId) async {
    try {
      final post = await remoteDataSource.likePost(postId);
      return Right(post);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> unlikePost(String postId) async {
    try {
      final post = await remoteDataSource.unlikePost(postId);
      return Right(post);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> savePost(String postId) async {
    try {
      final post = await remoteDataSource.savePost(postId);
      return Right(post);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> unsavePost(String postId) async {
    try {
      final post = await remoteDataSource.unsavePost(postId);
      return Right(post);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getSavedPosts() async {
    try {
      final posts = await remoteDataSource.getSavedPosts();
      return Right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
