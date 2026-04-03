// lib/core/di/service_locator.dart
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Network
  getIt.registerSingleton<ApiClient>(ApiClient());

  // Register datasources, repositories, use cases here
}
