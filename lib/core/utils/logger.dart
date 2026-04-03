// lib/core/utils/logger.dart
class Logger {
  static void log(String message, {String tag = 'SetRise'}) =>
      print('[$tag] 📌 $message');

  static void error(String message, {String tag = 'SetRise', StackTrace? stackTrace}) {
    print('[$tag] ❌ ERROR: $message');
    if (stackTrace != null) print(stackTrace);
  }

  static void success(String message, {String tag = 'SetRise'}) =>
      print('[$tag] ✅ SUCCESS: $message');

  static void warning(String message, {String tag = 'SetRise'}) =>
      print('[$tag] ⚠️ WARNING: $message');
}
