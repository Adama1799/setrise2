// lib/presentation/screens/shop/controllers/shop_controller.dart
import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/models/auction_model.dart';
import '../../../../data/models/seller_model.dart';
import '../../../../data/services/mock_shop_service.dart';

class ShopController extends ChangeNotifier {
  final List<dynamic> _mixedItems = [];
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final StreamController<List<SellerModel>> _sellersController = StreamController.broadcast();

  List<dynamic> get mixedItems => List.unmodifiable(_mixedItems);
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  Stream<List<SellerModel>> get sellersStream => _sellersController.stream;

  Future<void> fetchInitialData() async {
    _mixedItems.clear();
    _currentPage = 1;
    _hasMore = true;
    try {
      final sellers = await MockShopService.getTrendingSellers();
      _sellersController.add(sellers);
      await _fetchNextPage();
    } catch (e) { debugPrint(e.toString()); } finally { notifyListeners(); }
  }

  Future<void> fetchNextPage() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true; notifyListeners();
    try { await _fetchNextPage(); } finally { _isLoadingMore = false; notifyListeners(); }
  }

  Future<void> _fetchNextPage() async {
    final products = await MockShopService.getFeaturedProducts();
    final auctions = await MockShopService.getLiveAuctions();
    if (products.isEmpty && auctions.isEmpty) { _hasMore = false; return; }
    final newItems = <dynamic>[...products.take(3), ...auctions.take(2)];
    newItems.shuffle();
    _mixedItems.addAll(newItems);
    _currentPage++;
  }

  Future<void> refresh() => fetchInitialData();

  @override
  void dispose() { _sellersController.close(); super.dispose(); }
}
