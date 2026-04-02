// lib/domain/repositories/posts_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/post_entity.dart';
import '../../core/errors/failures.dart';

abstract class PostsRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts(int page);
  Future<Either<Failure, PostEntity>> getPost(String postId);
  Future<Either<Failure, List<PostEntity>>> getPostsByHashtag(String hashtag);
  Future<Either<Failure, PostEntity>> createPost(String content, List<String> mediaUrls);
  Future<Either<Failure, void>> deletePost(String postId);
  Future<Either<Failure, PostEntity>> likePost(String postId);
  Future<Either<Failure, PostEntity>> unlikePost(String postId);
  Future<Either<Failure, PostEntity>> savePost(String postId);
  Future<Either<Failure, PostEntity>> unsavePost(String postId);
  Future<Either<Failure, List<PostEntity>>> getSavedPosts();
}
