// lib/presentation/screens/shop/search/shop_search_screen.dart
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
  List<ProductModel> _allProducts = [];
  List<ProductModel> _results = [];
  bool _isLoading = false;

  // عوامل التصفية
  double? _minPrice, _maxPrice;
  double _minRating = 0;
  Set<String> _selectedBrands = {};
  String _sortOption = 'Relevance';

  @override
  void initState() {
    super.initState();
    _allProducts = ShopMockData.getFeaturedProducts() + ShopMockData.getPopularProducts();
    _searchCtrl.addListener(_applyFilters);
    WidgetsBinding.instance.addPostFrameCallback((_) => FocusScope.of(context).requestFocus(FocusNode()));
  }

  void _applyFilters() {
    final query = _searchCtrl.text.trim().toLowerCase();
    List<ProductModel> filtered = _allProducts.where((p) {
      if (query.isNotEmpty &&
          !p.name.toLowerCase().contains(query) &&
          !p.brandName.toLowerCase().contains(query)) {
        return false;
      }
      if (_minPrice != null && p.price < _minPrice!) return false;
      if (_maxPrice != null && p.price > _maxPrice!) return false;
      if (p.rating < _minRating) return false;
      if (_selectedBrands.isNotEmpty && !_selectedBrands.contains(p.brandName)) {
        return false;
      }
      return true;
    }).toList();

    switch (_sortOption) {
      case 'Newest':
        // افتراضيًا نتركه كما هو
        break;
      case 'Price Low-High':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price High-Low':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Best Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    setState(() => _results = filtered);
  }

  void _showFilterSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => FilterSheet(
        currentMinPrice: _minPrice,
        currentMaxPrice: _maxPrice,
        currentRating: _minRating,
        selectedBrands: _selectedBrands,
        availableBrands: _allProducts.map((p) => p.brandName).toSet(),
        currentSort: _sortOption,
        onApply: (min, max, rating, brands, sort) {
          setState(() {
            _minPrice = min;
            _maxPrice = max;
            _minRating = rating;
            _selectedBrands = brands;
            _sortOption = sort;
            _applyFilters();
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
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
          controller: _searchCtrl,
          placeholder: 'Search products...',
          style: const TextStyle(color: AppColors.black),
          backgroundColor: AppColors.lightGray,
          prefixIcon: const Icon(CupertinoIcons.search, color: AppColors.mediumGray),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _searchCtrl.clear();
                  },
                  child: const Icon(CupertinoIcons.xmark_circle_fill, color: AppColors.mediumGray),
                )
              : null,
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.slider_horizontal_3, color: AppColors.black),
          onPressed: _showFilterSheet,
        ),
      ),
      child: SafeArea(
        child: _searchCtrl.text.isEmpty && _results.isEmpty
            ? _buildRecents()
            : _results.isEmpty
                ? const Center(
                    child: Text('No results found',
                        style: TextStyle(color: AppColors.mediumGray)))
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
    final recents = ['Headphones', 'Shoes', 'Watch', 'Laptop'];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Recent Searches',
            style: TextStyle(color: AppColors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...recents.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () {
                  _searchCtrl.text = s;
                  _applyFilters();
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 4)
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.clock, color: AppColors.mediumGray, size: 16),
                      const SizedBox(width: 12),
                      Text(s, style: const TextStyle(color: AppColors.black, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

// ورقة الفلترة
class FilterSheet extends StatefulWidget {
  final double? currentMinPrice, currentMaxPrice;
  final double currentRating;
  final Set<String> selectedBrands, availableBrands;
  final String currentSort;
  final Function(double?, double?, double, Set<String>, String) onApply;

  const FilterSheet({
    super.key,
    required this.currentMinPrice,
    required this.currentMaxPrice,
    required this.currentRating,
    required this.selectedBrands,
    required this.availableBrands,
    required this.currentSort,
    required this.onApply,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late double? _minPrice, _maxPrice;
  late double _rating;
  late Set<String> _brands;
  late String _sort;
  final _minCtrl = TextEditingController(), _maxCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _minPrice = widget.currentMinPrice;
    _maxPrice = widget.currentMaxPrice;
    _rating = widget.currentRating;
    _brands = Set.from(widget.selectedBrands);
    _sort = widget.currentSort;
    _minCtrl.text = _minPrice?.toString() ?? '';
    _maxCtrl.text = _maxPrice?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppColors.lightGray, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          const Text('Sort By',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black)),
          const SizedBox(height: 12),
          CupertinoSegmentedControl<String>(
            groupValue: _sort,
            onValueChanged: (v) => setState(() => _sort = v),
            children: const {
              'Relevance': Text('Relevance'),
              'Newest': Text('Newest'),
              'Price Low-High': Text('Low-High'),
              'Price High-Low': Text('High-Low'),
              'Best Rating': Text('Rating'),
            },
          ),
          const SizedBox(height: 20),
          const Text('Price Range',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: CupertinoTextField(
                    controller: _minCtrl,
                    keyboardType: TextInputType.number,
                    placeholder: 'Min',
                    style: const TextStyle(color: AppColors.black),
                    decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(10)))),
            const SizedBox(width: 12),
            Expanded(
                child: CupertinoTextField(
                    controller: _maxCtrl,
                    keyboardType: TextInputType.number,
                    placeholder: 'Max',
                    style: const TextStyle(color: AppColors.black),
                    decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(10)))),
          ]),
          const SizedBox(height: 20),
          const Text('Minimum Rating',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black)),
          CupertinoSlider(
            value: _rating,
            min: 0,
            max: 5,
            divisions: 5,
            onChanged: (v) => setState(() => _rating = v),
          ),
          Text('${_rating.toStringAsFixed(1)} stars',
              style: const TextStyle(color: AppColors.mediumGray)),
          const SizedBox(height: 20),
          const Text('Brands',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: widget.availableBrands.map((b) {
              final selected = _brands.contains(b);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selected) _brands.remove(b); else _brands.add(b);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.black : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(b,
                      style: TextStyle(
                          color: selected ? AppColors.white : AppColors.black)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          CupertinoButton(
            color: AppColors.black,
            child: const Text('Apply Filters',
                style: TextStyle(color: AppColors.white)),
            onPressed: () {
              final min = double.tryParse(_minCtrl.text);
              final max = double.tryParse(_maxCtrl.text);
              widget.onApply(min, max, _rating, _brands, _sort);
              Navigator.pop(context);
            },
          ),
        ]),
      ),
    );
  }
}
