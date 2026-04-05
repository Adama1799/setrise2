import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/threads_repository.dart';

class DeleteThreadUseCase implements UseCase<void, String> {
  final ThreadsRepository _repository;

  DeleteThreadUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String threadId) {
    return _repository.deleteThread(threadId);
  }
}
