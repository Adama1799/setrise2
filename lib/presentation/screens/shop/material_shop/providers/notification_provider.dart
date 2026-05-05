import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';

final notificationProvider = FutureProvider<List<NotificationModel>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 800));
  return [
    NotificationModel(
      id: '1',
      title: 'Order Shipped',
      body: 'Your order #123 has been shipped!',
      type: NotificationType.orderShipped,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: '2',
      title: 'Flash Sale!',
      body: 'Up to 70% off on electronics',
      type: NotificationType.flashSaleStart,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationModel(
      id: '3',
      title: 'Back in Stock',
      body: 'The item you wanted is available again',
      type: NotificationType.backInStock,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
});

final unreadCountProvider = Provider<int>((ref) {
  final notifsAsync = ref.watch(notificationProvider);
  return notifsAsync.when(data: (list) => list.where((n) => !n.isRead).length, loading: () => 0, error: (_, __) => 0);
});
