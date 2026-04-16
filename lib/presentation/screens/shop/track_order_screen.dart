// lib/presentation/screens/shop/track_order_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderId;
  final String trackingNumber;

  const TrackOrderScreen({
    super.key,
    required this.orderId,
    required this.trackingNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Track Order',
          style: AppTextStyles.h5.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tracking info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Order #', style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
                      const SizedBox(width: 8),
                      Text(orderId, style: AppTextStyles.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('Tracking #', style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
                      const SizedBox(width: 8),
                      Text(trackingNumber, style: AppTextStyles.labelMedium.copyWith(color: AppColors.white)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, color: AppColors.grey2, size: 18),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Estimated delivery
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.shop.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping_outlined, color: AppColors.shop, size: 32),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estimated Delivery', style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
                      const SizedBox(height: 4),
                      Text('Tomorrow, April 17', style: AppTextStyles.h5.copyWith(color: AppColors.shop, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Timeline
            Text('Shipping Timeline', style: AppTextStyles.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTimelineItem(
              title: 'Order Placed',
              subtitle: 'Your order has been confirmed',
              time: 'Apr 15, 10:30 AM',
              isCompleted: true,
              isFirst: true,
            ),
            _buildTimelineItem(
              title: 'Processing',
              subtitle: 'We are preparing your items',
              time: 'Apr 15, 2:45 PM',
              isCompleted: true,
            ),
            _buildTimelineItem(
              title: 'Shipped',
              subtitle: 'Your package is on the way',
              time: 'Apr 16, 9:15 AM',
              isCompleted: true,
            ),
            _buildTimelineItem(
              title: 'Out for Delivery',
              subtitle: 'The courier is delivering your package',
              time: 'Expected today',
              isCompleted: false,
              isActive: true,
            ),
            _buildTimelineItem(
              title: 'Delivered',
              subtitle: 'Package will be delivered soon',
              time: 'Pending',
              isCompleted: false,
              isLast: true,
            ),
            const SizedBox(height: 24),
            // Map placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      color: Colors.blueGrey[800],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.map_rounded, color: AppColors.grey2, size: 48),
                            const SizedBox(height: 8),
                            Text('Live Map Tracking', style: AppTextStyles.labelMedium.copyWith(color: AppColors.grey2)),
                            const SizedBox(height: 4),
                            Text('Coming Soon', style: AppTextStyles.caption.copyWith(color: AppColors.grey2)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16, right: 16,
                    child: FloatingActionButton.small(
                      onPressed: () {},
                      backgroundColor: AppColors.shop,
                      child: const Icon(Icons.my_location_rounded, color: AppColors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required String time,
    required bool isCompleted,
    bool isActive = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isCompleted || isActive ? AppColors.shop : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted || isActive ? AppColors.shop : AppColors.grey2,
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check_rounded, color: AppColors.black, size: 12)
                      : (isActive ? Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.black, shape: BoxShape.circle)) : null),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted ? AppColors.shop : AppColors.grey.withOpacity(0.3),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isCompleted || isActive ? AppColors.white : AppColors.grey2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
                  const SizedBox(height: 2),
                  Text(time, style: AppTextStyles.caption.copyWith(color: AppColors.grey2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
