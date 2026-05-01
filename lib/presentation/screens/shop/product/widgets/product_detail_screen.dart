// lib/presentation/screens/shop/product/product_detail_screen.dart
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/services/mock_shop_service.dart';
import '../cart/cart_screen.dart';
import 'widgets/hero_section.dart';
import 'widgets/product_info_section.dart';
import 'widgets/reviews_section.dart';
import 'widgets/similar_products_section.dart';
import 'widgets/qna_section.dart';
import 'widgets/shipping_info_section.dart';

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
    _loadSimilar();
  }

  Future<void> _loadSimilar() async {
    final prods = await MockShopService.getSimilarProducts(widget.product);
    setState(() => _similarProducts = prods);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.surface,
        leading: CupertinoNavigationBarBackButton(color: AppColors.white, onPressed: () => Navigator.pop(context)),
        middle: Text(widget.product.name, style: const TextStyle(color: AppColors.white, fontSize: 17, fontWeight: FontWeight.w600)),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          CupertinoButton(padding: EdgeInsets.zero, child: const Icon(CupertinoIcons.share, color: AppColors.white), onPressed: () {}),
          CupertinoButton(padding: EdgeInsets.zero, child: const Icon(CupertinoIcons.cart, color: AppColors.white), onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const CartScreen()))),
        ]),
      ),
      child: SafeArea(
        child: Stack(children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: HeroSection(imageUrls: widget.product.imageUrls, heroTag: 'product-${widget.product.id}', videoUrl: widget.product.videoUrl)),
              SliverToBoxAdapter(child: ProductInfoSection(product: widget.product)),
              SliverToBoxAdapter(child: ShippingInfoSection()),
              SliverToBoxAdapter(child: ReviewsSection(product: widget.product)),
              SliverToBoxAdapter(child: QnaSection(questions: const [
                {'question': 'Is this product original?', 'answer': 'Yes, we guarantee 100% authenticity.'},
                {'question': 'How long does shipping take?', 'answer': 'Usually 2-5 business days.'},
              ])),
              SliverToBoxAdapter(child: SimilarProductsSection(products: _similarProducts)),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: _bottomBar()),
        ]),
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: AppColors.surface.withOpacity(0.95), border: Border(top: BorderSide(color: AppColors.grey.withOpacity(0.2)))),
      child: Row(children: [
        Expanded(child: CupertinoButton(padding: const EdgeInsets.symmetric(vertical: 12), color: AppColors.accent, child: const Text('Add to Cart'), onPressed: () {})),
        const SizedBox(width: 12),
        Expanded(child: CupertinoButton(padding: const EdgeInsets.symmetric(vertical: 12), color: AppColors.shop, child: const Text('Buy Now', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)), onPressed: () {})),
      ]),
    );
  }
}
