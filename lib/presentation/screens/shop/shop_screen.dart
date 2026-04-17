// lib/presentation/screens/shop/shop_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/mock_shop_service.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  ValueNotifier<int> _itemCount = ValueNotifier<int>(0);
  int get itemCount => _itemCount.value;

  void addToCart() {
    _itemCount.value++;
    notifyListeners();
  }

  void removeFromCart() {
    if (_itemCount.value > 0) {
      _itemCount.value--;
      notifyListeners();
    }
  }

  void setItemCount(int count) {
    _itemCount.value = count;
    notifyListeners();
  }
}

class ShopController extends ChangeNotifier {
  List<CategoryModel> categories = [];
  List<String> banners = [];
  List<ProductModel> featuredProducts = [];
  List<ProductModel> popularProducts = [];
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasReachedMax = false;
  
  final Set<String> selectedFilters = <String>{};
  String? selectedCategoryId;  int currentPage = 0;
  static const int pageSize = 10;

  void toggleFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
    _applyFilters();
  }

  void selectCategory(String? categoryId) {
    selectedCategoryId = categoryId;
    _applyFilters();
  }

  void _applyFilters() {
    List<ProductModel> result = List.from(allProducts);

    // Apply category filter
    if (selectedCategoryId != null) {
      result = result.where((product) => product.categoryId == selectedCategoryId).toList();
    }

    // Apply quick filters
    if (selectedFilters.isNotEmpty) {
      result = result.where((product) {
        bool matchesFilter = false;
        for (final filter in selectedFilters) {
          switch (filter) {
            case 'On Sale':
              matchesFilter = product.oldPrice != null;
              break;
            case 'Top Rated':
              matchesFilter = product.rating >= 4.0;
              break;
            case 'New Arrivals':
              matchesFilter = DateTime.now().difference(product.createdAt).inDays <= 30;
              break;
            case 'Free Shipping':
              matchesFilter = product.shippingCost == 0;
              break;
          }
          if (matchesFilter) break;
        }
        return matchesFilter;
      }).toList();
    }
    filteredProducts = result;
    notifyListeners();
  }

  Future<void> fetchInitialData() async {
    try {
      isLoading = true;
      notifyListeners();
      
      final results = await Future.wait([
        MockShopService.getCategories(),
        MockShopService.getBanners(),
        MockShopService.getFeaturedProducts(),
        MockShopService.getPopularProducts(),
      ]);

      categories = results[0] as List<CategoryModel>;
      banners = results[1] as List<String>;
      featuredProducts = results[2] as List<ProductModel>;
      popularProducts = results[3] as List<ProductModel>;

      // Fetch first page of products
      await fetchNextPage(reset: true);
    } catch (e) {
      // Handle error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNextPage({bool reset = false}) async {
    if (reset) {
      currentPage = 0;
      allProducts.clear();
      hasReachedMax = false;
    }

    if (hasReachedMax) return;

    try {
      isLoadingMore = true;
      notifyListeners();

      // Simulate pagination by getting a subset of all products
      final allProductsFromService = await MockShopService.getAllProducts();
      
      // Determine start and end indices for the current page
      final startIndex = currentPage * pageSize;
      final endIndex = (startIndex + pageSize).clamp(0, allProductsFromService.length);      
      if (startIndex >= allProductsFromService.length) {
        hasReachedMax = true;
        return;
      }

      final newProducts = allProductsFromService.sublist(startIndex, endIndex);
      all```dart
// lib/presentation/screens/shop/shop_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/mock_shop_service.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  ValueNotifier<int> _itemCount = ValueNotifier<int>(0);
  int get itemCount => _itemCount.value;

  void addToCart() {
    _itemCount.value++;
    notifyListeners();
  }

  void removeFromCart() {
    if (_itemCount.value > 0) {
      _itemCount.value--;
      notifyListeners();
    }
  }

  void setItemCount(int count) {
    _itemCount.value = count;
    notifyListeners();
  }
}

class ShopController extends ChangeNotifier {
  List<CategoryModel> categories = [];
  List<String> banners = [];
  List<ProductModel> featuredProducts = [];
  List<ProductModel> popularProducts = [];  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasReachedMax = false;
  
  final Set<String> selectedFilters = <String>{};
  String? selectedCategoryId;
  int currentPage = 0;
  static const int pageSize = 10;

  void toggleFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
    _applyFilters();
  }

  void selectCategory(String? categoryId) {
    selectedCategoryId = categoryId;
    _applyFilters();
  }

  void _applyFilters() {
    List<ProductModel> result = List.from(allProducts);

    // Apply category filter
    if (selectedCategoryId != null) {
      result = result.where((product) => product.categoryId == selectedCategoryId).toList();
    }

    // Apply quick filters
    if (selectedFilters.isNotEmpty) {
      result = result.where((product) {
        bool matchesFilter = false;
        for (final filter in selectedFilters) {
          switch (filter) {
            case 'On Sale':
              matchesFilter = product.oldPrice != null;
              break;
            case 'Top Rated':
              matchesFilter = product.rating >= 4.0;
              break;
            case 'New Arrivals':
              matchesFilter = DateTime.now().difference(product.createdAt).inDays <= 30;
              break;
            case 'Free Shipping':
              matchesFilter = product.shippingCost == 0;              break;
          }
          if (matchesFilter) break;
        }
        return matchesFilter;
      }).toList();
    }

    filteredProducts = result;
    notifyListeners();
  }

  Future<void> fetchInitialData() async {
    try {
      isLoading = true;
      notifyListeners();
      
      final results = await Future.wait([
        MockShopService.getCategories(),
        MockShopService.getBanners(),
        MockShopService.getFeaturedProducts(),
        MockShopService.getPopularProducts(),
      ]);

      categories = results[0] as List<CategoryModel>;
      banners = results[1] as List<String>;
      featuredProducts = results[2] as List<ProductModel>;
      popularProducts = results[3] as List<ProductModel>;

      // Fetch first page of products
      await fetchNextPage(reset: true);
    } catch (e) {
      // Handle error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNextPage({bool reset = false}) async {
    if (reset) {
      currentPage = 0;
      allProducts.clear();
      hasReachedMax = false;
    }

    if (hasReachedMax) return;

    try {
      isLoadingMore = true;      notifyListeners();

      // Simulate pagination by getting a subset of all products
      final allProductsFromService = await MockShopService.getAllProducts();
      
      // Determine start and end indices for the current page
      final startIndex = currentPage * pageSize;
      final endIndex = (startIndex + pageSize).clamp(0, allProductsFromService.length);
      
      if (startIndex >= allProductsFromService.length) {
        hasReachedMax = true;
        return;
      }

      final newProducts = allProductsFromService.sublist(startIndex, endIndex);
      allProducts.addAll(newProducts);
      
      // Apply filters again after adding new products
      _applyFilters();
      
      if (endIndex >= allProductsFromService.length) {
        hasReachedMax = true;
      } else {
        currentPage++;
      }
    } catch (e) {
      // Handle error
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }
}

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late ShopController _controller;
  final PageController _bannerController = PageController();
  final ScrollController _scrollController = ScrollController();
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();    _controller = ShopController();
    _controller.fetchInitialData();
    _startBannerAutoScroll();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_controller.banners.isEmpty) return;
      if (_bannerController.hasClients) {
        final nextPage = (_bannerController.page?.round() ?? 0 + 1) % _controller.banners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500) {
      if (!_controller.isLoadingMore && !_controller.hasReachedMax) {
        _controller.fetchNextPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: RefreshIndicator(
        onRefresh: () => _controller.fetchInitialData(),
        color: AppColors.electricBlue,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,              snap: false,
              backgroundColor: AppColors.background,
              title: Text("Shop", style: AppTextStyles.h4.copyWith(color: AppColors.white)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: AppColors.white),
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopSearchScreen()));
                  },
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.white),
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                      },
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: ValueListenableBuilder<int>(
                        valueListenable: CartService().itemCount,
                        builder: (context, count, child) {
                          if (count == 0) return const SizedBox.shrink();
                          return Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.electricBlue,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$count',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: _buildCategoryChips(),
            ),
            SliverToBoxAdapter(
              child: _buildBannerCarousel(),
            ),            SliverToBoxAdapter(
              child: _buildQuickFilters(),
            ),
            SliverToBoxAdapter(
              child: _buildSectionHeaderWithToggle(
                title: 'Featured Brands',
                onToggle: () {
                  // Toggle between grid/list view
                },
              ),
            ),
            SliverToBoxAdapter(
              child: _buildFeaturedBrands(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "Recommended For You",
                  style: AppTextStyles.h5.copyWith(color: AppColors.white),
                ),
              ),
            ),
            _buildProductFeed(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  "Popular Right Now",
                  style: AppTextStyles.h5.copyWith(color: AppColors.white),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildPopularSection(),
            ),
            if (_controller.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.electricBlue),
                  ),
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      child: ValueListenableBuilder(
        valueListenable: ValueNotifier(_controller.categories),
        builder: (context, categories, child) {
          if (_controller.isLoading) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator(color: AppColors.electricBlue)),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _controller.selectedCategoryId == category.id;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category.name),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    _controller.selectCategory(selected ? category.id : null);
                  },
                  selectedColor: AppColors.electricBlue.withOpacity(0.2),
                  backgroundColor: AppColors.grey.withOpacity(0.3),
                  side: BorderSide(
                    color: isSelected ? AppColors.electricBlue : Colors.transparent,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.electricBlue : AppColors.grey2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  Widget _buildBannerCarousel() {
    return ValueListenableBuilder(
      valueListenable: ValueNotifier(_controller.banners),
      builder: (context, banners, child) {
        if (_controller.isLoading || banners.isEmpty) {
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return Column(
          children: [
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _bannerController,
                onPageChanged: (index) {
                  // We don't need setState since we're using PageView's built-in state
                },
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(banners[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(banners.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (_bannerController.page?.round() ?? 0) == index 
                        ? AppColors.electricBlue 
                        : AppColors.grey2.withOpacity(0.5),
                  ),
                );
              }),
            ),          ],
        );
      },
    );
  }

  Widget _buildQuickFilters() {
    final filters = ['On Sale', 'Free Shipping', 'Top Rated', 'New Arrivals'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _controller.selectedFilters.contains(filter);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (_) => _controller.toggleFilter(filter),
              backgroundColor: Colors.transparent,
              selectedColor: AppColors.electricBlue.withOpacity(0.1),
              checkmarkColor: AppColors.electricBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.electricBlue : AppColors.grey2.withOpacity(0.3),
                ),
              ),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.electricBlue : AppColors.white,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeaderWithToggle({required String title, required VoidCallback onToggle}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.h5.copyWith(color: AppColors.white)),          TextButton.icon(
            onPressed: onToggle,
            icon: Icon(
              Icons.grid_view,
              color: AppColors.grey2,
              size: 20,
            ),
            label: Text(
              "Grid",
              style: const TextStyle(color: AppColors.grey2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedBrands() {
    final brands = ['Nike', 'Adidas', 'Sony', 'Apple', 'Samsung', 'Zara'];
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey2.withOpacity(0.1)),
            ),
            child: Center(
              child: Text(
                brands[index],
                style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold, color: AppColors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductFeed() {
    return ValueListenableBuilder(
      valueListenable: ValueNotifier(_controller.filteredProducts),      builder: (context, products, child) {
        if (_controller.isLoading) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => const _ProductCardShimmer(),
                childCount: 4,
              ),
            ),
          );
        }

        if (products.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No products found',
                  style: AppTextStyles.body1.copyWith(color: AppColors.grey2),
                ),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < products.length) {
                  return _ProductCard(product: products[index]);
                } else {
                  return const SizedBox.shrink();
                }
              },              childCount: products.length,
              addAutomaticKeepAlives: true,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopularSection() {
    return ValueListenableBuilder(
      valueListenable: ValueNotifier(_controller.popularProducts),
      builder: (context, products, child) {
        if (products.isEmpty) {
          return const SizedBox.shrink();
        }
        return SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: _ProductCard(product: products[index]),
              );
            },
          ),
        );
      },
    );
  }
}

class _ProductCardShimmer extends StatelessWidget {
  const _ProductCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey.withOpacity(0.3),
      highlightColor: AppColors.grey.withOpacity(0.1),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.4),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity * 0.8,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 60,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.electricBlue.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
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
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        product.imageUrls.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: AppColors.grey, child: const Center(child: Icon(Icons.image_not_supported, color: AppColors.grey2))),
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
                          borderRadius: BorderRadius.circular(4),                        ),
                        child: Text(
                          '-${product.discountPercentage}%',
                          style: const TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.black38,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 16,
                        icon: Icon(
                          product.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: product.isFavorite ? AppColors.neonRed : AppColors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.name,
                    style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.yellow.shade700),
                      const SizedBox(width: 4),
                      Text(                        product.rating.toString(),
                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
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
                        const SizedBox(width: 6),
                        Text(
                          '\$${product.oldPrice!.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: AppColors.grey2.withOpacity(0.7),
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductListItem extends StatelessWidget {
  final ProductModel product;
  const _ProductListItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
      },
      child: Container(        height: 120,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.network(
                product.imageUrls.first,
                width: 100,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.brand, style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
                        Text(product.name, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.electricBlue, fontWeight: FontWeight.bold)),
                            if (product.oldPrice != null)
                              Text('\$${product.oldPrice!.toStringAsFixed(2)}', style: TextStyle(decoration: TextDecoration.lineThrough, fontSize: 11, color: AppColors.grey2)),
                          ],
                        ),
                        IconButton(
                          icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border, color: product.isFavorite ? AppColors.neonRed : AppColors.grey2),
                          onPressed: () {},
                        )
                      ],
                    )
                  ],
                ),              ),
            )
          ],
        ),
      ),
    );
  }
}
