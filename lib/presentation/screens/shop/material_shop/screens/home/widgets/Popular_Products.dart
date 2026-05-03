import 'package:flutter/material.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_card.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';

final List<Product> demoProducts = [
  Product(id: 1, title: "Wireless Controller", description: "...", images: ["assets/images/ps4_console_white_1.png"], colors: [Colors.white], price: 64.99, rating: 4.8, isFavourite: true, isPopular: true),
  Product(id: 2, title: "Nike Sport White", description: "...", images: ["assets/images/Image Popular Product 2.png"], colors: [Colors.white], price: 50.5, rating: 4.1, isPopular: true),
];

class PopularProducts extends StatelessWidget {
  const PopularProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text("Popular Products", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: demoProducts.map((p) => Padding(
              padding: const EdgeInsets.only(left: 20),
              child: ProductCard(product: p, onPress: () {}),
            )).toList(),
          ),
        ),
      ],
    );
  }
}
