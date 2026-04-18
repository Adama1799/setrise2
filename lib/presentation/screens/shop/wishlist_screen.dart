// lib/presentation/screens/shop/

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/mock_shop_service.dart';
import 'product_detail_screen.dart';
import 'shop_screen.dart'; // لاستخدام CartService

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<ProductModel> _wishlistItems = [];
  bool _isLoading = true;
  String _sortOption = 'Newest';

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    setState(() => _isLoading = true);
    try {
      final allProducts = await MockShopService.getAllProducts();
      _wishlistItems = allProducts.where((p) => p.isFavorite).toList();
      _sortItems();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _sortItems() {
    setState(() {
      switch (_sortOption) {
        case 'Price: Low to High':
          _wishlistItems.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'Price: High to Low':
          _wishlistItems.sort((a, b) => b.price.compareTo(a.price));
          break;
        default:
          break;
      }
    });
  }

  void _moveToCart(ProductModel product) {
    CartService().addItem(CartItem(id: product.id, name: product.name, brand: product.brand, price: product.price, imageUrl: product.imageUrls.first, quantity: 1));
    setState(() => _wishlistItems.remove(product));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} moved to cart'), backgroundColor: AppColors.success));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Wishlist', style: AppTextStyles.headline2.copyWith(color: AppColors.primaryText)),
        centerTitle: false,
        foregroundColor: AppColors.primaryText,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wishlistItems.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.favorite_border, size: 80, color: AppColors.secondaryText), const SizedBox(height: 16), Text('Your wishlist is empty', style: AppTextStyles.headline2), const SizedBox(height: 8), Text('Save items you love', style: AppTextStyles.body2.copyWith(color: AppColors.secondaryText))]))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: DropdownButtonFormField<String>(
                        value: _sortOption,
                        decoration: InputDecoration(labelText: 'Sort by', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                        items: ['Newest', 'Price: Low to High', 'Price: High to Low'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                        onChanged: (v) => setState(() { _sortOption = v!; _sortItems(); }),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.7),
                        itemCount: _wishlistItems.length,
                        itemBuilder: (context, index) => _buildWishlistCard(_wishlistItems[index]),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildWishlistCard(ProductModel product) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
      child: Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(product.imageUrls.first, height: 150, width: double.infinity, fit: BoxFit.cover)),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: AppColors.surface.withOpacity(0.8), shape: BoxShape.circle), child: IconButton(icon: const Icon(Icons.favorite, color: AppColors.error, size: 20), onPressed: () => setState(() { product.isFavorite = false; _wishlistItems.remove(product); }))),
                ),
                if (product.oldPrice != null) Positioned(top: 8, left: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(4)), child: Text('-${product.discountPercentage.round()}%', style: AppTextStyles.caption.copyWith(color: Colors.white)))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.brand, style: AppTextStyles.body2.copyWith(color: AppColors.secondaryText)),
                  Text(product.name, style: AppTextStyles.body1, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(children: [Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.headline2), if (product.oldPrice != null) ...[const SizedBox(width: 8), Text('\$${product.oldPrice!.toStringAsFixed(2)}', style: AppTextStyles.caption.copyWith(decoration: TextDecoration.lineThrough, color: AppColors.secondaryText))]]),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: () => _moveToCart(product), style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, minimumSize: const Size(double.infinity, 36), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text('Move to Cart', style: AppTextStyles.button.copyWith(fontSize: 14))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
