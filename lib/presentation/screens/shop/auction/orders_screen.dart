// lib/presentation/screens/shop/account/orders_screen.dart
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(middle: Text('My Orders', style: TextStyle(color: CupertinoColors.white))),
      child: ListView(padding: const EdgeInsets.all(16), children: [
        _orderCard('ORD-001', 'Delivered', 249.98, 2),
        _orderCard('ORD-002', 'Processing', 89.99, 1),
      ]),
    );
  }

  Widget _orderCard(String id, String status, double total, int items) {
    final Color statusColor = status == 'Delivered' ? AppColors.success : AppColors.warning;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(id, style: TextStyle(color: AppColors.grey2, fontSize: 13)),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold))),
        ]),
        const SizedBox(height: 8),
        Text('$items items • \$${total.toStringAsFixed(2)}', style: const TextStyle(color: CupertinoColors.white)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: CupertinoButton(padding: EdgeInsets.zero, color: AppColors.accent, child: const Text('Track'), onPressed: () {})),
          const SizedBox(width: 12),
          Expanded(child: CupertinoButton(padding: EdgeInsets.zero, color: AppColors.shop, child: Text(status == 'Delivered' ? 'Review' : 'Reorder', style: const TextStyle(color: CupertinoColors.black)), onPressed: () {})),
        ]),
      ]),
    );
  }
}
