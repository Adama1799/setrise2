// material_shop/screens/product/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/services/cart_service.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/product/widgets/product_images.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/product/widgets/color_dots.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/product/widgets/product_description.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/product/widgets/top_rounded_container.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/cart/cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          ),
        ),
        actions: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset("assets/icons/Star Icon.svg"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          ProductImages(product: product),
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                ProductDescription(product: product, pressOnSeeMore: () {}),
                TopRoundedContainer(
                  color: const Color(0xFFF6F7F9),
                  child: ColorDots(product: product),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: TopRoundedContainer(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ElevatedButton(
              onPressed: () {
                CartService().addItem(product);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
              },
              child: const Text("Add To Cart", style: TextStyle(fontFamily: 'Inter')),
            ),
          ),
        ),
      ),
    );
  }
}
