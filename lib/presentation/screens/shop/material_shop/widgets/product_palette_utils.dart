// lib/presentation/screens/shop/material_shop/widgets/product_palette_utils.dart
//
// ملف مساعد: دوال الألوان + Palette Provider
// ──────────────────────────────────────────────────────────────

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';

// ─────────────────────────────────────────────────────────────
// Navigation helper — يستخدم في كل ملفات المنتج
// ─────────────────────────────────────────────────────────────
void pushScreen(BuildContext ctx, Widget w) => Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (_) => ProviderScope(
          parent: ProviderScope.containerOf(ctx),
          child: w,
        ),
      ),
    );

// ─────────────────────────────────────────────────────────────
// Color Extraction
// ─────────────────────────────────────────────────────────────
Future<Color> extractDominantColor(String imageUrl) async {
  try {
    final palette = await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(imageUrl),
      size: const Size(150, 150),
      maximumColorCount: 8,
    );

    final raw = palette.darkMutedColor?.color ??
        palette.mutedColor?.color ??
        palette.vibrantColor?.color ??
        palette.dominantColor?.color ??
        const Color(0xFF007AFF);

    return elegantize(raw);
  } catch (_) {
    return const Color(0xFF007AFF);
  }
}

/// تحويل اللون لنسخة فاخرة — تشبع أقل + ليست صاخبة
Color elegantize(Color base) {
  final hsl = HSLColor.fromColor(base);
  return hsl
      .withSaturation((hsl.saturation * 0.55).clamp(0.0, 0.75))
      .withLightness((hsl.lightness * 0.6).clamp(0.15, 0.45))
      .toColor();
}

/// لون الأكسنت للأزرار
Color accentFromElegant(Color elegant) {
  final hsl = HSLColor.fromColor(elegant);
  return hsl
      .withSaturation((hsl.saturation * 1.4).clamp(0.0, 0.9))
      .withLightness((hsl.lightness * 1.3).clamp(0.3, 0.6))
      .toColor();
}

/// نص على اللون — أبيض أو أسود حسب الإضاءة
Color onColor(Color bg) =>
    bg.computeLuminance() > 0.35 ? Colors.black87 : Colors.white;

// ─────────────────────────────────────────────────────────────
// Palette Provider — cache per image URL
// ─────────────────────────────────────────────────────────────
final _paletteCache = <String, Color>{};

final productPaletteProvider =
    FutureProvider.family<Color, String>((ref, imageUrl) async {
  if (_paletteCache.containsKey(imageUrl)) return _paletteCache[imageUrl]!;
  final color = await extractDominantColor(imageUrl);
  _paletteCache[imageUrl] = color;
  return color;
});
