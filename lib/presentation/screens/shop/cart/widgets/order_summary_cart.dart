// lib/presentation/screens/shop/cart/widgets/order_summary_cart.dart
import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';

class OrderSummaryCart extends StatelessWidget {
  final double subtotal, shipping, discount, total;
  final VoidCallback onCheckout;

  const OrderSummaryCart({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.discount,
    required this.total,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _row('Subtotal', subtotal),
          _row('Shipping', shipping),
          if (discount > 0) _row('Discount', -discount, color: AppColors.success),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: AppColors.border,
          ),
          _row('Total', total, bold: true),
          const SizedBox(height: 16),
          CupertinoButton(
            color: AppColors.shop,
            child: const Text('Checkout'),
            onPressed: onCheckout,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, double value, {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color ?? AppColors.grey2,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              color: color ?? AppColors.white,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
