// lib/data/mock_data/shop_mock_data.dart
import 'package:setrise/data/models/product_model.dart';

class ShopMockData {
  static List<ProductModel> getFeaturedProducts() => List.generate(
    6,
    (i) => ProductModel(
      id: 'feat$i',
      name: 'Featured Product $i',
      brandName: 'Brand $i',       // استخدم brandName فقط
      price: 19.99 + i,
      oldPrice: i % 2 == 0 ? 39.99 : null,
      description: 'Description of product $i',
      images: ['https://picsum.photos/400/400?random=4$i'],
      rating: 4.5,
      reviewsCount: 100,
      isFavorite: false,
      discountPercentage: i % 2 == 0 ? 50 : 0,
      videoUrl: null,
    ),
  );

  static List<ProductModel> getPopularProducts() => [];
  static List<ProductModel> getProductsForCategory(String id) => [];
}
