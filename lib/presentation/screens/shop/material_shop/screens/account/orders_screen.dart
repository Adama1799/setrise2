import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/order_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/orders_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/cart_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/empty_state.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white, surfaceTintColor: Colors.white, elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary)),
        title: Text('My Orders', style: AppTextStyles.headline3),
      ),
      body: orders.isEmpty
          ? const EmptyState(icon: Icons.receipt_long_outlined, title: 'No orders yet', subtitle: 'Your placed orders will appear here')
          : ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.lg),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.md),
              itemBuilder: (_, i) => _OrderCard(order: orders[i]),
            ),
    );
  }
}

class _OrderCard extends ConsumerWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = _statusData(order.status);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.sm),
          childrenPadding: const EdgeInsets.fromLTRB(AppDimensions.lg, 0, AppDimensions.lg, AppDimensions.lg),
          title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(order.id, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w800)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: s['bg'] as Color, borderRadius: BorderRadius.circular(99)),
                child: Text(s['label'] as String, style: AppTextStyles.caption.copyWith(color: s['fg'] as Color, fontWeight: FontWeight.w700)),
              ),
            ]),
            const SizedBox(height: 4),
            Text('${order.items.length} items · \$${order.total.toStringAsFixed(2)}',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
            if (order.createdAt != null)
              Text('${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textQuaternary)),
          ]),
          children: [
            const Divider(color: AppColors.borderSubtle, height: 1),
            const SizedBox(height: AppDimensions.lg),

            // ── Progress Timeline ──
            if (order.status != OrderStatus.cancelled)
              _OrderTimeline(currentStep: _stepIndex(order.status)),

            if (order.status == OrderStatus.cancelled)
              Container(
                padding: const EdgeInsets.all(AppDimensions.md),
                decoration: BoxDecoration(color: AppColors.statusCancelledBg, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)),
                child: Row(children: [
                  const Icon(Icons.cancel_outlined, color: AppColors.statusCancelledFg, size: 20),
                  const SizedBox(width: AppDimensions.sm),
                  Text('This order was cancelled', style: AppTextStyles.bodySmall.copyWith(color: AppColors.statusCancelledFg, fontWeight: FontWeight.w600)),
                ]),
              ),

            const SizedBox(height: AppDimensions.md),

            // Tracking number
            if (order.trackingNumber != null)
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: order.trackingNumber!));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Tracking number copied ✓', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                    backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(AppDimensions.lg),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
                    duration: const Duration(seconds: 1),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(color: AppColors.statusActiveBg, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)),
                  child: Row(children: [
                    const Icon(Icons.local_shipping_rounded, size: 18, color: AppColors.ctaPrimaryBg),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Tracking Number', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                      Text(order.trackingNumber!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w700, letterSpacing: 1)),
                    ])),
                    const Icon(Icons.copy_rounded, size: 14, color: AppColors.ctaPrimaryBg),
                  ]),
                ),
              ),

            const SizedBox(height: AppDimensions.md),

            // Items
            Text('Items', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
            const SizedBox(height: AppDimensions.xs),
            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.xs),
              child: Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.backgroundPrimary, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)),
                    child: Center(child: Text('${item.quantity}x', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800, color: AppColors.ctaPrimaryBg)))),
                const SizedBox(width: AppDimensions.sm),
                Expanded(child: Text(item.product.name, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                Text('\$${item.subtotal.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ]),
            )),

            const SizedBox(height: AppDimensions.md),

            // Actions
            Row(children: [
              Expanded(child: OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  for (final item in order.items) ref.read(cartProvider.notifier).addItem(item.product, {}, item.quantity);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Items added to cart ✓', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                    backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(AppDimensions.lg),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
                  ));
                },
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.ctaPrimaryBg, side: const BorderSide(color: AppColors.ctaPrimaryBg), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSm))),
                icon: const Icon(Icons.replay_rounded, size: 16),
                label: Text('Re-order', style: AppTextStyles.caption.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w700)),
              )),
              if (order.status != OrderStatus.cancelled && order.status != OrderStatus.delivered) ...[
                const SizedBox(width: AppDimensions.sm),
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(
                    backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
                    title: Text('Cancel Order', style: AppTextStyles.headline3),
                    content: Text('Are you sure you want to cancel?', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: Text('No', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary))),
                      TextButton(onPressed: () { ref.read(ordersProvider.notifier).cancelOrder(order.id); Navigator.pop(context); }, child: Text('Cancel Order', style: AppTextStyles.bodySmall.copyWith(color: AppColors.error, fontWeight: FontWeight.w700))),
                    ],
                  )),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSm))),
                  icon: const Icon(Icons.cancel_outlined, size: 16),
                  label: Text('Cancel', style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.w700)),
                )),
              ],
            ]),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _statusData(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:   return {'label': 'Pending',   'bg': AppColors.statusShippedBg,   'fg': AppColors.statusShippedFg};
      case OrderStatus.confirmed: return {'label': 'Confirmed', 'bg': AppColors.statusActiveBg,    'fg': AppColors.statusActiveFg};
      case OrderStatus.shipped:   return {'label': 'Shipped',   'bg': AppColors.statusShippedBg,   'fg': AppColors.statusShippedFg};
      case OrderStatus.delivered: return {'label': 'Delivered', 'bg': AppColors.statusDeliveredBg, 'fg': AppColors.statusDeliveredFg};
      case OrderStatus.cancelled: return {'label': 'Cancelled', 'bg': AppColors.statusCancelledBg, 'fg': AppColors.statusCancelledFg};
    }
  }

  int _stepIndex(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:   return 0;
      case OrderStatus.confirmed: return 1;
      case OrderStatus.shipped:   return 2;
      case OrderStatus.delivered: return 3;
      default: return 0;
    }
  }
}

