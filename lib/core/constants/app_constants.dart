/// Application constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Setrise';
  static const String appVersion = '1.0.0';

  // Pagination
  static const int pageSize = 20;

  // Media
  static const int maxImageSize = 10 * 1024 * 1024; // 10 MB
  static const int maxVideoSize = 100 * 1024 * 1024; // 100 MB

  // Text Limits
  static const int maxUsernameLength = 30;
  static const int maxBioLength = 150;
  static const int maxPostTitleLength = 100;
  static const int maxPostBodyLength = 500;
  static const int maxCommentLength = 500;

  // Regions & Categories
  static const Map<String, List<String>> regions = {
    '🔥 Trending': [
      '🇩🇿 Algeria',
      '🇺🇸 USA',
      '🇧🇷 Brazil',
      '🇯🇵 Japan',
      '🇫🇷 France',
      '🇸🇦 Saudi Arabia'
    ],
    '🌍 Africa': [
      '🇩🇿 Algeria',
      '🇹🇳 Tunisia',
      '🇪🇬 Egypt',
      '🇲🇦 Morocco',
      '🇳🇬 Nigeria',
      '🇰🇪 Kenya',
      '🇿🇦 South Africa',
      '🇬🇭 Ghana',
      '🇸🇳 Senegal',
      '🇪🇹 Ethiopia',
    ],
    '🇪🇺 Europe': [
      '🇫🇷 France',
      '🇩🇪 Germany',
      '🇬🇧 UK',
      '🇮🇹 Italy',
      '🇪🇸 Spain',
      '🇳🇱 Netherlands',
      '🇵🇹 Portugal',
      '🇷🇺 Russia',
    ],
    '🌎 Americas': [
      '🇺🇸 USA',
      '🇧🇷 Brazil',
      '🇲🇽 Mexico',
      '🇨🇦 Canada',
      '🇦🇷 Argentina',
      '🇨🇴 Colombia',
    ],
    '🌏 Asia': [
      '🇸🇦 Saudi Arabia',
      '🇦🇪 UAE',
      '🇯🇵 Japan',
      '🇰🇷 South Korea',
      '🇨🇳 China',
      '🇮🇳 India',
      '🇹🇷 Turkey',
    ],
  };

  static const List<String> categories = [
    '💻 Technology',
    '🏛️ Politics',
    '🎬 Movies',
    '🎵 Music',
    '📖 Stories',
    '💰 Business',
    '🎓 Education',
    '😂 Comedy',
    '🍳 Cooking',
    '🎭 Adventure',
    '❤️ Dating',
    '🛍️ Shop',
    '🔴 Live',
    '🌿 Nature',
    '✈️ Travel',
    '🎨 Art',
  ];

  static const List<String> sports = [
    '⚽ Football',
    '🏀 Basketball',
    '🎾 Tennis',
    '🏋️ Fitness',
    '🥊 Boxing',
    '🏊 Swimming',
    '🏃 Running',
    '🚴 Cycling',
    '🎯 E-Sports',
  ];

  static const List<String> moods = [
    '😴 Chill',
    '😤 Hyped',
    '😞 Sad',
    '🧘 Focus',
    '💪 Motivated',
  ];
}
