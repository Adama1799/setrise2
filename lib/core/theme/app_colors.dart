import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  // ألوان النظام الأساسية (فاتح)
  static const Color background = Color(0xFFF2F2F7); // خلفية فاتحة
  static const Color surface = Color(0xFFFFFFFF);    // أبيض
  static const Color primary = Color(0xFF0A84FF);    // iOS blue
  static const Color accent = CupertinoColors.systemBlue;
  static const Color shop = Color(0xFFFF9F0A);       // برتقالي
  static const Color white = CupertinoColors.white;
  static const Color black = CupertinoColors.black;

  // درجات الرمادي (التصميم الجديد)
  static const Color lightGray = Color(0xFFE5E5EA);
  static const Color mediumGray = Color(0xFF8E8E93);
  static const Color darkGray = Color(0xFF636366);
  static const Color border = Color(0xFFC6C6C8);

  // الألوان القديمة (متوافقة مع جميع الشاشات)
  static const Color grey = Color(0xFF8E8E93);
  static const Color grey2 = Color(0xFF636366);
  static const Color grey3 = Color(0xFF48484A);
  static const Color dating = Color(0xFFFF2D55);
  static const Color music = Color(0xFFFF9F0A);
  static const Color neonYellow = Color(0xFFFFD60A);
  static const Color cyan = Color(0xFF32ADE6);

  // ألوان حالة
  static const Color error = CupertinoColors.destructiveRed;
  static const Color success = CupertinoColors.activeGreen;
  static const Color warning = CupertinoColors.systemYellow;
  static const Color neonRed = Color(0xFFFF453A);
  static const Color neonGreen = Color(0xFF30D158);
  static const Color electricBlue = Color(0xFF5E5CE6);
  static const Color live = Color(0xFFFF2D55);


  // ===== PRIMARY COLORS =====
  static const Color primary = Color(0xFF007AFF);       // ✅ أضيف
  static const Color accent = primary;                  // ✅ أضيف كمرادف للتوافق
  static const Color electricBlue = Color(0xFF0066FF);
  static const Color neonBlue = electricBlue;
  static const Color neonPink = Color(0xFFFF00CC);
  static const Color neonYellow = Color(0xFFFFB300);
  static const Color neonRed = Color(0xFFFF2200);
  static const Color cyan = Color(0xFF00FFEE);
  static const Color neonGreen = Color(0xFF39FF14);

  // ===== BASE COLORS =====
  static const Color background = Color(0xFF010101);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0A0A0A);
  static const Color surface = black;
  static const Color grey = Color(0xFF2C2C2C);
  static const Color grey1 = grey;
  static const Color grey2 = Color(0xFF8E8E8E);
  static const Color grey3 = grey2;
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color border = grey;                     // ✅ أضيف لاستخدامه في shimmer

  // ===== FEATURE COLORS =====
  static const Color live = Color(0xFFFF4444);
  static const Color music = cyan;
  static const Color dating = neonYellow;
  static const Color shop = neonGreen;

  // ===== STATUS COLORS =====
  static const Color success = neonGreen;
  static const Color error = neonRed;
  static const Color warning = neonYellow;
  static const Color info = cyan;

  // ===== SOCIAL COLORS =====
  static const Color like = neonRed;
  static const Color comment = white;
  static const Color share = cyan;
  static const Color send = neonGreen;
  static const Color save = neonYellow;
  static const Color recommend = neonGreen;

  // ===== STORY COLORS =====
  static const Color storyUnseen = neonYellow;
  static const Color storySeen = grey2;
  static const Color storyLive = neonRed;
  static const Color storyCloseFriend = Color(0xFFFF6B35);
  static const Color storyOwn = neonGreen;

  // ===== GRADIENTS =====
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

  // ===== SHADOWS =====
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
}
