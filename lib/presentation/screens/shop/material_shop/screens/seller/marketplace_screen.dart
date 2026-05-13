import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/products_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/reviews_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_card.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/shimmer_loader.dart';
import 'package:setrise/presentation/screens/shop/material_shop/utils/responsive.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/chat/chat_screen.dart';

void _push(BuildContext ctx, Widget w) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => ProviderScope(parent: ProviderScope.containerOf(ctx), child: w)));

// ─── Seller Data ─────────────────────────────────────────────
class SellerModel {
  final String id, name, emoji, bio, badge;
  final double rating;
  final int sales, products, followers;
  final List<String> categories;

  const SellerModel({required this.id, required this.name, required this.emoji, required this.bio, required this.badge, required this.rating, required this.sales, required this.products, required this.followers, required this.categories});
}

const _kSellers = [
  SellerModel(id: 'store_1', name: 'TechZone Store',   emoji: '📱', bio: 'Premium electronics & gaming gear. Authorized reseller since 2019.',  badge: 'Top Seller',  rating: 4.9, sales: 2400, products: 48, followers: 1200, categories: ['Electronics', 'Gaming']),
  SellerModel(id: 'store_2', name: 'GamersHub',         emoji: '🎮', bio: 'Everything a gamer needs — peripherals, accessories, and more.',        badge: 'Verified',    rating: 4.7, sales: 1800, products: 32, followers: 890,  categories: ['Gaming', 'Tech']),
  SellerModel(id: 'store_3', name: 'StyleForward',      emoji: '👗', bio: 'Trendsetting fashion for every occasion. Ships worldwide in 3 days.',   badge: 'Top Seller',  rating: 4.8, sales: 3100, products: 95, followers: 2300, categories: ['Fashion', 'Beauty']),
  SellerModel(id: 'store_4', name: 'HomeEssentials',    emoji: '🏠', bio: 'Quality home goods at fair prices. Free shipping over \$50.',           badge: '',            rating: 4.6, sales: 920,  products: 61, followers: 540,  categories: ['Home', 'Kitchen']),
  SellerModel(id: 'store_5', name: 'BeautyCorner',      emoji: '💄', bio: 'Cruelty-free beauty products. Dermatologist-tested & approved.',        badge: 'Top Seller',  rating: 4.9, sales: 1200, products: 74, followers: 1800, categories: ['Beauty', 'Wellness']),
];

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  int _tab = 0;
  String _search = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  List<SellerModel> get _filtered {
    if (_search.isEmpty) return _kSellers;
    return _kSellers.where((s) => s.name.toLowerCase().contains(_search.toLowerCase()) || s.categories.any((c) => c.toLowerCase().contains(_search.toLowerCase()))).toList();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final reviews = ref.watch(reviewsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white, surfaceTintColor: Colors.white, elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary)),
        title: Text('Marketplace', style: AppTextStyles.headline3),
      ),
      body: CustomScrollView(slivers: [

        // Search
        SliverToBoxAdapter(child: Container(color: Colors.white, padding: const EdgeInsets.fromLTRB(AppDimensions.lg, 0, AppDimensions.lg, AppDimensions.md),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (v) => setState(() => _search = v),
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search sellers or categories...',
              hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textQuaternary),
              prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary, size: 20),
              suffixIcon: _search.isNotEmpty ? IconButton(icon: const Icon(Icons.close, size: 16, color: AppColors.textTertiary), onPressed: () { _searchCtrl.clear(); setState(() => _search = ''); }) : null,
              filled: true, fillColor: AppColors.backgroundPrimary,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd), borderSide: const BorderSide(color: AppColors.ctaPrimaryBg, width: 1.5)),
            ),
          ),
        )),

        // Featured Sellers
        if (_search.isEmpty) SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: const EdgeInsets.fromLTRB(AppDimensions.lg, AppDimensions.sm, AppDimensions.lg, AppDimensions.sm), child: Text('Featured Sellers', style: AppTextStyles.headline3)),
          SizedBox(height: 150, child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
            itemCount: _kSellers.length,
            itemBuilder: (_, i) {
              final s = _kSellers[i];
              final sellerReviews = reviews.where((r) => r.productId.startsWith('prod_${i}')).toList();
              final avgRating = sellerReviews.isEmpty ? s.rating : sellerReviews.map((r) => r.rating).reduce((a, b) => a + b) / sellerReviews.length;
              return GestureDetector(
                onTap: () => _push(context, _SellerProfilePage(seller: s)),
                child: Container(width: 120, margin: const EdgeInsets.only(right: AppDimensions.sm),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusLg), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))]),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(s.emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 6),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text(s.name, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis)),
                    const SizedBox(height: 4),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.star_rounded, size: 12, color: AppColors.ratingFilled),
                      const SizedBox(width: 2),
                      Text(avgRating.toStringAsFixed(1), style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ]),
                    if (s.badge.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4), child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.statusActiveBg, borderRadius: BorderRadius.circular(AppDimensions.radiusFull)), child: Text(s.badge, style: AppTextStyles.caption.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w700, fontSize: 9)))),
                  ]),
                ),
              );
            },
          )),
          const SizedBox(height: AppDimensions.md),
        ])),

        // Tabs
        SliverToBoxAdapter(child: Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.sm),
          child: Row(children: [
            _Tab('All Products', _tab == 0, () => setState(() => _tab = 0)),
            const SizedBox(width: AppDimensions.xs),
            _Tab('🔥 Hot',    _tab == 1, () => setState(() => _tab = 1)),
            const SizedBox(width: AppDimensions.xs),
            _Tab('✨ New',    _tab == 2, () => setState(() => _tab = 2)),
            const SizedBox(width: AppDimensions.xs),
            _Tab('💰 Sale',   _tab == 3, () => setState(() => _tab = 3)),
          ]),
        )),
        const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.sm)),

        // Products Grid
        productsAsync.when(
          data: (products) {
            final list = _tab == 1 ? products.where((p) => p.isHot).toList()
                : _tab == 2 ? products.where((p) => p.isNew).toList()
                : _tab == 3 ? products.where((p) => p.discount > 0).toList()
                : products;
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: context.gridColumns, childAspectRatio: 0.60, crossAxisSpacing: AppDimensions.gridGap, mainAxisSpacing: AppDimensions.gridGap),
                delegate: SliverChildBuilderDelegate((_, i) => ProductCard(product: list[i]), childCount: list.length),
              ),
            );
          },
          loading: () => SliverPadding(padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg), sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: context.gridColumns, childAspectRatio: 0.60, crossAxisSpacing: AppDimensions.gridGap, mainAxisSpacing: AppDimensions.gridGap),
            delegate: SliverChildBuilderDelegate((_, __) => const ShimmerLoader(child: Card(child: SizedBox.expand())), childCount: 6),
          )),
          error: (_, __) => const SliverFillRemaining(child: Center(child: Text('Failed to load'))),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: AppDimensions.xxl)),
      ]),
    );
  }
}

