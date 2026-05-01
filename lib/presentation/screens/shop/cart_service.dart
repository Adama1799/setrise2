// lib/presentation/screens/shop/cart_service.dart
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String imageUrl;
  final String brand;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.imageUrl,
    required this.brand,
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}

class CartService {
  static final CartService _instance = CartService._();
  factory CartService() => _instance;
  CartService._();

  final ValueNotifier<List<CartItem>> items = ValueNotifier([]);

  double get subtotal => items.value.fold(0, (sum, item) => sum + item.price * item.quantity);

  void addItem(CartItem item) {
    final idx = items.value.indexWhere((i) => i.id == item.id);
    if (idx != -1) {
      items.value[idx].quantity += item.quantity;
    } else {
      items.value.add(item);
    }
    items.notifyListeners();
  }

  void removeFromCart(String id) {
    items.value.removeWhere((i) => i.id == id);
    items.notifyListeners();
  }

  void updateQuantity(String id, int qty) {
    if (qty <= 0) {
      removeFromCart(id);
      return;
    }
    final idx = items.value.indexWhere((i) => i.id == id);
    if (idx != -1) {
      items.value[idx].quantity = qty;
      items.notifyListeners();
    }
  }
}
