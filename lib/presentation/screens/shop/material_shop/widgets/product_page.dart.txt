import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../shop/material_shop/models/product_model.dart';
import '../../../../../../shop/material_shop/providers/cart_provider.dart';
import '../../../../../../shop/material_shop/providers/wishlist_provider.dart';
import '../../../../../../shop/material_shop/theme/app_colors.dart';
import '../../../../../../shop/material_shop/theme/app_dimensions.dart';
import '../../../../../../shop/material_shop/theme/app_text_styles.dart';
import '../../../../../../shop/material_shop/utils/haptics.dart';
import '../../../../../../shop/material_shop/widgets/shimmer_loader.dart';

class ProductPage extends ConsumerStatefulWidget {
  final ProductModel product;
  const ProductPage({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  int _qty = 1;

  void _addToCart() {
    Haptics.light();
    ref.read(cartProvider.notifier).addItem(widget.product, {}, _qty);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added to cart',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.backgroundSecondary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppDimensions.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isWishlisted = ref.watch(wishlistProvider).contains(product.id);
    final cartCount = ref.watch(cartProvider).itemCount;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: CustomScrollView(
        slivers: [
          // ── AppBar مع صورة المنتج
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: AppColors.backgroundPrimary,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
              ),
            ),
            actions: [
              // زر الـ Wishlist
              GestureDetector(
                onTap: () {
                  Haptics.light();
                  ref.read(wishlistProvider.notifier).toggle(product.id);
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isWishlisted ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: isWishlisted ? AppColors.error : AppColors.textTertiary,
                  ),
                ),
              ),
              // زر الكارت مع عداد
              GestureDetector(
                onTap: () => context.push('/cart'),
                child: Container(
                  margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 20, color: AppColors.textPrimary),
                      if (cartCount > 0)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: AppColors.badgeCartBg,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$cartCount',
                                style: const TextStyle(fontSize: 8, color: AppColors.badgeCartFg, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: product.images.isNotEmpty ? product.images.first : '',
                fit: BoxFit.cover,
                placeholder: (context, url) => const ShimmerLoader(
                  child: ColoredBox(color: AppColors.backgroundSkeleton),
                ),
                errorWidget: (context, url, error) => const ColoredBox(
                  color: AppColors.backgroundTertiary,
                  child: Icon(Icons.image_not_supported, size: 48, color: AppColors.textQuaternary),
                ),
              ),
            ),
          ),

          // ── تفاصيل المنتج
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand + Badges
                  Row(
                    children: [
                      Text(
                        product.brand.toUpperCase(),
                        style: AppTextStyles.labelUpper.copyWith(color: AppColors.textTertiary),
                      ),
                      const Spacer(),
                      if (product.isHot)
                        _Badge(label: 'HOT', bg: AppColors.badgeHotBg, fg: AppColors.badgeHotFg),
                      if (product.isNew)
                        _Badge(label: 'NEW', bg: AppColors.badgeNewBg, fg: AppColors.badgeNewFg),
                      if (product.discount > 0)
                        _Badge(
                          label: '-${product.discount}%',
                          bg: AppColors.badgeSaleBg,
                          fg: AppColors.badgeSaleFg,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xs),

                  // اسم المنتج
                  Text(product.name, style: AppTextStyles.headline2),
                  const SizedBox(height: AppDimensions.sm),

                  // السعر والتقييم
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.priceLarge.copyWith(fontWeight: FontWeight.w800),
                      ),
                      if (product.originalPrice > 0) ...[
                        const SizedBox(width: AppDimensions.sm),
                        Text(
                          '\$${product.originalPrice.toStringAsFixed(2)}',
                          style: AppTextStyles.priceStrike,
                        ),
                      ],
                      const Spacer(),
                      Icon(Icons.star, size: AppDimensions.ratingStarMd, color: AppColors.ratingFilled),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating}',
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        ' (${product.reviewCount})',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.sectionGap),

                  // الوصف
                  if (product.description != null) ...[
                    Text('Description', style: AppTextStyles.headline3),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      product.description!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sectionGap),
                  ],

                  // Shipping info
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.md),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          color: product.shippingFree ? AppColors.success : AppColors.textTertiary,
                          size: 20,
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        Text(
                          product.shippingFree ? 'Free Shipping' : 'Standard Shipping \$5.99',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: product.shippingFree ? AppColors.success : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: product.stock > 0
                                ? AppColors.statusDeliveredBg
                                : AppColors.statusCancelledBg,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                          ),
                          child: Text(
                            product.stock > 0 ? 'In Stock' : 'Out of Stock',
                            style: AppTextStyles.caption.copyWith(
                              color: product.stock > 0
                                  ? AppColors.statusDeliveredFg
                                  : AppColors.statusCancelledFg,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sectionGap),

                  // اختيار الكمية
                  Text('Quantity', style: AppTextStyles.headline3),
                  const SizedBox(height: AppDimensions.sm),
                  Row(
                    children: [
                      _QtyButton(
                        icon: Icons.remove,
                        onTap: () { if (_qty > 1) setState(() => _qty--); },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
                        child: Text(
                          '$_qty',
                          style: AppTextStyles.headline3,
                        ),
                      ),
                      _QtyButton(
                        icon: Icons.add,
                        onTap: () {
                          if (_qty < product.stock) setState(() => _qty++);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 100), // مسافة للـ bottom bar
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Action Bar
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppDimensions.lg, AppDimensions.sm, AppDimensions.lg, AppDimensions.md),
          child: Row(
            children: [
              // زر السعر
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.md),
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: const Border.fromBorderSide(BorderSide(color: AppColors.borderSubtle)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                    Text(
                      '\$${(product.price * _qty).toStringAsFixed(2)}',
                      style: AppTextStyles.priceMedium.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              // زر Add to Cart
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: product.stock > 0 ? _addToCart : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ctaPrimaryBg,
                      disabledBackgroundColor: AppColors.ctaPrimaryDisabledBg,
                      foregroundColor: AppColors.ctaPrimaryFg,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                    ),
                    icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                    label: Text(
                      product.stock > 0 ? 'Add to Cart' : 'Out of Stock',
                      style: AppTextStyles.buttonLabel,
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

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _Badge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg, fontFamily: 'Inter'),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          border: const Border.fromBorderSide(BorderSide(color: AppColors.borderSubtle)),
        ),
        child: Icon(icon, size: 18, color: AppColors.textPrimary),
      ),
    );
  }
}
