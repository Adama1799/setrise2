// lib/data/models/product_model.dart

class ProductModel {
  final String id;
  final String name;
  final String brandName;
  final String categoryId;
  final String description;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviewsCount;
  final int stock;
  final List<String> images;
  final List<String> sizes;
  final List<String> colors;
  final bool isFeatured;
  final bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.brandName,
    required this.categoryId,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviewsCount,
    required this.stock,
    required this.images,
    required this.sizes,
    required this.colors,
    this.isFeatured = false,
    this.isFavorite = false,
  });

  double get discountPercentage {
    if (oldPrice != null && oldPrice! > price) {
      return ((oldPrice! - price) / oldPrice!) * 100;
    }
    return 0;
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? brandName,
    String? categoryId,
    String? description,
    double? price,
    double? oldPrice,
    double? rating,
    int? reviewsCount,
    int? stock,
    List<String>? images,
    List<String>? sizes,
    List<String>? colors,
    bool? isFeatured,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brandName: brandName ?? this.brandName,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      stock: stock ?? this.stock,
      images: images ?? this.images,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      isFeatured: isFeatured ?? this.isFeatured,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
