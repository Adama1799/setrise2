// lib/data/models/store_model.dart
class Store {
  final String id, name, description, logoUrl;
  final double rating;
  final double distance;
  final int reviewCount;
  final bool isActive, isVerified;

  Store({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.rating,
    required this.distance,
    required this.reviewCount,
    this.isActive = true,
    this.isVerified = true,
  });

  static List<Store> getMockStores() => [
    Store(
      id: '1',
      name: 'Tech Store',
      description: 'Best electronics',
      logoUrl: 'https://picsum.photos/200/200?random=31',
      rating: 4.8,
      distance: 2.5,
      reviewCount: 120,
    ),
    Store(
      id: '2',
      name: 'Fashion Hub',
      description: 'Trendy clothes',
      logoUrl: 'https://picsum.photos/200/200?random=32',
      rating: 4.5,
      distance: 5.0,
      reviewCount: 80,
    ),
  ];
}
