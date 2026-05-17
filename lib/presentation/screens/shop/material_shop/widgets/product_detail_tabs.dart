// lib/presentation/screens/shop/material_shop/widgets/product_detail_tabs.dart
//
// تابات صفحة التفاصيل: الوصف والمراجعات
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/review_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_detail_widgets.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_palette_utils.dart';

// ─────────────────────────────────────────────────────────────
// Description Tab
// ─────────────────────────────────────────────────────────────
class DescriptionTab extends StatelessWidget {
  final ProductModel p;
  final Color accent;
  const DescriptionTab({Key? key, required this.p, required this.accent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (p.description != null)
            Text(
              p.description!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.7,
              ),
            ),
          const SizedBox(height: AppDimensions.md),
          SpecRow('Brand', p.brand, accent),
          SpecRow('SKU', p.id.toUpperCase(), accent),
          SpecRow('Stock', '${p.stock} units', accent),
          SpecRow('Shipping', p.shippingFree ? 'Free' : '\$5.99', accent),
          SpecRow('Returns', '30-day return policy', accent),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Reviews Tab
// ─────────────────────────────────────────────────────────────
class ReviewsTab extends StatelessWidget {
  final ProductModel p;
  final List<ReviewModel> reviews;
  final double avg;
  final Color accent;
  final VoidCallback onWriteReview;

  const ReviewsTab({
    Key? key,
    required this.p,
    required this.reviews,
    required this.avg,
    required this.accent,
    required this.onWriteReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reviewCount = reviews.isEmpty ? p.reviewCount : reviews.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Row(
            children: [
              // Rating summary
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    avg.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: accent,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < avg.round()
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 18,
                        color: AppColors.ratingFilled,
                      ),
                    ),
                  ),
                  Text(
                    '$reviewCount reviews',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: onWriteReview,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Write Review'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: onColor(accent),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Review list
        Expanded(
          child: reviews.isEmpty
              ? Center(
                  child: Text(
                    'No reviews yet.\nBe the first!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textTertiary),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.lg),
                  itemCount: reviews.length,
                  itemBuilder: (_, i) {
                    final r = reviews[i];
                    return ReviewItem(
                      userName: r.userName,
                      rating: r.rating,
                      comment: r.comment,
                      date: r.date,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
