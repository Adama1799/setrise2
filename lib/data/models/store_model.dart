// lib/data/models/store_model.dart

import 'product_model.dart';

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
