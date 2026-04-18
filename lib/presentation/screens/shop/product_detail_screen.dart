// lib/presentation/screens/shop/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_view/photo_view.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/mock_shop_service.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  int _quantity = 1;
  String? _selectedSize;
  String? _selectedColor;
  bool _isDescriptionExpanded = false;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  List<ProductModel> _similarProducts = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.product.videoUrl != null) {
      _videoController = VideoPlayerController.network(widget.product.videoUrl!)
        ..initialize().then((_) => setState(() => _isVideoInitialized = true));
    }
    _loadSimilarProducts();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _loadSimilarProducts() async {
    final products = await MockShopService.getSimilarProducts(widget.product);
    setState(() => _similarProducts = products);
  }

  void _addToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.product.name} added to cart'), backgroundColor: AppColors.success),
    );
  }

  void _buyNow() {
    _addToCart();
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.width,
                pinned: true,
                backgroundColor: AppColors.surface,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                    child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: 18),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                      child: Icon(Icons.share_rounded, color: AppColors.white, size: 18),
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                      child: Icon(Icons.shopping_cart_outlined, color: AppColors.white, size: 18),
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeroSection(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.brand, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2)),
                      const SizedBox(height: 4),
                      Text(widget.product.name, style: AppTextStyles.h4.copyWith(color: AppColors.white)),
                      const SizedBox(height: 12),
                      _buildPriceSection(),
                      const SizedBox(height: 12),
                      _buildRatingSection(),
                      const SizedBox(height: 20),
                      _buildSizeSelector(),
                      const SizedBox(height: 20),
                      _buildColorSelector(),
                      const SizedBox(height: 20),
                      _buildQuantitySelector(),
                      const SizedBox(height: 20),
                      _buildExpandableDescription(),
                      const SizedBox(height: 24),
                      _buildReviewsSection(),
                      const SizedBox(height: 24),
                      _buildSimilarProductsSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomActionBar()),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    if (widget.product.videoUrl != null && _videoController != null && _isVideoInitialized) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_videoController!),
            GestureDetector(
              onTap: () => setState(() => _videoController!.value.isPlaying ? _videoController!.pause() : _videoController!.play()),
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Icon(
                    _videoController!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: widget.product.imageUrls.length,
            itemBuilder: (context, index) => GestureDetector(
              onDoubleTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _FullScreenImage(imageUrl: widget.product.imageUrls[index]))),
              child: Image.network(widget.product.imageUrls[index], fit: BoxFit.contain),
            ),
          ),
          if (widget.product.imageUrls.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.product.imageUrls.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? AppColors.primary : AppColors.grey2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Row(
      children: [
        Text('\$${widget.product.price.toStringAsFixed(2)}', style: AppTextStyles.h4.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
        if (widget.product.oldPrice != null) ...[
          const SizedBox(width: 8),
          Text('\$${widget.product.oldPrice!.toStringAsFixed(2)}', style: AppTextStyles.bodyMedium.copyWith(decoration: TextDecoration.lineThrough, color: AppColors.grey2)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(6)),
            child: Text('-${widget.product.discountPercentage.round()}%', style: AppTextStyles.caption.copyWith(color: Colors.white)),
          ),
        ],
      ],
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        ...List.generate(5, (index) => Icon(index < widget.product.rating.floor() ? Icons.star_rounded : index < widget.product.rating ? Icons.star_half_rounded : Icons.star_border_rounded, color: AppColors.warning, size: 16)),
        const SizedBox(width: 8),
        Text('${widget.product.rating.toStringAsFixed(1)} (${widget.product.reviewsCount} reviews)', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey2)),
      ],
    );
  }

  Widget _buildSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Size', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: ['XS', 'S', 'M', 'L', 'XL'].map((size) => ChoiceChip(label: Text(size), selected: _selectedSize == size, selectedColor: AppColors.primary, onSelected: (selected) => setState(() => _selectedSize = selected ? size : null)))),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: ['Black', 'White', 'Blue', 'Red', 'Green'].map((color) => ChoiceChip(label: Text(color), selected: _selectedColor == color, selectedColor: AppColors.primary, onSelected: (selected) => setState(() => _selectedColor = selected ? color : null)))),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Quantity', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.w500)),
        Container(
          decoration: BoxDecoration(border: Border.all(color: AppColors.grey3), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              IconButton(icon: Icon(Icons.remove_rounded, color: AppColors.white), onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null),
              Text('$_quantity', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
              IconButton(icon: Icon(Icons.add_rounded, color: AppColors.white), onPressed: () => setState(() => _quantity++)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Description', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.w500)),
            IconButton(
              icon: Icon(_isDescriptionExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: AppColors.grey2),
              onPressed: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
            ),
          ],
        ),
        if (_isDescriptionExpanded) Text(widget.product.description, style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey2)),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reviews', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Container(
          height: 80,
          child: Row(
            children: [
              Container(
                width: 60,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(widget.product.rating.toStringAsFixed(1), style: AppTextStyles.h4.copyWith(color: AppColors.white)),
                  Text('/5', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey2)),
                ]),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) => _buildRatingBar(5 - index, _getRatingCount(5 - index))),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(3, (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 16, backgroundColor: AppColors.primary.withOpacity(0.2), child: Text('U${index + 1}', style: AppTextStyles.caption.copyWith(color: AppColors.primary))),
                  const SizedBox(width: 8),
                  Text('User ${index + 1}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.white)),
                  const Spacer(),
                  ...List.generate(5, (starIndex) => Icon(starIndex < [5, 4, 3][index] ? Icons.star_rounded : Icons.star_border_rounded, color: AppColors.warning, size: 14)),
                ],
              ),
              const SizedBox(height: 8),
              Text('Great product! Highly recommended.', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey2)),
            ],
          ),
        )),
      ],
    );
  }

  int _getRatingCount(int stars) {
    final total = widget.product.reviewsCount;
    if (stars == 5) return (total * 0.4).round();
    if (stars == 4) return (total * 0.3).round();
    if (stars == 3) return (total * 0.2).round();
    if (stars == 2) return (total * 0.07).round();
    return (total * 0.03).round();
  }

  Widget _buildRatingBar(int stars, int count) {
    return Row(
      children: [
        Text('$stars', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey2)),
        const Icon(Icons.star_rounded, color: AppColors.warning, size: 12),
        Expanded(
          child: Container(
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: AppColors.grey3, borderRadius: BorderRadius.circular(3)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: count / widget.product.reviewsCount,
              child: Container(decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(3))),
            ),
          ),
        ),
        Text('$count', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey2)),
      ],
    );
  }

  Widget _buildSimilarProductsSection() {
    if (_similarProducts.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('You May Also Like', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _similarProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = _similarProducts[index];
              return GestureDetector(
                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
                child: Container(
                  width: 140,
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: Image.network(product.imageUrls.first, height: 100, width: double.infinity, fit: BoxFit.cover)),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name, style: AppTextStyles.bodySmall.copyWith(color: AppColors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.grey3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _addToCart,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Add to Cart', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _buyNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Buy Now', style: AppTextStyles.button.copyWith(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullScreenImage extends StatelessWidget {
  final String imageUrl;
  const _FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, iconTheme: IconThemeData(color: Colors.white)),
      body: Center(child: PhotoView(imageProvider: NetworkImage(imageUrl))),
    );
  }
}
