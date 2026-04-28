// lib/presentation/screens/shop/widgets/reviews_section.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/product_model.dart';

class ReviewsSection extends StatelessWidget {
  final ProductModel product;
  const ReviewsSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reviews', style: AppTextStyles.body1),
          const SizedBox(height: 8),
          _buildRatingSummary(),
          const SizedBox(height: 16),
          ...List.generate(3, (index) => _buildReviewCard(index)),
        ],
      ),
    );
  }

  Widget _buildRatingSummary() {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(product.rating.toStringAsFixed(1), style: AppTextStyles.headline2),
                Text('/5', style: AppTextStyles.body2.copyWith(color: AppColors.secondaryText)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (i) => _buildRatingBar(5 - i, _getCount(5 - i))),
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(int stars) {
    final total = product.reviewsCount;
    if (stars == 5) return (total * 0.4).round();
    if (stars == 4) return (total * 0.3).round();
    if (stars == 3) return (total * 0.2).round();
    if (stars == 2) return (total * 0.07).round();
    return (total * 0.03).round();
  }

  Widget _buildRatingBar(int stars, int count) {
    return Row(
      children: [
        Text('$stars', style: AppTextStyles.body2),
        const Icon(Icons.star, color: Colors.amber, size: 12),
        Expanded(
          child: Container(
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: AppColors.border, borderRadius: BorderRadius.circular(4)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: count / product.reviewsCount,
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.accent, borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
        ),
        Text('$count', style: AppTextStyles.body2),
      ],
    );
  }

  Widget _buildReviewCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.accent.withOpacity(0.2),
                child: Text('U${index + 1}',
                    style: AppTextStyles.caption.copyWith(color: AppColors.accent)),
              ),
              const SizedBox(width: 8),
              Text('User ${index + 1}', style: AppTextStyles.body2),
              const Spacer(),
              ...List.generate(
                5,
                (starIndex) => Icon(
                  starIndex < [5, 4, 3][index] ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Great product! Highly recommended.', style: AppTextStyles.body2),
        ],
      ),
    );
  }
}
