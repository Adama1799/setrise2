import 'package:flutter/material.dart';

/// Apple / iPhone 17 Pro Max — Light Design System
/// مستقل تماماً — لا يعتمد على SetRizeColors الداكن
class AppColors {
  AppColors._();

  // ── Backgrounds ──────────────────────────────────
  static const Color backgroundPrimary       = Color(0xFFF2F2F7); // iOS system background
  static const Color backgroundSecondary     = Color(0xFFFFFFFF); // card / surface
  static const Color backgroundTertiary      = Color(0xFFE5E5EA); // grouped secondary
  static const Color backgroundInput        = Color(0xFFFFFFFF);
  static const Color backgroundSkeleton     = Color(0xFFE5E5EA);
  static const Color backgroundSkeletonShine= Color(0xFFF5F5F7);

  // ── Text ─────────────────────────────────────────
  static const Color textPrimary    = Color(0xFF000000);
  static const Color textSecondary  = Color(0xFF3C3C43);
  static const Color textTertiary   = Color(0xFF8E8E93);
  static const Color textQuaternary = Color(0xFFC7C7CC);
  static const Color textOnDark     = Color(0xFFFFFFFF);
  static const Color textLink       = Color(0xFF007AFF);

  // ── Borders ──────────────────────────────────────
  static const Color borderSubtle = Color(0xFFE5E5EA);
  static const Color borderMedium = Color(0xFFAEAEB2);
  static const Color borderBlack  = Color(0xFF000000);

  // ── Semantic ─────────────────────────────────────
  static const Color error   = Color(0xFFFF3B30); // Apple red
  static const Color success = Color(0xFF34C759); // Apple green
  static const Color warning = Color(0xFFFF9500); // Apple orange

  // ── Rating ───────────────────────────────────────
  static const Color ratingFilled = Color(0xFFFF9500);

  // ── Status Chips ─────────────────────────────────
  static const Color statusActiveBg    = Color(0xFFEAF3FF);
  static const Color statusActiveFg    = Color(0xFF007AFF);
  static const Color statusShippedBg   = Color(0xFFFFF3E0);
  static const Color statusShippedFg   = Color(0xFFFF9500);
  static const Color statusDeliveredBg = Color(0xFFE8F8EF);
  static const Color statusDeliveredFg = Color(0xFF34C759);
  static const Color statusCancelledBg = Color(0xFFFFEBEA);
  static const Color statusCancelledFg = Color(0xFFFF3B30);

  // ── Badges ───────────────────────────────────────
  static const Color badgeHotBg  = Color(0xFFFF3B30);
  static const Color badgeHotFg  = Color(0xFFFFFFFF);
  static const Color badgeNewBg  = Color(0xFF007AFF);
  static const Color badgeNewFg  = Color(0xFFFFFFFF);
  static const Color badgeSaleBg = Color(0xFFFF9500);
  static const Color badgeSaleFg = Color(0xFFFFFFFF);
  static const Color badgeCartBg = Color(0xFFFF3B30);
  static const Color badgeCartFg = Color(0xFFFFFFFF);

  // ── CTA Buttons ──────────────────────────────────
  static const Color ctaPrimaryBg         = Color(0xFF007AFF);
  static const Color ctaPrimaryDisabledBg = Color(0xFFAEAEB2);
  static const Color ctaPrimaryFg         = Color(0xFFFFFFFF);
  static const Color ctaGhostBg           = Colors.transparent;
  static const Color ctaGhostBorder       = Color(0xFF007AFF);
  static const Color ctaGhostFg           = Color(0xFF007AFF);

  // ── Compatibility (compat مع الكود القديم) ───────
  static const Color black      = Color(0xFF000000);
  static const Color white      = Color(0xFFFFFFFF);
  static const Color shopAccent = Color(0xFFFF9500);
  static const Color neonRed    = Color(0xFFFF3B30);
  static const Color neonYellow = Color(0xFFFF9500);
  static const Color primary    = Color(0xFF007AFF);
  static const Color grey2      = Color(0xFF8E8E93);
  static const Color background = Color(0xFFF2F2F7);
}
