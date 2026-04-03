// lib/data/datasources/remote/threads_remote_datasource.dart
import '../../../core/network/api_client.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/thread_model.dart';

abstract class ThreadsRemoteDataSource {
  Future<List<ThreadModel>> getThreads(int page);
  Future<ThreadModel> getThread(String threadId);
  Future<List<ThreadModel>> getThreadReplies(String threadId);
  Future<ThreadModel> createThread(String content);
  Future<ThreadModel> replyToThread(String threadId, String content);
  Future<void> deleteThread(String threadId);
  Future<ThreadModel> likeThread(String threadId);
  Future<ThreadModel> unlikeThread(String threadId);
  Future<ThreadModel> repostThread(String threadId);
  Future<ThreadModel> unrepostThread(String threadId);
}

class ThreadsRemoteDataSourceImpl implements ThreadsRemoteDataSource {
  final ApiClient apiClient;

  ThreadsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ThreadModel>> getThreads(int page) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.threadsEndpoint}?page=$page&limit=${AppConstants.pageSize}',
      );
      return (response as List)
          .map((e) => ThreadModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ThreadModel> getThread(String threadId) async {
    try {
      final response = await apiClient.get('${ApiEndpoints.threadsEndpoint}/$threadId');
      return ThreadModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ThreadModel>> getThreadReplies(String threadId) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.threadsEndpoint}/$threadId/replies',
      );
      return (response as List)
          .map((e) => ThreadModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ThreadModel> createThread(String content) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.threadsEndpoint,
        {'content': content},
      );
      return ThreadModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ThreadModel> replyToThread(String threadId, String content) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.threadsEndpoint}/$threadId/reply',
        {'content': content},
      );
      return ThreadModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteThread(String threadId) async {
    try {
      await apiClient.delete('${ApiEndpoints.threadsEndpoint}/$threadId');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ThreadModel> likeThread(String threadId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.threadsEndpoint}/$threadId/like',
        {},
      );
      return ThreadModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ThreadModel> unlikeThread(String threadId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.threadsEndpoint}/$threadId/unlike',
        {},
      );
      return ThreadModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ThreadModel> repostThread(String threadId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.threadsEndpoint}/$threadId/repost',
        {},
      );
      return ThreadModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ThreadModel> unrepostThread(String threadId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.threadsEndpoint}/$threadId/unrepost',
        {},
      );
      return ThreadModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
