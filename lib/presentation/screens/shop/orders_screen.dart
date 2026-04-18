// lib/presentation/screens/shop/orders_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Order> _allOrders = [
    Order(id: 'ORD-001', date: DateTime.now().subtract(const Duration(days: 1)), status: 'Delivered', total: 249.98, items: 2),
    Order(id: 'ORD-002', date: DateTime.now().subtract(const Duration(days: 3)), status: 'Processing', total: 89.99, items: 1),
    Order(id: 'ORD-003', date: DateTime.now().subtract(const Duration(days: 5)), status: 'Shipped', total: 159.99, items: 1),
    Order(id: 'ORD-004', date: DateTime.now().subtract(const Duration(days: 7)), status: 'Cancelled', total: 49.99, items: 1),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Order> _filterOrders(String status) {
    if (status == 'All') return _allOrders;
    return _allOrders.where((o) => o.status == status).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered': return AppColors.success;
      case 'Processing': return AppColors.warning;
      case 'Shipped': return AppColors.accent;
      case 'Cancelled': return AppColors.error;
      default: return AppColors.secondaryText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('My Orders', style: AppTextStyles.headline2.copyWith(color: AppColors.primaryText)),
        centerTitle: false,
        foregroundColor: AppColors.primaryText,
        bottom: TabBar(controller: _tabController, tabs: const [Tab(text: 'All'), Tab(text: 'Processing'), Tab(text: 'Shipped'), Tab(text: 'Delivered')]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(_filterOrders('All')),
          _buildOrderList(_filterOrders('Processing')),
          _buildOrderList(_filterOrders('Shipped')),
          _buildOrderList(_filterOrders('Delivered')),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(child: Text('No orders found', style: AppTextStyles.body1.copyWith(color: AppColors.secondaryText)));
    }
    return ListView.builder(padding: const EdgeInsets.all(16), itemCount: orders.length, itemBuilder: (context, index) => _buildOrderCard(orders[index]));
  }

  Widget _buildOrderCard(Order order) {
    final statusColor = _getStatusColor(order.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.id, style: AppTextStyles.body2.copyWith(color: AppColors.secondaryText)),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(order.status, style: AppTextStyles.body2.copyWith(color: statusColor, fontWeight: FontWeight.w600))),
              ],
            ),
            const SizedBox(height: 8),
            Text('${order.items} items • \$${order.total.toStringAsFixed(2)}', style: AppTextStyles.body2),
            const SizedBox(height: 8),
            Text('Placed on ${_formatDate(order.date)}', style: AppTextStyles.body2.copyWith(color: AppColors.secondaryText)),
            const SizedBox(height: 12),
            Row(
              children: [
                if (order.status == 'Processing' || order.status == 'Shipped') ...[Expanded(child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.accent), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text('Track', style: TextStyle(color: AppColors.accent)))), const SizedBox(width: 12)],
                if (order.status == 'Delivered') ...[Expanded(child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.accent), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text('Review', style: TextStyle(color: AppColors.accent)))), const SizedBox(width: 12)],
                Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text(order.status == 'Cancelled' ? 'Order Again' : 'Reorder', style: AppTextStyles.button.copyWith(fontSize: 14)))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class Order {
  final String id;
  final DateTime date;
  final String status;
  final double total;
  final int items;

  Order({required this.id, required this.date, required this.status, required this.total, required this.items});
}
