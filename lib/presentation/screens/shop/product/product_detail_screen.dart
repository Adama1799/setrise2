import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';
import 'package:setrise/core/utils/color_extractor.dart';
import 'package:setrise/data/models/product_model.dart';
import 'package:setrise/data/services/mock_shop_service.dart';
import 'package:setrise/presentation/screens/shop/cart/cart_screen.dart';
import 'package:setrise/presentation/screens/shop/cart_service.dart';
import 'package:setrise/presentation/screens/shop/chat/chat_screen.dart';
import 'package:setrise/presentation/screens/shop/write_review_screen.dart';
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
  Color _themeColor = AppColors.lightGray;
  bool _colorLoaded = false;
  List<ProductModel> _similar = [];

  @override
  void initState() {
    super.initState();
    _loadThemeColor();
    MockShopService.getSimilarProducts(widget.product).then((p) {
      if (mounted) setState(() => _similar = p);
    });
  }

  Future<void> _loadThemeColor() async {
    if (widget.product.images.isNotEmpty) {
      final c = await getDominantColor(widget.product.images.first);
      if (mounted) {
        setState(() {
          // نمزج مع الرمادي لتبقى ناعمة
          _themeColor = Color.lerp(c, AppColors.lightGray, 0.5)!;
          _colorLoaded = true;
        });
      }
    } else {
      setState(() => _colorLoaded = true);
    }
  }

  void _addToCart() {
    CartService().addItem(CartItem(
      id: widget.product.id,
      imageUrl: widget.product.images.first,
      brand: widget.product.brandName,
      name: widget.product.name,
      price: widget.product.price,
      quantity: 1,
    ));
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Added to Cart'),
        content: Text('${widget.product.name} added to your cart.'),
        actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: _themeColor.withOpacity(0.9),
        leading: CupertinoNavigationBarBackButton(
          color: AppColors.black,
          onPressed: () => Navigator.pop(context),
        ),
        middle: Text(
          widget.product.name,
          style: TextStyle(color: AppColors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.share, color: AppColors.black),
            onPressed: () {},
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.cart, color: AppColors.black),
            onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const CartScreen())),
          ),
        ]),
      ),
      child: _colorLoaded
          ? Stack(children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [_themeColor.withOpacity(0.3), AppColors.background],
                    ),
                  ),
                ),
              ),
              CustomScrollView(slivers: [
                SliverToBoxAdapter(child: HeroSection(images: widget.product.images, heroTag: 'p-${widget.product.id}')),
                SliverToBoxAdapter(child: ProductInfoSection(product: widget.product)),
                // زر الدردشة مع البائع
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      color: AppColors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.chat_bubble_2, color: AppColors.black),
                          const SizedBox(width: 8),
                          Text('Chat with Seller', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (_) => ChatScreen(storeName: widget.product.brandName, storeId: widget.product.id)),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: ShippingInfoSection()),
                SliverToBoxAdapter(child: ReviewsSection(product: widget.product)),
                SliverToBoxAdapter(child: QnaSection(questions: const [
                  {'question': 'Is this product original?', 'answer': 'Yes, we guarantee authenticity.'},
                ])),
                SliverToBoxAdapter(child: SimilarProductsSection(products: _similar)),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ]),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: _bottomBar(),
              ),
            ])
          : const Center(child: CupertinoActivityIndicator()),
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.9),
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(children: [
        Expanded(
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: _themeColor.withOpacity(0.8),
            child: const Text('Add to Cart', style: TextStyle(color: AppColors.black)),
            onPressed: _addToCart,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: AppColors.shop,
            child: const Text('Buy Now', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)),
            onPressed: () {},
          ),
        ),
      ]),
    );
  }
}
