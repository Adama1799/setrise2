// lib/presentation/screens/shop/material_shop/widgets/product_detail_selectors.dart
//
// اختيارات صفحة التفاصيل: اللون، المقاس، البائع، الكمية
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_detail_widgets.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_palette_utils.dart';

// ─────────────────────────────────────────────────────────────
// Color Picker
// ─────────────────────────────────────────────────────────────
class ColorPicker extends StatelessWidget {
  final Color accent;
  final List<Color> colors;
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPicker({
    Key? key,
    required this.accent,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Color',
                style: AppTextStyles.bodySmall
                    .copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(width: AppDimensions.sm),
            if (selectedColor != null)
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: selectedColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        Row(
          children: colors
              .map(
                (c) => GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onColorSelected(c);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin:
                        const EdgeInsets.only(right: AppDimensions.sm),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: selectedColor == c
                          ? Border.all(color: accent, width: 3)
                          : Border.all(color: AppColors.borderSubtle),
                      boxShadow: selectedColor == c
                          ? [
                              BoxShadow(
                                color: accent.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                    child: selectedColor == c
                        ? Icon(Icons.check, size: 16, color: onColor(c))
                        : null,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Size Picker
// ─────────────────────────────────────────────────────────────
class SizePicker extends StatelessWidget {
  final Color accent;
  final List<String> sizes;
  final String? selectedSize;
  final ValueChanged<String> onSizeSelected;

  const SizePicker({
    Key? key,
    required this.accent,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Size',
                style: AppTextStyles.bodySmall
                    .copyWith(fontWeight: FontWeight.w700)),
            const Spacer(),
            Text('Size Guide',
                style: AppTextStyles.caption.copyWith(
                    color: accent, fontWeight: FontWeight.w600)),
            Icon(Icons.chevron_right, size: 14, color: accent),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        Wrap(
          spacing: AppDimensions.sm,
          children: sizes.map((s) {
            final sel = selectedSize == s;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onSizeSelected(s);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: sel ? accent : Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSm),
                  border: Border.all(
                    color: sel ? accent : AppColors.borderSubtle,
                    width: sel ? 0 : 1,
                  ),
                  boxShadow: sel
                      ? [
                          BoxShadow(
                            color: accent.withOpacity(0.35),
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    s,
                    style: AppTextStyles.caption.copyWith(
                      color:
                          sel ? onColor(accent) : AppColors.textPrimary,
                      fontWeight:
                          sel ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Seller Card
// ─────────────────────────────────────────────────────────────
class SellerCard extends StatelessWidget {
  final Map<String, String> seller;
  final Color elegant, accent;
  final VoidCallback onChatTap;

  const SellerCard({
    Key? key,
    required this.seller,
    required this.elegant,
    required this.accent,
    required this.onChatTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChatTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: elegant.withOpacity(0.15),
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Center(
              child: Text(seller['emoji']!,
                  style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sold by',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textTertiary)),
                Text(seller['name']!,
                    style: AppTextStyles.bodySmall
                        .copyWith(fontWeight: FontWeight.w700)),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 12, color: AppColors.ratingFilled),
                    const SizedBox(width: 2),
                    Text(seller['rating']!,
                        style: AppTextStyles.caption
                            .copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md, vertical: 8),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Row(
              children: [
                Icon(Icons.chat_bubble_outline, size: 14, color: accent),
                const SizedBox(width: 4),
                Text('Chat',
                    style: AppTextStyles.caption.copyWith(
                        color: accent, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Quantity Row
// ─────────────────────────────────────────────────────────────
class QuantityRow extends StatelessWidget {
  final ProductModel p;
  final Color accent;
  final int qty;
  final VoidCallback onDecrement, onIncrement;

  const QuantityRow({
    Key? key,
    required this.p,
    required this.accent,
    required this.qty,
    required this.onDecrement,
    required this.onIncrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Quantity',
            style: AppTextStyles.bodySmall
                .copyWith(fontWeight: FontWeight.w700)),
        const Spacer(),
        QtyButton(icon: Icons.remove, accent: accent, onTap: onDecrement),
        SizedBox(
          width: 44,
          child: Center(
            child: Text('$qty',
                style: AppTextStyles.headline3
                    .copyWith(fontWeight: FontWeight.w800)),
          ),
        ),
        QtyButton(icon: Icons.add, accent: accent, onTap: onIncrement),
        const SizedBox(width: AppDimensions.lg),
        Text(
          '${p.stock} left',
          style: AppTextStyles.caption.copyWith(
            color: p.stock > 5 ? AppColors.success : AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
