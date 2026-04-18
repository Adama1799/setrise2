// lib/data/services/mock_shop_service.dart
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/auction_model.dart';
import '../models/seller_model.dart';

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

  // ✅ الدوال المفقودة التي تسبب الأخطاء
  static Future<List<SellerModel>> getTrendingSellers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      SellerModel(id: 's1', name: 'Tech Store', avatar: 'https://picsum.photos/200?random=1', isVerified: true),
      SellerModel(id: 's2', name: 'Fashion Hub', avatar: 'https://picsum.photos/200?random=2', isVerified: true),
      SellerModel(id: 's3', name: 'Home Decor', avatar: 'https://picsum.photos/200?random=3', isVerified: false),
    ];
  }

  static Future<List<AuctionModel>> getLiveAuctions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      AuctionModel(
        id: 'a1',
        title: 'Vintage Watch',
        currentBid: 450.0,
        imageUrl: 'https://picsum.photos/200?random=10',
        endTime: DateTime.now().add(const Duration(hours: 2)),
      ),
      AuctionModel(
        id: 'a2',
        title: 'Gaming Laptop',
        currentBid: 1200.0,
        imageUrl: 'https://picsum.photos/200?random=11',
        endTime: DateTime.now().add(const Duration(hours: 5)),
      ),
    ];
  }

  static final List<CategoryModel> _mockCategories = [
    CategoryModel(id: 'cat_1', name: 'Electronics', icon: 'devices', color: Color(0xFF0066FF)),
    CategoryModel(id: 'cat_2', name: 'Fashion', icon: 'checkroom', color: Color(0xFFFF00CC)),
    CategoryModel(id: 'cat_3', name: 'Home & Living', icon: 'chair', color: Color(0xFF8B4513)),
    CategoryModel(id: 'cat_4', name: 'Sports', icon: 'sports_soccer', color: Color(0xFF39FF14)),
    CategoryModel(id: 'cat_5', name: 'Beauty', icon: 'face', color: Color(0xFF800080)),
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
      description: 'Premium wireless headphones with active noise cancellation.',
      categoryId: 'cat_1',
      tags: ['featured', 'audio'],
    ),
    // ... يمكنك إضافة باقي المنتجات من ملفك السابق
  ];
}
