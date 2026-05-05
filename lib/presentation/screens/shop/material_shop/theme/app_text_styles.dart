import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String _fontFamily = 'Inter';

  static const TextStyle display = TextStyle(fontSize: 32, fontWeight: FontWeight.w800, fontFamily: _fontFamily, color: AppColors.textPrimary);
  static const TextStyle headline1 = TextStyle(fontSize: 28, fontWeight: FontWeight.w700, fontFamily: _fontFamily, color: AppColors.textPrimary);
  static const TextStyle headline2 = TextStyle(fontSize: 24, fontWeight: FontWeight.w700, fontFamily: _fontFamily, color: AppColors.textPrimary);
  static const TextStyle headline3 = TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: _fontFamily, color: AppColors.textPrimary);
  static const TextStyle bodyLarge = TextStyle(fontSize: 18, fontWeight: FontWeight.w400, fontFamily: _fontFamily, color: AppColors.textPrimary);
  static const TextStyle bodyMedium = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: _fontFamily, color: AppColors.textPrimary);
  static const TextStyle bodySmall = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: _fontFamily, color: AppColors.textPrimary);
  static const TextStyle caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: _fontFamily, color: AppColors.textTertiary);
  static const TextStyle buttonLabel = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: _fontFamily);
  static const TextStyle labelUpper = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: _fontFamily, letterSpacing: 1.2);
  static const TextStyle priceLarge = TextStyle(fontSize: 24, fontWeight: FontWeight.w700, fontFamily: _fontFamily, color: AppColors.textPrimary);
  static const TextStyle priceMedium = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontFamily: _fontFamily, color: AppColors.textPrimary);
  static const TextStyle priceSmall = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: _fontFamily, color: AppColors.textPrimary);
  static const TextStyle priceStrike = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: _fontFamily, color: AppColors.textTertiary, decoration: TextDecoration.lineThrough);
}
