// lib/domain/usecases/chat/delete_message_usecase.dart
import 'package:dartz/dartz.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/errors/failures.dart';

class DeleteMessageUsecase {
  final ChatRepository repository;

  DeleteMessageUsecase(this.repository);

  Future<Either<Failure, void>> call(String messageId) async {
    return repository.deleteMessage(messageId);
  }
}
