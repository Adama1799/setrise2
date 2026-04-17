// lib/presentation/screens/shop/product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_view/photo_view.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/mock_shop_service.dart';
import 'shop_screen.dart'; // For CartService

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _showDescription = false;
  String? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _selectedSize = 'M';
    _selectedColor = 'Black';

    if (widget.product.videoUrl != null) {
      _videoController = VideoPlayerController.network(widget.product.videoUrl!)
        ..initialize().then((_) {
          setState(() {
            _isVideoInitialized = true;
          });
        });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _addToCart() {
    CartService().addToCart();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        backgroundColor: AppColors.electricBlue,
      ),
    );
  }

  void _buyNow() {
    // Navigate to checkout or payment
    _addToCart(); // Add to cart first
    // Then navigate to checkout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.white),
            onPressed: () {
              // Share product
            },
          ),
          IconButton(
            icon: Icon(
              widget.product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.product.isFavorite ? AppColors.neonRed : AppColors.white,
            ),
            onPressed: () {
              setState(() {
                widget.product.isFavorite = !widget.product.isFavorite;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Images Carousel
                    SizedBox(
                      height: 350,
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemCount: widget.product.imageUrls.length + 
                                (widget.product.videoUrl != null ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (widget.product.videoUrl != null && index == 0) {
                                // First item is video if available
                                if (_isVideoInitialized) {
                                  return AspectRatio(
                                    aspectRatio: _videoController!.value.aspectRatio,
                                    child: VideoPlayer(_videoController!),
                                  );
                                } else {
                                  return const Center(child: CircularProgressIndicator());
                                }
                              } else {
                                // Regular images
                                final imgIndex = widget.product.videoUrl != null 
                                    ? index - 1 
                                    : index;
                                
                                if (imgIndex >= 0 && imgIndex < widget.product.imageUrls.length) {
                                  return Hero(
                                    tag: 'product-${widget.product.id}',
                                    child: PhotoView(
                                      imageProvider: NetworkImage(widget.product.imageUrls[imgIndex]),
                                      loadingBuilder: (context, event) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      backgroundDecoration: BoxDecoration(
                                        color: AppColors.background,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }
                            },
                          ),
                          
                          // Play button on video
                          if (widget.product.videoUrl != null && _isVideoInitialized)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(
                                  _videoController!.value.isPlaying 
                                      ? Icons.pause 
                                      : Icons.play_arrow,
                                  color: AppColors.white,
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_videoController!.value.isPlaying) {
                                      _videoController!.pause();
                                    } else {
                                      _videoController!.play();
                                    }
                                  });
                                },
                              ),
                            ),
                          
                          // Page indicator
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                widget.product.imageUrls.length + 
                                    (widget.product.videoUrl != null ? 1 : 0),
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentPage == index 
                                        ? AppColors.electricBlue 
                                        : AppColors.grey2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Product Info
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.brand,
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.grey2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.product.name,
                            style: AppTextStyles.h5.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Rating and Reviews
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow.shade700, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                widget.product.rating.toStringAsFixed(1),
                                style: AppTextStyles.body1.copyWith(color: AppColors.white),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '(${widget.product.reviewsCount} reviews)',
                                style: AppTextStyles.body1.copyWith(color: AppColors.grey2),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          // Price and Discount
                          Row(
                            children: [
                              Text(
                                '\$${widget.product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.electricBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              if (widget.product.oldPrice != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '\$${widget.product.oldPrice!.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: AppColors.grey2,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.neonRed,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '-${widget.product.discountPercentage}%',
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Description
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showDescription = !_showDescription;
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Description',
                                      style: AppTextStyles.labelLarge.copyWith(
                                        color: AppColors.white,
                                      ),
                                    ),
                                    Icon(
                                      _showDescription 
                                          ? Icons.expand_less 
                                          : Icons.expand_more,
                                      color: AppColors.grey2,
                                    ),
                                  ],
                                ),
                                if (_showDescription)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      widget.product.description,
                                      style: AppTextStyles.body1.copyWith(
                                        color: AppColors.grey2,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Size Selection
                          Text(
                            'Size',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: ['S', 'M', 'L', 'XL'].map((size) {
                              return ChoiceChip(
                                label: Text(size),
                                selected: _selectedSize == size,
                                selectedColor: AppColors.electricBlue,
                                backgroundColor: AppColors.grey.withOpacity(0.3),
                                labelStyle: TextStyle(
                                  color: _selectedSize == size 
                                      ? AppColors.white 
                                      : AppColors.grey2,
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedSize = size;
                                    });
                                  }
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          
                          // Color Selection
                          Text(
                            'Color',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: ['Black', 'White', 'Blue'].map((color) {
                              return ChoiceChip(
                                label: Text(color),
                                selected: _selectedColor == color,
                                selectedColor: AppColors.electricBlue,
                                backgroundColor: AppColors.grey.withOpacity(0.3),
                                labelStyle: TextStyle(
                                  color: _selectedColor == color 
                                      ? AppColors.white 
                                      : AppColors.grey2,
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedColor = color;
                                    });
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    
                    // Customer Reviews
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Reviews',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Rating Breakdown
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: List.generate(5, (index) {
                                    final star = 5 - index;
                                    return Expanded(
                                      child: Row(
                                        children: [
                                          Text('$star★'),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              value: star == 5 ? 0.6 : star == 4 ? 0.3 : star == 3 ? 0.2 : star == 2 ? 0.1 : 0.05,
                                              backgroundColor: AppColors.grey.withOpacity(0.2),
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                AppColors.electricBlue,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            star == 5 ? '60%' : star == 4 ? '30%' : star == 3 ? '20%' : star == 2 ? '10%' : '5%',
                                            style: AppTextStyles.labelSmall.copyWith(
                                              color: AppColors.grey2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Review Cards
                          ...List.generate(3, (index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: AppColors.electricBlue,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'U',
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'User ${index + 1}',
                                        style: AppTextStyles.body1.copyWith(
                                          color: AppColors.white,
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: List.generate(5, (starIndex) {
                                          return Icon(
                                            Icons.star,
                                            size: 14,
                                            color: starIndex < 4 
                                                ? Colors.yellow.shade700 
                                                : AppColors.grey2,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Great product! Quality is excellent and fits perfectly.',
                                    style: AppTextStyles.body1.copyWith(
                                      color: AppColors.grey2,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    
                    // You May Also Like
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You May Also Like',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          FutureBuilder<List<ProductModel>>(
                            future: MockShopService.getSimilarProducts(widget.product),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SizedBox(
                                  height: 180,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 3,
                                    itemBuilder: (context, index) => Container(
                                      width: 120,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        color: AppColors.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              
                              final products = snapshot.data ?? [];
                              if (products.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No similar products found',
                                    style: TextStyle(color: AppColors.grey2),
                                  ),
                                );
                              }
                              
                              return SizedBox(
                                height: 180,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    return Container(
                                      width: 120,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        color: AppColors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.vertical(
                                                  top: Radius.circular(12),
                                                ),
                                                image: DecorationImage(
                                                  image: NetworkImage(product.imageUrls.first),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.name,
                                                  style: AppTextStyles.labelSmall.copyWith(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '\$${product.price.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    color: AppColors.electricBlue,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Sticky Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(
                    color: AppColors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Quantity Selector
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: () {
                                if (_quantity > 1) {
                                  setState(() {
                                    _quantity--;
                                  });
                                }
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                            ),
                            Text(
                              '$_quantity',
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: () {
                                setState(() {
                                  _quantity++;
                                });
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      
                      // Add to Cart
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _addToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.electricBlue,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Add to Cart'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      
                      // Buy Now
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _buyNow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.electricBlue,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Buy Now'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
