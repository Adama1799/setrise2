// lib/data/models/cart_item.dart
import 'product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;
  String? selectedSize;
  String? selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  double get totalPrice => product.price * quantity;
}
