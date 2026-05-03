// material_shop/services/notification_service.dart
import 'package:flutter/material.dart';

class NotificationItem {
  final String id, title, body, type;
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

class NotificationService extends ChangeNotifier {
  final List<NotificationItem> _items = [];
  List<NotificationItem> get items => List.unmodifiable(_items);
  int get unreadCount => _items.where((n) => !n.isRead).length;

  void add(NotificationItem item) {
    _items.insert(0, item);
    notifyListeners();
  }

  void markAllRead() {
    for (var n in _items) { n.isRead = true; }
    notifyListeners();
  }
}
