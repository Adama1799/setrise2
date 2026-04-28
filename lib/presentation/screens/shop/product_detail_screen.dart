// lib/presentation/screens/shop/product_detail_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/mock_shop_service.dart';
import 'cart_screen.dart';
import 'widgets/hero_section.dart';
import 'widgets/product_info_section.dart';
import 'widgets/reviews_section.dart';
import 'widgets/similar_products_section.dart';
import 'widgets/bottom_action_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<ProductModel> _similarProducts = [];

  @override
  void initState() {
    super.initState();
    _loadSimilarProducts();
  }

  Future<void> _loadSimilarProducts() async {
    final products = await MockShopService.getSimilarProducts(widget.product);
    setState(() => _similarProducts = products);
  }

  void _addToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _buyNow() {
    _addToCart();
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const CartScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.share, color: AppColors.primaryText),
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.primaryText),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const CartScreen()))),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: HeroSection(
                  videoUrl: widget.product.videoUrl,
                  imageUrls: widget.product.imageUrls,
                  heroTag: 'product-${widget.product.id}',
                ),
              ),
              SliverToBoxAdapter(
                child: ProductInfoSection(product: widget.product),
              ),
              SliverToBoxAdapter(
                child: ReviewsSection(product: widget.product),
              ),
              SliverToBoxAdapter(
                child: SimilarProductsSection(products: _similarProducts),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomActionBar(onAddToCart: _addToCart, onBuyNow: _buyNow),
          ),
        ],
      ),
    );
  }
}
