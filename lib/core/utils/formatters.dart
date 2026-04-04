// lib/core/utils/formatters.dart
// BUG FIX: formatDate() called .toRelativeTime() without importing the extension
//           This caused a compile error: method not found on DateTime
import '../extensions/datetime_extensions.dart'; // ✅ ADDED

class Formatters {
  static String formatNumber(int number) {
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toString();
  }

  static String formatPrice(double price) => '\$${price.toStringAsFixed(2)}';

  static String formatDate(DateTime date) =>
      date.toRelativeTime(); // ✅ Now works with the import above

  static String formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
