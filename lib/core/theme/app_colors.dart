// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ===== PRIMARY COLORS (Original) =====
  static const Color primary = Color(0xFF007AFF);
  static const Color accent = primary;
  static const Color electricBlue = Color(0xFF0066FF);
  static const Color neonBlue = electricBlue;
  static const Color neonPink = Color(0xFFFF00CC);
  static const Color neonYellow = Color(0xFFFFB300);
  static const Color neonRed = Color(0xFFFF2200);
  static const Color cyan = Color(0xFF00FFEE);
  static const Color neonGreen = Color(0xFF39FF14);

  // ===== BASE COLORS (Original) =====
  static const Color background = Color(0xFF010101);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0A0A0A);
  static const Color surface = black;
  static const Color grey = Color(0xFF2C2C2C);
  static const Color grey1 = grey;
  static const Color grey2 = Color(0xFF8E8E8E);
  static const Color grey3 = grey2;
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color border = grey;

  // ===== FEATURE COLORS (Original) =====
  static const Color live = Color(0xFFFF4444);
  static const Color music = cyan;
  static const Color dating = neonYellow;
  static const Color shop = neonGreen;

  // ===== STATUS COLORS (Original) =====
  static const Color success = neonGreen;
  static const Color error = neonRed;
  static const Color warning = neonYellow;
  static const Color info = cyan;

  // ===== SOCIAL COLORS (Original) =====
  static const Color like = neonRed;
  static const Color comment = white;
  static const Color share = cyan;
  static const Color send = neonGreen;
  static const Color save = neonYellow;
  static const Color recommend = neonGreen;

  // ===== STORY COLORS (Original) =====
  static const Color storyUnseen = neonYellow;
  static const Color storySeen = grey2;
  static const Color storyLive = neonRed;
  static const Color storyCloseFriend = Color(0xFFFF6B35);
  static const Color storyOwn = neonGreen;

  // ===== GRADIENTS (Original) =====
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [electricBlue, cyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient liveGradient = LinearGradient(
    colors: [neonRed, neonPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient musicGradient = LinearGradient(
    colors: [cyan, Color(0xFF00D4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient datingGradient = LinearGradient(
    colors: [neonYellow, Color(0xFFFFD740)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient shopGradient = LinearGradient(
    colors: [neonGreen, Color(0xFF7FFF00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===== SHADOWS (Original) =====
  static BoxShadow get neonGlow => BoxShadow(
        color: electricBlue.withOpacity(0.3),
        blurRadius: 20,
        spreadRadius: 2,
      );
  static BoxShadow get pinkGlow => BoxShadow(
        color: neonPink.withOpacity(0.3),
        blurRadius: 20,
        spreadRadius: 2,
      );


  // ─────────────────────────────────────
  // 🛍️ إضافات المتجر (Shop Add-ons)
  // هذه الألوان جديدة ولا تؤثر على القديم
  // ─────────────────────────────────────
  static const Color shopAccent = Color(0xFFFF9F0A);   // برتقالي للمتجر (أزرار الشراء)
  static const Color lightGray = Color(0xFFE5E5EA);    // خلفيات البطاقات
  static const Color mediumGray = Color(0xFF8E8E93);   // نصوص ثانوية
  static const Color darkGray = Color(0xFF636366);     // نصوص ثالثية
  static const Color borderColor = Color(0xFFC6C6C8);  // حدود البطاقات
}
