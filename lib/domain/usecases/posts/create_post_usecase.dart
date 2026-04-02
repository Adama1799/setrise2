// lib/domain/usecases/posts/create_post_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/post_entity.dart';
import '../../repositories/posts_repository.dart';
import '../../../core/errors/failures.dart';

class CreatePostUsecase {
  final PostsRepository repository;

  CreatePostUsecase(this.repository);

  Future<Either<Failure, PostEntity>> call(
    String content,
    List<String> mediaUrls,
  ) async {
    return repository.createPost(content, mediaUrls);
  }
}
