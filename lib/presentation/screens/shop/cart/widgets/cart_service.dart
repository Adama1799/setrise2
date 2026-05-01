// lib/presentation/screens/shop/cart/cart_service.dart
import 'package:flutter/foundation.dart';

class CartItem {
  final String id, name, brand, imageUrl;
  final double price;
  int quantity;
  CartItem({required this.id, required this.name, required this.brand, required this.price, required this.imageUrl, this.quantity = 1});
}

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);
  double get subtotal => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  final ValueNotifier<List<CartItem>> itemsNotifier = ValueNotifier([]);

  void addItem(CartItem item) {
    final idx = _items.indexWhere((i) => i.id == item.id);
    if (idx != -1) {
      _items[idx].quantity++;
    } else {
      _items.add(item);
    }
    itemsNotifier.value = List.from(_items);
    notifyListeners();
  }

  void removeFromCart(String id) {
    _items.removeWhere((i) => i.id == id);
    itemsNotifier.value = List.from(_items);
    notifyListeners();
  }

  void updateQuantity(String id, int newQty) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx != -1) {
      if (newQty <= 0) {
        _items.removeAt(idx);
      } else {
        _items[idx].quantity = newQty;
      }
      itemsNotifier.value = List.from(_items);
      notifyListeners();
    }
  }
}
