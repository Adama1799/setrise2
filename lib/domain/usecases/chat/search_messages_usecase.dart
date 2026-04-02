// lib/domain/usecases/chat/search_messages_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/message_entity.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/errors/failures.dart';

class SearchMessagesUsecase {
  final ChatRepository repository;

  SearchMessagesUsecase(this.repository);

  Future<Either<Failure, List<MessageEntity>>> call(String query) async {
    return repository.searchMessages(query);
  }
}
