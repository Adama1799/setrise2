import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart' as setrise;
import '../../../../core/theme/app_text_styles.dart' as text;
import '../../providers/products_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/shimmer_loader.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/search_bar_widget.dart';
import 'package:go_router/go_router.dart';
import '../../utils/responsive.dart';
import '../../theme/app_dimensions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: setrise.AppColors.background,
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
                    children: [
                      const SearchBarWidget(),
                      const SizedBox(height: AppDimensions.lg),
                      _buildBanner(context),
                      const SizedBox(height: AppDimensions.sectionGap),
                      SectionHeader(title: 'Featured Products', onSeeAll: () {}),
                    ],
                  ),
                ),
              ),
              productsAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return const SliverFillRemaining(
                      child: EmptyState(icon: Icons.shopping_bag_outlined, title: 'No products yet', subtitle: 'Check back soon for new arrivals'),
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
                        (context, index) => ProductCard(product: products[index], index: index),
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
                  child: ErrorState(message: 'Failed to load products', onRetry: () => ref.read(productsProvider.future)),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: AppDimensions.xxl)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
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
                Text('Summer Collection', style: text.AppTextStyles.headline2.copyWith(color: setrise.AppColors.white)),
                const SizedBox(height: AppDimensions.xs),
                Text('Up to 50% off on selected items', style: text.AppTextStyles.bodyMedium.copyWith(color: setrise.AppColors.white.withOpacity(0.8))),
                const SizedBox(height: AppDimensions.md),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.xs),
                  decoration: BoxDecoration(color: setrise.AppColors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)),
                  child: Text('Shop Now', style: text.AppTextStyles.buttonLabel.copyWith(color: setrise.AppColors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
