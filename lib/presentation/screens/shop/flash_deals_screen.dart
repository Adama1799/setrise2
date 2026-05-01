// lib/presentation/screens/shop/flash_deals_screen.dart
import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/product_model.dart';
import 'widgets/product_grid_card.dart';

class FlashDealsScreen extends StatelessWidget {
  const FlashDealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات وهمية للعروض
    final deals = List.generate(6, (i) => ProductModel(
      id: 'deal$i', name: 'Deal Product $i', brand: 'Brand', price: 9.99 + i, oldPrice: 19.99 + i,
      description: '', images: ['https://picsum.photos/400/400?random=10$i'],
      imageUrls: ['https://picsum.photos/400/400?random=10$i'],
      rating: 4.5, reviewsCount: 100, isFavorite: false, discountPercentage: 50, brandName: 'Brand', videoUrl: null,
    ));

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Flash Deals', style: TextStyle(color: CupertinoColors.white)),
      ),
      child: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemCount: deals.length,
          itemBuilder: (_, i) => ProductGridCard(product: deals[i]),
        ),
      ),
    );
  }
}
