// lib/data/models/product_model.dart
import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required String id,
    required String name,
    required String description,
    required double price,
    required double originalPrice,
    required List<String> images,
    required double rating,
    required int reviewsCount,
    required int stock,
    required bool isFavorite,
    required String category,
    required bool onSale,
    required int discount,
  }) : super(
    id: id,
    name: name,
    description: description,
    price: price,
    originalPrice: originalPrice,
    images: images,
    rating: rating,
    reviewsCount: reviewsCount,
    stock: stock,
    isFavorite: isFavorite,
    category: category,
    onSale: onSale,
    discount: discount,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewsCount: json['reviewsCount'] ?? 0,
      stock: json['stock'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
      category: json['category'] ?? '',
      onSale: json['onSale'] ?? false,
      discount: json['discount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'originalPrice': originalPrice,
    'images': images,
    'rating': rating,
    'reviewsCount': reviewsCount,
    'stock': stock,
    'isFavorite': isFavorite,
    'category': category,
    'onSale': onSale,
    'discount': discount,
  };

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    List<String>? images,
    double? rating,
    int? reviewsCount,
    int? stock,
    bool? isFavorite,
    String? category,
    bool? onSale,
    int? discount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      stock: stock ?? this.stock,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      onSale: onSale ?? this.onSale,
      discount: discount ?? this.discount,
    );
  }
}
