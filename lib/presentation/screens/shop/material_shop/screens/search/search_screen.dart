import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/products_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_card.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/empty_state.dart';
import 'package:setrise/presentation/screens/shop/material_shop/utils/responsive.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  String _query = '';
  String _selectedFilter = 'All';
  String _sortBy = 'Default';

  final List<String> _filters = ['All', 'HOT', 'NEW', 'Free Ship', 'On Sale'];
  final List<String> _sorts = ['Default', 'Price ↑', 'Price ↓', 'Rating', 'Reviews'];

  List<ProductModel> _applyFilter(List<ProductModel> products) {
    var result = List<ProductModel>.from(products);

    if (_query.isNotEmpty) {
      result = result.where((p) {
        final q = _query.toLowerCase();
        return p.name.toLowerCase().contains(q) || p.brand.toLowerCase().contains(q);
      }).toList();
    }

    switch (_selectedFilter) {
      case 'HOT':
        result = result.where((p) => p.isHot).toList();
        break;
      case 'NEW':
        result = result.where((p) => p.isNew).toList();
        break;
      case 'Free Ship':
        result = result.where((p) => p.shippingFree).toList();
        break;
      case 'On Sale':
        result = result.where((p) => p.discount > 0).toList();
        break;
    }

    switch (_sortBy) {
      case 'Price ↑':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price ↓':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Reviews':
        result.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }

    return result;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.textPrimary,
          ),
        ),
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textQuaternary,
            ),
            border: InputBorder.none,
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              onPressed: () {
                _ctrl.clear();
                setState(() => _query = '');
              },
              icon: const Icon(
                Icons.close,
                size: 18,
                color: AppColors.textTertiary,
              ),
            ),
          IconButton(
            onPressed: _showSortSheet,
            icon: const Icon(
              Icons.sort,
              size: 22,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
                vertical: 6,
              ),
              itemCount: _filters.length,
              itemBuilder: (context, i) {
                final isSelected = _selectedFilter == _filters[i];
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = _filters[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: AppDimensions.xs),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.ctaPrimaryBg
                          : AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: isSelected
                              ? AppColors.ctaPrimaryBg
                              : AppColors.borderSubtle,
                        ),
                      ),
                    ),
                    child: Text(
                      _filters[i],
                      style: AppTextStyles.caption.copyWith(
                        color: isSelected
                            ? AppColors.ctaPrimaryFg
                            : AppColors.textTertiary,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: productsAsync.when(
              data: (products) {
                final results = _applyFilter(products);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.lg,
                        AppDimensions.xs,
                        AppDimensions.lg,
                        AppDimensions.xs,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${results.length} results',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const Spacer(),
                          if (_sortBy != 'Default')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.statusActiveBg,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusXs,
                                ),
                              ),
                              child: Text(
                                _sortBy,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.ctaPrimaryBg,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (results.isEmpty)
                      Expanded(
                        child: EmptyState(
                          icon: Icons.search_off,
                          title: 'No results found',
                          subtitle: _query.isNotEmpty
                              ? 'Try different keywords'
                              : 'No products in this filter',
                        ),
                      )
                    else
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.lg,
                            vertical: AppDimensions.sm,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: context.gridColumns,
                            childAspectRatio: 0.62,
                            crossAxisSpacing: AppDimensions.gridGap,
                            mainAxisSpacing: AppDimensions.gridGap,
                          ),
                          itemCount: results.length,
                          itemBuilder: (context, index) => ProductCard(
                            product: results[index],
                          ),
                        ),
                      ),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.ctaPrimaryBg,
                ),
              ),
              error: (_, __) => const Center(
                child: Text('Failed to load products'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sort By', style: AppTextStyles.headline3),
            const SizedBox(height: AppDimensions.md),
            ..._sorts.map(
              (s) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(s, style: AppTextStyles.bodyMedium),
                trailing: _sortBy == s
                    ? const Icon(
                        Icons.check_circle,
                        color: AppColors.ctaPrimaryBg,
                        size: 20,
                      )
                    : null,
                onTap: () {
                  setState(() => _sortBy = s);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
          ],
        ),
      ),
    );
  }
}
