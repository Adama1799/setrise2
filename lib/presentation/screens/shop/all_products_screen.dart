// lib/presentation/screens/shop/all_products_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock_data/shop_mock_data.dart';
import '../../../data/models/product_model.dart';
import 'product_detail_screen.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  late List<ProductModel> _products;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _products = ShopMockData.getFeaturedProducts() + ShopMockData.getPopularProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500 && !_isLoading) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    final newProducts = ShopMockData.getPopularProducts().map((p) => p.copyWith(id: 'more_${DateTime.now().millisecondsSinceEpoch}_${p.id}')).toList();
    setState(() {
      _products.addAll(newProducts);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'All Products',
          style: AppTextStyles.h5.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _products = ShopMockData.getFeaturedProducts() + ShopMockData.getPopularProducts();
          });
        },
        child: GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _products.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _products.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final product = _products[index];
            return _ProductGridCard(product: product);
          },
        ),
      ),
    );
  }
}

class _ProductGridCard extends StatefulWidget {
  final ProductModel product;
  const _ProductGridCard({required this.product});

  @override
  State<_ProductGridCard> createState() => _ProductGridCardState();
}

class _ProductGridCardState extends State<_ProductGridCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final hasDiscount = product.oldPrice != null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      width: double.infinity,
                      color: AppColors.grey,
                      child: Image.network(
                        product.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.grey,
                          child: const Icon(Icons.image_not_supported_outlined, color: AppColors.grey2, size: 40),
                        ),
                      ),
                    ),
                  ),
                  if (hasDiscount)
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.neonRed, borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          '-${product.discountPercentage.round()}%',
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8, right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _isFavorite = !_isFavorite),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                        child: Icon(
                          _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: _isFavorite ? AppColors.neonRed : AppColors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: AppTextStyles.labelMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(product.brandName, style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.labelLarge.copyWith(color: AppColors.shop, fontWeight: FontWeight.bold)),
                            if (hasDiscount)
                              Text('\$${product.oldPrice!.toStringAsFixed(2)}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2, decoration: TextDecoration.lineThrough)),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(color: AppColors.shop, borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.add_shopping_cart_rounded, color: AppColors.black, size: 20),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(product.rating.toStringAsFixed(1), style: AppTextStyles.labelSmall.copyWith(color: AppColors.white)),
                        const SizedBox(width: 4),
                        Text('(${product.reviewsCount})', style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
