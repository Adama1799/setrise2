/// Local storage keys
class StorageKeys {
  StorageKeys._();

  // Authentication
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String isLoggedIn = 'is_logged_in';
  static const String rememberMe = 'remember_me';

  // User Data
  static const String currentUser = 'current_user';
  static const String userProfile = 'user_profile';
  static const String userSettings = 'user_settings';
  static const String userPreferences = 'user_preferences';

  // App Settings
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String soundEnabled = 'sound_enabled';
  static const String vibrationEnabled = 'vibration_enabled';

  // Cache
  static const String feedCache = 'feed_cache';
  static const String postsCache = 'posts_cache';
  static const String threadsCache = 'threads_cache';
  static const String storiesCache = 'stories_cache';
  static const String messagesCache = 'messages_cache';
  static const String lastCacheUpdate = 'last_cache_update';

  // Onboarding
  static const String isFirstLaunch = 'is_first_launch';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String tutorialCompleted = 'tutorial_completed';

  // Search History
  static const String searchHistory = 'search_history';
  static const String recentSearches = 'recent_searches';

  // Filters & Preferences
  static const String contentFilters = 'content_filters';
  static const String privacySettings = 'privacy_settings';
  static const String blockedUsers = 'blocked_users';
  static const String mutedUsers = 'muted_users';

  // Media
  static const String autoPlayVideos = 'auto_play_videos';
  static const String dataUsageMode = 'data_usage_mode';
  static const String downloadQuality = 'download_quality';
  static const String uploadQuality = 'upload_quality';

  // Dating
  static const String datingProfile = 'dating_profile';
  static const String datingPreferences = 'dating_preferences';
  static const String datingMatches = 'dating_matches';
  static const String swipeHistory = 'swipe_history';

  // Live
  static const String liveStreamSettings = 'live_stream_settings';
  static const String liveStreamQuality = 'live_stream_quality';
  static const String watchedStreams = 'watched_streams';

  // Music
  static const String musicPlaylists = 'music_playlists';
  static const String favoriteTrack = 'favorite_tracks';
  static const String recentlyPlayed = 'recently_played';
  static const String musicQuality = 'music_quality';

  // Shop
  static const String shoppingCart = 'shopping_cart';
  static const String wishlist = 'wishlist';
  static const String orderHistory = 'order_history';
  static const String savedAddresses = 'saved_addresses';
  static const String paymentMethods = 'payment_methods';

  // Analytics
  static const String analyticsEnabled = 'analytics_enabled';
  static const String crashReportingEnabled = 'crash_reporting_enabled';

  // Device Info
  static const String deviceId = 'device_id';
  static const String deviceToken = 'device_token';
  static const String lastAppVersion = 'last_app_version';
}
