// lib/domain/repositories/chat_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/message_entity.dart';
import '../../core/errors/failures.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<MessageEntity>>> getConversation(String userId);
  Future<Either<Failure, List<MessageEntity>>> getMessages(String conversationId);
  Future<Either<Failure, MessageEntity>> sendMessage(
    String receiverId,
    String content, {
    String? mediaUrl,
  });
  Future<Either<Failure, void>> markAsRead(String messageId);
  Future<Either<Failure, void>> deleteMessage(String messageId);
  Future<Either<Failure, List<MessageEntity>>> searchMessages(String query);
}
