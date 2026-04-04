// lib/domain/usecases/threads/delete_thread_usecase.dart
// BUG FIX: This file was at the WRONG path:
//   lib/domain/usecases/threads/lib/domain/usecases/threads/delete_thread_usecase.dart
// service_locator.dart imports it from the correct path:
//   '../../domain/usecases/threads/delete_thread_usecase.dart'
import 'package:dartz/dartz.dart';
import '../../errors/failures.dart';
import '../../repositories/threads_repository.dart';

class DeleteThreadUsecase {
  final ThreadsRepository _repository;
  DeleteThreadUsecase(this._repository);

  Future<Either<Failure, void>> call(String threadId) {
    return _repository.deleteThread(threadId);
  }
}
