import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../utils/haptics.dart';
import '../models/product_model.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';
import 'shimmer_loader.dart';

class ProductCard extends ConsumerStatefulWidget {
  final ProductModel product;
  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  bool _pressed = false;

  void _addToCart() {
    Haptics.light();
    ref.read(cartProvider.notifier).addItem(widget.product, {}, 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.product.name} added to cart',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.backgroundSecondary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppDimensions.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: AppColors.ctaPrimaryBg,
          onPressed: () => context.push('/cart'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isWishlisted = ref.watch(wishlistProvider).contains(product.id);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        Haptics.light();
        // ✅ تم التصحيح: تمرير الـ product كـ extra
        context.push('/product/${product.id}', extra: product);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            side: const BorderSide(color: AppColors.borderSubtle, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(product, isWishlisted),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.cardInner,
                  AppDimensions.cardInner,
                  AppDimensions.cardInner,
                  AppDimensions.xs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand.toUpperCase(),
                      style: AppTextStyles.labelUpper.copyWith(color: AppColors.textTertiary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    _buildPrice(product),
                    const SizedBox(height: AppDimensions.xxs),
                    _buildRating(product),
                    if (product.shippingFree) _buildShippingBadge(),
                  ],
                ),
              ),
              // ✅ زر Add to Cart الجديد
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.cardInner,
                  AppDimensions.xxs,
                  AppDimensions.cardInner,
                  AppDimensions.cardInner,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 34,
                  child: ElevatedButton(
                    onPressed: _addToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ctaPrimaryBg,
                      foregroundColor: AppColors.ctaPrimaryFg,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                    ),
                    child: Text(
                      'Add to Cart',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.ctaPrimaryFg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(ProductModel product, bool isWishlisted) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: product.images.isNotEmpty ? product.images.first : '',
              fit: BoxFit.cover,
              placeholder: (context, url) => const ShimmerLoader(
                child: ColoredBox(color: AppColors.backgroundSkeleton),
              ),
              errorWidget: (context, url, error) => const ColoredBox(
                color: AppColors.backgroundTertiary,
                child: Icon(Icons.image_not_supported, color: AppColors.textQuaternary),
              ),
            ),
            // Badges
            if (product.isHot || product.isNew || product.discount > 0)
              Positioned(
                top: AppDimensions.xs,
                left: AppDimensions.xs,
                child: _buildBadge(product),
              ),
            // Wishlist button
            Positioned(
              top: AppDimensions.xs,
              right: AppDimensions.xs,
              child: GestureDetector(
                onTap: () {
                  Haptics.light();
                  ref.read(wishlistProvider.notifier).toggle(product.id);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isWishlisted ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: isWishlisted ? AppColors.error : AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(ProductModel product) {
    Color bg;
    Color fg;
    String label;

    if (product.isHot) {
      bg = AppColors.badgeHotBg;
      fg = AppColors.badgeHotFg;
      label = 'HOT';
    } else if (product.isNew) {
      bg = AppColors.badgeNewBg;
      fg = AppColors.badgeNewFg;
      label = 'NEW';
    } else {
      bg = AppColors.badgeSaleBg;
      fg = AppColors.badgeSaleFg;
      label = '-${product.discount}%';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildPrice(ProductModel product) {
    return Row(
      children: [
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: AppTextStyles.priceSmall.copyWith(fontWeight: FontWeight.w700),
        ),
        if (product.originalPrice > 0) ...[
          const SizedBox(width: AppDimensions.xs),
          Text(
            '\$${product.originalPrice.toStringAsFixed(2)}',
            style: AppTextStyles.priceStrike,
          ),
        ],
      ],
    );
  }

  Widget _buildRating(ProductModel product) {
    return Row(
      children: [
        Icon(Icons.star, size: AppDimensions.ratingStarSm, color: AppColors.ratingFilled),
        const SizedBox(width: 2),
        Text(
          '${product.rating}',
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          ' (${product.reviewCount})',
          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildShippingBadge() {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.xxs),
      child: Row(
        children: [
          Icon(Icons.local_shipping_outlined, size: 12, color: AppColors.success),
          const SizedBox(width: 2),
          Text(
            'Free Shipping',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
