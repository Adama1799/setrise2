// lib/domain/usecases/chat/get_messages_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/message_entity.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/errors/failures.dart';

class GetMessagesUsecase {
  final ChatRepository repository;

  GetMessagesUsecase(this.repository);

  Future<Either<Failure, List<MessageEntity>>> call(String conversationId) async {
    return repository.getMessages(conversationId);
  }
}
