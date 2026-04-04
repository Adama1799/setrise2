/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'SetRise';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // API Configuration
  static const String apiBaseUrl = 'https://api.setrise.com';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100 MB

  // Media
  static const int maxImageSize = 10 * 1024 * 1024; // 10 MB
  static const int maxVideoSize = 100 * 1024 * 1024; // 100 MB
  static const int maxAudioSize = 50 * 1024 * 1024; // 50 MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedVideoFormats = ['mp4', 'mov', 'avi'];
  static const List<String> allowedAudioFormats = ['mp3', 'wav', 'aac'];

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int maxBioLength = 150;
  static const int maxPostLength = 2200;
  static const int maxCommentLength = 500;
  static const int maxThreadLength = 500;

  // Features
  static const bool enableDarkMode = true;
  static const bool enableNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;

  // Social
  static const int maxMediaPerPost = 10;
  static const int maxHashtags = 30;
  static const int maxMentions = 20;

  // Dating
  static const int minAge = 18;
  static const int maxAge = 100;
  static const int maxDistance = 100; // km
  static const int superLikesPerDay = 5;
  static const int likesPerDay = 100;

  // Live Streaming
  static const int maxStreamDuration = 4 * 60 * 60; // 4 hours
  static const int maxViewers = 1000;
  static const Duration streamReconnectTimeout = Duration(seconds: 10);

  // Music
  static const int maxPlaylistSize = 500;
  static const int maxQueueSize = 100;

  // Shop
  static const String defaultCurrency = 'USD';
  static const int maxCartItems = 50;
  static const int maxProductImages = 10;

  // Regex Patterns
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp usernameRegex = RegExp(
    r'^[a-zA-Z0-9._]{3,30}$',
  );
  static final RegExp phoneRegex = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );
  static final RegExp urlRegex = RegExp(
    r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
  );
  static final RegExp hashtagRegex = RegExp(
    r'#[a-zA-Z0-9_]+',
  );
  static final RegExp mentionRegex = RegExp(
    r'@[a-zA-Z0-9._]+',
  );

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'hh:mm a';

  // Storage Paths
  static const String imagesPath = 'images';
  static const String videosPath = 'videos';
  static const String audiosPath = 'audios';
  static const String avatarsPath = 'avatars';
  static const String postsPath = 'posts';
  static const String storiesPath = 'stories';

  // Error Messages
  static const String networkError = 'No internet connection';
  static const String serverError = 'Server error. Please try again later';
  static const String unknownError = 'An unknown error occurred';
  static const String timeoutError = 'Request timeout. Please try again';
  static const String unauthorizedError = 'Unauthorized. Please login again';
  static const String forbiddenError = 'Access denied';
  static const String notFoundError = 'Resource not found';
  static const String validationError = 'Validation error';

  // Success Messages
  static const String loginSuccess = 'Login successful';
  static const String registerSuccess = 'Registration successful';
  static const String updateSuccess = 'Updated successfully';
  static const String deleteSuccess = 'Deleted successfully';
  static const String uploadSuccess = 'Uploaded successfully';

  // WebSocket
  static const String wsBaseUrl = 'wss://ws.setrise.com';
  static const Duration wsPingInterval = Duration(seconds: 30);
  static const int wsMaxReconnectAttempts = 5;
  static const Duration wsReconnectDelay = Duration(seconds: 5);

  // Notifications
  static const String fcmServerKey = 'YOUR_FCM_SERVER_KEY';
  static const String notificationChannelId = 'setrise_notifications';
  static const String notificationChannelName = 'SetRise Notifications';

  // Deep Links
  static const String deepLinkScheme = 'setrise';
  static const String deepLinkHost = 'app.setrise.com';

  // Analytics Events
  static const String eventLogin = 'login';
  static const String eventRegister = 'register';
  static const String eventPostCreated = 'post_created';
  static const String eventPostLiked = 'post_liked';
  static const String eventPostShared = 'post_shared';
  static const String eventProfileViewed = 'profile_viewed';
  static const String eventVideoWatched = 'video_watched';
  static const String eventStreamStarted = 'stream_started';
  static const String eventPurchaseMade = 'purchase_made';
}
