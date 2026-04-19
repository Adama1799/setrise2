// lib/data/models/cart_item.dart
class CartItem {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  int quantity;
  String? selectedSize;
  String? selectedColor;

  CartItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });
}
