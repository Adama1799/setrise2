// lib/data/datasources/remote/posts_remote_datasource.dart
import '../../../core/network/api_client.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/post_model.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostModel>> getPosts(int page);
  Future<PostModel> getPost(String postId);
  Future<List<PostModel>> getPostsByHashtag(String hashtag);
  Future<PostModel> createPost(String content, List<String> mediaUrls);
  Future<void> deletePost(String postId);
  Future<PostModel> likePost(String postId);
  Future<PostModel> unlikePost(String postId);
  Future<PostModel> savePost(String postId);
  Future<PostModel> unsavePost(String postId);
  Future<List<PostModel>> getSavedPosts();
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final ApiClient apiClient;

  PostsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<PostModel>> getPosts(int page) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.postsEndpoint}?page=$page&limit=${AppConstants.pageSize}',
      );
      return (response as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PostModel> getPost(String postId) async {
    try {
      final response = await apiClient.get('${ApiEndpoints.postsEndpoint}/$postId');
      return PostModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PostModel>> getPostsByHashtag(String hashtag) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.postsEndpoint}/hashtag/$hashtag',
      );
      return (response as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PostModel> createPost(String content, List<String> mediaUrls) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.postsEndpoint,
        {'content': content, 'mediaUrls': mediaUrls},
      );
      return PostModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await apiClient.delete('${ApiEndpoints.postsEndpoint}/$postId');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PostModel> likePost(String postId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.postsEndpoint}/$postId/like',
        {},
      );
      return PostModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PostModel> unlikePost(String postId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.postsEndpoint}/$postId/unlike',
        {},
      );
      return PostModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PostModel> savePost(String postId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.postsEndpoint}/$postId/save',
        {},
      );
      return PostModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PostModel> unsavePost(String postId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.postsEndpoint}/$postId/unsave',
        {},
      );
      return PostModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PostModel>> getSavedPosts() async {
    try {
      final response = await apiClient.get('${ApiEndpoints.postsEndpoint}/saved');
      return (response as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
