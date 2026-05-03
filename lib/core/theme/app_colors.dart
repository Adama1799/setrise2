// lib/core/theme/app_colors.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  // ── ألوان النظام الأساسية (الوضع الفاتح) ──
  static const Color background = Color(0xFFF2F2F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF0A84FF);
  static const Color accent = CupertinoColors.systemBlue;
  static const Color shop = Color(0xFFFF9F0A);
  static const Color white = CupertinoColors.white;
  static const Color black = CupertinoColors.black;

  // ── درجات الرمادي ──
  static const Color lightGray = Color(0xFFE5E5EA);
  static const Color mediumGray = Color(0xFF8E8E93);
  static const Color darkGray = Color(0xFF636366);
  static const Color border = Color(0xFFC6C6C8);
  static const Color grey = Color(0xFF8E8E93);
  static const Color grey2 = Color(0xFF636366);
  static const Color grey3 = Color(0xFF48484A);

  // ── ألوان الأقسام (Dating, Music...) ──
  static const Color dating = Color(0xFFFF2D55);
  static const Color music = Color(0xFFFF9F0A);
  static const Color neonYellow = Color(0xFFFFD60A);
  static const Color cyan = Color(0xFF32ADE6);

  // ── ألوان الحالة ──
  static const Color error = CupertinoColors.destructiveRed;
  static const Color success = CupertinoColors.activeGreen;
  static const Color warning = CupertinoColors.systemYellow;
  static const Color neonRed = Color(0xFFFF453A);
  static const Color neonGreen = Color(0xFF30D158);
  static const Color electricBlue = Color(0xFF5E5CE6);
  static const Color live = Color(0xFFFF2D55);
}
