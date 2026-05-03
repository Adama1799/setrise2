// lib/presentation/screens/shop/providers/wishlist_provider.dart
import 'package:flutter/foundation.dart';

class WishlistProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }
}

// كائن عالمي للبساطة (يمكن استخدام Provider في المستقبل)
final globalWishlistProvider = WishlistProvider();
