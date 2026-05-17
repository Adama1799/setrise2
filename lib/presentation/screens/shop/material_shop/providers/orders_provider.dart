// lib/presentation/screens/shop/material_shop/providers/orders_provider.dart
//
// ✅ FIX: ordersProvider مع placeOrder(CartState) — يُصلح خطأ checkout_screen
// ──────────────────────────────────────────────────────────────

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/order_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/cart_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/cart_provider.dart';

// ─────────────────────────────────────────────────────────────
// OrdersNotifier — ✅ يحتوي على placeOrder(CartState)
// ─────────────────────────────────────────────────────────────
class OrdersNotifier extends StateNotifier<List<OrderModel>> {
  OrdersNotifier() : super([]);

  /// ✅ المتوقع من checkout_screen:
  /// ref.read(ordersProvider.notifier).placeOrder(cart);
  void placeOrder(CartState cart) {
    if (cart.items.isEmpty) return;

    final order = OrderModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: List<CartItem>.from(cart.items),
      total: cart.total,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );

    state = [order, ...state];
  }

  void cancelOrder(String orderId) {
    state = [
      for (final o in state)
        if (o.id == orderId)
          OrderModel(
            id: o.id,
            items: o.items,
            total: o.total,
            status: OrderStatus.cancelled,
            createdAt: o.createdAt,
            trackingNumber: o.trackingNumber,
          )
        else
          o,
    ];
  }
}

// ✅ Provider الرئيسي — يُستخدم في checkout_screen
final ordersProvider =
    StateNotifierProvider<OrdersNotifier, List<OrderModel>>(
  (_) => OrdersNotifier(),
);

// ─────────────────────────────────────────────────────────────
// بيانات وهمية للعرض في orders_screen
// ─────────────────────────────────────────────────────────────
final activeOrdersProvider = FutureProvider<List<OrderModel>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    OrderModel(
      id: 'ORD-001',
      items: [
        CartItem(
          product: ProductModel(
            id: '1',
            name: 'Sample Product',
            brand: 'Brand',
            price: 29.99,
          ),
          quantity: 2,
        ),
      ],
      total: 59.98,
      status: OrderStatus.shipped,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      trackingNumber: 'TRK123456',
    ),
  ];
});

final completedOrdersProvider = FutureProvider<List<OrderModel>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    OrderModel(
      id: 'ORD-003',
      items: [
        CartItem(
          product: ProductModel(
            id: '3',
            name: 'Delivered Product',
            brand: 'Brand',
            price: 19.99,
          ),
          quantity: 1,
        ),
      ],
      total: 19.99,
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];
});
