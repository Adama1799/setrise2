import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Centralized app theme provider
class AppThemeData {
  AppThemeData._();

  /// Get theme mode from string
  static ThemeMode themeModeFromString(String? mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Convert theme mode to string
  static String themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Check if dark mode based on brightness
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get text color based on theme
  static Color getTextColor(BuildContext context) {
    return isDarkMode(context) ? AppColors.textWhite : AppColors.textPrimary;
  }

  /// Get background color based on theme
  static Color getBackgroundColor(BuildContext context) {
    return isDarkMode(context) ? AppColors.backgroundDark : AppColors.background;
  }

  /// Get surface color based on theme
  static Color getSurfaceColor(BuildContext context) {
    return isDarkMode(context) ? AppColors.surfaceDark : AppColors.surface;
  }
}
