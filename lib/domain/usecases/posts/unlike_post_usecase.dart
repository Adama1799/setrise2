// lib/domain/usecases/posts/unlike_post_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/post_entity.dart';
import '../../repositories/posts_repository.dart';
import '../../../core/errors/failures.dart';

class UnlikePostUsecase {
  final PostsRepository repository;

  UnlikePostUsecase(this.repository);

  Future<Either<Failure, PostEntity>> call(String postId) async {
    return repository.unlikePost(postId);
  }
}
