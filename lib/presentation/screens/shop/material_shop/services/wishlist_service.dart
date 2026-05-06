import 'package:flutter/material.dart';
import '../models/product_model.dart';

class WishlistService extends ChangeNotifier {
  final List<ProductModel> _items = [];
  List<ProductModel> get items => List.unmodifiable(_items);

  void toggle(ProductModel product) {
    if (_items.any((p) => p.id == product.id)) {
      _items.removeWhere((p) => p.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  bool isFavorite(String productId) => _items.any((p) => p.id == productId);
}
