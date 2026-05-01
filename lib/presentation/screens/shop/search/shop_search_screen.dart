// lib/presentation/screens/shop/search/shop_search_screen.dart
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/mock_data/shop_mock_data.dart';
import '../../../../data/models/product_model.dart';
import '../widgets/product_grid_card.dart';

class ShopSearchScreen extends StatefulWidget {
  const ShopSearchScreen({super.key});
  @override
  State<ShopSearchScreen> createState() => _ShopSearchScreenState();
}

class _ShopSearchScreenState extends State<ShopSearchScreen> {
  final _searchController = TextEditingController();
  List<ProductModel> _results = [];
  final _recents = ['Headphones', 'Shoes', 'Watch', 'Laptop'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => _search(_searchController.text));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  void _search(String query) {
    if (query.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }
    final all = ShopMockData.getFeaturedProducts() + ShopMockData.getPopularProducts();
    setState(() {
      _results = all.where((p) =>
          p.name.toLowerCase().contains(query.toLowerCase()) ||
          p.brandName.toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _searchController.text.isNotEmpty && _results.isEmpty;
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.surface,
        leading: CupertinoNavigationBarBackButton(
          color: AppColors.white,
          onPressed: () => Navigator.pop(context),
        ),
        middle: CupertinoSearchTextField(
          controller: _searchController,
          placeholder: 'Search products...',
          style: const TextStyle(color: AppColors.white),
          backgroundColor: AppColors.grey.withOpacity(0.2),
          prefixIcon: const Icon(CupertinoIcons.search, color: AppColors.grey2),
          suffixIcon: _searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _search('');
                  },
                  child: const Icon(CupertinoIcons.xmark_circle_fill, color: AppColors.grey2),
                )
              : null,
        ),
      ),
      child: SafeArea(
        child: _searchController.text.isEmpty
            ? _buildRecents()
            : _results.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.search, color: AppColors.grey2, size: 48),
                        SizedBox(height: 12),
                        Text('No results found', style: TextStyle(color: AppColors.grey2)),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _results.length,
                    itemBuilder: (_, i) => ProductGridCard(product: _results[i]),
                  ),
      ),
    );
  }

  Widget _buildRecents() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Recent Searches', style: TextStyle(color: AppColors.white, fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ..._recents.map((search) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () {
              _searchController.text = search;
              _search(search);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.clock, color: AppColors.grey2, size: 16),
                  const SizedBox(width: 12),
                  Text(search, style: const TextStyle(color: AppColors.white)),
                ],
              ),
            ),
          ),
        )),
      ],
    );
  }
}
