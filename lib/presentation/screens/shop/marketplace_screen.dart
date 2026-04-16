// lib/presentation/screens/shop/marketplace_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/store_model.dart'; 
import 'store_profile_screen.dart';
import 'chat_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<Store> _stores = Store.getMockStores();
  final List<String> _filters = ['All', 'Top Rated', 'Nearby', 'Recently Active'];

  List<Store> get _filteredStores {
    if (_selectedFilter == 'All') return _stores;
    if (_selectedFilter == 'Top Rated') {
      return _stores.where((s) => s.rating >= 4.5).toList();
    }
    if (_selectedFilter == 'Nearby') {
      return _stores.where((s) => s.distance <= 10).toList();
    }
    if (_selectedFilter == 'Recently Active') {
      return _stores.where((s) => s.isActive).toList();
    }
    return _stores;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Marketplace', style: AppTextStyles.h5.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Search stores or sellers...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.grey2),
                filled: true,
                fillColor: AppColors.grey.withOpacity(0.2),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.shop : AppColors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(filter, style: AppTextStyles.labelSmall.copyWith(color: isSelected ? AppColors.black : AppColors.white, fontWeight: FontWeight.w600)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredStores.length,
              itemBuilder: (context, index) {
                final store = _filteredStores[index];
                return _StoreCard(store: store);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final Store store;

  const _StoreCard({required this.store});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreProfileScreen(store: store))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(store.logoUrl, width: 70, height: 70, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 70, height: 70, color: AppColors.grey, child: const Icon(Icons.store, color: AppColors.white, size: 30)))),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(store.name, style: AppTextStyles.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold))),
                      if (store.isVerified) const Icon(Icons.verified_rounded, color: AppColors.electricBlue, size: 18),
                      if (store.isActive) Container(margin: const EdgeInsets.only(left: 8), width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.neonGreen, shape: BoxShape.circle)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(store.description, style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(store.rating.toStringAsFixed(1), style: AppTextStyles.labelSmall.copyWith(color: AppColors.white)),
                      const SizedBox(width: 4),
                      Text('(${store.reviewCount} reviews)', style: AppTextStyles.caption.copyWith(color: AppColors.grey2)),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on_outlined, color: AppColors.grey2, size: 14),
                      const SizedBox(width: 4),
                      Text('${store.distance} km', style: AppTextStyles.caption.copyWith(color: AppColors.grey2)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(storeName: store.name, storeId: store.id))),
                          style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.shop.withOpacity(0.5)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: Text('Message', style: AppTextStyles.labelSmall.copyWith(color: AppColors.shop)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreProfileScreen(store: store))),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.shop, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: Text('View Store', style: AppTextStyles.labelSmall.copyWith(color: AppColors.black, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
