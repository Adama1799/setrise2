import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor for logging HTTP requests and responses in debug mode
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌───────────────────────────────────────────────────────────');
      print('│ 🚀 REQUEST');
      print('├───────────────────────────────────────────────────────────');
      print('│ Method: ${options.method}');
      print('│ URL: ${options.uri}');
      print('│ Headers: ${options.headers}');
      if (options.queryParameters.isNotEmpty) {
        print('│ Query Parameters: ${options.queryParameters}');
      }
      if (options.data != null) {
        print('│ Data: ${options.data}');
      }
      print('└───────────────────────────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌───────────────────────────────────────────────────────────');
      print('│ ✅ RESPONSE');
      print('├───────────────────────────────────────────────────────────');
      print('│ Status Code: ${response.statusCode}');
      print('│ URL: ${response.requestOptions.uri}');
      print('│ Headers: ${response.headers}');
      print('│ Data: ${response.data}');
      print('└───────────────────────────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌───────────────────────────────────────────────────────────');
      print('│ ❌ ERROR');
      print('├───────────────────────────────────────────────────────────');
      print('│ Type: ${err.type}');
      print('│ Message: ${err.message}');
      print('│ URL: ${err.requestOptions.uri}');
      if (err.response != null) {
        print('│ Status Code: ${err.response?.statusCode}');
        print('│ Data: ${err.response?.data}');
      }
      print('│ Stack Trace: ${err.stackTrace}');
      print('└───────────────────────────────────────────────────────────');
    }
    handler.next(err);
  }
}
