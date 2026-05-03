import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/search/shop_search_screen.dart';
import 'home/widgets/banner_section.dart';
import 'home/widgets/categories_section.dart';
import 'home/widgets/live_auctions_section.dart';
import 'home/widgets/stores_section.dart';
import 'home/widgets/products_grid_section.dart';

class ShopHomeScreen extends StatelessWidget {
  const ShopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.white,
        border: const Border(bottom: BorderSide.none),
        middle: const Text('Shop',
            style: TextStyle(color: AppColors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.search, color: AppColors.black),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => const ShopSearchScreen()),
            );
          },
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: const [
            SliverToBoxAdapter(child: CategoriesSection()),
            SliverToBoxAdapter(child: BannerSection()),
            SliverToBoxAdapter(child: LiveAuctionsSection()),
            SliverToBoxAdapter(child: StoresSection()),
            SliverToBoxAdapter(child: ProductsGridSection()),
          ],
        ),
      ),
    );
  }
}
