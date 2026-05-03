// models/order_model.dart
import 'cart_model.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime date;
  final String status; // pending, shipped, delivered
  final String? trackingNumber;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    this.status = 'pending',
    this.trackingNumber,
  });
}
