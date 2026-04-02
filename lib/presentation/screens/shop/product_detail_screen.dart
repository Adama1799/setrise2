// lib/presentation/screens/shop/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  int _selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Mock product
    final product = {
      'id': widget.productId,
      'name': 'Premium Wireless Headphones',
      'price': 89.99,
      'originalPrice': 149.99,
      'rating': 4.8,
      'reviews': 2543,
      'stock': 45,
      'images': [
        'https://via.placeholder.com/500x500?text=Product+1',
        'https://via.placeholder.com/500x500?text=Product+2',
        'https://via.placeholder.com/500x500?text=Product+3',
      ],
      'description':
          'Premium quality wireless headphones with active noise cancellation, 30-hour battery life, and premium sound quality.',
      'features': [
        'Active Noise Cancellation',
        '30-hour battery',
        'Bluetooth 5.0',
        'Comfortable design',
      ],
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0.5,
        title: const Text('Product Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            Column(
              children: [
                Container(
                  height: 300,
                  color: AppColors.surface,
                  child: PageView.builder(
                    onPageChanged: (index) {
                      setState(() => _selectedImageIndex = index);
                    },
                    itemCount: product['images'].length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: product['images'][index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // Image Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    product['images'].length,
                    (index) => Container(
                      width: _selectedImageIndex == index ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: _selectedImageIndex == index
                            ? AppColors.primary
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Product Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    product['name'],
                    style: AppTypography.h3,
                  ),
                  const SizedBox(height: 12),
                  // Rating
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star,
                            color: i < 4 ? AppColors.primary : AppColors.border,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${product['rating']} (${product['reviews']} reviews)',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Price
                  Row(
                    children: [
                      Text(
                        Formatters.formatPrice(product['price']),
                        style: AppTypography.h2.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        Formatters.formatPrice(product['originalPrice']),
                        style: AppTypography.bodyLarge.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.live.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Save 40%',
                          style: TextStyle(
                            color: AppColors.live,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Description
                  Text(
                    'Description',
                    style: AppTypography.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['description'],
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  // Features
                  Text(
                    'Features',
                    style: AppTypography.labelLarge,
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    product['features'].length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: AppColors.green, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            product['features'][i],
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Quantity Selector
                  Row(
                    children: [
                      Text(
                        'Quantity',
                        style: AppTypography.labelLarge,
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '$_quantity',
                                style: AppTypography.labelLarge,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: _quantity < product['stock']
                                  ? () => setState(() => _quantity++)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Added $_quantity item(s) to cart',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Buy Now Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
