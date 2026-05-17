// lib/presentation/screens/shop/material_shop/widgets/product_detail_page.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/wishlist_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/cart_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/reviews_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/shimmer_loader.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_palette_utils.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_detail_widgets.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_detail_body.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/chat/chat_screen.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final ProductModel product;
  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  int _qty = 1, _imgPage = 0;
  String? _selectedSize = 'M';
  Color? _selectedColor;
  late TabController _tabCtrl;
  final _imgCtrl = PageController();

  static const _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  static const _colors = [
    Color(0xFF000000),
    Color(0xFFFFFFFF),
    Color(0xFF1C1C1E),
    Color(0xFFD4AF37),
    Color(0xFF8E8E93),
    Color(0xFFFF3B30),
  ];

  static const _sellers = [
    {'id': 'store_1', 'name': 'TechZone Store', 'emoji': '📱', 'rating': '4.9'},
    {'id': 'store_2', 'name': 'GamersHub', 'emoji': '🎮', 'rating': '4.7'},
    {'id': 'store_3', 'name': 'StyleForward', 'emoji': '👗', 'rating': '4.8'},
  ];
  late final Map<String, String> _seller;

  // ✅ صور المنتج الحقيقية — تستخرج اللون منها
  List<String> get _images {
    if (widget.product.images.isNotEmpty) {
      return widget.product.images;
    }
    // fallback لو ما في صور حقيقية
    final base = widget.product.id.hashCode.abs() % 100;
    return List.generate(
      4,
      (i) => 'https://picsum.photos/600/600?random=${base + i}',
    );
  }

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _seller = _sellers[widget.product.id.hashCode.abs() % _sellers.length];
    _selectedColor = _colors[0];
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _imgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    // ✅ يستخرج اللون من أول صورة حقيقية للمنتج
    final paletteAsync = ref.watch(productPaletteProvider(_images.first));

    return paletteAsync.when(
      loading: () => _buildPage(p, const Color(0xFF1C1C1E), context),
      error: (_, __) => _buildPage(p, const Color(0xFF1C1C1E), context),
      data: (elegant) => _buildPage(p, elegant, context),
    );
  }

  Widget _buildPage(ProductModel p, Color elegant, BuildContext ctx) {
    final accent = accentFromElegant(elegant);
    final onEl = onColor(elegant);
    final isWishlisted = ref.watch(wishlistProvider).contains(p.id);
    final cartCount = ref.watch(cartProvider).itemCount;
    final reviews =
        ref.watch(reviewsProvider).where((r) => r.productId == p.id).toList();
    final avg = reviews.isEmpty
        ? p.rating
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
            reviews.length;
    final images = _images;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.35, 1.0],
          colors: [
            elegant.withOpacity(0.18),
            elegant.withOpacity(0.06),
            AppColors.backgroundPrimary,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: _BottomBar(
          p: p,
          accent: accent,
          qty: _qty,
          onAddToCart: () {
            HapticFeedback.mediumImpact();
            ref.read(cartProvider.notifier).addItem(p, {
              'size': _selectedSize ?? '',
              'color': _selectedColor?.value.toString() ?? '',
            }, _qty);
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(
                  'Added $_qty item(s) to cart',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                ),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(AppDimensions.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            _buildSliverAppBar(
              images: images,
              elegant: elegant,
              onEl: onEl,
              accent: accent,
              cartCount: cartCount,
              isWishlisted: isWishlisted,
              p: p,
              ctx: ctx,
            ),
          ],
          body: ProductDetailBody(
            p: p,
            elegant: elegant,
            accent: accent,
            reviews: reviews,
            avg: avg,
            tabCtrl: _tabCtrl,
            selectedSize: _selectedSize,
            selectedColor: _selectedColor,
            sizes: _sizes,
            colors: _colors,
            qty: _qty,
            seller: _seller,
            onSizeSelected: (s) => setState(() => _selectedSize = s),
            onColorSelected: (c) => setState(() => _selectedColor = c),
            onQtyDecrement: () {
              if (_qty > 1) setState(() => _qty--);
            },
            onQtyIncrement: () {
              if (_qty < p.stock) setState(() => _qty++);
            },
            onChatTap: () => pushScreen(
              ctx,
              ChatScreen(
                storeId: _seller['id']!,
                storeName: _seller['name']!,
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar({
    required List<String> images,
    required Color elegant,
    required Color onEl,
    required Color accent,
    required int cartCount,
    required bool isWishlisted,
    required ProductModel p,
    required BuildContext ctx,
  }) {
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(ctx),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: elegant.withOpacity(0.85),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: elegant.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 1,
              )
            ],
          ),
          child: Icon(Icons.arrow_back_ios_new, size: 16, color: onEl),
        ),
      ),
      actions: [
        _AppBarBtn(
          elegant: elegant,
          onEl: onEl,
          icon: Icons.ios_share,
          onTap: () => HapticFeedback.lightImpact(),
        ),
        _AppBarBtn(
          elegant: elegant,
          onEl: onEl,
          icon: isWishlisted
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          iconColor: isWishlisted ? AppColors.error : onEl,
          onTap: () {
            HapticFeedback.lightImpact();
            ref.read(wishlistProvider.notifier).toggle(p.id);
          },
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            _AppBarBtn(
              elegant: elegant,
              onEl: onEl,
              icon: Icons.shopping_bag_outlined,
              margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
              onTap: () {},
            ),
            if (cartCount > 0)
              Positioned(
                top: 6,
                right: 10,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration:
                      BoxDecoration(color: accent, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _ImageGallery(
          images: images,
          imgCtrl: _imgCtrl,
          imgPage: _imgPage,
          elegant: elegant,
          onEl: onEl,
          onPageChanged: (i) => setState(() => _imgPage = i),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// AppBar Action Button
// ─────────────────────────────────────────────────────────────
class _AppBarBtn extends StatelessWidget {
  final Color elegant, onEl;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;
  final EdgeInsets margin;

  const _AppBarBtn({
    required this.elegant,
    required this.onEl,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.margin = const EdgeInsets.only(right: 4, top: 8, bottom: 8),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: elegant.withOpacity(0.85),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: elegant.withOpacity(0.4), blurRadius: 12),
          ],
        ),
        child: Icon(icon, size: 18, color: iconColor ?? onEl),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Image Gallery
// ─────────────────────────────────────────────────────────────
class _ImageGallery extends StatelessWidget {
  final List<String> images;
  final PageController imgCtrl;
  final int imgPage;
  final Color elegant, onEl;
  final ValueChanged<int> onPageChanged;

  const _ImageGallery({
    required this.images,
    required this.imgCtrl,
    required this.imgPage,
    required this.elegant,
    required this.onEl,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: imgCtrl,
          onPageChanged: onPageChanged,
          itemCount: images.length,
          itemBuilder: (_, i) => CachedNetworkImage(
            imageUrl: images[i],
            fit: BoxFit.cover,
            placeholder: (_, __) => const ShimmerLoader(
              child: ColoredBox(color: AppColors.backgroundSkeleton),
            ),
            errorWidget: (_, __, ___) => const ColoredBox(
              color: AppColors.backgroundTertiary,
              child: Icon(
                Icons.image_outlined,
                size: 64,
                color: AppColors.textQuaternary,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [elegant.withOpacity(0.25), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16, left: 0, right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: imgPage == i ? 24 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: imgPage == i
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: imgPage == i
                      ? [BoxShadow(color: elegant.withOpacity(0.5), blurRadius: 8)]
                      : null,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 36, right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: elegant.withOpacity(0.7),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Text(
              '${imgPage + 1}/${images.length}',
              style: AppTextStyles.caption.copyWith(
                color: onEl,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Bottom Bar
// ─────────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  final ProductModel p;
  final Color accent;
  final int qty;
  final VoidCallback onAddToCart;

  const _BottomBar({
    required this.p,
    required this.accent,
    required this.qty,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.lg,
        AppDimensions.md,
        AppDimensions.lg,
        AppDimensions.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: onAddToCart,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: accent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                child: Text(
                  'Add to Cart',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: onAddToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: onColor(accent),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                child: Text(
                  'Buy Now',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: onColor(accent),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
