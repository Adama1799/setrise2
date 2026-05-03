import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onPress;
  const ProductCard({Key? key, required this.product, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(product.images[0]),
              ),
            ),
            const SizedBox(height: 8),
            Text(product.title, style: const TextStyle(fontSize: 12, fontFamily: 'Inter'), maxLines: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("\$${product.price}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFFF7643), fontFamily: 'Inter')),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    height: 24, width: 24,
                    decoration: BoxDecoration(
                      color: product.isFavourite ? const Color(0xFFFF7643).withOpacity(0.15) : const Color(0xFF979797).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/Heart Icon_2.svg",
                      colorFilter: ColorFilter.mode(
                          product.isFavourite ? const Color(0xFFFF4848) : const Color(0xFFDBDEE4),
                          BlendMode.srcIn),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
