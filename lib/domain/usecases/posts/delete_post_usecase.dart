// lib/domain/usecases/posts/delete_post_usecase.dart
import 'package:dartz/dartz.dart';
import '../../repositories/posts_repository.dart';
import '../../../core/errors/failures.dart';

class DeletePostUsecase {
  final PostsRepository repository;

  DeletePostUsecase(this.repository);

  Future<Either<Failure, void>> call(String postId) async {
    return repository.deletePost(postId);
  }
}
