import 'package:flutter/material.dart';
import 'package:setrise/core/theme/app_colors.dart' as SetRiseColors;

class AppColors {
  AppColors._();

  static const Color backgroundPrimary = SetRiseColors.AppColors.background;
  static const Color backgroundSecondary = Color(0xFF2C2C2C);
  static const Color backgroundTertiary = Color(0xFF3A3A3A);
  static const Color backgroundInput = Color(0xFF2C2C2C);
  static const Color backgroundSkeleton = Color(0xFF2C2C2C);
  static const Color backgroundSkeletonShine = Color(0xFF3A3A3A);

  static const Color textPrimary = SetRiseColors.AppColors.white;
  static const Color textSecondary = Color(0xFFE0E0E0);
  static const Color textTertiary = SetRiseColors.AppColors.grey2;
  static const Color textQuaternary = Color(0xFF8E8E8E);
  static const Color textOnDark = SetRiseColors.AppColors.white; // ✅ كان black — تم التصحيح
  static const Color textLink = SetRiseColors.AppColors.primary;

  static const Color borderSubtle = Color(0xFF3A3A3A);
  static const Color borderMedium = Color(0xFF8E8E8E);
  static const Color borderBlack = SetRiseColors.AppColors.white;

  static const Color error = SetRiseColors.AppColors.error;
  static const Color success = SetRiseColors.AppColors.success;
  static const Color warning = SetRiseColors.AppColors.warning;

  static const Color ratingFilled = SetRiseColors.AppColors.neonYellow;

  static const Color statusActiveBg = Color(0x1A007AFF);
  static const Color statusActiveFg = SetRiseColors.AppColors.primary;
  static const Color statusShippedBg = Color(0x1AFFB300);
  static const Color statusShippedFg = Color(0xFFFFB300);
  static const Color statusDeliveredBg = Color(0x1A39FF14);
  static const Color statusDeliveredFg = SetRiseColors.AppColors.success;
  static const Color statusCancelledBg = Color(0x1AFF2200);
  static const Color statusCancelledFg = SetRiseColors.AppColors.error;

  static const Color badgeHotBg = SetRiseColors.AppColors.neonRed;
  static const Color badgeHotFg = SetRiseColors.AppColors.white;
  static const Color badgeNewBg = SetRiseColors.AppColors.primary;
  static const Color badgeNewFg = SetRiseColors.AppColors.white;
  static const Color badgeSaleBg = SetRiseColors.AppColors.shopAccent;
  static const Color badgeSaleFg = SetRiseColors.AppColors.black;
  static const Color badgeCartBg = SetRiseColors.AppColors.neonRed;
  static const Color badgeCartFg = SetRiseColors.AppColors.white;

  static const Color ctaPrimaryBg = SetRiseColors.AppColors.primary;
  static const Color ctaPrimaryDisabledBg = Color(0xFF3A3A3A);
  static const Color ctaPrimaryFg = SetRiseColors.AppColors.white;
  static const Color ctaGhostBg = Colors.transparent;
  static const Color ctaGhostBorder = Color(0xFF8E8E8E);
  static const Color ctaGhostFg = SetRiseColors.AppColors.white;
}
