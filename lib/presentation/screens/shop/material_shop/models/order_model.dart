import 'cart_model.dart';

enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double total;
  final OrderStatus status;
  final DateTime? createdAt;
  final String? trackingNumber;

  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    this.status = OrderStatus.pending,
    this.createdAt,
    this.trackingNumber,
  });
}
