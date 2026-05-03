import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';
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
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.white,
        border: Border(bottom: BorderSide.none),
        middle: Text('Shop', style: TextStyle(color: AppColors.black, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      child: SafeArea(
        child: CustomScrollView(slivers: [
          const SliverToBoxAdapter(child: CategoriesSection()),
          const SliverToBoxAdapter(child: BannerSection()),
          const SliverToBoxAdapter(child: LiveAuctionsSection()),
          const SliverToBoxAdapter(child: StoresSection()),
          const SliverToBoxAdapter(child: ProductsGridSection()),
        ]),
      ),
    );
  }
}
