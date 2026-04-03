// lib/data/datasources/remote/chat_remote_datasource.dart
import '../../../core/network/api_client.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<MessageModel>> getConversation(String userId);
  Future<List<MessageModel>> getMessages(String conversationId);
  Future<MessageModel> sendMessage(String receiverId, String content, {String? mediaUrl});
  Future<void> markAsRead(String messageId);
  Future<void> deleteMessage(String messageId);
  Future<List<MessageModel>> searchMessages(String query);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient apiClient;

  ChatRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<MessageModel>> getConversation(String userId) async {
    try {
      final response = await apiClient.get('${ApiEndpoints.usersEndpoint}/$userId/conversations');
      return (response as List)
          .map((e) => MessageModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MessageModel>> getMessages(String conversationId) async {
    try {
      final response = await apiClient.get('${ApiEndpoints.usersEndpoint}/conversations/$conversationId/messages');
      return (response as List)
          .map((e) => MessageModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MessageModel> sendMessage(String receiverId, String content, {String? mediaUrl}) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.usersEndpoint}/$receiverId/message',
        {
          'content': content,
          if (mediaUrl != null) 'mediaUrl': mediaUrl,
        },
      );
      return MessageModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> markAsRead(String messageId) async {
    try {
      await apiClient.post('${ApiEndpoints.usersEndpoint}/messages/$messageId/read', {});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    try {
      await apiClient.delete('${ApiEndpoints.usersEndpoint}/messages/$messageId');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MessageModel>> searchMessages(String query) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.usersEndpoint}/messages/search?q=$query',
      );
      return (response as List)
          .map((e) => MessageModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
