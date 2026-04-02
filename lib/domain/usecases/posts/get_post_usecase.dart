// lib/domain/usecases/posts/get_post_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/post_entity.dart';
import '../../repositories/posts_repository.dart';
import '../../../core/errors/failures.dart';

class GetPostUsecase {
  final PostsRepository repository;

  GetPostUsecase(this.repository);

  Future<Either<Failure, PostEntity>> call(String postId) async {
    return repository.getPost(postId);
  }
}
