// lib/data/services/mock_shop_service.dart
import '../models/product_model.dart';

class MockShopService {
  static Future<List<ProductModel>> getSimilarProducts(ProductModel product) async {
    // إرجاع قائمة فارغة مؤقتًا
    return [];
  }

  static Future<List<ProductModel>> getAllProducts() async {
    return Future.delayed(const Duration(milliseconds: 500), () => []);
  }
}
