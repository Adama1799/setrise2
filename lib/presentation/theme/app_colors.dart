import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF007AFF); // iOS Blue
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF1C1C1E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF2C2C2E);
  static const Color grey2 = Color(0xFF8E8E93);
  static const Color grey3 = Color(0xFF3A3A3C);
  static const Color error = Color(0xFFFF453A);
  static const Color success = Color(0xFF32D74B);
  static const Color warning = Color(0xFFFFD60A);

  // For backward compatibility with old code (can be mapped)
  static const Color accent = primary;
  static const Color primaryText = white;
  static const Color secondaryText = grey2;
  static const Color border = grey3;
  static const Color live = error;
  static const Color music = primary;
  static const Color dating = primary;
  static const Color shop = success;
  static const Color neonRed = error;
  static const Color neonGreen = success;
  static const Color neonYellow = warning;
  static const Color neonPink = Color(0xFFFF2D55);
  static const Color electricBlue = primary;
  static const Color cyan = Color(0xFF64D2FF);
  static const Color storyUnseen = primary;
  static const Color storySeen = grey3;
  static const Color storyLive = error;
  static const Color storyCloseFriend = Color(0xFFFF9F0A);
  static const Color storyOwn = success;
}
