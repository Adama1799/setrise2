import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/products_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/home/widgets/home_header.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/home/widgets/Discount_Banner.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/home/widgets/categories.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/home/widgets/Special_Offers.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/home/widgets/Popular_Products.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(productsProvider.future),
          color: AppColors.ctaPrimaryBg,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // ── 1. Header ──
              Container(color: Colors.white, padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm), child: const HomeHeader()),

              const SizedBox(height: 1),

              // ── 2. Categories ──
              Container(color: Colors.white, padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
                child: Categories(onSelected: (i) => setState(() => _selectedCategory = i))),

              const SizedBox(height: AppDimensions.sm),

              // ── 3. Banner Carousel ──
              const DiscountBanner(),

              const SizedBox(height: AppDimensions.sm),

              // ── 4. Special Offers ──
              Container(color: Colors.white, child: const SpecialOffers()),

              const SizedBox(height: AppDimensions.sm),

              // ── 5. New Arrivals ──
              Container(color: Colors.white, child: const NewArrivalsSection()),

              const SizedBox(height: AppDimensions.sm),

              // ── 6. Recently Viewed ──
              Container(color: Colors.white, child: const RecentlyViewedSection()),

              const SizedBox(height: AppDimensions.sm),

              // ── 7. Popular Products ──
              Container(color: Colors.white,
                child: PopularProducts(filterCategory: _selectedCategory)),

              const SizedBox(height: AppDimensions.xxl),
            ]),
          ),
        ),
      ),
    );
  }
}