// ─── Seller Profile Page ─────────────────────────────────────
class _SellerProfilePage extends ConsumerWidget {
  final SellerModel seller;
  const _SellerProfilePage({required this.seller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final reviews = ref.watch(reviewsProvider);
    final idx = _kSellers.indexOf(seller);
    final sellerReviews = reviews.where((r) => r.productId.startsWith('prod_$idx')).toList();
    final avgRating = sellerReviews.isEmpty ? seller.rating : sellerReviews.map((r) => r.rating).reduce((a, b) => a + b) / sellerReviews.length;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: CustomScrollView(slivers: [
        // Header
        SliverAppBar(
          expandedHeight: 200, pinned: true,
          backgroundColor: Colors.white, surfaceTintColor: Colors.white,
          leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]), child: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.textPrimary))),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF007AFF), Color(0xFF0040CC)])),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(height: 40),
                Text(seller.emoji, style: const TextStyle(fontSize: 56)),
                const SizedBox(height: AppDimensions.sm),
                Text(seller.name, style: AppTextStyles.headline2.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                if (seller.badge.isNotEmpty) Container(margin: const EdgeInsets.only(top: 4), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(AppDimensions.radiusFull)), child: Text(seller.badge, style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700))),
              ]),
            ),
          ),
        ),

        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(AppDimensions.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Stats
          Container(padding: const EdgeInsets.all(AppDimensions.md), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMd), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)]),
            child: Row(children: [
              _SellerStat('${avgRating.toStringAsFixed(1)} ⭐', 'Rating', AppColors.ratingFilled),
              _SellerDiv(),
              _SellerStat('${seller.sales}+', 'Sales', AppColors.success),
              _SellerDiv(),
              _SellerStat('${seller.products}', 'Products', AppColors.ctaPrimaryBg),
              _SellerDiv(),
              _SellerStat('${seller.followers}', 'Followers', const Color(0xFF9C27B0)),
            ]),
          ),
          const SizedBox(height: AppDimensions.md),

          // Bio
          Container(padding: const EdgeInsets.all(AppDimensions.md), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMd), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('About', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppDimensions.xs),
              Text(seller.bio, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5)),
              const SizedBox(height: AppDimensions.sm),
              Wrap(spacing: AppDimensions.xs, children: seller.categories.map((c) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.statusActiveBg, borderRadius: BorderRadius.circular(AppDimensions.radiusFull)), child: Text(c, style: AppTextStyles.caption.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w600)))).toList()),
            ]),
          ),
          const SizedBox(height: AppDimensions.md),

          // Actions
          Row(children: [
            Expanded(child: SizedBox(height: 48, child: ElevatedButton.icon(
              onPressed: () => _push(context, ChatScreen(storeId: seller.id, storeName: seller.name, storeEmoji: seller.emoji)),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.ctaPrimaryBg, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd))),
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
              label: Text('Message', style: AppTextStyles.buttonLabel),
            ))),
            const SizedBox(width: AppDimensions.sm),
            SizedBox(height: 48, child: OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.ctaPrimaryBg, side: const BorderSide(color: AppColors.ctaPrimaryBg), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)), padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md)),
              icon: const Icon(Icons.person_add_outlined, size: 18),
              label: Text('Follow', style: AppTextStyles.buttonLabel.copyWith(color: AppColors.ctaPrimaryBg)),
            )),
          ]),
          const SizedBox(height: AppDimensions.lg),

          // Products
          Row(children: [
            Text('Products', style: AppTextStyles.headline3),
            const Spacer(),
            Text('${seller.products} listed', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
          ]),
          const SizedBox(height: AppDimensions.sm),
        ]))),

        productsAsync.when(
          data: (products) {
            final slice = products.take(6).toList();
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: context.gridColumns, childAspectRatio: 0.60, crossAxisSpacing: AppDimensions.gridGap, mainAxisSpacing: AppDimensions.gridGap),
                delegate: SliverChildBuilderDelegate((_, i) => ProductCard(product: slice[i]), childCount: slice.length),
              ),
            );
          },
          loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: AppColors.ctaPrimaryBg))),
          error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
        ),

        const SliverPadding(padding: EdgeInsets.only(bottom: AppDimensions.xxl)),
      ]),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label; final bool sel; final VoidCallback onTap;
  const _Tab(this.label, this.sel, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 150), padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: 7), decoration: BoxDecoration(color: sel ? AppColors.ctaPrimaryBg : AppColors.backgroundPrimary, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)), child: Text(label, style: AppTextStyles.caption.copyWith(color: sel ? Colors.white : AppColors.textTertiary, fontWeight: sel ? FontWeight.w700 : FontWeight.w400))));
}

class _SellerStat extends StatelessWidget {
  final String value, label; final Color color;
  const _SellerStat(this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [Text(value, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800, color: color), textAlign: TextAlign.center), Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textQuaternary, fontSize: 10), textAlign: TextAlign.center)]));
}

class _SellerDiv extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 28, color: AppColors.borderSubtle);
}
