// lib/core/extensions/string_extensions.dart
extension StringExtensions on String {
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(this);
  }

  bool get isValidPassword => length >= 8;

  bool get isValidUsername => length >= 3 && !contains(' ');

  String capitalize() => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  String truncate(int maxLength) =>
      length > maxLength ? '${substring(0, maxLength)}...' : this;

  List<String> extractMentions() {
    final regex = RegExp(r'@(\w+)');
    return regex.allMatches(this).map((m) => m.group(1) ?? '').toList();
  }

  List<String> extractHashtags() {
    final regex = RegExp(r'#(\w+)');
    return regex.allMatches(this).map((m) => m.group(1) ?? '').toList();
  }
}
