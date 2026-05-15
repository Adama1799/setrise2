import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

/// CartService — متوافق مع CartItem الـ immutable
/// ملاحظة: استخدم cart_provider.dart (Riverpod) في الشاشات الجديدة
class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.product.price * item.quantity);

  void addItem(ProductModel product, {int quantity = 1}) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      // CartItem is immutable — replace with new instance
      _items[index] = CartItem(
        product: _items[index].product,
        quantity: _items[index].quantity + quantity,
      );
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  void increment(int index) {
    if (index < 0 || index >= _items.length) return;
    _items[index] = CartItem(
      product: _items[index].product,
      quantity: _items[index].quantity + 1,
    );
    notifyListeners();
  }

  void decrement(int index) {
    if (index < 0 || index >= _items.length) return;
    if (_items[index].quantity > 1) {
      _items[index] = CartItem(
        product: _items[index].product,
        quantity: _items[index].quantity - 1,
      );
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
