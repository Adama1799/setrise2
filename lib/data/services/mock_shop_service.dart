// lib/data/services/cart_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);
  
  final ValueNotifier<List<CartItem>> _itemsNotifier = ValueNotifier([]);
  ValueListenable<List<CartItem>> get itemsListenable => _itemsNotifier;

  double get subtotal => _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  void addToCart(CartItem item) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    _notify();
  }

  void removeFromCart(String id) {
    _items.removeWhere((item) => item.id == id);
    _notify();
  }

  void updateQuantity(String id, int quantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
    }
    _notify();
  }

  void clear() {
    _items.clear();
    _notify();
  }

  void _notify() {
    _itemsNotifier.value = List.from(_items);
    notifyListeners();
  }
}}
