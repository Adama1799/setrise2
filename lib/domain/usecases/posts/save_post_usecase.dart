// lib/domain/usecases/posts/save_post_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/post_entity.dart';
import '../../repositories/posts_repository.dart';
import '../../../core/errors/failures.dart';

class SavePostUsecase {
  final PostsRepository repository;

  SavePostUsecase(this.repository);

  Future<Either<Failure, PostEntity>> call(String postId) async {
    return repository.savePost(postId);
  }
}
