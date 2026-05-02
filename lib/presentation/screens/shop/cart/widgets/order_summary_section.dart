// lib/presentation/screens/shop/cart/widgets/order_summary_section.dart
import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';

class OrderSummarySection extends StatelessWidget {
  final double subtotal, shipping, tax, discount, total;
  final bool couponApplied;

  const OrderSummarySection({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.discount,
    required this.total,
    required this.couponApplied,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _row('Subtotal', subtotal),
          _row('Shipping', shipping),
          _row('Tax', tax),
          if (couponApplied) _row('Discount', -discount, color: AppColors.success),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: AppColors.border,
          ),
          _row('Total', total, bold: true),
        ],
      ),
    );
  }

  Widget _row(String label, double amount, {Color? color, bool bold = false}) {
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
            '\$${amount.toStringAsFixed(2)}',
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
