// material_shop/screens/product/widgets/top_rounded_container.dart
import 'package:flutter/material.dart';

class TopRoundedContainer extends StatelessWidget {
  final Color color;
  final Widget child;
  const TopRoundedContainer({Key? key, required this.color, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(top: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      ),
      child: child,
    );
  }
}
