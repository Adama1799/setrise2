import 'package:flutter/cupertino.dart';

class AppColors {
  // خلفية رئيسية: أبيض فضي
  static const Color background = Color(0xFFF2F2F7); // iOS light gray
  static const Color surface = Color(0xFFFFFFFF);   // أبيض نقي
  static const Color primary = Color(0xFF0A84FF);   // أزرق iOS
  static const Color accent = CupertinoColors.systemBlue;
  static const Color shop = Color(0xFFFF9F0A);      // برتقالي للعلامات التجارية

  // درجات الرمادي
  static const Color white = CupertinoColors.white;
  static const Color lightGray = Color(0xFFE5E5EA);
  static const Color mediumGray = Color(0xFF8E8E93);
  static const Color darkGray = Color(0xFF636366);
  static const Color black = CupertinoColors.black;

  // حدود وفواصل
  static const Color border = Color(0xFFC6C6C8);

  // ألوان النظام
  static const Color error = CupertinoColors.destructiveRed;
  static const Color success = CupertinoColors.activeGreen;
  static const Color warning = CupertinoColors.systemYellow;
  static const Color neonRed = Color(0xFFFF453A);
  static const Color neonGreen = Color(0xFF30D158);
  static const Color electricBlue = Color(0xFF5E5CE6);
  static const Color live = Color(0xFFFF2D55);
}
