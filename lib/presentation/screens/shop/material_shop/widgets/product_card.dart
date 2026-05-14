import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/review_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/wishlist_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/cart_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/reviews_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/shimmer_loader.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/review/write_review_screen.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/chat/chat_screen.dart';

void _push(BuildContext ctx, Widget w) => Navigator.push(ctx,
    MaterialPageRoute(builder: (_) => ProviderScope(parent: ProviderScope.containerOf(ctx), child: w)));

// ═══════════════════════════════════════════════════════════════
// PRODUCT CARD — grid item
// ═══════════════════════════════════════════════════════════════
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Added to cart', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
      backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(AppDimensions.lg),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final isWishlisted = ref.watch(wishlistProvider).contains(p.id);
    final reviews = ref.watch(reviewsProvider).where((r) => r.productId == p.id).toList();
    final avg = reviews.isEmpty ? p.rating : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); HapticFeedback.lightImpact(); _push(context, _ProductDetailPage(product: p)); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 16, offset: const Offset(0, 4))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Image
            Stack(children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLg)),
                child: AspectRatio(aspectRatio: 1, child: CachedNetworkImage(
                  imageUrl: p.images.isNotEmpty ? p.images.first : '',
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const ShimmerLoader(child: ColoredBox(color: AppColors.backgroundSkeleton)),
                  errorWidget: (_, __, ___) => const ColoredBox(color: AppColors.backgroundTertiary, child: Icon(Icons.image_outlined, color: AppColors.textQuaternary, size: 36)),
                )),
              ),
              if (p.isHot || p.isNew || p.discount > 0)
                Positioned(top: 8, left: 8, child: _Badge(p: p)),
              Positioned(top: 8, right: 8, child: GestureDetector(
                onTap: () { HapticFeedback.lightImpact(); ref.read(wishlistProvider.notifier).toggle(p.id); },
                child: Container(width: 34, height: 34,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]),
                  child: Icon(isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 18, color: isWishlisted ? AppColors.error : AppColors.textTertiary)),
              )),
            ]),
            // Info
            Padding(padding: const EdgeInsets.fromLTRB(12, 10, 12, 4), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.brand.toUpperCase(), style: AppTextStyles.labelUpper.copyWith(color: AppColors.ctaPrimaryBg, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(p.name, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Row(children: [
                Text('\$${p.price.toStringAsFixed(2)}', style: AppTextStyles.priceSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w800)),
                if (p.originalPrice > 0) ...[const SizedBox(width: 6), Text('\$${p.originalPrice.toStringAsFixed(2)}', style: AppTextStyles.priceStrike)],
              ]),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.star_rounded, size: 13, color: AppColors.ratingFilled),
                const SizedBox(width: 2),
                Text(avg.toStringAsFixed(1), style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text(' (${reviews.isEmpty ? p.reviewCount : reviews.length})', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                if (p.shippingFree) ...[const Spacer(), const Icon(Icons.local_shipping_rounded, size: 12, color: AppColors.success)],
              ]),
            ])),
            // Add to Cart button
            Padding(padding: const EdgeInsets.fromLTRB(12, 4, 12, 12), child: SizedBox(width: double.infinity, height: 36, child: ElevatedButton(
              onPressed: _addToCart,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.ctaPrimaryBg, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSm))),
              child: Text('Add to Cart', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
            ))),
          ]),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final ProductModel p;
  const _Badge({required this.p});
  @override
  Widget build(BuildContext context) {
    Color bg; String label;
    if (p.isHot)       { bg = AppColors.badgeHotBg;  label = '🔥 HOT'; }
    else if (p.isNew)  { bg = AppColors.badgeNewBg;  label = '✨ NEW'; }
    else               { bg = AppColors.badgeSaleBg; label = '-${p.discount}%'; }
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)), child: Text(label, style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 10)));
  }
}

