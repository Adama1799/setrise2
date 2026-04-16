// lib/presentation/screens/shop/shop_search_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock_data/shop_mock_data.dart';
import '../../../data/models/product_model.dart';
import 'product_detail_screen.dart';

class ShopSearchScreen extends StatefulWidget {
  const ShopSearchScreen({super.key});

  @override
  State<ShopSearchScreen> createState() => _ShopSearchScreenState();
}

class _ShopSearchScreenState extends State<ShopSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<ProductModel> _searchResults = [];
  List<String> _recentSearches = ['Headphones', 'Shoes', 'Watch', 'Laptop'];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() => _isSearching = true);

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final allProducts = ShopMockData.getFeaturedProducts() + ShopMockData.getPopularProducts();
      final results = allProducts.where((p) =>
          p.name.toLowerCase().contains(query.toLowerCase()) ||
          p.brandName.toLowerCase().contains(query.toLowerCase())).toList();
      setState(() {
        _searchResults = results;
        if (!_recentSearches.contains(query) && query.isNotEmpty) {
          _recentSearches.insert(0, query);
          if (_recentSearches.length > 10) _recentSearches.removeLast();
        }
      });
    });
  }

  void _clearRecentSearches() {
    setState(() => _recentSearches.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
          decoration: InputDecoration(
            hintText: 'Search products, brands...',
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2),
            border: InputBorder.none,
          ),
          onChanged: _performSearch,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: AppColors.grey2),
              onPressed: () {
                _searchController.clear();
                _performSearch('');
              },
            ),
        ],
      ),
      body: _isSearching && _searchController.text.isEmpty
          ? _buildRecentSearches()
          : _searchController.text.isEmpty
              ? _buildRecentSearches()
              : _searchResults.isEmpty
                  ? _buildNoResults()
                  : _buildSearchResults(),
    );
  }

  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Searches', style: AppTextStyles.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: _clearRecentSearches,
                child: Text('Clear All', style: AppTextStyles.labelSmall.copyWith(color: AppColors.shop)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches.map((search) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = search;
                  _performSearch(search);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(search, style: AppTextStyles.labelSmall.copyWith(color: AppColors.white)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text('Popular Categories', style: AppTextStyles.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Electronics', 'Fashion', 'Home', 'Beauty', 'Sports'].map((category) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                ),
                child: Text(category, style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, color: AppColors.grey2, size: 64),
          const SizedBox(height: 16),
          Text('No results found', style: AppTextStyles.labelLarge.copyWith(color: AppColors.grey2)),
          const SizedBox(height: 8),
          Text('Try searching for something else', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2)),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return _SearchResultCard(product: product);
      },
    );
  }
}

class _SearchResultCard extends StatefulWidget {
  final ProductModel product;
  const _SearchResultCard({required this.product});

  @override
  State<_SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<_SearchResultCard> {
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
