// services/order_service.dart
import '../models/order_model.dart';

class OrderService extends ChangeNotifier {
  final List<Order> _orders = [];
  List<Order> get orders => List.unmodifiable(_orders);

  void placeOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }
}
