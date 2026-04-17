// lib/data/models/product_model.dart

class ProductModel {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviewsCount;
  final int stock;
  final List<String> imageUrls;
  final String? videoUrl;
  final String description;
  final String categoryId;
  final DateTime createdAt;
  final double shippingCost;
  bool isFavorite;
  final List<String> tags;

  ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviewsCount,
    required this.stock,
    required this.imageUrls,
    this.videoUrl,
    required this.description,
    required this.categoryId,
    DateTime? createdAt,
    this.shippingCost = 5.99,
    this.isFavorite = false,
    this.tags = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  int get discountPercentage {
    if (oldPrice == null || oldPrice! <= price) return 0;
    return ((1 - (price / oldPrice!)) * 100).round();
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? brand,
    double? price,
    double? oldPrice,
    double? rating,
    int? reviewsCount,
    int? stock,
    List<String>? imageUrls,
    String? videoUrl,
    String? description,
    String? categoryId,
    DateTime? createdAt,
    double? shippingCost,
    bool? isFavorite,
    List<String>? tags,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      stock: stock ?? this.stock,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      shippingCost: shippingCost ?? this.shippingCost,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
    );
  }
}
