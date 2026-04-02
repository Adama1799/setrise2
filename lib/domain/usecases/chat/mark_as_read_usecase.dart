// lib/domain/usecases/chat/mark_as_read_usecase.dart
import 'package:dartz/dartz.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/errors/failures.dart';

class MarkAsReadUsecase {
  final ChatRepository repository;

  MarkAsReadUsecase(this.repository);

  Future<Either<Failure, void>> call(String messageId) async {
    return repository.markAsRead(messageId);
  }
}
