// lib/presentation/screens/shop/widgets/store_stats.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';

class StoreStats extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final int productCount;
  final int followerCount;

  const StoreStats({
    super.key,
    required this.rating,
    required this.reviewCount,
    required this.productCount,
    required this.followerCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('Rating', rating.toStringAsFixed(1)),
          _buildStat('Reviews', Formatters.formatCount(reviewCount)),
          _buildStat('Products', Formatters.formatCount(productCount)),
          _buildStat('Followers', Formatters.formatCount(followerCount)),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.white, fontWeight: FontWeight.bold)),
        Text(label,
            style: AppTextStyles.caption.copyWith(color: AppColors.grey2)),
      ],
    );
  }
}
