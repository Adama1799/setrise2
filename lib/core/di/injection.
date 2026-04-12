import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/local_storage.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/chat_remote_datasource.dart';
import '../../data/datasources/remote/dating_remote_datasource.dart';
import '../../data/datasources/remote/posts_remote_datasource.dart';
import '../../data/datasources/remote/threads_remote_datasource.dart';
import '../../data/datasources/remote/users_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/dating_repository_impl.dart';
import '../../data/repositories/posts_repository_impl.dart';
import '../../data/repositories/threads_repository_impl.dart';
import '../../data/repositories/users_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/dating_repository.dart';
import '../../domain/repositories/posts_repository.dart';
import '../../domain/repositories/threads_repository.dart';
import '../../domain/repositories/users_repository.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/posts/create_post_usecase.dart';
import '../../domain/usecases/posts/delete_post_usecase.dart';
import '../../domain/usecases/posts/get_feed_usecase.dart';
import '../../domain/usecases/posts/like_post_usecase.dart';
import '../../domain/usecases/threads/create_thread_usecase.dart';
import '../../domain/usecases/threads/get_threads_usecase.dart';
import '../../domain/usecases/users/follow_user_usecase.dart';
import '../../domain/usecases/users/get_user_profile_usecase.dart';
import '../constants/api_endpoints.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> initDependencies() async {
  // ==================== External Dependencies ====================
  
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Hive
  await Hive.initFlutter();
  getIt.registerLazySingleton(() => Hive);

  // Connectivity
  getIt.registerLazySingleton(() => Connectivity());

  // Dio
  getIt.registerLazySingleton(() => Dio());

  // ==================== Core ====================
  
  // Network Info
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt()),
  );

  // Local Storage
  getIt.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(getIt()),
  );

  // Dio Client
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      baseUrl: '${ApiEndpoints.baseUrl}${ApiEndpoints.apiVersion}',
      dio: getIt(),
    ),
  );

  // ==================== Data Sources ====================
  
  // Remote Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<UsersRemoteDataSource>(
    () => UsersRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<PostsRemoteDataSource>(
    () => PostsRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<ThreadsRemoteDataSource>(
    () => ThreadsRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<DatingRemoteDataSource>(
    () => DatingRemoteDataSourceImpl(getIt()),
  );

  // ==================== Repositories ====================
  
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localStorage: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton<UsersRepository>(
    () => UsersRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton<PostsRepository>(
    () => PostsRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton<ThreadsRepository>(
    () => ThreadsRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton<DatingRepository>(
    () => DatingRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // ==================== Use Cases ====================
  
  // Auth Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));

  // User Use Cases
  getIt.registerLazySingleton(() => GetUserProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => FollowUserUseCase(getIt()));

  // Post Use Cases
  getIt.registerLazySingleton(() => GetFeedUseCase(getIt()));
  getIt.registerLazySingleton(() => CreatePostUseCase(getIt()));
  getIt.registerLazySingleton(() => LikePostUseCase(getIt()));
  getIt.registerLazySingleton(() => DeletePostUseCase(getIt()));

  // Thread Use Cases
  getIt.registerLazySingleton(() => GetThreadsUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateThreadUseCase(getIt()));
}

/// Clear all dependencies (for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
