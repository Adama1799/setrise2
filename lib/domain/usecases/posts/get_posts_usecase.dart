// lib/domain/usecases/posts/get_posts_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/post_entity.dart';
import '../../repositories/posts_repository.dart';
import '../../../core/errors/failures.dart';

class GetPostsUsecase {
  final PostsRepository repository;

  GetPostsUsecase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call(int page) async {
    return repository.getPosts(page);
  }
}
