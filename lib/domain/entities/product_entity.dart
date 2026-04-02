// lib/domain/entities/product_entity.dart
class ProductEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final List<String> images;
  final double rating;
  final int reviewsCount;
  final int stock;
  final bool isFavorite;
  final String category;
  final bool onSale;
  final int discount;

  ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.images,
    required this.rating,
    required this.reviewsCount,
    required this.stock,
    required this.isFavorite,
    required this.category,
    required this.onSale,
    required this.discount,
  });
}
