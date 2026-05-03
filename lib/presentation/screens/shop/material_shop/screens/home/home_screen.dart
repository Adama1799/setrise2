// material_shop/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/home/widgets/home_header.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/home/widgets/discount_banner.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/home/widgets/categories.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/home/widgets/special_offers.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/home/widgets/popular_products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: const [
              HomeHeader(),
              DiscountBanner(),
              Categories(),
              SpecialOffers(),
              SizedBox(height: 20),
              PopularProducts(),
            ],
          ),
        ),
      ),
    );
  }
}
