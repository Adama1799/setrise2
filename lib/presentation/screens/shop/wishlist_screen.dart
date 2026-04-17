// lib/presentation/screens/shop/wishlist_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/product_model.dart';
import '../../../data/mock_data/shop_mock_data.dart';
import 'shop_screen.dart'; // For CartService

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<ProductModel> _wishlistItems = [];
  List<ProductModel> _filteredItems = [];
  bool _isLoading = true;
  String _sortBy = 'Date Added';

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  void _loadWishlist() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final allProducts = await MockShopService.getAllProducts();
      _wishlistItems = allProducts.where((product) => product.isFavorite).toList();
      _sortItems();
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sortItems() {
    List<ProductModel> sortedItems = List.from(_wishlistItems);

    switch (_sortBy) {
      case 'Price: Low to High':
        sortedItems.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Discount %':
        sortedItems.sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
        break;
      default:
        // Date Added - keep original order
        break;
    }

    setState(() {
      _filteredItems = sortedItems;
    });
  }

  void _removeFromWishlist(ProductModel product) {
    setState(() {
      _wishlistItems.remove(product);
      _filteredItems.remove(product);
      // Update the product's favorite status
      product.isFavorite = false;
    });
  }

  void _moveToCart(ProductModel product) {
    CartService().addToCart();
    _removeFromWishlist(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} moved to cart'),
        backgroundColor: AppColors.electricBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          "My Wishlist (${_filteredItems.length})",
          style: AppTextStyles.h5.copyWith(color: AppColors.white),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.electricBlue))
          : _filteredItems.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadWishlist,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Text(
                                'Sort by:',
                                style: AppTextStyles.body1.copyWith(
                                  color: AppColors.grey2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: DropdownButton<String>(
                                  value: _sortBy,
                                  isExpanded: true,
                                  underline: Container(
                                    height: 1,
                                    color: AppColors.grey2,
                                  ),
                                  dropdownColor: AppColors.grey.withOpacity(0.2),
                                  style: AppTextStyles.body1.copyWith(
                                    color: AppColors.white,
                                  ),
                                  items: [
                                    'Date Added',
                                    'Price: Low to High',
                                    'Discount %',
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _sortBy = newValue;
                                        _sortItems();
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = _filteredItems[index];
                              return _buildWishlistCard(product);
                            },
                            childCount: _filteredItems.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_outlined,
            size: 80,
            color: AppColors.grey2,
          ),
          const SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: AppTextStyles.h5.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to your wishlist to save them for later',
            style: AppTextStyles.body1.copyWith(color: AppColors.grey2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate back to shop
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricBlue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text(
              'Continue Shopping',
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistCard(ProductModel product) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  product.imageUrls.first,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 150,
                    color: AppColors.grey,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppColors.grey2,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => _removeFromWishlist(product),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.grey2,
                      size: 18,
                    ),
                  ),
                ),
              ),
              if (product.oldPrice != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.neonRed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '-${product.discountPercentage}%',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brand,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.grey2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.name,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.electricBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (product.oldPrice != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        '\$${product.oldPrice!.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: AppColors.grey2,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () => _moveToCart(product),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.electricBlue,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Move to Cart',
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price Drop Alert',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.grey2,
                      ),
                    ),
                    Switch(
                      value: false,
                      onChanged: (value) {
                        // Toggle price drop alert
                      },
                      activeColor: AppColors.electricBlue,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
