// lib/presentation/screens/shop/all_products_screen.dart
import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock_data/shop_mock_data.dart';
import '../../../data/models/product_model.dart';
import 'widgets/product_grid_card.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});
  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  late List<ProductModel> _products;
  bool _isLoading = false;
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _products = ShopMockData.getFeaturedProducts() + ShopMockData.getPopularProducts();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200 && !_isLoading) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    final more = ShopMockData.getPopularProducts().map((p) => p.copyWith(id: 'more_${DateTime.now().millisecondsSinceEpoch}_${p.id}')).toList();
    setState(() {
      _products.addAll(more);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('All Products', style: TextStyle(color: CupertinoColors.white)),
      ),
      child: SafeArea(
        child: GridView.builder(
          controller: _scrollCtrl,
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemCount: _products.length + (_isLoading ? 1 : 0),
          itemBuilder: (_, i) {
            if (i >= _products.length) return const Center(child: CupertinoActivityIndicator());
            return ProductGridCard(product: _products[i]);
          },
        ),
      ),
    );
  }
}
