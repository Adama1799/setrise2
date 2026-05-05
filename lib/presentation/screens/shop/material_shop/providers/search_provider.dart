import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import 'products_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final recentSearchesProvider = StateNotifierProvider<RecentSearchesNotifier, List<String>>((ref) => RecentSearchesNotifier());

class RecentSearchesNotifier extends StateNotifier<List<String>> {
  RecentSearchesNotifier() : super([]);
  void add(String query) {
    if (query.trim().isEmpty) return;
    state = [query, ...state.where((s) => s != query)].take(10).toList();
  }
  void remove(String query) => state = state.where((s) => s != query).toList();
  void clearAll() => state = [];
}

final searchResultsProvider = FutureProvider.family<List<ProductModel>, String>((ref, query) async {
  final products = await ref.read(productsProvider.future);
  if (query.isEmpty) return [];
  return products.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
});
