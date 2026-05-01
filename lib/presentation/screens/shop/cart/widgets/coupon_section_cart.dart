// lib/presentation/screens/shop/cart/widgets/coupon_section_cart.dart
import 'package:flutter/cupertino.dart';
import '../../../../../core/theme/app_colors.dart';

class CouponSectionCart extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onApply;
  final double discount;
  final bool enabled;

  const CouponSectionCart({super.key, required this.controller, required this.onApply, required this.discount, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Expanded(
          child: CupertinoTextField(
            controller: controller,
            enabled: enabled,
            placeholder: 'Coupon code',
            style: const TextStyle(color: AppColors.white),
            decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(width: 12),
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: enabled ? AppColors.shop : AppColors.grey,
          child: const Text('Apply'),
          onPressed: enabled ? onApply : null,
        ),
        if (discount > 0) ...[
          const SizedBox(width: 8),
          Text('-\$${discount.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
        ],
      ]),
    );
  }
}
