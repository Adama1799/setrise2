// services/product_service.dart
import '../models/product_model.dart';

class ProductService {
  final List<Product> _products = List.generate(
    30,
    (i) => Product(
      id: i + 1,
      title: 'Product ${i + 1}',
      description: 'Description for product ${i + 1}',
      images: ['assets/images/ps4_console_white_1.png'],
      colors: [Colors.white, Colors.black, Colors.blue],
      price: 10.0 + (i * 5),
      rating: 3.5 + (i % 3) * 0.5,
      isPopular: i < 10,
      isFavourite: i % 3 == 0,
    ),
  );

  List<Product> getProducts() => _products;

  List<Product> searchProducts(String query) {
    return _products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Product? getProductById(int id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
