// lib/core/di/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../../data/datasources/remote/posts_remote_datasource.dart';
import '../../data/datasources/remote/threads_remote_datasource.dart';
import '../../data/datasources/remote/users_remote_datasource.dart';
import '../../data/datasources/remote/shop_remote_datasource.dart';
import '../../data/datasources/remote/live_remote_datasource.dart';
import '../../data/datasources/remote/music_remote_datasource.dart';
import '../../data/datasources/remote/dating_remote_datasource.dart';
import '../../data/datasources/remote/chat_remote_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/local/local_cache_datasource.dart';
import '../../data/datasources/local/preferences_datasource.dart';
import '../../data/repositories/posts_repository_impl.dart';
import '../../data/repositories/threads_repository_impl.dart';
import '../../data/repositories/users_repository_impl.dart';
import '../../data/repositories/shop_repository_impl.dart';
import '../../data/repositories/live_repository_impl.dart';
import '../../data/repositories/music_repository_impl.dart';
import '../../data/repositories/dating_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/posts_repository.dart';
import '../../domain/repositories/threads_repository.dart';
import '../../domain/repositories/users_repository.dart';
import '../../domain/repositories/shop_repository.dart';
import '../../domain/repositories/live_repository.dart';
import '../../domain/repositories/music_repository.dart';
import '../../domain/repositories/dating_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/posts/get_posts_usecase.dart';
import '../../domain/usecases/posts/get_post_usecase.dart';
import '../../domain/usecases/posts/create_post_usecase.dart';
import '../../domain/usecases/posts/delete_post_usecase.dart';
import '../../domain/usecases/posts/like_post_usecase.dart';
import '../../domain/usecases/posts/unlike_post_usecase.dart';
import '../../domain/usecases/posts/save_post_usecase.dart';
import '../../domain/usecases/posts/get_saved_posts_usecase.dart';
import '../../domain/usecases/threads/get_threads_usecase.dart';
import '../../domain/usecases/threads/get_thread_usecase.dart';
import '../../domain/usecases/threads/create_thread_usecase.dart';
import '../../domain/usecases/threads/reply_thread_usecase.dart';
import '../../domain/usecases/threads/delete_thread_usecase.dart';
import '../../domain/usecases/threads/like_thread_usecase.dart';
import '../../domain/usecases/threads/repost_thread_usecase.dart';
import '../../domain/usecases/users/get_user_usecase.dart';
import '../../domain/usecases/users/update_profile_usecase.dart';
import '../../domain/usecases/users/follow_user_usecase.dart';
import '../../domain/usecases/users/unfollow_user_usecase.dart';
import '../../domain/usecases/users/search_users_usecase.dart';
import '../../domain/usecases/users/get_user_followers_usecase.dart';
import '../../domain/usecases/shop/get_products_usecase.dart';
import '../../domain/usecases/shop/get_product_usecase.dart';
import '../../domain/usecases/shop/search_products_usecase.dart';
import '../../domain/usecases/shop/get_favorite_products_usecase.dart';
import '../../domain/usecases/shop/add_to_favorite_usecase.dart';
import '../../domain/usecases/shop/get_categories_usecase.dart';
import '../../domain/usecases/live/get_live_streams_usecase.dart';
import '../../domain/usecases/live/get_live_stream_usecase.dart';
import '../../domain/usecases/live/start_live_stream_usecase.dart';
import '../../domain/usecases/live/end_live_stream_usecase.dart';
import '../../domain/usecases/live/like_live_stream_usecase.dart';
import '../../domain/usecases/music/get_tracks_usecase.dart';
import '../../domain/usecases/music/get_trending_tracks_usecase.dart';
import '../../domain/usecases/music/get_track_usecase.dart';
import '../../domain/usecases/music/search_tracks_usecase.dart';
import '../../domain/usecases/music/like_track_usecase.dart';
import '../../domain/usecases/music/get_favorite_tracks_usecase.dart';
import '../../domain/usecases/dating/get_profiles_usecase.dart';
import '../../domain/usecases/dating/get_profile_usecase.dart';
import '../../domain/usecases/dating/update_dating_profile_usecase.dart';
import '../../domain/usecases/dating/like_profile_usecase.dart';
import '../../domain/usecases/dating/pass_profile_usecase.dart';
import '../../domain/usecases/dating/get_matches_usecase.dart';
import '../../domain/usecases/chat/get_conversations_usecase.dart';
import '../../domain/usecases/chat/get_messages_usecase.dart';
import '../../domain/usecases/chat/send_message_usecase.dart';
import '../../domain/usecases/chat/mark_as_read_usecase.dart';
import '../../domain/usecases/chat/delete_message_usecase.dart';
import '../../domain/usecases/chat/search_messages_usecase.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/reset_password_usecase.dart';
import '../../domain/usecases/auth/change_password_usecase.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External
  final prefs = await SharedPreferences.getInstance();

  // Network
  getIt.registerSingleton<ApiClient>(ApiClient());

  // Local
  getIt.registerSingleton<LocalCacheDataSource>(LocalCacheDataSourceImpl());
  getIt.registerSingleton<PreferencesDataSource>(PreferencesDataSource(prefs));

  // Remote Datasources
  getIt.registerSingleton<PostsRemoteDataSource>(
    PostsRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerSingleton<ThreadsRemoteDataSource>(
    ThreadsRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerSingleton<UsersRemoteDataSource>(
    UsersRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerSingleton<ShopRemoteDataSource>(
    ShopRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerSingleton<LiveRemoteDataSource>(
    LiveRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerSingleton<MusicRemoteDataSource>(
    MusicRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerSingleton<DatingRemoteDataSource>(
    DatingRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerSingleton<ChatRemoteDataSource>(
    ChatRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerSingleton<PostsRepository>(
    PostsRepositoryImpl(
      remoteDataSource: getIt<PostsRemoteDataSource>(),
      cacheDataSource: getIt<LocalCacheDataSource>(),
    ),
  );
  getIt.registerSingleton<ThreadsRepository>(
    ThreadsRepositoryImpl(getIt<ThreadsRemoteDataSource>()),
  );
  getIt.registerSingleton<UsersRepository>(
    UsersRepositoryImpl(getIt<UsersRemoteDataSource>()),
  );
  getIt.registerSingleton<ShopRepository>(
    ShopRepositoryImpl(getIt<ShopRemoteDataSource>()),
  );
  getIt.registerSingleton<LiveRepository>(
    LiveRepositoryImpl(getIt<LiveRemoteDataSource>()),
  );
  getIt.registerSingleton<MusicRepository>(
    MusicRepositoryImpl(getIt<MusicRemoteDataSource>()),
  );
  getIt.registerSingleton<DatingRepository>(
    DatingRepositoryImpl(getIt<DatingRemoteDataSource>()),
  );
  getIt.registerSingleton<ChatRepository>(
    ChatRepositoryImpl(getIt<ChatRemoteDataSource>()),
  );
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      preferencesDataSource: getIt<PreferencesDataSource>(),
    ),
  );

  // Posts Use Cases
  getIt.registerSingleton<GetPostsUsecase>(
    GetPostsUsecase(getIt<PostsRepository>()),
  );
  getIt.registerSingleton<GetPostUsecase>(
    GetPostUsecase(getIt<PostsRepository>()),
  );
  getIt.registerSingleton<CreatePostUsecase>(
    CreatePostUsecase(getIt<PostsRepository>()),
  );
  getIt.registerSingleton<DeletePostUsecase>(
    DeletePostUsecase(getIt<PostsRepository>()),
  );
  getIt.registerSingleton<LikePostUsecase>(
    LikePostUsecase(getIt<PostsRepository>()),
  );
  getIt.registerSingleton<UnlikePostUsecase>(
    UnlikePostUsecase(getIt<PostsRepository>()),
  );
  getIt.registerSingleton<SavePostUsecase>(
    SavePostUsecase(getIt<PostsRepository>()),
  );
  getIt.registerSingleton<GetSavedPostsUsecase>(
    GetSavedPostsUsecase(getIt<PostsRepository>()),
  );

  // Threads Use Cases
  getIt.registerSingleton<GetThreadsUsecase>(
    GetThreadsUsecase(getIt<ThreadsRepository>()),
  );
  getIt.registerSingleton<GetThreadUsecase>(
    GetThreadUsecase(getIt<ThreadsRepository>()),
  );
  getIt.registerSingleton<CreateThreadUsecase>(
    CreateThreadUsecase(getIt<ThreadsRepository>()),
  );
  getIt.registerSingleton<ReplyThreadUsecase>(
    ReplyThreadUsecase(getIt<ThreadsRepository>()),
  );
  getIt.registerSingleton<DeleteThreadUsecase>(
    DeleteThreadUsecase(getIt<ThreadsRepository>()),
  );
  getIt.registerSingleton<LikeThreadUsecase>(
    LikeThreadUsecase(getIt<ThreadsRepository>()),
  );
  getIt.registerSingleton<RepostThreadUsecase>(
    RepostThreadUsecase(getIt<ThreadsRepository>()),
  );

  // Users Use Cases
  getIt.registerSingleton<GetUserUsecase>(
    GetUserUsecase(getIt<UsersRepository>()),
  );
  getIt.registerSingleton<UpdateProfileUsecase>(
    UpdateProfileUsecase(getIt<UsersRepository>()),
  );
  getIt.registerSingleton<FollowUserUsecase>(
    FollowUserUsecase(getIt<UsersRepository>()),
  );
  getIt.registerSingleton<UnfollowUserUsecase>(
    UnfollowUserUsecase(getIt<UsersRepository>()),
  );
  getIt.registerSingleton<SearchUsersUsecase>(
    SearchUsersUsecase(getIt<UsersRepository>()),
  );
  getIt.registerSingleton<GetUserFollowersUsecase>(
    GetUserFollowersUsecase(getIt<UsersRepository>()),
  );

  // Shop Use Cases
  getIt.registerSingleton<GetProductsUsecase>(
    GetProductsUsecase(getIt<ShopRepository>()),
  );
  getIt.registerSingleton<GetProductUsecase>(
    GetProductUsecase(getIt<ShopRepository>()),
  );
  getIt.registerSingleton<SearchProductsUsecase>(
    SearchProductsUsecase(getIt<ShopRepository>()),
  );
  getIt.registerSingleton<GetFavoriteProductsUsecase>(
    GetFavoriteProductsUsecase(getIt<ShopRepository>()),
  );
  getIt.registerSingleton<AddToFavoriteUsecase>(
    AddToFavoriteUsecase(getIt<ShopRepository>()),
  );
  getIt.registerSingleton<GetCategoriesUsecase>(
    GetCategoriesUsecase(getIt<ShopRepository>()),
  );

  // Live Use Cases
  getIt.registerSingleton<GetLiveStreamsUsecase>(
    GetLiveStreamsUsecase(getIt<LiveRepository>()),
  );
  getIt.registerSingleton<GetLiveStreamUsecase>(
    GetLiveStreamUsecase(getIt<LiveRepository>()),
  );
  getIt.registerSingleton<StartLiveStreamUsecase>(
    StartLiveStreamUsecase(getIt<LiveRepository>()),
  );
  getIt.registerSingleton<EndLiveStreamUsecase>(
    EndLiveStreamUsecase(getIt<LiveRepository>()),
  );
  getIt.registerSingleton<LikeLiveStreamUsecase>(
    LikeLiveStreamUsecase(getIt<LiveRepository>()),
  );

  // Music Use Cases
  getIt.registerSingleton<GetTracksUsecase>(
    GetTracksUsecase(getIt<MusicRepository>()),
  );
  getIt.registerSingleton<GetTrendingTracksUsecase>(
    GetTrendingTracksUsecase(getIt<MusicRepository>()),
  );
  getIt.registerSingleton<GetTrackUsecase>(
    GetTrackUsecase(getIt<MusicRepository>()),
  );
  getIt.registerSingleton<SearchTracksUsecase>(
    SearchTracksUsecase(getIt<MusicRepository>()),
  );
  getIt.registerSingleton<LikeTrackUsecase>(
    LikeTrackUsecase(getIt<MusicRepository>()),
  );
  getIt.registerSingleton<GetFavoriteTracksUsecase>(
    GetFavoriteTracksUsecase(getIt<MusicRepository>()),
  );

  // Dating Use Cases
  getIt.registerSingleton<GetProfilesUsecase>(
    GetProfilesUsecase(getIt<DatingRepository>()),
  );
  getIt.registerSingleton<GetProfileUsecase>(
    GetProfileUsecase(getIt<DatingRepository>()),
  );
  getIt.registerSingleton<UpdateDatingProfileUsecase>(
    UpdateDatingProfileUsecase(getIt<DatingRepository>()),
  );
  getIt.registerSingleton<LikeProfileUsecase>(
    LikeProfileUsecase(getIt<DatingRepository>()),
  );
  getIt.registerSingleton<PassProfileUsecase>(
    PassProfileUsecase(getIt<DatingRepository>()),
  );
  getIt.registerSingleton<GetMatchesUsecase>(
    GetMatchesUsecase(getIt<DatingRepository>()),
  );

  // Chat Use Cases
  getIt.registerSingleton<GetConversationsUsecase>(
    GetConversationsUsecase(getIt<ChatRepository>()),
  );
  getIt.registerSingleton<GetMessagesUsecase>(
    GetMessagesUsecase(getIt<ChatRepository>()),
  );
  getIt.registerSingleton<SendMessageUsecase>(
    SendMessageUsecase(getIt<ChatRepository>()),
  );
  getIt.registerSingleton<MarkAsReadUsecase>(
    MarkAsReadUsecase(getIt<ChatRepository>()),
  );
  getIt.registerSingleton<DeleteMessageUsecase>(
    DeleteMessageUsecase(getIt<ChatRepository>()),
  );
  getIt.registerSingleton<SearchMessagesUsecase>(
    SearchMessagesUsecase(getIt<ChatRepository>()),
  );

  // Auth Use Cases
  getIt.registerSingleton<LoginUsecase>(
    LoginUsecase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<RegisterUsecase>(
    RegisterUsecase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<LogoutUsecase>(
    LogoutUsecase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<ResetPasswordUsecase>(
    ResetPasswordUsecase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<ChangePasswordUsecase>(
    ChangePasswordUsecase(getIt<AuthRepository>()),
  );
}
