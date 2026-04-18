import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String _fontFamily = 'Inter';

  // Display
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle displaySmall = TextStyle(
    fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.primaryText, fontFamily: _fontFamily);

  // Headline (h1..h6)
  static const TextStyle h1 = TextStyle(
    fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle h2 = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle h3 = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle h4 = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle h5 = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle h6 = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryText, fontFamily: _fontFamily);

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.secondaryText, fontFamily: _fontFamily);
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.secondaryText, fontFamily: _fontFamily);

  // Label
  static const TextStyle labelLarge = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle labelMedium = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryText, fontFamily: _fontFamily);
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.secondaryText, fontFamily: _fontFamily);

  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.secondaryText, fontFamily: _fontFamily);

  // Button
  static const TextStyle button = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: _fontFamily);

  // إضافات أخرى مستخدمة في الكود
  static const TextStyle postTitle = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryText);
}
