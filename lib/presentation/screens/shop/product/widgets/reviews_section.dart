// lib/presentation/screens/shop/product/widgets/reviews_section.dart
import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';
import 'package:setrise/data/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/models/review_model.dart';
import 'package:setrise/presentation/screens/shop/services/reviews_service.dart';
import 'package:setrise/presentation/screens/shop/write_review_screen.dart';

class ReviewsSection extends StatelessWidget {
  final ProductModel product;
  const ReviewsSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final reviews = ReviewsService().getReviewsForProduct(product.id);
    // إضافة بعض المراجعات الافتراضية إن كانت فارغة
    final displayReviews = reviews.isNotEmpty
        ? reviews
        : [
            ReviewModel(
                id: '1',
                productId: product.id,
                userName: 'User 1',
                rating: 5,
                comment: 'Great product!'),
            ReviewModel(
                id: '2',
                productId: product.id,
                userName: 'User 2',
                rating: 4,
                comment: 'Good quality',
                imageUrl: 'https://picsum.photos/100/100?random=99'),
          ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reviews',
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...displayReviews.map((r) => _reviewCard(r)),
          const SizedBox(height: 12),
          Center(
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: AppColors.black,
              child: const Text('Write a Review',
                  style: TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (_) => WriteReviewScreen(
                            productId: product.id,
                            productName: product.name,
                            productImage: product.images.first)));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewCard(ReviewModel r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 4)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: AppColors.accent, shape: BoxShape.circle),
                child: Center(
                    child: Text(r.userName.substring(0, 1),
                        style: const TextStyle(
                            color: AppColors.white, fontSize: 12)))),
            const SizedBox(width: 8),
            Text(r.userName,
                style: const TextStyle(
                    color: AppColors.black, fontWeight: FontWeight.w600)),
            const Spacer(),
            Row(
                children: List.generate(
                    5,
                    (i) => Icon(
                          i < r.rating.floor()
                              ? CupertinoIcons.star_fill
                              : CupertinoIcons.star,
                          color: AppColors.shop,
                          size: 14,
                        ))),
          ]),
          const SizedBox(height: 8),
          Text(r.comment, style: const TextStyle(color: AppColors.darkGray)),
          if (r.imageUrl != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(r.imageUrl!,
                    width: 80, height: 80, fit: BoxFit.cover)),
          ],
        ],
      ),
    );
  }
}
