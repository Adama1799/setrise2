// lib/core/network/network_adapter.dart
// BUG FIX: Was importing UniversalPlatform from '../utils/universal_platform.dart'
//           which resolves to lib/core/utils/universal_platform.dart (DOESN'T EXIST)
//           Correct path is lib/presentation/utils/universal_platform.dart
import 'package:dio/dio.dart';
import '../../presentation/utils/universal_platform.dart'; // ✅ FIXED import path

class NetworkAdapter {
  static Dio setupDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.setrise.app',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
        headers: {
          'User-Agent': _getUserAgent(),
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('📤 REQUEST: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('📥 RESPONSE: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ ERROR: ${error.message}');
          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  static String _getUserAgent() {
    if (UniversalPlatform.isWeb) return 'SetRise/Web';
    if (UniversalPlatform.isAndroid) return 'SetRise/Android';
    if (UniversalPlatform.isIOS) return 'SetRise/iOS';
    return 'SetRise/Desktop';
  }
}
