// lib/domain/usecases/chat/get_conversations_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/message_entity.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/errors/failures.dart';

class GetConversationsUsecase {
  final ChatRepository repository;

  GetConversationsUsecase(this.repository);

  Future<Either<Failure, List<MessageEntity>>> call(String userId) async {
    return repository.getConversation(userId);
  }
}
