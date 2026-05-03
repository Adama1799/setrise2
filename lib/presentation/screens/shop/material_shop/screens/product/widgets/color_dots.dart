// material_shop/screens/product/widgets/color_dots.dart
import 'package:flutter/material.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';

class ColorDots extends StatelessWidget {
  final Product product;
  const ColorDots({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedColor = 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: List.generate(product.colors.length, (index) => _ColorDot(
          color: product.colors[index],
          isSelected: index == selectedColor,
        )),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  const _ColorDot({required this.color, required this.isSelected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(8),
      height: 40, width: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: isSelected ? const Color(0xFFFF7643) : Colors.transparent),
        shape: BoxShape.circle,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
