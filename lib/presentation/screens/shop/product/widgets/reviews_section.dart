import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';
import 'package:setrise/data/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/write_review_screen.dart';

class ReviewsSection extends StatelessWidget {
  final ProductModel product;
  const ReviewsSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Reviews', style: TextStyle(color: AppColors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _ratingSummary(),
        const SizedBox(height: 12),
        ...List.generate(2, (i) => _reviewCard(i)),
        const SizedBox(height: 12),
        Center(
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: AppColors.black,
            child: const Text('Write a Review', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600)),
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (_) => WriteReviewScreen(
                productId: product.id,
                productName: product.name,
                productImage: product.images.first,
              )));
            },
          ),
        ),
      ]),
    );
  }

  Widget _ratingSummary() {
    return Row(children: [
      Text(product.rating.toStringAsFixed(1), style: const TextStyle(color: AppColors.black, fontSize: 40, fontWeight: FontWeight.bold)),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: List.generate(5, (i) => Row(children: [
        Icon(CupertinoIcons.star_fill, color: AppColors.shop, size: 12),
        const SizedBox(width: 8),
        Container(width: 80, height: 4, color: AppColors.lightGray, child: Align(alignment: Alignment.centerLeft, child: Container(width: (i < 3 ? 0.6 : 0.2) * 80, color: AppColors.shop))),
      ]))),
    ]);
  }

  Widget _reviewCard(int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 4)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle), child: Center(child: Text('U${i+1}', style: TextStyle(color: AppColors.white, fontSize: 12)))),
          const SizedBox(width: 8),
          const Text('User Name', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600)),
          const Spacer(),
          Row(children: List.generate(5, (s) => Icon(s < 4 ? CupertinoIcons.star_fill : CupertinoIcons.star, color: AppColors.shop, size: 14))),
        ]),
        const SizedBox(height: 8),
        const Text('Great product! Highly recommended.', style: TextStyle(color: AppColors.darkGray)),
      ]),
    );
  }
}
