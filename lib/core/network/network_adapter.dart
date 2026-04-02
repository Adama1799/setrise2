// lib/core/network/network_adapter.dart
import 'package:dio/dio.dart';
import '../utils/universal_platform.dart';

class NetworkAdapter {
  static Dio setupDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.setrise.app',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
        // Add certificates for iOS/Android
        headers: {
          'User-Agent': _getUserAgent(),
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('📤 REQUEST: ${options.method} ${options.path}');
          return handler.next(options);
        },
      ),
    );

    return dio;
  }

  static String _getUserAgent() {
    if (UniversalPlatform.isWeb) {
      return 'SetRise/Web';
    } else if (UniversalPlatform.isAndroid) {
      return 'SetRise/Android';
    } else if (UniversalPlatform.isIOS) {
      return 'SetRise/iOS';
    } else {
      return 'SetRise/Desktop';
    }
  }
}
