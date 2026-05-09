import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/products_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/cart_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_card.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/shimmer_loader.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/empty_state.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/section_header.dart';
import 'package:setrise/presentation/screens/shop/material_shop/utils/responsive.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/cart/cart_screen.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/account/auction_screen.dart';
import 'search_screen.dart';

// ─── Helper للتنقل مع الحفاظ على Riverpod ───
void _push(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: screen,
      ),
    ),
  );
}

// ─── Categories Data ───
const _categories = [
  {'icon': '🔥', 'label': 'Hot Deals'},
  {'icon': '📱', 'label': 'Electronics'},
  {'icon': '👗', 'label': 'Fashion'},
  {'icon': '🏠', 'label': 'Home'},
  {'icon': '🎮', 'label': 'Gaming'},
  {'icon': '💄', 'label': 'Beauty'},
  {'icon': '📚', 'label': 'Books'},
  {'icon': '🏋️', 'label': 'Sports'},
];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedCategory = 0;
  int _bannerPage = 0;
  final PageController _bannerCtrl = PageController();

  @override
  void dispose() {
    _bannerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final cartCount = ref.watch(cartProvider).itemCount;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(productsProvider.future),
          color: AppColors.ctaPrimaryBg,
          backgroundColor: AppColors.backgroundSecondary,
          child: CustomScrollView(
            slivers: [
              // ─── AppBar ───
              SliverAppBar(
                floating: true,
                backgroundColor: AppColors.backgroundPrimary,
                titleSpacing: AppDimensions.lg,
                title: Row(
                  children: [
                    Text('SetRize', style: AppTextStyles.headline3.copyWith(color: AppColors.ctaPrimaryBg)),
                    const SizedBox(width: 4),
                    Text('Shop', style: AppTextStyles.headline3),
                  ],
                ),
                actions: [
                  // Search Icon
                  IconButton(
                    onPressed: () => _push(context, const SearchScreen()),
                    icon: const Icon(Icons.search, color: AppColors.textPrimary),
                  ),
                  // Cart Icon with badge
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        onPressed: () => _push(context, const CartScreen()),
                        icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary),
                      ),
                      if (cartCount > 0)
                        Positioned(
                          top: 8, right: 8,
                          child: Container(
                            width: 16, height: 16,
                            decoration: const BoxDecoration(
                              color: AppColors.badgeCartBg,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$cartCount',
                                style: const TextStyle(
                                  fontSize: 9, color: AppColors.badgeCartFg,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 4),
                ],
              ),

              // ─── Search Bar ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppDimensions.lg, AppDimensions.sm, AppDimensions.lg, AppDimensions.sm),
                  child: GestureDetector(
                    onTap: () => _push(context, const SearchScreen()),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundTertiary,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
                      child: Row(
                        children: [
                          const Icon(Icons.search, size: 20, color: AppColors.textTertiary),
                          const SizedBox(width: AppDimensions.xs),
                          Text('Search products...',
                              style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textQuaternary)),
                          const Spacer(),
                          const Icon(Icons.mic_none, size: 20, color: AppColors.textTertiary),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ─── Categories ───
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 88,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
                    itemCount: _categories.length,
                    itemBuilder: (context, i) {
                      final cat = _categories[i];
                      final isSelected = _selectedCategory == i;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: AppDimensions.sm),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 52, height: 52,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.ctaPrimaryBg
                                      : AppColors.backgroundSecondary,
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                                  border: isSelected
                                      ? null
                                      : const Border.fromBorderSide(
                                          BorderSide(color: AppColors.borderSubtle)),
                                ),
                                child: Center(
                                  child: Text(cat['icon']!,
                                      style: const TextStyle(fontSize: 24)),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cat['label']!,
                                style: AppTextStyles.caption.copyWith(
                                  color: isSelected
                                      ? AppColors.ctaPrimaryBg
                                      : AppColors.textTertiary,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // ─── Banner Carousel ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.lg, vertical: AppDimensions.sm),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 160,
                        child: PageView(
                          controller: _bannerCtrl,
                          onPageChanged: (i) => setState(() => _bannerPage = i),
                          children: [
                            _BannerCard(
                              title: 'Summer Collection',
                              subtitle: 'Up to 50% off selected items',
                              gradient: const [Color(0xFF007AFF), Color(0xFF0040CC)],
                              emoji: '☀️',
                              onTap: () {},
                            ),
                            _BannerCard(
                              title: 'Live Auctions',
                              subtitle: 'Bid on exclusive items now',
                              gradient: const [Color(0xFFFF2200), Color(0xFFCC1100)],
                              emoji: '🔨',
                              onTap: () => _push(context, const AuctionScreen()),
                            ),
                            _BannerCard(
                              title: 'Free Shipping',
                              subtitle: 'On orders over \$100',
                              gradient: const [Color(0xFF39FF14), Color(0xFF22AA00)],
                              emoji: '🚚',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      // Dots indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _bannerPage == i ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _bannerPage == i
                                ? AppColors.ctaPrimaryBg
                                : AppColors.backgroundTertiary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
              ),

              // ─── Live Auction Teaser ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.lg, vertical: AppDimensions.sm),
                  child: GestureDetector(
                    onTap: () => _push(context, const AuctionScreen()),
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.md),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        border: const Border.fromBorderSide(
                            BorderSide(color: AppColors.badgeHotBg, width: 1)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.badgeHotBg.withOpacity(0.15),
                              borderRadius:
                                  BorderRadius.circular(AppDimensions.radiusSm),
                            ),
                            child: const Center(
                              child: Text('🔨', style: TextStyle(fontSize: 20)),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Live Auctions', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                                Text('5 auctions ending soon',
                                    style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textTertiary)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.badgeHotBg,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                            ),
                            child: Text('LIVE',
                                style: AppTextStyles.caption.copyWith(
                                    color: AppColors.badgeHotFg,
                                    fontWeight: FontWeight.w800)),
                          ),
                          const SizedBox(width: AppDimensions.xs),
                          const Icon(Icons.chevron_right,
                              color: AppColors.textTertiary, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ─── Featured Products Header ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppDimensions.lg, AppDimensions.md, AppDimensions.lg, 0),
                  child: SectionHeader(title: 'Featured Products'),
                ),
              ),

              // ─── Products Grid ───
              productsAsync.when(
                data: (allProducts) {
                  // Filter by category if not first
                  final products = _selectedCategory == 0
                      ? allProducts
                      : allProducts.where((p) {
                          if (_selectedCategory == 1) return p.isHot;
                          if (_selectedCategory == 6) return p.isNew;
                          return true;
                        }).toList();

                  if (products.isEmpty) {
                    return const SliverFillRemaining(
                      child: EmptyState(
                        icon: Icons.shopping_bag_outlined,
                        title: 'No products in this category',
                        subtitle: 'Try another category',
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.lg, vertical: AppDimensions.sm),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context.gridColumns,
                        childAspectRatio: 0.62,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.lg, vertical: AppDimensions.sm),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: context.gridColumns,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: AppDimensions.gridGap,
                      mainAxisSpacing: AppDimensions.gridGap,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          const ShimmerLoader(child: Card(child: SizedBox.expand())),
                      childCount: 6,
                    ),
                  ),
                ),
                error: (error, _) => SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: AppColors.error),
                        const SizedBox(height: AppDimensions.md),
                        Text('Failed to load products',
                            style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textTertiary)),
                        const SizedBox(height: AppDimensions.md),
                        ElevatedButton(
                          onPressed: () => ref.refresh(productsProvider.future),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
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

// ─── Banner Card Widget ───
class _BannerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final String emoji;
  final VoidCallback onTap;

  const _BannerCard({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.emoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        child: Stack(
          children: [
            // Emoji decorativo
            Positioned(
              right: -10, bottom: -10,
              child: Text(emoji,
                  style: const TextStyle(fontSize: 100, opacity: 0.15)),
            ),
            Positioned(
              right: AppDimensions.lg, top: AppDimensions.lg,
              child: Text(emoji, style: const TextStyle(fontSize: 48)),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: AppTextStyles.headline2.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w800)),
                  const SizedBox(height: AppDimensions.xs),
                  Text(subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.85))),
                  const SizedBox(height: AppDimensions.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.md, vertical: AppDimensions.xs),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Text('Shop Now',
                        style: AppTextStyles.caption.copyWith(
                            color: gradient[0], fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
