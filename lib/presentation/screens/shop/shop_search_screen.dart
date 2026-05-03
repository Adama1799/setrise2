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
  final _searchCtrl = TextEditingController();
  List<ProductModel> _results = [];

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_search);
    WidgetsBinding.instance.addPostFrameCallback((_) => FocusScope.of(context).requestFocus(FocusNode()));
  }

  void _search() {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) { setState(() => _results = []); return; }
    final all = ShopMockData.getFeaturedProducts() + ShopMockData.getPopularProducts();
    setState(() => _results = all.where((p) => p.name.toLowerCase().contains(q) || p.brandName.toLowerCase().contains(q)).toList());
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.surface,
        leading: CupertinoNavigationBarBackButton(color: AppColors.black, onPressed: () => Navigator.pop(context)),
        middle: CupertinoSearchTextField(
          controller: _searchCtrl,
          placeholder: 'Search products...',
          style: const TextStyle(color: AppColors.black),
          backgroundColor: AppColors.lightGray,
          prefixIcon: const Icon(CupertinoIcons.search, color: AppColors.mediumGray),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () { _searchCtrl.clear(); },
                  child: const Icon(CupertinoIcons.xmark_circle_fill, color: AppColors.mediumGray),
                )
              : null,
        ),
      ),
      child: SafeArea(
        child: _searchCtrl.text.isEmpty
            ? _buildRecents()
            : _results.isEmpty
                ? const Center(child: Text('No results', style: TextStyle(color: AppColors.mediumGray)))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
                    itemCount: _results.length,
                    itemBuilder: (_, i) => ProductGridCard(product: _results[i]),
                  ),
      ),
    );
  }

  Widget _buildRecents() {
    final recents = ['Headphones', 'Shoes', 'Watch', 'Laptop'];
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Recent Searches', style: TextStyle(color: AppColors.black, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      ...recents.map((s) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTap: () { _searchCtrl.text = s; _search(); },
          child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 4)]), child: Row(children: [const Icon(CupertinoIcons.clock, color: AppColors.mediumGray, size: 16), const SizedBox(width: 12), Text(s, style: const TextStyle(color: AppColors.black, fontSize: 16))])),
        ),
      )),
    ]);
  }
}
