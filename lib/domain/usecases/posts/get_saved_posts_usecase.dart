// lib/domain/usecases/posts/get_saved_posts_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/post_entity.dart';
import '../../repositories/posts_repository.dart';
import '../../../core/errors/failures.dart';

class GetSavedPostsUsecase {
  final PostsRepository repository;

  GetSavedPostsUsecase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call() async {
    return repository.getSavedPosts();
  }
}
