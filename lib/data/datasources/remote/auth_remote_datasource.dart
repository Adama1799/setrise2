// lib/data/datasources/remote/auth_remote_datasource.dart
import '../../../core/network/api_client.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> register(String name, String email, String password, String username);
  Future<void> logout();
  Future<AuthResponseModel> refreshToken(String token);
  Future<void> resetPassword(String email);
  Future<void> changePassword(String oldPassword, String newPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.authEndpoint}/login',
        {'email': email, 'password': password},
      );
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthResponseModel> register(
    String name,
    String email,
    String password,
    String username,
  ) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.authEndpoint}/register',
        {
          'name': name,
          'email': email,
          'password': password,
          'username': username,
        },
      );
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post('${ApiEndpoints.authEndpoint}/logout', {});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthResponseModel> refreshToken(String token) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.authEndpoint}/refresh',
        {'token': token},
      );
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await apiClient.post(
        '${ApiEndpoints.authEndpoint}/reset-password',
        {'email': email},
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await apiClient.post(
        '${ApiEndpoints.authEndpoint}/change-password',
        {'oldPassword': oldPassword, 'newPassword': newPassword},
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
