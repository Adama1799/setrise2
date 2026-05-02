import 'package:flutter/cupertino.dart';

class AppColors {
  // الألوان الأساسية الجديدة (الوضع الفاتح)
  static const Color background = Color(0xFFF2F2F7); // iOS light gray
  static const Color surface = Color(0xFFFFFFFF); // أبيض
  static const Color primary = Color(0xFF0A84FF); // iOS blue
  static const Color accent = CupertinoColors.systemBlue;
  static const Color shop = Color(0xFFFF9F0A); // برتقالي

  // تدرجات الأبيض والرمادي والفضي
  static const Color white = CupertinoColors.white;
  static const Color lightGray = Color(0xFFE5E5EA);
  static const Color mediumGray = Color(0xFF8E8E93);
  static const Color darkGray = Color(0xFF636366);
  static const Color black = CupertinoColors.black;

  // ألوان النظام
  static const Color border = Color(0xFFC6C6C8);
  static const Color error = CupertinoColors.destructiveRed;
  static const Color success = CupertinoColors.activeGreen;
  static const Color warning = CupertinoColors.systemYellow;
  static const Color live = Color(0xFFFF2D55);
}
