// lib/presentation/screens/shop/orders_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class OrderModel {
  final String id;
  final DateTime date;
  final int itemCount;
  final double total;
  final String status;
  final String shippingAddress;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.date,
    required this.itemCount,
    required this.total,
    required this.status,
    required this.shippingAddress,
    required this.items,
  });

  String get formattedDate => '${date.day}/${date.month}/${date.year}';
}

class OrderItem {
  final String name;
  final String imageUrl;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<OrderModel> _allOrders = [];
  List<OrderModel> _activeOrders = [];
  List<OrderModel> _completedOrders = [];
  List<OrderModel> _cancelledOrders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadOrders() {
    // Mock data
    _allOrders = [
      OrderModel(
        id: '#ORD-001',
        date: DateTime.now().subtract(const Duration(days: 1)),
        itemCount: 2,
        total: 129.98,
        status: 'Delivered',
        shippingAddress: '123 Main St, City, Country',
        items: [
          OrderItem(
            name: 'Wireless Headphones',
            imageUrl: 'https://via.placeholder.com/50x50',
            quantity: 1,
            price: 89.99,
          ),
          OrderItem(
            name: 'Phone Case',
            imageUrl: 'https://via.placeholder.com/50x50',
            quantity: 1,
            price: 24.99,
          ),
        ],
      ),
      OrderModel(
        id: '#ORD-002',
        date: DateTime.now().subtract(const Duration(days: 2)),
        itemCount: 1,
        total: 199.99,
        status: 'Processing',
        shippingAddress: '456 Oak Ave, City, Country',
        items: [
          OrderItem(
            name: 'Smart Watch',
            imageUrl: 'https://via.placeholder.com/50x50',
            quantity: 1,
            price: 199.99,
          ),
        ],
      ),
      OrderModel(
        id: '#ORD-003',
        date: DateTime.now().subtract(const Duration(days: 3)),
        itemCount: 3,
        total: 89.97,
        status: 'Cancelled',
        shippingAddress: '789 Pine Rd, City, Country',
        items: [
          OrderItem(
            name: 'T-Shirt',
            imageUrl: 'https://via.placeholder.com/50x50',
            quantity: 2,
            price: 24.99,
          ),
          OrderItem(
            name: 'Sneakers',
            imageUrl: 'https://via.placeholder.com/50x50',
            quantity: 1,
            price: 39.99,
          ),
        ],
      ),
      OrderModel(
        id: '#ORD-004',
        date: DateTime.now(),
        itemCount: 1,
        total: 49.99,
        status: 'Shipped',
        shippingAddress: '321 Elm St, City, Country',
        items: [
          OrderItem(
            name: 'Bluetooth Speaker',
            imageUrl: 'https://via.placeholder.com/50x50',
            quantity: 1,
            price: 49.99,
          ),
        ],
      ),
    ];

    _activeOrders = _allOrders.where((order) => 
        order.status == 'Processing' || 
        order.status == 'Shipped').toList();
    _completedOrders = _allOrders.where((order) => 
        order.status == 'Delivered').toList();
    _cancelledOrders = _allOrders.where((order) => 
        order.status == 'Cancelled').toList();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return AppColors.electricBlue;
      case 'processing':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      case 'cancelled':
        return AppColors.neonRed;
      default:
        return AppColors.grey2;
    }
  }

  List<Widget> _getActionButtons(String status) {
    List<Widget> buttons = [];
    
    switch (status.toLowerCase()) {
      case 'delivered':
        buttons.add(
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.grey.withOpacity(0.2),
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Review',
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
        buttons.add(const SizedBox(width: 8));
        buttons.add(
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricBlue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Buy Again',
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
        break;
      case 'processing':
      case 'shipped':
        buttons.add(
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricBlue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Track',
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
        break;
      case 'cancelled':
        buttons.add(
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricBlue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Order Again',
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
        break;
    }
    
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          "My Orders",
          style: AppTextStyles.h5.copyWith(color: AppColors.white),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColors.background,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.electricBlue,
              labelColor: AppColors.electricBlue,
              unselectedLabelColor: AppColors.grey2,
              labelStyle: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Active'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(_allOrders),
          _buildOrderList(_activeOrders),
          _buildOrderList(_completedOrders),
          _buildOrderList(_cancelledOrders),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: AppColors.grey2,
            ),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: AppTextStyles.h5.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven\'t placed any orders yet',
              style: AppTextStyles.body1.copyWith(color: AppColors.grey2),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh orders
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => _buildOrderCard(orders[index]),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(
              order.id,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: BorderSide(
                  color: _getStatusColor(order.status),
                ),
              ),
              child: Text(
                order.status,
                style: AppTextStyles.labelSmall.copyWith(
                  color: _getStatusColor(order.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          order.formattedDate,
          style: AppTextStyles.body1.copyWith(color: AppColors.grey2),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Items
                Text(
                  'Items (${order.itemCount})',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 40,
                            height: 40,
                            color: AppColors.grey,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: AppColors.grey2,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${item.name} x${item.quantity}',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      Text(
                        '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.electricBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )),
                
                const SizedBox(height: 16),
                
                // Shipping Address
                Text(
                  'Shipping Address',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.shippingAddress,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.grey2,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Order Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Total',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$${order.total.toStringAsFixed(2)}',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.electricBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: _getActionButtons(order.status),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
