import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistNotifier extends StateNotifier<List<String>> {
  WishlistNotifier() : super([]);

  void toggle(String productId) {
    if (state.contains(productId)) {
      state = state.where((id) => id != productId).toList();
    } else {
      state = [...state, productId];
    }
  }

  void moveToCart(String productId) {
    toggle(productId);
    // يمكن استدعاء cartProvider لإضافة العنصر
  }
}

final wishlistProvider = StateNotifierProvider<WishlistNotifier, List<String>>((ref) => WishlistNotifier());
