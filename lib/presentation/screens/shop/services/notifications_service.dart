// lib/presentation/screens/shop/services/notifications_service.dart
import 'dart:async';

class NotificationItem {
  final String id, title, body, type; // order, promotion, auction
  final DateTime time;
  bool isRead;
  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.time,
    this.isRead = false,
  });
}

class NotificationsService {
  static final NotificationsService _instance = NotificationsService._();
  factory NotificationsService() => _instance;
  NotificationsService._();

  final List<NotificationItem> _notifications = [];
  final StreamController<List<NotificationItem>> _controller = StreamController.broadcast();

  Stream<List<NotificationItem>> get stream => _controller.stream;
  List<NotificationItem> get items => List.unmodifiable(_notifications);

  void initialize() {
    _notifications.clear();
    _notifications.addAll([
      NotificationItem(
          id: '1',
          title: 'Flash Sale!',
          body: 'Up to 70% off on electronics',
          type: 'promotion',
          time: DateTime.now().subtract(const Duration(hours: 2))),
      NotificationItem(
          id: '2',
          title: 'Order Shipped',
          body: 'Your order #123 has been shipped',
          type: 'order',
          time: DateTime.now().subtract(const Duration(hours: 5))),
      NotificationItem(
          id: '3',
          title: 'Auction Ending!',
          body: 'iPhone auction ends in 10 minutes',
          type: 'auction',
          time: DateTime.now().subtract(const Duration(minutes: 45))),
    ]);
    _controller.add(_notifications);
  }

  void add(NotificationItem item) {
    _notifications.insert(0, item);
    _controller.add(_notifications);
  }

  void markAllRead() {
    for (var n in _notifications) { n.isRead = true; }
    _controller.add(_notifications);
  }

  void dispose() {
    _controller.close();
  }
}
