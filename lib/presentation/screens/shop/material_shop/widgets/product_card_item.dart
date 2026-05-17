// lib/presentation/screens/shop/material_shop/widgets/product_card_item.dart
//
// ProductCard — بطاقة المنتج في الشبكة (Grid)
// ✅ إصلاح: لا يوجد circular import — يستخدم onTap callback خارجي
// ──────────────────────────────────────────────────────────────

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/wishlist_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/cart_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/reviews_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/shimmer_loader.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_detail_widgets.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_palette_utils.dart';
// ✅ import مباشر — لا يسبب حلقة لأن detail_page لا يستورد card_item
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_detail_page.dart';

class ProductCard extends ConsumerStatefulWidget {
  final ProductModel product;
  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  bool _pressed = false;

  void _addToCart() {
    HapticFeedback.lightImpact();
    ref.read(cartProvider.notifier).addItem(widget.product, {}, 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added to cart',
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppDimensions.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openDetail() {
    HapticFeedback.lightImpact();
    pushScreen(context, ProductDetailPage(product: widget.product));
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final isWishlisted = ref.watch(wishlistProvider).contains(p.id);
    final reviews =
        ref.watch(reviewsProvider).where((r) => r.productId == p.id).toList();
    final avg = reviews.isEmpty
        ? p.rating
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
            reviews.length;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        _openDetail();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 16,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image + badges ─────────────────────────────
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.radiusLg),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: p.images.isNotEmpty ? p.images.first : '',
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const ShimmerLoader(
                          child: ColoredBox(
                            color: AppColors.backgroundSkeleton,
                          ),
                        ),
                        errorWidget: (_, __, ___) => const ColoredBox(
                          color: AppColors.backgroundTertiary,
                          child: Icon(
                            Icons.image_outlined,
                            color: AppColors.textQuaternary,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (p.isHot || p.isNew || p.discount > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: ProductBadge(p: p),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        ref.read(wishlistProvider.notifier).toggle(p.id);
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: Icon(
                          isWishlisted
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 18,
                          color: isWishlisted
                              ? AppColors.error
                              : AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ── Text info ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.brand.toUpperCase(),
                      style: AppTextStyles.labelUpper.copyWith(
                        color: AppColors.ctaPrimaryBg,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      p.name,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '\$${p.price.toStringAsFixed(2)}',
                          style: AppTextStyles.priceSmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (p.originalPrice > 0) ...[
                          const SizedBox(width: 6),
                          Text(
                            '\$${p.originalPrice.toStringAsFixed(2)}',
                            style: AppTextStyles.priceStrike,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 13, color: AppColors.ratingFilled),
                        const SizedBox(width: 2),
                        Text(
                          avg.toStringAsFixed(1),
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          ' (${reviews.isEmpty ? p.reviewCount : reviews.length})',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.textTertiary),
                        ),
                        if (p.shippingFree) ...[
                          const Spacer(),
                          const Icon(Icons.local_shipping_rounded,
                              size: 12, color: AppColors.success),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // ── Add to cart button ─────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: _addToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ctaPrimaryBg,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                    ),
                    child: Text(
                      'Add to Cart',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
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
}
