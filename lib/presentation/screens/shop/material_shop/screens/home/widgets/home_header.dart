import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/icon_btn_with_counter.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/home/widgets/search_field.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/cart/cart_screen.dart';
import 'package:setrise/presentation/screens/shop/material_shop/services/cart_service.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Expanded(child: SearchField()),
          const SizedBox(width: 12),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Cart Icon.svg",
            numOfitem: cartService.itemCount,
            press: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
          ),
          const SizedBox(width: 8),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Bell.svg",
            numOfitem: 3,
            press: () {},
          ),
        ],
      ),
    );
  }
}
