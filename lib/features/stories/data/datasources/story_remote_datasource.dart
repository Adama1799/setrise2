// lib/features/stories/data/datasources/story_remote_datasource.dart

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/story_entity.dart';
import '../models/story_model.dart';

abstract class StoryRemoteDataSource {
  Future<List<StoryModel>> getFeedStories();
  Future<List<StoryModel>> getUserStories(String userId);
  Future<StoryModel> createStory({required String mediaPath, required StoryMediaType mediaType});
  Future<bool> deleteStory(String storyId);
  Future<bool> viewStory(String storyId);
}

class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  final ApiClient apiClient;

  const StoryRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<StoryModel>> getFeedStories() async {
    try {
      final response = await apiClient.get(ApiEndpoints.storiesEndpoint);
      final List data = response['data'] as List;
      return data.map((e) => StoryModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<StoryModel>> getUserStories(String userId) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.getUserStoriesEndpoint(userId),
      );
      final List data = response['data'] as List;
      return data.map((e) => StoryModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<StoryModel> createStory({
    required String mediaPath,
    required StoryMediaType mediaType,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.createStoryEndpoint,
        data: {
          'media_path': mediaPath,
          'media_type': mediaType.name,
        },
      );
      return StoryModel.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> deleteStory(String storyId) async {
    try {
      await apiClient.delete(ApiEndpoints.deleteStoryEndpoint(storyId));
      return true;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> viewStory(String storyId) async {
    try {
      await apiClient.post(
        ApiEndpoints.viewStoryEndpoint,
        data: {'story_id': storyId},
      );
      return true;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
