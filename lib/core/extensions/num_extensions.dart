// lib/core/extensions/num_extensions.dart
extension NumExtensions on num {
  String toFormattedString() {
    if (this >= 1000000) return '${(this / 1000000).toStringAsFixed(1)}M';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}K';
    return toString();
  }

  String toCurrency() => '\$${toStringAsFixed(2)}';
}
