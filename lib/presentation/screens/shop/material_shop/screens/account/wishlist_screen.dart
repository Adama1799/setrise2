import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/wishlist_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/cart_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/products_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/empty_state.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistIds = ref.watch(wishlistProvider);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white, surfaceTintColor: Colors.white, elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary)),
        title: Text('Wishlist', style: AppTextStyles.headline3),
        actions: [
          if (wishlistIds.isNotEmpty)
            TextButton(
              onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(
                backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
                title: Text('Clear Wishlist', style: AppTextStyles.headline3),
                content: Text('Remove all saved items?', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary))),
                  TextButton(onPressed: () {
                    for (final id in wishlistIds.toList()) ref.read(wishlistProvider.notifier).toggle(id);
                    Navigator.pop(context);
                  }, child: Text('Clear', style: AppTextStyles.bodySmall.copyWith(color: AppColors.error, fontWeight: FontWeight.w700))),
                ],
              )),
              child: Text('Clear', style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
            ),
        ],
      ),
      body: wishlistIds.isEmpty
          ? const EmptyState(icon: Icons.favorite_border_rounded, title: 'Wishlist is empty', subtitle: 'Tap ♡ on any product to save it here')
          : productsAsync.when(
              data: (all) {
                final wished = all.where((p) => wishlistIds.contains(p.id)).toList();
                return Column(children: [
                  Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.md),
                    child: Row(children: [
                      Text('${wished.length} saved item${wished.length > 1 ? 's' : ''}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          for (final p in wished) ref.read(cartProvider.notifier).addItem(p, {}, 1);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('All items added to cart ✓', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                            backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(AppDimensions.lg),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.statusActiveBg, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)),
                          child: Row(children: [
                            const Icon(Icons.shopping_bag_outlined, size: 14, color: AppColors.ctaPrimaryBg),
                            const SizedBox(width: 4),
                            Text('Add All to Cart', style: AppTextStyles.caption.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w700)),
                          ]),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(child: ListView.separated(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    itemCount: wished.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.sm),
                    itemBuilder: (_, i) => _WishItem(product: wished[i]),
                  )),
                ]);
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.ctaPrimaryBg)),
              error: (_, __) => const Center(child: Text('Error loading items')),
            ),
    );
  }
}

class _WishItem extends ConsumerWidget {
  final ProductModel product;
  const _WishItem({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) { HapticFeedback.mediumImpact(); ref.read(wishlistProvider.notifier).toggle(product.id); },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppDimensions.lg),
        decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.favorite_border_rounded, color: Colors.white, size: 24),
          SizedBox(height: 4),
          Text('Remove', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
        ]),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 2))]),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            child: SizedBox(width: 80, height: 80, child: CachedNetworkImage(
              imageUrl: product.images.isNotEmpty ? product.images.first : '',
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => const ColoredBox(color: AppColors.backgroundPrimary, child: Icon(Icons.image_outlined, color: AppColors.textQuaternary)),
            )),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.brand.toUpperCase(), style: AppTextStyles.caption.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w700, fontSize: 10)),
            const SizedBox(height: 2),
            Text(product.name, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: AppDimensions.xs),
            Row(children: [
              Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              if (product.originalPrice > 0) ...[const SizedBox(width: AppDimensions.xs), Text('\$${product.originalPrice.toStringAsFixed(2)}', style: AppTextStyles.priceStrike)],
            ]),
            if (product.shippingFree) Text('Free Shipping', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)),
          ])),
          const SizedBox(width: AppDimensions.sm),
          Column(children: [
            GestureDetector(onTap: () { HapticFeedback.lightImpact(); ref.read(wishlistProvider.notifier).toggle(product.id); }, child: const Icon(Icons.favorite_rounded, color: AppColors.error, size: 22)),
            const SizedBox(height: AppDimensions.sm),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                ref.read(cartProvider.notifier).addItem(product, {}, 1);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Added to cart', style: AppTextStyles.caption.copyWith(color: Colors.white)),
                  backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(AppDimensions.lg),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
                  duration: const Duration(seconds: 1),
                ));
              },
              child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.ctaPrimaryBg, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)), child: const Icon(Icons.add_shopping_cart_rounded, size: 16, color: Colors.white)),
            ),
          ]),
        ]),
      ),
    );
  }
}
