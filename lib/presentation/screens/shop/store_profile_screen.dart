// lib/presentation/screens/shop/store_profile_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock_data/shop_mock_data.dart';
import '../../../data/models/store_model.dart';
import 'product_detail_screen.dart';
import 'chat_screen.dart';
import 'widgets/store_product_card.dart';
import 'widgets/store_stats.dart';

class StoreProfileScreen extends StatelessWidget {
  final Store store;
  const StoreProfileScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final products = ShopMockData.getFeaturedProducts().take(6).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.white, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share_outlined,
                      color: AppColors.white, size: 20),
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(store.logoUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: AppColors.shop.withOpacity(0.3))),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.background.withOpacity(0.9)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(store.logoUrl, width: 80, height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                                width: 80, height: 80, color: AppColors.grey,
                                child: const Icon(Icons.store, color: AppColors.white, size: 40))),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(store.name,
                                    style: AppTextStyles.h5.copyWith(
                                        color: AppColors.white, fontWeight: FontWeight.bold)),
                                if (store.isVerified) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.verified_rounded,
                                      color: AppColors.electricBlue, size: 18),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(store.description,
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) =>
                                  ChatScreen(storeName: store.name, storeId: store.id))),
                          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                          label: const Text('Message'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.shop,
                            side: BorderSide(color: AppColors.shop.withOpacity(0.5)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.person_add_rounded, size: 18),
                          label: const Text('Follow'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.shop,
                            foregroundColor: AppColors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  StoreStats(
                    rating: store.rating,
                    reviewCount: store.reviewCount,
                    productCount: 42,
                    followerCount: 1520,
                  ),
                  const SizedBox(height: 20),
                  Text('Featured Products',
                      style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => StoreProductCard(product: products[index]),
                childCount: products.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
