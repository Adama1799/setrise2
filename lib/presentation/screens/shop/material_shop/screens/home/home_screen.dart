import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/products_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_card.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/shimmer_loader.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/empty_state.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/error_state.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/search_bar_widget.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/section_header.dart';
import 'package:setrise/presentation/screens/shop/material_shop/utils/responsive.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(productsProvider.future),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(context.horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SearchBarWidget(),
                      SizedBox(height: AppDimensions.lg),
                      _BannerSection(),
                      SizedBox(height: AppDimensions.sectionGap),
                      SectionHeader(title: 'Featured Products'),
                    ],
                  ),
                ),
              ),
              productsAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return const SliverFillRemaining(
                      child: EmptyState(
                        icon: Icons.shopping_bag_outlined,
                        title: 'No products yet',
                        subtitle: 'Check back soon for new arrivals',
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context.gridColumns,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: AppDimensions.gridGap,
                        mainAxisSpacing: AppDimensions.gridGap,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ProductCard(product: products[index]),
                        childCount: products.length,
                      ),
                    ),
                  );
                },
                loading: () => SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: context.gridColumns,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: AppDimensions.gridGap,
                      mainAxisSpacing: AppDimensions.gridGap,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const ShimmerLoader(child: Card(child: SizedBox.expand())),
                      childCount: 6,
                    ),
                  ),
                ),
                error: (error, _) => SliverFillRemaining(
                  child: ErrorState(
                    message: 'Failed to load products',
                    onRetry: () => ref.read(productsProvider.future),
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: AppDimensions.xxl)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BannerSection extends StatelessWidget {
  const _BannerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        color: const Color(0xFF1a1a2e),
      ),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Summer Collection', style: AppTextStyles.headline2.copyWith(color: AppColors.textOnDark)),
                const SizedBox(height: AppDimensions.xs),
                Text('Up to 50% off on selected items', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textOnDark.withOpacity(0.8))),
                const SizedBox(height: AppDimensions.md),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.xs),
                  decoration: BoxDecoration(color: AppColors.textOnDark, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)),
                  child: Text('Shop Now', style: AppTextStyles.buttonLabel.copyWith(color: AppColors.textPrimary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