// ── Visual Timeline ───────────────────────────────────────────
class _OrderTimeline extends StatelessWidget {
  final int currentStep;
  const _OrderTimeline({required this.currentStep});

  static const _steps = [
    {'icon': Icons.check_circle_outline, 'label': 'Confirmed', 'sub': 'Order placed'},
    {'icon': Icons.inventory_2_outlined, 'label': 'Processing', 'sub': 'Being packed'},
    {'icon': Icons.local_shipping_outlined, 'label': 'Shipped', 'sub': 'On the way'},
    {'icon': Icons.home_outlined, 'label': 'Delivered', 'sub': 'Enjoy it!'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final done = currentStep > i ~/ 2;
          return Expanded(child: Container(height: 2, color: done ? AppColors.success : AppColors.borderSubtle));
        }
        final idx = i ~/ 2; final done = currentStep >= idx; final active = currentStep == idx;
        return AnimatedContainer(duration: const Duration(milliseconds: 300), width: 40, height: 40,
          decoration: BoxDecoration(shape: BoxShape.circle, color: done ? AppColors.success : Colors.white,
              border: Border.all(color: done ? AppColors.success : active ? AppColors.ctaPrimaryBg : AppColors.borderSubtle, width: done ? 0 : 2),
              boxShadow: active ? [BoxShadow(color: AppColors.ctaPrimaryBg.withOpacity(0.3), blurRadius: 12, spreadRadius: 2)] : null),
          child: Icon(done ? Icons.check_rounded : _steps[idx]['icon'] as IconData, size: 18,
              color: done ? Colors.white : active ? AppColors.ctaPrimaryBg : AppColors.textQuaternary));
      })),
      const SizedBox(height: AppDimensions.xs),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(_steps.length, (i) {
        final done = currentStep >= i;
        return SizedBox(width: 64, child: Column(children: [
          Text(_steps[i]['label'] as String, style: AppTextStyles.caption.copyWith(color: done ? AppColors.textPrimary : AppColors.textQuaternary, fontWeight: done ? FontWeight.w700 : FontWeight.w400), textAlign: TextAlign.center),
          Text(_steps[i]['sub'] as String, style: const TextStyle(fontSize: 9, color: AppColors.textQuaternary, fontFamily: 'Inter'), textAlign: TextAlign.center),
        ]));
      })),
      const SizedBox(height: AppDimensions.md),
    ]);
  }
}
