// lib/presentation/screens/shop/product/widgets/shipping_info_section.dart
import 'package:flutter/cupertino.dart';
import '../../../../../core/theme/app_colors.dart';

class ShippingInfoSection extends StatelessWidget {
  const ShippingInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Shipping & Returns', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _infoRow(CupertinoIcons.shippingbox, 'Free delivery on orders over \$50', 'Delivered in 2-5 business days'),
          _infoRow(CupertinoIcons.return_icon, '30-day returns', 'Free return within 30 days'),
          _infoRow(CupertinoIcons.lock_shield, 'Secure transaction', 'Your data is protected'),
        ]),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Icon(icon, color: AppColors.accent, size: 24),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600)),
          Text(subtitle, style: const TextStyle(color: AppColors.grey2, fontSize: 13)),
        ])),
      ]),
    );
  }
}
