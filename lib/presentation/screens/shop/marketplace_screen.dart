// lib/presentation/screens/shop/marketplace_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'store_profile_screen.dart';
import 'chat_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<Store> _stores = Store.getMockStores();
  final List<String> _filters = ['All', 'Top Rated', 'Nearby', 'Recently Active'];

  List<Store> get _filteredStores {
    if (_selectedFilter == 'All') return _stores;
    if (_selectedFilter == 'Top Rated') {
      return _stores.where((s) => s.rating >= 4.5).toList();
    }
    if (_selectedFilter == 'Nearby') {
      return _stores.where((s) => s.distance <= 10).toList();
    }
    if (_selectedFilter == 'Recently Active') {
      return _stores.where((s) => s.isActive).toList();
    }
    return _stores;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Marketplace',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Search stores or sellers...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey2,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.grey2,
                ),
                filled: true,
                fillColor: AppColors.grey.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Filter chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.shop
                          : AppColors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      filter,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isSelected ? AppColors.black : AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Stores list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredStores.length,
              itemBuilder: (context, index) {
                final store = _filteredStores[index];
                return _StoreCard(store: store);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final Store store;

  const _StoreCard({required this.store});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StoreProfileScreen(store: store),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.grey.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            // Store logo
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                store.logoUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 70,
                  height: 70,
                  color: AppColors.grey,
                  child: const Icon(
                    Icons.store,
                    color: AppColors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Store info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          store.name,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (store.isVerified)
                        const Icon(
                          Icons.verified_rounded,
                          color: AppColors.electricBlue,
                          size: 18,
                        ),
                      if (store.isActive)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.neonGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    store.description,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.grey2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        store.rating.toStringAsFixed(1),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${store.reviewCount} reviews)',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.grey2,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.grey2,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${store.distance} km',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.grey2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  storeName: store.name,
                                  storeId: store.id,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.shop.withOpacity(0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Message',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.shop,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StoreProfileScreen(store: store),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.shop,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'View Store',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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

// ===== STORE MODEL =====
class Store {
  final String id;
  final String name;
  final String logoUrl;
  final String description;
  final double rating;
  final int reviewCount;
  final double distance;
  final bool isVerified;
  final bool isActive;
  final List<Product> featuredProducts;

  Store({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.isVerified,
    required this.isActive,
    required this.featuredProducts,
  });

  static List<Store> getMockStores() {
    return [
      Store(
        id: '1',
        name: 'Tech Gadgets Store',
        logoUrl: 'https://picsum.photos/200?random=1',
        description: 'Your one-stop shop for the latest tech gadgets',
        rating: 4.8,
        reviewCount: 1240,
        distance: 2.5,
        isVerified: true,
        isActive: true,
        featuredProducts: [],
      ),
      Store(
        id: '2',
        name: 'Fashion Hub',
        logoUrl: 'https://picsum.photos/200?random=2',
        description: 'Trendy fashion for everyone',
        rating: 4.6,
        reviewCount: 890,
        distance: 5.0,
        isVerified: true,
        isActive: true,
        featuredProducts: [],
      ),
      Store(
        id: '3',
        name: 'Home Decor Center',
        logoUrl: 'https://picsum.photos/200?random=3',
        description: 'Beautiful home decor items',
        rating: 4.7,
        reviewCount: 560,
        distance: 8.2,
        isVerified: false,
        isActive: true,
        featuredProducts: [],
      ),
      Store(
        id: '4',
        name: 'Sporting Goods Pro',
        logoUrl: 'https://picsum.photos/200?random=4',
        description: 'Premium sports equipment',
        rating: 4.9,
        reviewCount: 2100,
        distance: 3.1,
        isVerified: true,
        isActive: true,
        featuredProducts: [],
      ),
      Store(
        id: '5',
        name: 'Beauty & Cosmetics',
        logoUrl: 'https://picsum.photos/200?random=5',
        description: 'Luxury beauty products',
        rating: 4.5,
        reviewCount: 720,
        distance: 12.4,
        isVerified: false,
        isActive: false,
        featuredProducts: [],
      ),
    ];
  }
}
// أضف هذا في نهاية marketplace_screen.dart
class Store {
  final String id;
  final String name;
  final String logoUrl;
  final String description;
  final double rating;
  final int reviewCount;
  final double distance;
  final bool isVerified;
  final bool isActive;
  final List<ProductModel> featuredProducts;

  Store({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.isVerified,
    required this.isActive,
    required this.featuredProducts,
  });

  static List<Store> getMockStores() {
    return [
      Store(
        id: '1', name: 'Tech Gadgets Store', logoUrl: 'https://picsum.photos/200?random=1',
        description: 'Your one-stop shop for the latest tech gadgets',
        rating: 4.8, reviewCount: 1240, distance: 2.5, isVerified: true, isActive: true,
        featuredProducts: [],
      ),
      Store(
        id: '2', name: 'Fashion Hub', logoUrl: 'https://picsum.photos/200?random=2',
        description: 'Trendy fashion for everyone',
        rating: 4.6, reviewCount: 890, distance: 5.0, isVerified: true, isActive: true,
        featuredProducts: [],
      ),
      Store(
        id: '3', name: 'Home Decor Center', logoUrl: 'https://picsum.photos/200?random=3',
        description: 'Beautiful home decor items',
        rating: 4.7, reviewCount: 560, distance: 8.2, isVerified: false, isActive: true,
        featuredProducts: [],
      ),
      Store(
        id: '4', name: 'Sporting Goods Pro', logoUrl: 'https://picsum.photos/200?random=4',
        description: 'Premium sports equipment',
        rating: 4.9, reviewCount: 2100, distance: 3.1, isVerified: true, isActive: true,
        featuredProducts: [],
      ),
      Store(
        id: '5', name: 'Beauty & Cosmetics', logoUrl: 'https://picsum.photos/200?random=5',
        description: 'Luxury beauty products',
        rating: 4.5, reviewCount: 720, distance: 12.4, isVerified: false, isActive: false,
        featuredProducts: [],
      ),
    ];
  }
}