// ═══════════════════════════════════════════════════════════════
// PRODUCT DETAIL PAGE — full screen Apple style
// ═══════════════════════════════════════════════════════════════
class _ProductDetailPage extends ConsumerStatefulWidget {
  final ProductModel product;
  const _ProductDetailPage({required this.product});
  @override
  ConsumerState<_ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<_ProductDetailPage> with SingleTickerProviderStateMixin {
  int _qty = 1, _imgPage = 0;
  String? _selectedSize = 'M';
  Color? _selectedColor;
  late TabController _tabCtrl;
  final _imgCtrl = PageController();

  static const _sizes  = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  static const _colors = [Color(0xFF000000), Color(0xFFFFFFFF), Color(0xFF007AFF), Color(0xFFFF3B30), Color(0xFF34C759), Color(0xFFFF9500)];
  static const _sellers = [
    {'id': 'store_1', 'name': 'TechZone Store',  'emoji': '📱', 'rating': '4.9'},
    {'id': 'store_2', 'name': 'GamersHub',        'emoji': '🎮', 'rating': '4.7'},
    {'id': 'store_3', 'name': 'StyleForward',     'emoji': '👗', 'rating': '4.8'},
  ];
  late final Map<String, String> _seller;

  List<String> get _images {
    final base = widget.product.id.hashCode.abs() % 100;
    return List.generate(4, (i) => 'https://picsum.photos/600/600?random=${base + i}');
  }

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _seller = _sellers[widget.product.id.hashCode.abs() % _sellers.length];
    _selectedColor = _colors[0];
  }

  @override
  void dispose() { _tabCtrl.dispose(); _imgCtrl.dispose(); super.dispose(); }

