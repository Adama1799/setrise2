// lib/presentation/screens/shop/shop_home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/shop_provider.dart';
import '../../widgets/shop/product_card.dart';
import '../../widgets/shop/category_slider.dart';
import '../../widgets/common/search_input.dart';
import 'widgets/shop_banner.dart';

class ShopHomeScreen extends ConsumerStatefulWidget {
  const ShopHomeScreen({super.key});

  @override
  ConsumerState<ShopHomeScreen> createState() => _ShopHomeScreenState();
}

class _ShopHomeScreenState extends ConsumerState<ShopHomeScreen> {
  final _searchController = TextEditingController();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shopProvider.notifier).loadCategories();
      ref.read(shopProvider.notifier).loadProducts(0);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more products
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(shopProvider);

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          expandedHeight: 120,
          pinned: true,
          backgroundColor: AppColors.background,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SearchInput(
                          controller: _searchController,
                          onChanged: (_) {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.notifications_none),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: CategorySlider(
            categories: shopState.categories,
            onCategorySelected: (category) {
              ref.read(shopProvider.notifier).loadProducts(0, category: category);
            },
          ),
        ),
        const SliverToBoxAdapter(child: ShopBanner()),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == shopState.products.length) {
                  return shopState.hasMoreProducts
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                }
                final product = shopState.products[index];
                return ProductCard(
                  product: product,
                  onTap: () => Navigator.pushNamed(context, '/shop/product/${product.id}'),
                  onFavoriteToggle: () =>
                      ref.read(shopProvider.notifier).toggleFavorite(product.id),
                );
              },
              childCount: shopState.products.length + 1,
            ),
          ),
        ),
      ],
    );
  }
}
