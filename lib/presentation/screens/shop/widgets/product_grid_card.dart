// lib/presentation/screens/shop/widgets/product_grid_card.dart
import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';
import 'package:setrise/data/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/product/product_detail_screen.dart';
import 'package:setrise/presentation/screens/shop/providers/wishlist_provider.dart';
import 'package:setrise/presentation/screens/shop/cart_service.dart';

final CartService _cartService = CartService();

class ProductGridCard extends StatelessWidget {
  final ProductModel product;
  const ProductGridCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: globalWishlistProvider,
      builder: (context, _) {
        final isFav = globalWishlistProvider.isFavorite(product.id);
        final hasDiscount = product.oldPrice != null;
        return GestureDetector(
          onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_) => ProductDetailScreen(product: product))),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: AppColors.black.withOpacity(0.08), blurRadius: 8)
              ],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 6,
                child: Stack(children: [
                  ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(product.images.first,
                          width: double.infinity, fit: BoxFit.cover)),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => globalWishlistProvider.toggleFavorite(product.id),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.9),
                            shape: BoxShape.circle),
                        child: Icon(
                          isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                          color: isFav ? AppColors.neonRed : AppColors.mediumGray,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: AppColors.shop,
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          '-${product.discountPercentage}%',
                          style: const TextStyle(
                              color: AppColors.white, fontSize: 11),
                        ),
                      ),
                    ),
                ]),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
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
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              if (hasDiscount)
                                Text(
                                  '\$${product.oldPrice!.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      color: AppColors.mediumGray,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 11),
                                ),
                            ],
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Icon(CupertinoIcons.cart_fill_badge_plus,
                                color: AppColors.shop, size: 20),
                            onPressed: () {
                              _cartService.addItem(CartItem(
                                id: product.id,
                                imageUrl: product.images.first,
                                brand: product.brandName,
                                name: product.name,
                                price: product.price,
                                quantity: 1,
                              ));
                              showCupertinoDialog(
                                context: context,
                                builder: (_) => CupertinoAlertDialog(
                                  title: const Text('Added to Cart'),
                                  content: Text(
                                      '${product.name} added to your cart.'),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text('OK'),
                                      onPressed: () => Navigator.pop(context),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
