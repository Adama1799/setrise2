import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/products_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/utils/responsive.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_card.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/shimmer_loader.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/section_header.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';

// ─── Recently Viewed Provider ────────────────────────────────
final recentlyViewedProvider =
    StateNotifierProvider<RecentlyViewedNotifier, List<String>>(
        (_) => RecentlyViewedNotifier());

class RecentlyViewedNotifier extends StateNotifier<List<String>> {
  RecentlyViewedNotifier() : super([]);

  void add(String productId) {
    state = [productId, ...state.where((id) => id != productId)].take(10).toList();
  }
}

// ─── Popular Products Grid ───────────────────────────────────
class PopularProducts extends ConsumerWidget {
  final int? filterCategory;
  const PopularProducts({Key? key, this.filterCategory}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(productsProvider);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(AppDimensions.lg, AppDimensions.md, AppDimensions.lg, AppDimensions.sm),
        child: SectionHeader(
          title: filterCategory == 1 ? '🔥 Hot Deals'
              : filterCategory == 6 ? '✨ New Arrivals'
              : 'Popular Products',
        ),
      ),
      async.when(
        data: (products) {
          final list = filterCategory == null || filterCategory == 0
              ? products
              : filterCategory == 1 ? products.where((p) => p.isHot).toList()
              : filterCategory == 6 ? products.where((p) => p.isNew).toList()
              : products;
          if (list.isEmpty) return Padding(
            padding: const EdgeInsets.all(AppDimensions.xl),
            child: Center(child: Text('No products in this category',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary))),
          );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
            child: GridView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.gridColumns, childAspectRatio: 0.60,
                crossAxisSpacing: AppDimensions.gridGap, mainAxisSpacing: AppDimensions.gridGap,
              ),
              itemCount: list.length,
              itemBuilder: (_, i) => ProductCard(product: list[i]),
            ),
          );
        },
        loading: () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
          child: GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.gridColumns, childAspectRatio: 0.60,
              crossAxisSpacing: AppDimensions.gridGap, mainAxisSpacing: AppDimensions.gridGap,
            ),
            itemCount: 6,
            itemBuilder: (_, __) => Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))]),
              child: const ShimmerLoader(child: SizedBox.expand()),
            ),
          ),
        ),
        error: (_, __) => Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Center(child: Column(children: [
            const Icon(Icons.error_outline, size: 36, color: AppColors.error),
            const SizedBox(height: AppDimensions.sm),
            Text('Failed to load', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
            TextButton(onPressed: () => ref.refresh(productsProvider.future), child: const Text('Retry')),
          ])),
        ),
      ),
    ]);
  }
}

// ─── New Arrivals Horizontal Scroll ─────────────────────────
class NewArrivalsSection extends ConsumerWidget {
  const NewArrivalsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(productsProvider);
    return async.when(
      data: (products) {
        final newItems = products.where((p) => p.isNew).toList();
        if (newItems.isEmpty) return const SizedBox.shrink();
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDimensions.lg, AppDimensions.md, AppDimensions.lg, AppDimensions.sm),
            child: SectionHeader(title: '✨ New Arrivals'),
          ),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
              itemCount: newItems.length,
              itemBuilder: (_, i) {
                final p = newItems[i];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: AppDimensions.sm),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLg)),
                      child: SizedBox(height: 140, child: Stack(children: [
                        CachedNetworkImage(imageUrl: p.images.isNotEmpty ? p.images.first : '', width: 160, height: 140, fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => const ColoredBox(color: AppColors.backgroundPrimary, child: Icon(Icons.image_outlined, color: AppColors.textQuaternary))),
                        Positioned(top: 8, left: 8, child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.badgeNewBg, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)),
                          child: Text('NEW', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 9)),
                        )),
                      ])),
                    ),
                    Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.name, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('\$${p.price.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w800, color: AppColors.ctaPrimaryBg)),
                    ])),
                  ]),
                );
              },
            ),
          ),
        ]);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

// ─── Recently Viewed ─────────────────────────────────────────
class RecentlyViewedSection extends ConsumerWidget {
  const RecentlyViewedSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentIds = ref.watch(recentlyViewedProvider);
    if (recentIds.isEmpty) return const SizedBox.shrink();
    final productsAsync = ref.watch(productsProvider);
    return productsAsync.when(
      data: (products) {
        final recent = recentIds
            .map((id) => products.where((p) => p.id == id).firstOrNull)
            .whereType<ProductModel>()
            .toList();
        if (recent.isEmpty) return const SizedBox.shrink();
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDimensions.lg, AppDimensions.md, AppDimensions.lg, AppDimensions.sm),
            child: SectionHeader(title: '🕐 Recently Viewed'),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
              itemCount: recent.length,
              itemBuilder: (_, i) {
                final p = recent[i];
                return Container(
                  width: 80, margin: const EdgeInsets.only(right: AppDimensions.sm),
                  child: Column(children: [
                    Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        child: CachedNetworkImage(imageUrl: p.images.isNotEmpty ? p.images.first : '', fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => const Icon(Icons.image_outlined, color: AppColors.textQuaternary)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('\$${p.price.toStringAsFixed(0)}',
                        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  ]),
                );
              },
            ),
          ),
        ]);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
