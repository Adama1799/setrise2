// material_shop/services/wishlist_service.dart
import 'package:flutter/material.dart';
import '../models/product_model.dart';

class WishlistService extends ChangeNotifier {
  final List<Product> _items = [];
  List<Product> get items => List.unmodifiable(_items);

  void toggle(Product product) {
    if (_items.any((p) => p.id == product.id)) {
      _items.removeWhere((p) => p.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  bool isFavorite(int productId) => _items.any((p) => p.id == productId);
}
