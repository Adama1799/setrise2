// lib/data/services/mock_shop_service.dart

import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class MockShopService {
  static Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockCategories;
  }

  static Future<List<ProductModel>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockProducts.where((p) => p.tags.contains('featured')).toList();
  }

  static Future<List<ProductModel>> getPopularProducts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    var sorted = List<ProductModel>.from(_mockProducts);
    sorted.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
    return sorted.take(5).toList();
  }

  static Future<List<String>> getBanners() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      'https://picsum.photos/800/400?random=10',
      'https://picsum.photos/800/400?random=11',
      'https://picsum.photos/800/400?random=12',
    ];
  }

  static Future<List<ProductModel>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockProducts;
  }

  static Future<List<ProductModel>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.isEmpty) return [];
    return _mockProducts
        .where((p) =>
            p.name.toLowerCase().contains(query.toLowerCase()) ||
            p.brand.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static Future<List<ProductModel>> getSimilarProducts(ProductModel product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockProducts
        .where((p) => p.categoryId == product.categoryId && p.id != product.id)
        .take(5)
        .toList();
  }

  static final List<CategoryModel> _mockCategories = [
    CategoryModel(id: 'cat_1', name: 'Electronics', icon: 'devices', color: Colors.blue),
    CategoryModel(id: 'cat_2', name: 'Fashion', icon: 'checkroom', color: Colors.pink),
    CategoryModel(id: 'cat_3', name: 'Home & Living', icon: 'chair', color: Colors.brown),
    CategoryModel(id: 'cat_4', name: 'Sports', icon: 'sports_soccer', color: Colors.green),
    CategoryModel(id: 'cat_5', name: 'Beauty', icon: 'face', color: Colors.purple),
  ];

  static final List<ProductModel> _mockProducts = [
    ProductModel(
      id: 'prod_1',
      name: 'Wireless Noise Cancelling Headphones',
      brand: 'SoundCore',
      price: 249.99,
      oldPrice: 299.99,
      rating: 4.8,
      reviewsCount: 1250,
      stock: 15,
      imageUrls: ['https://picsum.photos/400/400?random=1', 'https://picsum.photos/400/400?random=2'],
      description: 'Premium wireless headphones with active noise cancellation and 30-hour battery life.',
      categoryId: 'cat_1',
      tags: ['featured', 'audio', 'wireless'],
    ),
    ProductModel(
      id: 'prod_2',
      name: 'Minimalist Leather Watch',
      brand: 'NordTime',
      price: 120.00,
      rating: 4.5,
      reviewsCount: 340,
      stock: 50,
      imageUrls: ['https://picsum.photos/400/400?random=3'],
      description: 'Elegant genuine leather watch with a stainless steel case.',
      categoryId: 'cat_2',
      tags: ['featured', 'accessories'],
    ),
    ProductModel(
      id: 'prod_3',
      name: 'Smart 4K Action Camera',
      brand: 'GoVision',
      price: 399.00,
      oldPrice: 450.00,
      rating: 4.7,
      reviewsCount: 890,
      stock: 8,
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      imageUrls: ['https://picsum.photos/400/400?random=4'],
      description: 'Waterproof 4K action camera with stabilization.',
      categoryId: 'cat_1',
      tags: ['featured', 'camera', 'tech'],
    ),
    ProductModel(
      id: 'prod_4',
      name: 'Ergonomic Office Chair',
      brand: 'ComfortPro',
      price: 199.99,
      rating: 4.2,
      reviewsCount: 2100,
      stock: 20,
      imageUrls: ['https://picsum.photos/400/400?random=5'],
      description: 'Mesh back office chair with lumbar support.',
      categoryId: 'cat_3',
      tags: ['furniture', 'office'],
    ),
    ProductModel(
      id: 'prod_5',
      name: 'Running Sneakers Pro',
      brand: 'SpeedX',
      price: 85.50,
      oldPrice: 110.00,
      rating: 4.6,
      reviewsCount: 5600,
      stock: 100,
      imageUrls: ['https://picsum.photos/400/400?random=6'],
      description: 'Lightweight running shoes with breathable mesh.',
      categoryId: 'cat_4',
      tags: ['shoes', 'sports', 'running'],
    ),
    ProductModel(
      id: 'prod_6',
      name: 'Organic Face Serum',
      brand: 'GlowNature',
      price: 45.00,
      rating: 4.9,
      reviewsCount: 3200,
      stock: 45,
      imageUrls: ['https://picsum.photos/400/400?random=7'],
      description: 'Hydrating serum with vitamin C and hyaluronic acid.',
      categoryId: 'cat_5',
      tags: ['skincare', 'beauty', 'organic'],
    ),
  ];
}
