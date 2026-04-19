// lib/core/utils/formatters.dart
import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  // ── Currency ──────────────────────────────────────────────────────────────
  static String formatPrice(double amount, {String currency = 'DZD'}) {
    final formatter = NumberFormat.currency(
      locale: 'fr_DZ',
      symbol: currency,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatPriceCompact(double amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }

  // ── Numbers ───────────────────────────────────────────────────────────────
  static String formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  // ── Date / Time ───────────────────────────────────────────────────────────
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(date);
  }

  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      return '${duration.inHours}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, MMMM d').format(date);
  }

  // ── Distance ──────────────────────────────────────────────────────────────
  static String formatDistance(double meters) {
    if (meters >= 1000) return '${(meters / 1000).toStringAsFixed(1)} km';
    return '${meters.toStringAsFixed(0)} m';
  }

  // ── File size ─────────────────────────────────────────────────────────────
  static String formatFileSize(int bytes) {
    if (bytes >= 1073741824) return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
    if (bytes >= 1048576) return '${(bytes / 1048576).toStringAsFixed(2)} MB';
    if (bytes >= 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '$bytes B';
  }

  // ── Text ──────────────────────────────────────────────────────────────────
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  static String formatUsername(String name) {
    return '@${name.toLowerCase().replaceAll(' ', '_')}';
  }

  // ── Rating ────────────────────────────────────────────────────────────────
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }
}
