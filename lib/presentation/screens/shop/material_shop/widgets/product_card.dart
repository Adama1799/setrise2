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
import 'shimmer_loader.dart';

class ProductCard extends ConsumerStatefulWidget {
  final ProductModel product;
  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isWishlisted = ref.watch(wishlistProvider).contains(product.id);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        Haptics.light();
        context.push('/product/${product.id}');
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
                padding: const EdgeInsets.all(AppDimensions.cardInner),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.brand.toUpperCase(), style: AppTextStyles.labelUpper.copyWith(color: AppColors.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(product.name, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: AppDimensions.xs),
                    _buildPrice(product),
                    const SizedBox(height: AppDimensions.xxs),
                    _buildRating(product),
                    if (product.shippingFree) _buildShippingBadge(),
                  ],
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLg)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: product.images.isNotEmpty ? product.images.first : '',
              fit: BoxFit.cover,
              placeholder: (context, url) => const ShimmerLoader(child: ColoredBox(color: AppColors.backgroundSkeleton)),
              errorWidget: (context, url, error) => const ColoredBox(
                color: AppColors.backgroundTertiary,
                child: Icon(Icons.image_not_supported, color: AppColors.textQuaternary),
              ),
            ),
            Positioned(
              top: AppDimensions.xs, right: AppDimensions.xs,
              child: GestureDetector(
                onTap: () {
                  Haptics.light();
                  ref.read(wishlistProvider.notifier).toggle(product.id);
                },
                child: Container(
                  width: 32, height: 32,
                  decoration: const BoxDecoration(color: AppColors.backgroundPrimary, shape: BoxShape.circle),
                  child: Icon(
                    isWishlisted ? Icons.favorite : Icons.favorite_border,
                    size: 18, color: isWishlisted ? AppColors.error : AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrice(ProductModel product) {
    return Row(
      children: [
        Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.priceSmall.copyWith(fontWeight: FontWeight.w700)),
        if (product.originalPrice > 0) ...[
          const SizedBox(width: AppDimensions.xs),
          Text('\$${product.originalPrice.toStringAsFixed(2)}', style: AppTextStyles.priceStrike),
        ],
      ],
    );
  }

  Widget _buildRating(ProductModel product) {
    return Row(
      children: [
        Icon(Icons.star, size: AppDimensions.ratingStarSm, color: AppColors.ratingFilled),
        const SizedBox(width: 2),
        Text('${product.rating}', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
        Text(' (${product.reviewCount})', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
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
          Text('Free Shipping', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
