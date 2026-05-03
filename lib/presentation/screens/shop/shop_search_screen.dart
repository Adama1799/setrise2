import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';
import 'package:setrise/data/mock_data/shop_mock_data.dart';
import 'package:setrise/data/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/widgets/product_grid_card.dart';

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
      _results = all
          .where((p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.brandName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.surface,
        leading: CupertinoNavigationBarBackButton(
          color: AppColors.black,
          onPressed: () => Navigator.pop(context),
        ),
        middle: CupertinoSearchTextField(
          controller: _searchController,
          placeholder: 'Search products...',
          style: const TextStyle(color: AppColors.black),
          backgroundColor: AppColors.lightGray,
          prefixIcon: const Icon(CupertinoIcons.search, color: AppColors.mediumGray),
          suffixIcon: _searchController.text.isNotEmpty
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _searchController.clear();
                    _search('');
                  },
                  child: const Icon(CupertinoIcons.xmark_circle_fill, color: AppColors.mediumGray),
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
                        Icon(CupertinoIcons.search, color: AppColors.mediumGray, size: 48),
                        SizedBox(height: 12),
                        Text('No results found', style: TextStyle(color: AppColors.mediumGray)),
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
        const Text('Recent Searches',
            style: TextStyle(color: AppColors.black, fontSize: 18, fontWeight: FontWeight.bold)),
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
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 4)],
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.clock, color: AppColors.mediumGray, size: 16),
                      const SizedBox(width: 12),
                      Text(search, style: const TextStyle(color: AppColors.black, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
