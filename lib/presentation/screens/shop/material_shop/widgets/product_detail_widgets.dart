// lib/presentation/screens/shop/material_shop/widgets/product_detail_widgets.dart
//
// ويدجت مساعدة مشتركة بين ProductCard و ProductDetailPage
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';

// ─────────────────────────────────────────────────────────────
// _Badge — بادج الصورة (Hot / New / Sale)
// ─────────────────────────────────────────────────────────────
class ProductBadge extends StatelessWidget {
  final ProductModel p;
  const ProductBadge({Key? key, required this.p}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (p.isHot)
          _BadgePill(label: '🔥 HOT', color: AppColors.badgeHotBg),
        if (p.isNew)
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: _BadgePill(label: '✨ NEW', color: AppColors.badgeNewBg),
          ),
        if (p.discount > 0)
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: _BadgePill(
              label: '-${p.discount}%',
              color: AppColors.badgeSaleBg,
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// _SmBadge — بادج صغيرة نصية فقط
// ─────────────────────────────────────────────────────────────
class SmallBadge extends StatelessWidget {
  final String label;
  final Color color;
  const SmallBadge(this.label, this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _BadgePill(label: label, color: color);
}

class _BadgePill extends StatelessWidget {
  final String label;
  final Color color;
  const _BadgePill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 9,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// _Section — حاوية القسم ذات الخلفية الفاخرة
// ─────────────────────────────────────────────────────────────
class DetailSection extends StatelessWidget {
  final Color elegant;
  final Widget child;
  const DetailSection({Key? key, required this.elegant, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: elegant.withOpacity(0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: elegant.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// _QtyBtn — زر تعديل الكمية
// ─────────────────────────────────────────────────────────────
class QtyButton extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;
  const QtyButton({
    Key? key,
    required this.icon,
    required this.accent,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: accent.withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        child: Icon(icon, size: 18, color: accent),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// _Spec — صف مواصفات المنتج (label: value)
// ─────────────────────────────────────────────────────────────
class SpecRow extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;
  const SpecRow(this.label, this.value, this.accent, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// _ReviewItem — عنصر مراجعة واحدة
// ─────────────────────────────────────────────────────────────
class ReviewItem extends StatelessWidget {
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  const ReviewItem({
    Key? key,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.backgroundTertiary,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < rating.round()
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 12,
                        color: AppColors.ratingFilled,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '${date.day}/${date.month}/${date.year}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            comment,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const Divider(height: 16, color: AppColors.borderSubtle),
        ],
      ),
    );
  }
}
