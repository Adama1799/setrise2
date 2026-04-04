import 'dart:io' as io;
import 'package:flutter/foundation.dart' as foundation;

/// Universal platform detection utility
/// 
/// Provides platform detection that works across web and native platforms
class UniversalPlatform {
  UniversalPlatform._();

  /// Check if running on web
  static bool get isWeb => foundation.kIsWeb;

  /// Check if running on Android
  static bool get isAndroid =>
      !foundation.kIsWeb && io.Platform.isAndroid;

  /// Check if running on iOS
  static bool get isIOS =>
      !foundation.kIsWeb && io.Platform.isIOS;

  /// Check if running on macOS
  static bool get isMacOS =>
      !foundation.kIsWeb && io.Platform.isMacOS;

  /// Check if running on Linux
  static bool get isLinux =>
      !foundation.kIsWeb && io.Platform.isLinux;

  /// Check if running on Windows
  static bool get isWindows =>
      !foundation.kIsWeb && io.Platform.isWindows;

  /// Check if running on Fuchsia
  static bool get isFuchsia =>
      !foundation.kIsWeb && io.Platform.isFuchsia;

  /// Check if running on any mobile platform (Android or iOS)
  static bool get isMobile => isAndroid || isIOS;

  /// Check if running on any desktop platform (macOS, Windows, or Linux)
  static bool get isDesktop => isMacOS || isLinux || isWindows;

  /// Check if running on any Apple platform (iOS or macOS)
  static bool get isApple => isIOS || isMacOS;

  /// Get the current platform name as a string
  static String get currentPlatform {
    if (isWeb) return 'web';
    if (isAndroid) return 'android';
    if (isIOS) return 'ios';
    if (isMacOS) return 'macos';
    if (isLinux) return 'linux';
    if (isWindows) return 'windows';
    if (isFuchsia) return 'fuchsia';
    return 'unknown';
  }

  /// Get a user-friendly platform name
  static String get platformDisplayName {
    if (isWeb) return 'Web';
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (isMacOS) return 'macOS';
    if (isLinux) return 'Linux';
    if (isWindows) return 'Windows';
    if (isFuchsia) return 'Fuchsia';
    return 'Unknown';
  }

  /// Get the platform version (native platforms only)
  static String get platformVersion {
    if (isWeb) return 'N/A';
    return io.Platform.operatingSystemVersion;
  }

  /// Get the number of processors (native platforms only)
  static int get numberOfProcessors {
    if (isWeb) return 0;
    return io.Platform.numberOfProcessors;
  }

  /// Get the local hostname (native platforms only)
  static String get localHostname {
    if (isWeb) return 'N/A';
    return io.Platform.localHostname;
  }

  /// Check if the platform supports native APIs
  static bool get supportsNativeAPIs => !isWeb;

  /// Check if the platform supports file system access
  static bool get supportsFileSystem => !isWeb;

  /// Check if the platform supports notifications
  static bool get supportsNotifications => isMobile || isDesktop;

  /// Check if the platform supports camera
  static bool get supportsCamera => isMobile || isWeb;

  /// Check if the platform supports biometric authentication
  static bool get supportsBiometrics => isMobile;

  /// Check if the platform is in release mode
  static bool get isReleaseMode => foundation.kReleaseMode;

  /// Check if the platform is in profile mode
  static bool get isProfileMode => foundation.kProfileMode;

  /// Check if the platform is in debug mode
  static bool get isDebugMode => foundation.kDebugMode;
}
