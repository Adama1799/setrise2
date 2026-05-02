// lib/presentation/screens/shop/product/widgets/similar_products_section.dart
import 'package:flutter/cupertino.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../data/models/product_model.dart';
import '../product_detail_screen.dart';

class SimilarProductsSection extends StatelessWidget {
  final List<ProductModel> products;
  const SimilarProductsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'You May Also Like',
            style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final p = products[i];
                return GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(builder: (_) => ProductDetailScreen(product: p)),
                  ),
                  child: Container(
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            p.images.first,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            p.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.white, fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 8),
                          child: Text(
                            '\$${p.price.toStringAsFixed(2)}',
                            style: const TextStyle(color: AppColors.shop, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
