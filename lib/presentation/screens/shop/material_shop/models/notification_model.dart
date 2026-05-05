enum NotificationType {
  orderPlaced,
  orderConfirmed,
  orderShipped,
  orderOutForDelivery,
  orderDelivered,
  orderCancelled,
  priceDrop,
  flashSaleStart,
  couponExpiring,
  backInStock,
  generic,
}

class NotificationModel {
  final String id, title, body;
  final NotificationType type;
  final DateTime? createdAt;
  final bool isRead;
  final bool isDismissed;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.type = NotificationType.generic,
    this.createdAt,
    this.isRead = false,
    this.isDismissed = false,
  });
}
