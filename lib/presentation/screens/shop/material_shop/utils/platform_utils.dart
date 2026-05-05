import 'package:flutter/foundation.dart';

class PlatformUtils {
  static bool get isMobile => defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;
}
