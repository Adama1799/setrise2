// lib/data/datasources/remote/dating_remote_datasource.dart
import '../../../core/network/api_client.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/dating_profile_model.dart';

abstract class DatingRemoteDataSource {
  Future<List<DatingProfileModel>> getProfiles();
  Future<DatingProfileModel> getProfile(String profileId);
  Future<DatingProfileModel> updateProfile(Map<String, dynamic> data);
  Future<void> likeProfile(String profileId);
  Future<void> passProfile(String profileId);
  Future<List<DatingProfileModel>> getMatches();
  Future<void> startConversation(String profileId);
}

class DatingRemoteDataSourceImpl implements DatingRemoteDataSource {
  final ApiClient apiClient;

  DatingRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<DatingProfileModel>> getProfiles() async {
    try {
      final response = await apiClient.get('${ApiEndpoints.usersEndpoint}/dating/discover');
      return (response as List)
          .map((e) => DatingProfileModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<DatingProfileModel> getProfile(String profileId) async {
    try {
      final response = await apiClient.get('${ApiEndpoints.usersEndpoint}/dating/$profileId');
      return DatingProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<DatingProfileModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.put(
        '${ApiEndpoints.usersEndpoint}/dating/profile',
        data,
      );
      return DatingProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> likeProfile(String profileId) async {
    try {
      await apiClient.post(
        '${ApiEndpoints.usersEndpoint}/dating/$profileId/like',
        {},
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> passProfile(String profileId) async {
    try {
      await apiClient.post(
        '${ApiEndpoints.usersEndpoint}/dating/$profileId/pass',
        {},
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<DatingProfileModel>> getMatches() async {
    try {
      final response = await apiClient.get('${ApiEndpoints.usersEndpoint}/dating/matches');
      return (response as List)
          .map((e) => DatingProfileModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> startConversation(String profileId) async {
    try {
      await apiClient.post(
        '${ApiEndpoints.usersEndpoint}/dating/$profileId/message',
        {},
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
