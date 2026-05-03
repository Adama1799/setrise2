// widgets/shipping_info.dart
import 'package:flutter/material.dart';

class ShippingInfo extends StatelessWidget {
  const ShippingInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Free shipping on orders over \$50", style: TextStyle(fontFamily: 'Inter')),
        Text("30-day easy returns", style: TextStyle(fontFamily: 'Inter')),
      ],
    );
  }
}
