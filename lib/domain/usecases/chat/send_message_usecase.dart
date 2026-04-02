// lib/domain/usecases/chat/send_message_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/message_entity.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/errors/failures.dart';

class SendMessageUsecase {
  final ChatRepository repository;

  SendMessageUsecase(this.repository);

  Future<Either<Failure, MessageEntity>> call(
    String receiverId,
    String content, {
    String? mediaUrl,
  }) async {
    return repository.sendMessage(receiverId, content, mediaUrl: mediaUrl);
  }
}
