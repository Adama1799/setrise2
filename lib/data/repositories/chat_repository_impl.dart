// lib/data/repositories/chat_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/entities/message_entity.dart';
import '../datasources/remote/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MessageEntity>>> getConversation(String userId) async {
    try {
      final messages = await remoteDataSource.getConversation(userId);
      return Right(messages);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(String conversationId) async {
    try {
      final messages = await remoteDataSource.getMessages(conversationId);
      return Right(messages);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(
    String receiverId,
    String content, {
    String? mediaUrl,
  }) async {
    try {
      final message = await remoteDataSource.sendMessage(
        receiverId,
        content,
        mediaUrl: mediaUrl,
      );
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String messageId) async {
    try {
      await remoteDataSource.markAsRead(messageId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(String messageId) async {
    try {
      await remoteDataSource.deleteMessage(messageId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> searchMessages(String query) async {
    try {
      final messages = await remoteDataSource.searchMessages(query);
      return Right(messages);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
