import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

final activeOrdersProvider = FutureProvider<List<OrderModel>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    OrderModel(
      id: 'ORD-001',
      items: [
        CartItem(product: ProductModel(id: '1', name: 'Product 1', brand: 'Brand', price: 29.99), quantity: 2),
      ],
      total: 59.98,
      status: OrderStatus.shipped,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      trackingNumber: 'TRK123456',
    ),
    OrderModel(
      id: 'ORD-002',
      items: [
        CartItem(product: ProductModel(id: '2', name: 'Product 2', brand: 'Brand', price: 49.99), quantity: 1),
      ],
      total: 49.99,
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];
});

final completedOrdersProvider = FutureProvider<List<OrderModel>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    OrderModel(
      id: 'ORD-003',
      items: [
        CartItem(product: ProductModel(id: '3', name: 'Product 3', brand: 'Brand', price: 19.99), quantity: 1),
      ],
      total: 19.99,
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];
});
