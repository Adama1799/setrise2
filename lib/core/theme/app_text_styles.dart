import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String _fontFamily = 'Inter';

  static const TextStyle h1 = TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle h2 = TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle h3 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle h4 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle h5 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle h6 = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryText, fontFamily: _fontFamily);

  static const TextStyle bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.secondaryText, fontFamily: _fontFamily);
  static const TextStyle bodySmall = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.secondaryText, fontFamily: _fontFamily);

  static const TextStyle labelLarge = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle labelMedium = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle labelSmall = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.secondaryText, fontFamily: _fontFamily);

  static const TextStyle caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.secondaryText, fontFamily: _fontFamily);
  static const TextStyle button = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: _fontFamily);

  // Aliases for backward compatibility
  static const TextStyle headline1 = h1;
  static const TextStyle headline2 = h2;
  static const TextStyle body1 = bodyLarge;
  static const TextStyle body2 = bodyMedium;
  static const TextStyle displayLarge = h1;
  static const TextStyle displayMedium = h2;
  static const TextStyle displaySmall = h3;
  static const TextStyle postTitle = h4;
}
