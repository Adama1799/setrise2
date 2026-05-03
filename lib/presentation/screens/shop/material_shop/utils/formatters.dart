// utils/formatters.dart
class Formatters {
  static String price(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  static String date(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