  void _addToCart() {
    HapticFeedback.mediumImpact();
    ref.read(cartProvider.notifier).addItem(widget.product, {'size': _selectedSize ?? '', 'color': _selectedColor?.value.toString() ?? ''}, _qty);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Added to cart ✓', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
      backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(AppDimensions.lg),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final isWishlisted = ref.watch(wishlistProvider).contains(p.id);
    final cartCount = ref.watch(cartProvider).itemCount;
    final reviews = ref.watch(reviewsProvider).where((r) => r.productId == p.id).toList();
    final avg = reviews.isEmpty ? p.rating : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
    final images = _images;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 380, pinned: true,
            backgroundColor: Colors.white, surfaceTintColor: Colors.white, elevation: 0,
            leading: GestureDetector(onTap: () => Navigator.pop(context),
              child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]),
                child: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.textPrimary))),
            actions: [
              GestureDetector(onTap: () { HapticFeedback.lightImpact(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Share link copied!', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)), backgroundColor: AppColors.textSecondary, behavior: SnackBarBehavior.floating, margin: const EdgeInsets.all(AppDimensions.lg), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)), duration: const Duration(seconds: 1))); },
                child: Container(margin: const EdgeInsets.only(right: 4, top: 8, bottom: 8), width: 38, height: 38, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]), child: const Icon(Icons.ios_share, size: 18, color: AppColors.textPrimary))),
              GestureDetector(onTap: () { HapticFeedback.lightImpact(); ref.read(wishlistProvider.notifier).toggle(p.id); },
                child: Container(margin: const EdgeInsets.only(right: 4, top: 8, bottom: 8), width: 38, height: 38, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]), child: Icon(isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 18, color: isWishlisted ? AppColors.error : AppColors.textTertiary))),
              Stack(alignment: Alignment.center, children: [
                Container(margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8), width: 38, height: 38, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]), child: const Icon(Icons.shopping_bag_outlined, size: 18, color: AppColors.textPrimary)),
                if (cartCount > 0) Positioned(top: 6, right: 10, child: Container(width: 14, height: 14, decoration: const BoxDecoration(color: AppColors.badgeCartBg, shape: BoxShape.circle), child: Center(child: Text('$cartCount', style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.w800))))),
              ]),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(children: [
                PageView.builder(controller: _imgCtrl, onPageChanged: (i) => setState(() => _imgPage = i), itemCount: images.length,
                  itemBuilder: (_, i) => CachedNetworkImage(imageUrl: images[i], fit: BoxFit.cover,
                    placeholder: (_, __) => const ShimmerLoader(child: ColoredBox(color: AppColors.backgroundSkeleton)),
                    errorWidget: (_, __, ___) => const ColoredBox(color: AppColors.backgroundTertiary, child: Icon(Icons.image_outlined, size: 64, color: AppColors.textQuaternary)))),
                // Dots
                Positioned(bottom: 16, left: 0, right: 0, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(images.length, (i) => AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.symmetric(horizontal: 3), width: _imgPage == i ? 20 : 6, height: 6, decoration: BoxDecoration(color: _imgPage == i ? AppColors.ctaPrimaryBg : Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(3), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)]))))),
                // Counter
                Positioned(bottom: 36, right: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(AppDimensions.radiusSm)), child: Text('${_imgPage + 1}/${images.length}', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700)))),
              ]),
            ),
          ),
        ],
        body: SingleChildScrollView(child: Column(children: [
          // Product Info
          Container(color: Colors.white, padding: const EdgeInsets.all(AppDimensions.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.statusActiveBg, borderRadius: BorderRadius.circular(AppDimensions.radiusXs)), child: Text(p.brand.toUpperCase(), style: AppTextStyles.caption.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w700))),
              const Spacer(),
              if (p.isHot)       _SmBadge('🔥 HOT', AppColors.badgeHotBg),
              if (p.isNew)       Padding(padding: const EdgeInsets.only(left: 4), child: _SmBadge('✨ NEW', AppColors.badgeNewBg)),
              if (p.discount > 0) Padding(padding: const EdgeInsets.only(left: 4), child: _SmBadge('-${p.discount}%', AppColors.badgeSaleBg)),
            ]),
            const SizedBox(height: AppDimensions.sm),
            Text(p.name, style: AppTextStyles.headline3.copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: AppDimensions.sm),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('\$${p.price.toStringAsFixed(2)}', style: AppTextStyles.priceLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w800)),
              if (p.originalPrice > 0) ...[const SizedBox(width: AppDimensions.sm), Padding(padding: const EdgeInsets.only(bottom: 2), child: Text('\$${p.originalPrice.toStringAsFixed(2)}', style: AppTextStyles.priceStrike))],
              const Spacer(),
              GestureDetector(onTap: () => _tabCtrl.animateTo(1),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppColors.backgroundPrimary, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)),
                  child: Row(children: [const Icon(Icons.star_rounded, size: 14, color: AppColors.ratingFilled), const SizedBox(width: 3), Text(avg.toStringAsFixed(1), style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)), Text(' (${reviews.isEmpty ? p.reviewCount : reviews.length})', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary))]))),
            ]),
            if (p.shippingFree) Padding(padding: const EdgeInsets.only(top: AppDimensions.sm), child: Row(children: [const Icon(Icons.local_shipping_rounded, size: 14, color: AppColors.success), const SizedBox(width: 4), Text('Free Shipping', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600))])),
          ])),
          const SizedBox(height: AppDimensions.sm),

          // Color Selector
          Container(color: Colors.white, padding: const EdgeInsets.all(AppDimensions.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Text('Color', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)), const SizedBox(width: AppDimensions.sm), if (_selectedColor != null) Container(width: 16, height: 16, decoration: BoxDecoration(color: _selectedColor, shape: BoxShape.circle, border: Border.all(color: AppColors.borderSubtle)))]),
            const SizedBox(height: AppDimensions.sm),
            Row(children: _colors.map((c) => GestureDetector(
              onTap: () { HapticFeedback.selectionClick(); setState(() => _selectedColor = c); },
              child: AnimatedContainer(duration: const Duration(milliseconds: 150), margin: const EdgeInsets.only(right: AppDimensions.sm), width: 34, height: 34,
                decoration: BoxDecoration(color: c, shape: BoxShape.circle,
                  border: _selectedColor == c ? Border.all(color: AppColors.ctaPrimaryBg, width: 2.5) : Border.all(color: AppColors.borderSubtle),
                  boxShadow: _selectedColor == c ? [BoxShadow(color: AppColors.ctaPrimaryBg.withOpacity(0.3), blurRadius: 8, spreadRadius: 1)] : null),
                child: _selectedColor == c ? const Icon(Icons.check, size: 16, color: Colors.grey) : null),
            )).toList()),
          ])),
          const SizedBox(height: AppDimensions.sm),

          // Size Selector
          Container(color: Colors.white, padding: const EdgeInsets.all(AppDimensions.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Text('Size', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)), const Spacer(), Text('Size Guide', style: AppTextStyles.caption.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w600)), const Icon(Icons.chevron_right, size: 14, color: AppColors.ctaPrimaryBg)]),
            const SizedBox(height: AppDimensions.sm),
            Wrap(spacing: AppDimensions.sm, children: _sizes.map((s) {
              final sel = _selectedSize == s;
              return GestureDetector(onTap: () { HapticFeedback.selectionClick(); setState(() => _selectedSize = s); },
                child: AnimatedContainer(duration: const Duration(milliseconds: 150), width: 48, height: 48,
                  decoration: BoxDecoration(color: sel ? AppColors.ctaPrimaryBg : Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusSm), border: Border.all(color: sel ? AppColors.ctaPrimaryBg : AppColors.borderSubtle, width: sel ? 2 : 1)),
                  child: Center(child: Text(s, style: AppTextStyles.caption.copyWith(color: sel ? Colors.white : AppColors.textPrimary, fontWeight: sel ? FontWeight.w800 : FontWeight.w500)))));
            }).toList()),
          ])),
          const SizedBox(height: AppDimensions.sm),

          // Seller Card
          Container(color: Colors.white, padding: const EdgeInsets.all(AppDimensions.lg),
            child: GestureDetector(onTap: () => _push(context, ChatScreen(storeId: _seller['id']!, storeName: _seller['name']!, storeEmoji: _seller['emoji']!)),
              child: Row(children: [
                Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.backgroundPrimary, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)), child: Center(child: Text(_seller['emoji']!, style: const TextStyle(fontSize: 24)))),
                const SizedBox(width: AppDimensions.md),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Sold by', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                  Text(_seller['name']!, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                  Row(children: [const Icon(Icons.star_rounded, size: 12, color: AppColors.ratingFilled), const SizedBox(width: 2), Text(_seller['rating']!, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600))]),
                ])),
                Container(padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: 8), decoration: BoxDecoration(color: AppColors.statusActiveBg, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)),
                  child: Row(children: [const Icon(Icons.chat_bubble_outline, size: 14, color: AppColors.ctaPrimaryBg), const SizedBox(width: 4), Text('Chat', style: AppTextStyles.caption.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w700))])),
              ]),
            )),
          const SizedBox(height: AppDimensions.sm),

          // Quantity
          Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.md),
            child: Row(children: [
              Text('Quantity', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              _QtyBtn(icon: Icons.remove, onTap: () { if (_qty > 1) setState(() => _qty--); }),
              SizedBox(width: 44, child: Center(child: Text('$_qty', style: AppTextStyles.headline3.copyWith(fontWeight: FontWeight.w800)))),
              _QtyBtn(icon: Icons.add, onTap: () { if (_qty < p.stock) setState(() => _qty++); }),
              const SizedBox(width: AppDimensions.lg),
              Text('${p.stock} in stock', style: AppTextStyles.caption.copyWith(color: p.stock > 5 ? AppColors.success : AppColors.error, fontWeight: FontWeight.w600)),
            ])),
          const SizedBox(height: AppDimensions.sm),

          // Tabs
          Container(color: Colors.white, child: TabBar(controller: _tabCtrl, indicatorColor: AppColors.ctaPrimaryBg, indicatorWeight: 2.5, labelColor: AppColors.ctaPrimaryBg, unselectedLabelColor: AppColors.textTertiary, labelStyle: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700), unselectedLabelStyle: AppTextStyles.bodySmall, tabs: [const Tab(text: 'Description'), Tab(text: 'Reviews (${reviews.isEmpty ? p.reviewCount : reviews.length})')])),

          SizedBox(height: 380, child: TabBarView(controller: _tabCtrl, children: [
            // Description
            SingleChildScrollView(padding: const EdgeInsets.all(AppDimensions.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (p.description != null) Text(p.description!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.7)),
              const SizedBox(height: AppDimensions.md),
              _Spec('Brand', p.brand), _Spec('SKU', p.id.toUpperCase()), _Spec('Stock', '${p.stock} units'), _Spec('Shipping', p.shippingFree ? 'Free' : '\$5.99'), _Spec('Returns', '30-day return policy'),
            ])),
            // Reviews
            Column(children: [
              Padding(padding: const EdgeInsets.all(AppDimensions.lg), child: Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(avg.toStringAsFixed(1), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontFamily: 'Inter')),
                  Row(children: List.generate(5, (i) => Icon(i < avg.round() ? Icons.star_rounded : Icons.star_outline_rounded, size: 18, color: AppColors.ratingFilled))),
                  Text('${reviews.isEmpty ? p.reviewCount : reviews.length} reviews', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                ]),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _push(context, WriteReviewScreen(productId: p.id, productName: p.name)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.ctaPrimaryBg, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSm))),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: Text('Write Review', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ])),
              const Divider(color: AppColors.borderSubtle, height: 1),
              Expanded(child: reviews.isEmpty
                ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.rate_review_outlined, size: 48, color: AppColors.textQuaternary),
                    const SizedBox(height: AppDimensions.sm),
                    Text('No reviews yet', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                    TextButton(onPressed: () => _push(context, WriteReviewScreen(productId: p.id, productName: p.name)), child: Text('Be the first!', style: AppTextStyles.bodySmall.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w700))),
                  ]))
                : ListView.separated(padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg), itemCount: reviews.length, separatorBuilder: (_, __) => const Divider(color: AppColors.borderSubtle, height: 1), itemBuilder: (_, i) => _ReviewTile(review: reviews[i]))),
            ]),
          ])),

          // Related Products
          Container(color: Colors.white, padding: const EdgeInsets.all(AppDimensions.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('You May Also Like', style: AppTextStyles.headline3),
            const SizedBox(height: AppDimensions.sm),
            SizedBox(height: 80, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: 6,
              itemBuilder: (_, i) => Container(width: 72, height: 72, margin: const EdgeInsets.only(right: AppDimensions.sm),
                decoration: BoxDecoration(color: AppColors.backgroundPrimary, borderRadius: BorderRadius.circular(AppDimensions.radiusSm), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))]),
                child: ClipRRect(borderRadius: BorderRadius.circular(AppDimensions.radiusSm), child: CachedNetworkImage(imageUrl: 'https://picsum.photos/150/150?random=${p.id.hashCode.abs() + i + 10}', fit: BoxFit.cover))),
            )),
          ])),
          const SizedBox(height: 100),
        ])),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))]),
        child: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(AppDimensions.lg, AppDimensions.sm, AppDimensions.lg, AppDimensions.md), child: Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.md), decoration: BoxDecoration(color: AppColors.backgroundPrimary, borderRadius: BorderRadius.circular(AppDimensions.radiusMd)), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Total', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
            Text('\$${(p.price * _qty).toStringAsFixed(2)}', style: AppTextStyles.priceMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          ])),
          const SizedBox(width: AppDimensions.sm),
          Expanded(child: SizedBox(height: 52, child: ElevatedButton.icon(
            onPressed: p.stock > 0 ? _addToCart : null,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.ctaPrimaryBg, disabledBackgroundColor: AppColors.ctaPrimaryDisabledBg, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd))),
            icon: const Icon(Icons.shopping_bag_outlined, size: 20),
            label: Text(p.stock > 0 ? 'Add to Cart' : 'Out of Stock', style: AppTextStyles.buttonLabel),
          ))),
        ]))),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ReviewModel review;
  const _ReviewTile({required this.review});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: AppDimensions.md), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [
      CircleAvatar(backgroundColor: AppColors.ctaPrimaryBg.withOpacity(0.15), radius: 18, child: Text(review.userName[0], style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w800, color: AppColors.ctaPrimaryBg))),
      const SizedBox(width: AppDimensions.sm),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(review.userName, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
        Text('${review.date.day}/${review.date.month}/${review.date.year}', style: AppTextStyles.caption.copyWith(color: AppColors.textQuaternary)),
      ])),
      Row(children: List.generate(5, (i) => Icon(i < review.rating.round() ? Icons.star_rounded : Icons.star_outline_rounded, size: 14, color: AppColors.ratingFilled))),
    ]),
    const SizedBox(height: AppDimensions.xs),
    Text(review.comment, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5)),
  ]));
}

class _Spec extends StatelessWidget {
  final String l, v;
  const _Spec(this.l, this.v);
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: AppDimensions.sm), child: Row(children: [Text(l, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)), const Spacer(), Text(v, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary))]));
}

class _SmBadge extends StatelessWidget {
  final String label; final Color bg;
  const _SmBadge(this.label, this.bg);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppDimensions.radiusXs)), child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Inter')));
}

class _QtyBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.backgroundPrimary, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)), child: Icon(icon, size: 18, color: AppColors.textPrimary)));
}
