// lib/presentation/screens/shop/marketplace/marketplace_screen.dart
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/store_model.dart';
import 'widgets/store_card.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});
  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final _stores = Store.getMockStores();
  String _filter = 'All';
  final _filters = ['All', 'Top Rated', 'Nearby'];

  List<Store> get filteredStores {
    if (_filter == 'All') return _stores;
    if (_filter == 'Top Rated') return _stores.where((s) => s.rating >= 4.5).toList();
    return _stores.where((s) => s.distance <= 10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.surface,
        middle: Text('Marketplace', style: TextStyle(color: AppColors.white)),
      ),
      child: SafeArea(
        child: Column(children: [
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (_, i) {
                final f = _filters[i];
                final sel = _filter == f;
                return GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.shop : AppColors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(f, style: TextStyle(color: sel ? AppColors.black : AppColors.white, fontWeight: FontWeight.w600)),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredStores.length,
              itemBuilder: (_, i) => StoreCard(store: filteredStores[i]),
            ),
          ),
        ]),
      ),
    );
  }
}
