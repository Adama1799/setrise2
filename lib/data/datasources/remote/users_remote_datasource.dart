// lib/data/datasources/remote/users_remote_datasource.dart
import '../../../core/network/api_client.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';

abstract class UsersRemoteDataSource {
  Future<UserModel> getUser(String userId);
  Future<UserModel> updateProfile(Map<String, dynamic> data);
  Future<UserModel> followUser(String userId);
  Future<UserModel> unfollowUser(String userId);
  Future<List<UserModel>> searchUsers(String query);
  Future<List<UserModel>> getUserFollowers(String userId);
  Future<List<UserModel>> getUserFollowing(String userId);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final ApiClient apiClient;

  UsersRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final response = await apiClient.get('${ApiEndpoints.usersEndpoint}/$userId');
      return UserModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.put(
        '${ApiEndpoints.usersEndpoint}/profile',
        data,
      );
      return UserModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> followUser(String userId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.usersEndpoint}/$userId/follow',
        {},
      );
      return UserModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> unfollowUser(String userId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.usersEndpoint}/$userId/unfollow',
        {},
      );
      return UserModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.usersEndpoint}/search?q=$query',
      );
      return (response as List)
          .map((e) => UserModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<UserModel>> getUserFollowers(String userId) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.usersEndpoint}/$userId/followers',
      );
      return (response as List)
          .map((e) => UserModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<UserModel>> getUserFollowing(String userId) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.usersEndpoint}/$userId/following',
      );
      return (response as List)
          .map((e) => UserModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
