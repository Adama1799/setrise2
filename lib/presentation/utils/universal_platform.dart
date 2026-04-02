// lib/presentation/utils/universal_platform.dart
import 'package:flutter/foundation.dart' as foundation;

class UniversalPlatform {
  static bool isWeb => foundation.kIsWeb;
  
  static bool isAndroid =>
      !foundation.kIsWeb && foundation.defaultTargetPlatform == foundation.TargetPlatform.android;
  
  static bool isIOS =>
      !foundation.kIsWeb && foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  
  static bool isMacOS =>
      !foundation.kIsWeb && foundation.defaultTargetPlatform == foundation.TargetPlatform.macOS;
  
  static bool isLinux =>
      !foundation.kIsWeb && foundation.defaultTargetPlatform == foundation.TargetPlatform.linux;
  
  static bool isWindows =>
      !foundation.kIsWeb && foundation.defaultTargetPlatform == foundation.TargetPlatform.windows;
  
  static bool isMobile => isAndroid || isIOS;
  
  static bool isDesktop => isMacOS || isLinux || isWindows;
  
  static String platformName {
    if (isWeb) return 'web';
    if (isAndroid) return 'android';
    if (isIOS) return 'ios';
    if (isMacOS) return 'macos';
    if (isLinux) return 'linux';
    if (isWindows) return 'windows';
    return 'unknown';
  }
}
