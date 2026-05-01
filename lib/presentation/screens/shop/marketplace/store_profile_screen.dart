// lib/presentation/screens/shop/marketplace/store_profile_screen.dart
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/mock_data/shop_mock_data.dart';
import '../../../../data/models/store_model.dart';
import 'widgets/store_product_card.dart';
import '../widgets/store_stats.dart';

class StoreProfileScreen extends StatelessWidget {
  final Store store;
  const StoreProfileScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final products = ShopMockData.getFeaturedProducts().take(6).toList();
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.surface,
        middle: Text(store.name, style: const TextStyle(color: AppColors.white)),
        leading: CupertinoNavigationBarBackButton(color: AppColors.white, onPressed: () => Navigator.pop(context)),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(store.logoUrl, width: 80, height: 80, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(store.name, style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(store.description, style: const TextStyle(color: AppColors.grey2)),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  StoreStats(rating: store.rating, reviewCount: store.reviewCount, productCount: 42, followerCount: 1520),
                  const SizedBox(height: 24),
                  const Text('Featured Products', style: TextStyle(color: AppColors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 12, mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, i) => StoreProductCard(product: products[i]),
                  childCount: products.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
