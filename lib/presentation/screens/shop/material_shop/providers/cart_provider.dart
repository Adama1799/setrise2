import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartState {
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double shipping;
  final double tax;
  final double total;
  final int itemCount;

  const CartState({
    this.items = const [],
    this.subtotal = 0,
    this.discount = 0,
    this.shipping = 0,
    this.tax = 0,
    this.total = 0,
    this.itemCount = 0,
  });
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(ProductModel product, Map<String, String> options, int quantity) {
    final existingIndex = state.items.indexWhere((item) => item.product.id == product.id);
    List<CartItem> updatedItems = List.from(state.items);

    if (existingIndex >= 0) {
      updatedItems[existingIndex] = CartItem(
        product: product,
        quantity: updatedItems[existingIndex].quantity + quantity,
      );
    } else {
      updatedItems.add(CartItem(product: product, quantity: quantity));
    }
    _updateState(updatedItems);
  }

  void removeItem(String productId) {
    final updatedItems = state.items.where((item) => item.product.id != productId).toList();
    _updateState(updatedItems);
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }
    final updatedItems = state.items.map((item) {
      if (item.product.id == productId) {
        return CartItem(product: item.product, quantity: newQuantity);
      }
      return item;
    }).toList();
    _updateState(updatedItems);
  }

  void clearCart() {
    state = const CartState();
  }

  void _updateState(List<CartItem> items) {
    final subtotal = items.fold<double>(0, (sum, item) => sum + (item.product.price * item.quantity));
    const discount = 0.0;
    final shipping = subtotal > 100 ? 0.0 : 5.99;
    final tax = subtotal * 0.08;
    final total = subtotal - discount + shipping + tax;
    final itemCount = items.fold<int>(0, (sum, item) => sum + item.quantity);

    state = CartState(
      items: items,
      subtotal: subtotal,
      discount: discount,
      shipping: shipping,
      tax: tax,
      total: total,
      itemCount: itemCount,
    );
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) => CartNotifier());
