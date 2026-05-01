// lib/presentation/screens/shop/product/widgets/reviews_section.dart
import 'package:flutter/cupertino.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../data/models/product_model.dart';

class ReviewsSection extends StatelessWidget {
  final ProductModel product;
  const ReviewsSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Reviews', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _ratingBar(),
        const SizedBox(height: 12),
        ...List.generate(3, (i) => _reviewCard(i)),
      ]),
    );
  }

  Widget _ratingBar() {
    return Row(children: [
      Text(product.rating.toStringAsFixed(1), style: const TextStyle(color: AppColors.white, fontSize: 40, fontWeight: FontWeight.bold)),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: List.generate(5, (i) => Row(children: [
        Icon(CupertinoIcons.star_fill, color: CupertinoColors.systemYellow, size: 12),
        const SizedBox(width: 8),
        Container(width: 80, height: 4, color: AppColors.grey.withOpacity(0.2), child: Align(alignment: Alignment.centerLeft, child: Container(width: (i < 3 ? 0.5 : 0.2) * 80, color: AppColors.shop))),
        const SizedBox(width: 8),
        Text('${(i < 3 ? 50 : 20)}%', style: const TextStyle(color: AppColors.grey2, fontSize: 11)),
      ]))),
    ]);
  }

  Widget _reviewCard(int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 16, backgroundColor: AppColors.accent, child: Text('U${i+1}', style: const TextStyle(color: AppColors.white, fontSize: 12))),
          const SizedBox(width: 8),
          const Text('User Name', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600)),
          const Spacer(),
          Row(children: List.generate(5, (star) => Icon(star < 4 ? CupertinoIcons.star_fill : CupertinoIcons.star, color: CupertinoColors.systemYellow, size: 14))),
        ]),
        const SizedBox(height: 8),
        const Text('Great product! Highly recommended.', style: TextStyle(color: AppColors.grey2)),
      ]),
    );
  }
}
