import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/utils/haptics.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/wishlist_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/cart_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/shimmer_loader.dart';

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProviderScope(
              parent: ProviderScope.containerOf(context),
              child: _ProductDetailPage(product: product),
            ),
          ),
        );
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
              // ✅ زر Add to Cart
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
            if (product.isHot || product.isNew || product.discount > 0)
              Positioned(
                top: AppDimensions.xs,
                left: AppDimensions.xs,
                child: _buildBadge(product),
              ),
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
      bg = AppColors.badgeHotBg; fg = AppColors.badgeHotFg; label = 'HOT';
    } else if (product.isNew) {
      bg = AppColors.badgeNewBg; fg = AppColors.badgeNewFg; label = 'NEW';
    } else {
      bg = AppColors.badgeSaleBg; fg = AppColors.badgeSaleFg; label = '-${product.discount}%';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: fg, fontWeight: FontWeight.w700, fontSize: 10)),
    );
  }

  Widget _buildPrice(ProductModel product) {
    return Row(
      children: [
        Text('\$${product.price.toStringAsFixed(2)}',
            style: AppTextStyles.priceSmall.copyWith(fontWeight: FontWeight.w700)),
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
        Text(' (${product.reviewCount})',
            style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
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
          Text('Free Shipping',
              style: AppTextStyles.caption.copyWith(
                  color: AppColors.success, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// شاشة تفاصيل المنتج — مدمجة في نفس الملف
// لتجنب مشاكل GoRouter
// ─────────────────────────────────────────────
class _ProductDetailPage extends ConsumerStatefulWidget {
  final ProductModel product;
  const _ProductDetailPage({required this.product});

  @override
  ConsumerState<_ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<_ProductDetailPage> {
  int _qty = 1;

  void _addToCart() {
    Haptics.light();
    ref.read(cartProvider.notifier).addItem(widget.product, {}, _qty);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to cart',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
        backgroundColor: AppColors.backgroundSecondary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppDimensions.md),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
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
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: AppColors.backgroundPrimary,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: AppColors.backgroundSecondary, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Haptics.light();
                  ref.read(wishlistProvider.notifier).toggle(product.id);
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 38, height: 38,
                  decoration: const BoxDecoration(
                      color: AppColors.backgroundSecondary, shape: BoxShape.circle),
                  child: Icon(
                    isWishlisted ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: isWishlisted ? AppColors.error : AppColors.textTertiary,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                width: 38, height: 38,
                decoration: const BoxDecoration(
                    color: AppColors.backgroundSecondary, shape: BoxShape.circle),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 20, color: AppColors.textPrimary),
                    if (cartCount > 0)
                      Positioned(
                        top: 4, right: 4,
                        child: Container(
                          width: 14, height: 14,
                          decoration: const BoxDecoration(
                              color: AppColors.badgeCartBg, shape: BoxShape.circle),
                          child: Center(
                            child: Text('$cartCount',
                                style: const TextStyle(
                                    fontSize: 8, color: AppColors.badgeCartFg, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: product.images.isNotEmpty ? product.images.first : '',
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const ShimmerLoader(child: ColoredBox(color: AppColors.backgroundSkeleton)),
                errorWidget: (context, url, error) => const ColoredBox(
                  color: AppColors.backgroundTertiary,
                  child: Icon(Icons.image_not_supported, size: 48, color: AppColors.textQuaternary),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(product.brand.toUpperCase(),
                          style: AppTextStyles.labelUpper.copyWith(color: AppColors.textTertiary)),
                      const Spacer(),
                      if (product.isHot)
                        _SmallBadge(label: 'HOT', bg: AppColors.badgeHotBg, fg: AppColors.badgeHotFg),
                      if (product.isNew)
                        _SmallBadge(label: 'NEW', bg: AppColors.badgeNewBg, fg: AppColors.badgeNewFg),
                      if (product.discount > 0)
                        _SmallBadge(
                            label: '-${product.discount}%',
                            bg: AppColors.badgeSaleBg,
                            fg: AppColors.badgeSaleFg),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(product.name, style: AppTextStyles.headline2),
                  const SizedBox(height: AppDimensions.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('\$${product.price.toStringAsFixed(2)}',
                          style: AppTextStyles.priceLarge.copyWith(fontWeight: FontWeight.w800)),
                      if (product.originalPrice > 0) ...[
                        const SizedBox(width: AppDimensions.sm),
                        Text('\$${product.originalPrice.toStringAsFixed(2)}',
                            style: AppTextStyles.priceStrike),
                      ],
                      const Spacer(),
                      Icon(Icons.star, size: AppDimensions.ratingStarMd, color: AppColors.ratingFilled),
                      const SizedBox(width: 4),
                      Text('${product.rating}',
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                      Text(' (${product.reviewCount})',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.sectionGap),
                  if (product.description != null) ...[
                    Text('Description', style: AppTextStyles.headline3),
                    const SizedBox(height: AppDimensions.sm),
                    Text(product.description!,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textSecondary, height: 1.6)),
                    const SizedBox(height: AppDimensions.sectionGap),
                  ],
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.md),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_shipping_outlined,
                            color: product.shippingFree ? AppColors.success : AppColors.textTertiary,
                            size: 20),
                        const SizedBox(width: AppDimensions.sm),
                        Text(
                          product.shippingFree ? 'Free Shipping' : 'Standard Shipping \$5.99',
                          style: AppTextStyles.bodySmall.copyWith(
                              color: product.shippingFree ? AppColors.success : AppColors.textSecondary,
                              fontWeight: FontWeight.w500),
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
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sectionGap),
                  Text('Quantity', style: AppTextStyles.headline3),
                  const SizedBox(height: AppDimensions.sm),
                  Row(
                    children: [
                      _QtyBtn(
                          icon: Icons.remove,
                          onTap: () { if (_qty > 1) setState(() => _qty--); }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
                        child: Text('$_qty', style: AppTextStyles.headline3),
                      ),
                      _QtyBtn(
                          icon: Icons.add,
                          onTap: () { if (_qty < product.stock) setState(() => _qty++); }),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppDimensions.lg, AppDimensions.sm, AppDimensions.lg, AppDimensions.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.lg, vertical: AppDimensions.md),
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: const Border.fromBorderSide(
                      BorderSide(color: AppColors.borderSubtle)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                    Text('\$${(product.price * _qty).toStringAsFixed(2)}',
                        style: AppTextStyles.priceMedium.copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
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
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
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

class _SmallBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _SmallBadge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppDimensions.radiusXs)),
      child: Text(label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg, fontFamily: 'Inter')),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
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
