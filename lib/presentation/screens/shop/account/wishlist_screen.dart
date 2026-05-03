// lib/presentation/screens/shop/account/wishlist_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';
import 'package:setrise/data/mock_data/shop_mock_data.dart';
import 'package:setrise/data/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/providers/wishlist_provider.dart';
import 'package:setrise/presentation/screens/shop/widgets/product_grid_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allProducts = ShopMockData.getFeaturedProducts() + ShopMockData.getPopularProducts();
    return ListenableBuilder(
      listenable: globalWishlistProvider,
      builder: (context, _) {
        final favorites = allProducts
            .where((p) => globalWishlistProvider.isFavorite(p.id))
            .toList();
        return CupertinoPageScaffold(
          backgroundColor: AppColors.background,
          navigationBar: const CupertinoNavigationBar(
            backgroundColor: AppColors.surface,
            middle: Text('Wishlist', style: TextStyle(color: AppColors.black)),
          ),
          child: favorites.isEmpty
              ? const Center(
                  child: Text('Your wishlist is empty',
                      style: TextStyle(color: AppColors.mediumGray)))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (_, i) => ProductGridCard(product: favorites[i]),
                ),
        );
      },
    );
  }
}
