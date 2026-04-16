// lib/presentation/screens/shop/wishlist_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock_data/shop_mock_data.dart';
import '../../../data/models/product_model.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late List<ProductModel> _wishlistItems;

  @override
  void initState() {
    super.initState();
    // Get mock products and mark some as favorite
    _wishlistItems = ShopMockData.getFeaturedProducts()
        .take(4)
        .map((p) => p.copyWith(isFavorite: true))
        .toList();
    _wishlistItems.addAll(ShopMockData.getPopularProducts()
        .take(3)
        .map((p) => p.copyWith(isFavorite: true)));
  }

  void _removeFromWishlist(ProductModel product) {
    setState(() {
      _wishlistItems.removeWhere((p) => p.id == product.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} removed from wishlist'),
        backgroundColor: AppColors.grey,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppColors.shop,
          onPressed: () {
            setState(() {
              _wishlistItems.add(product);
            });
          },
        ),
      ),
    );
  }

  void _addToCart(ProductModel product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart!'),
        backgroundColor: AppColors.shop,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.grey,
        title: Text(
          'Clear Wishlist',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.white,
          ),
        ),
        content: Text(
          'Are you sure you want to remove all items from your wishlist?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.grey2,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.grey2,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _wishlistItems.clear();
              });
              Navigator.pop(ctx);
            },
            child: Text(
              'Clear All',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.neonRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Wishlist',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_wishlistItems.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.grey2,
              ),
              onPressed: _clearAll,
            ),
        ],
      ),
      body: _wishlistItems.isEmpty
          ? _buildEmptyWishlist()
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: _wishlistItems.length,
              itemBuilder: (context, index) {
                final product = _wishlistItems[index];
                return _WishlistCard(
                  product: product,
                  onRemove: () => _removeFromWishlist(product),
                  onAddToCart: () => _addToCart(product),
                );
              },
            ),
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              color: AppColors.grey2,
              size: 60,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your wishlist is empty',
            style: AppTextStyles.h5.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Save your favorite items here',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.shop,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Start Shopping',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== WISHLIST CARD =====
class _WishlistCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const _WishlistCard({
    required this.product,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.oldPrice != null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.grey.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: AppColors.grey,
                      child: Image.network(
                        product.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.grey,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.grey2,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Discount Badge
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.neonRed,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-${product.discountPercentage.round()}%',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Remove button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Details
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brandName,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.shop,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.shop,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (hasDiscount)
                              Text(
                                '\$${product.oldPrice!.toStringAsFixed(2)}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.grey2,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        // Add to Cart Button
                        GestureDetector(
                          onTap: onAddToCart,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.shop,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart_rounded,
                              color: AppColors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
