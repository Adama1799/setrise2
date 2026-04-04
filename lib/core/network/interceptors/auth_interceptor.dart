import 'package:dio/dio.dart';
import '../../di/injection.dart';
import '../../../data/datasources/local/local_storage.dart';
import '../../constants/storage_keys.dart';

/// Interceptor for adding authentication token to requests
class AuthInterceptor extends Interceptor {
  final LocalStorage _localStorage = getIt<LocalStorage>();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get access token from local storage
    final token = await _localStorage.getString(StorageKeys.accessToken);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - Token expired
    if (err.response?.statusCode == 401) {
      // Try to refresh token
      final refreshed = await _refreshToken();

      if (refreshed) {
        // Retry the failed request
        try {
          final response = await _retry(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          // If retry fails, continue with error
        }
      }

      // If refresh failed, clear tokens and redirect to login
      await _logout();
    }

    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _localStorage.getString(
        StorageKeys.refreshToken,
      );

      if (refreshToken == null) return false;

      // Call refresh token endpoint
      // This is a simplified example - implement according to your API
      final dio = Dio();
      final response = await dio.post(
        '${getIt<DioClient>().dio.options.baseUrl}/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];

        await _localStorage.setString(StorageKeys.accessToken, newAccessToken);
        await _localStorage.setString(
          StorageKeys.refreshToken,
          newRefreshToken,
        );

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return getIt<DioClient>().dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<void> _logout() async {
    await _localStorage.remove(StorageKeys.accessToken);
    await _localStorage.remove(StorageKeys.refreshToken);
    await _localStorage.setBool(StorageKeys.isLoggedIn, false);
    
    // Navigate to login screen
    // You can use a navigation service here
  }
}
