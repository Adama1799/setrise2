// lib/domain/usecases/threads/delete_thread_usecase.dart
import 'package:dartz/dartz.dart';
import '../../repositories/threads_repository.dart';
import '../../../core/errors/failures.dart';

class DeleteThreadUsecase {
  final ThreadsRepository repository;

  DeleteThreadUsecase(this.repository);

  Future<Either<Failure, void>> call(String threadId) async {
    return repository.deleteThread(threadId);
  }
}
