// lib/core/constants/app_constants.dart
class AppConstants {
  // API
  static const String baseUrl = 'https://api.setrise.app';
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
  
  // App
  static const String appName = 'SetRise';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  
  // Pagination
  static const int pageSize = 20;
  
  // Features
  static const List<String> features = [
    'Set',    // Feed
    'Rize',   // Threads
    'Shop',   // E-commerce
    'Date',   // Dating
    'Live',   // Live Streaming
    'Music',  // Music
  ];
}

class ApiEndpoints {
  static const String postsEndpoint = '/posts';
  static const String threadsEndpoint = '/threads';
  static const String usersEndpoint = '/users';
  static const String shopEndpoint = '/shop';
  static const String liveEndpoint = '/live';
  static const String musicEndpoint = '/music';
  static const String authEndpoint = '/auth';
}

class AppStrings {
  // General
  static const String appName = 'SetRise';
  static const String loading = 'Loading...';
  static const String error = 'Something went wrong';
  static const String retry = 'Retry';
  
  // Auth
  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String username = 'Username';
  
  // Features
  static const String set = 'Set';
  static const String rize = 'Rize';
  static const String shop = 'Shop';
  static const String date = 'Date';
  static const String live = 'Live';
  static const String music = 'Music';
  
  // Actions
  static const String like = 'Like';
  static const String comment = 'Comment';
  static const String share = 'Share';
  static const String save = 'Save';
  static const String follow = 'Follow';
  static const String unfollow = 'Unfollow';
}
