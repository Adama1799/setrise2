// lib/domain/usecases/posts/like_post_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/post_entity.dart';
import '../../repositories/posts_repository.dart';
import '../../../core/errors/failures.dart';

class LikePostUsecase {
  final PostsRepository repository;

  LikePostUsecase(this.repository);

  Future<Either<Failure, PostEntity>> call(String postId) async {
    return repository.likePost(postId);
  }
}
