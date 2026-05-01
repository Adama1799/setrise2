// lib/presentation/screens/shop/cart/widgets/cart_item.dart
import 'package:flutter/cupertino.dart';
import '../../../../../core/theme/app_colors.dart';

class CartItemWidget extends StatelessWidget {
  final String imageUrl, brand, name;
  final double price;
  final int quantity;
  final VoidCallback onDecrement, onIncrement;

  const CartItemWidget({
    super.key,
    required this.imageUrl,
    required this.brand,
    required this.name,
    required this.price,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(brand, style: const TextStyle(color: AppColors.grey2, fontSize: 12)),
          Text(name, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('\$${(price * quantity).toStringAsFixed(2)}', style: const TextStyle(color: AppColors.shop, fontWeight: FontWeight.bold)),
        ])),
        Column(children: [
          CupertinoButton(padding: EdgeInsets.zero, child: const Icon(CupertinoIcons.minus_circle, color: AppColors.grey2), onPressed: onDecrement),
          Text('$quantity', style: const TextStyle(color: AppColors.white)),
          CupertinoButton(padding: EdgeInsets.zero, child: const Icon(CupertinoIcons.add_circled, color: AppColors.shop), onPressed: onIncrement),
        ]),
      ]),
    );
  }
}
