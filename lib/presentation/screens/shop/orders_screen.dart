// lib/presentation/screens/shop/orders_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/mock_data/shop_mock_data.dart';
import '../../../data/models/product_model.dart';
import 'product_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Order> _orders = Order.getMockOrders();

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

  List<Order> get _activeOrders =>
      _orders.where((o) => o.status == OrderStatus.processing || o.status == OrderStatus.shipped).toList();

  List<Order> get _completedOrders =>
      _orders.where((o) => o.status == OrderStatus.delivered).toList();

  List<Order> get _cancelledOrders =>
      _orders.where((o) => o.status == OrderStatus.cancelled).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Orders',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.shop,
          indicatorWeight: 2,
          labelColor: AppColors.shop,
          unselectedLabelColor: AppColors.grey2,
          labelStyle: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _OrdersList(orders: _orders),
          _OrdersList(orders: _activeOrders),
          _OrdersList(orders: _completedOrders),
          _OrdersList(orders: _cancelledOrders),
        ],
      ),
    );
  }
}

// ===== ORDERS LIST =====
class _OrdersList extends StatelessWidget {
  final List<Order> orders;

  const _OrdersList({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.grey2,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No orders found',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.grey2,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _OrderCard(order: orders[index]);
      },
    );
  }
}

// ===== ORDER CARD =====
class _OrderCard extends StatefulWidget {
  final Order order;

  const _OrderCard({required this.order});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id}',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Formatters.formatDate(order.orderDate),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.grey2,
                          ),
                        ),
                      ],
                    ),
                    _buildStatusBadge(order.status),
                  ],
                ),
                const SizedBox(height: 16),
                // Items summary
                Row(
                  children: [
                    // Product images stack
                    SizedBox(
                      width: 80,
                      height: 70,
                      child: Stack(
                        children: order.items.take(3).toList().asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return Positioned(
                            left: index * 20.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.background,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.network(
                                  item.product.images.first,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: AppColors.grey,
                                    child: const Icon(
                                      Icons.image_not_supported_outlined,
                                      color: AppColors.grey2,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total: \$${order.total.toStringAsFixed(2)}',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.shop,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expand/Collapse icon
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                      icon: Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.grey2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Track order
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.shop.withOpacity(0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Track Order',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.shop,
                          ),
                        ),
                      ),
                    ),
                    if (order.status == OrderStatus.processing) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Cancel order
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AppColors.grey,
                                title: Text(
                                  'Cancel Order',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to cancel this order?',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.grey2,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: Text(
                                      'No',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: AppColors.grey2,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Order cancelled'),
                                          backgroundColor: AppColors.neonRed,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Yes, Cancel',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: AppColors.neonRed,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.neonRed.withOpacity(0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.neonRed,
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (order.status == OrderStatus.delivered) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Write review
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.neonYellow.withOpacity(0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Write Review',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.neonYellow,
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (order.status == OrderStatus.delivered) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Buy again
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to cart!'),
                                backgroundColor: AppColors.shop,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.shop,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Buy Again',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Expanded items list
          if (_expanded)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                border: Border(
                  top: BorderSide(
                    color: AppColors.grey.withOpacity(0.2),
                  ),
                ),
              ),
              child: Column(
                children: [
                  ...order.items.map((item) => _OrderItemRow(item: item)),
                  const SizedBox(height: 16),
                  // Order summary
                  _buildOrderSummary(order),
                  const SizedBox(height: 16),
                  // Shipping address
                  _buildAddressSummary(order.shippingAddress),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case OrderStatus.processing:
        bgColor = AppColors.warning.withOpacity(0.2);
        textColor = AppColors.warning;
        text = 'Processing';
        break;
      case OrderStatus.shipped:
        bgColor = AppColors.electricBlue.withOpacity(0.2);
        textColor = AppColors.electricBlue;
        text = 'Shipped';
        break;
      case OrderStatus.delivered:
        bgColor = AppColors.neonGreen.withOpacity(0.2);
        textColor = AppColors.neonGreen;
        text = 'Delivered';
        break;
      case OrderStatus.cancelled:
        bgColor = AppColors.neonRed.withOpacity(0.2);
        textColor = AppColors.neonRed;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildOrderSummary(Order order) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', order.subtotal),
          const SizedBox(height: 4),
          _buildSummaryRow('Shipping', order.shippingCost),
          const SizedBox(height: 4),
          _buildSummaryRow('Tax', order.tax),
          if (order.discount > 0) ...[
            const SizedBox(height: 4),
            _buildSummaryRow('Discount', -order.discount, valueColor: AppColors.neonGreen),
          ],
          const SizedBox(height: 8),
          const Divider(color: AppColors.grey),
          const SizedBox(height: 8),
          _buildSummaryRow('Total', order.total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double amount, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    final displayColor = valueColor ?? (isTotal ? AppColors.shop : AppColors.white);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.labelSmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                )
              : AppTextStyles.labelSmall.copyWith(
                  color: AppColors.grey2,
                ),
        ),
        Text(
          '${amount < 0 ? '-' : ''}\$${amount.abs().toStringAsFixed(2)}',
          style: isTotal
              ? AppTextStyles.labelSmall.copyWith(
                  color: displayColor,
                  fontWeight: FontWeight.bold,
                )
              : AppTextStyles.labelSmall.copyWith(
                  color: displayColor,
                ),
        ),
      ],
    );
  }

  Widget _buildAddressSummary(Address address) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: AppColors.shop,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipping Address',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address.fullName,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.grey2,
                  ),
                ),
                Text(
                  '${address.street}, ${address.city}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.grey2,
                  ),
                ),
                Text(
                  '${address.state}, ${address.zipCode}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.grey2,
                  ),
                ),
                Text(
                  address.country,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.grey2,
                  ),
                ),
                Text(
                  address.phone,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.grey2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===== ORDER ITEM ROW =====
class _OrderItemRow extends StatelessWidget {
  final OrderItem item;

  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: AppColors.grey,
                child: Image.network(
                  product.images.first,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.grey,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.grey2,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Qty: ${item.quantity}  •  \$${product.price.toStringAsFixed(2)}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey2,
                    ),
                  ),
                  if (item.selectedSize != null || item.selectedColor != null)
                    Text(
                      '${item.selectedSize ?? ''} ${item.selectedColor != null ? '• ${item.selectedColor}' : ''}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey2,
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
}

// ===== ORDER MODEL =====
enum OrderStatus { processing, shipped, delivered, cancelled }

class Order {
  final String id;
  final List<OrderItem> items;
  final double subtotal;
  final double shippingCost;
  final double tax;
  final double discount;
  final double total;
  final Address shippingAddress;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? deliveredDate;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.tax,
    this.discount = 0,
    required this.total,
    required this.shippingAddress,
    required this.status,
    required this.orderDate,
    this.deliveredDate,
  });

  static List<Order> getMockOrders() {
    final products = ShopMockData.getFeaturedProducts();
    final popularProducts = ShopMockData.getPopularProducts();

    return [
      Order(
        id: 'ORD-2024-001',
        items: [
          OrderItem(
            product: products[0],
            quantity: 2,
            selectedSize: 'M',
            selectedColor: 'Black',
          ),
          OrderItem(
            product: popularProducts[1],
            quantity: 1,
            selectedSize: 'One Size',
            selectedColor: 'Silver',
          ),
        ],
        subtotal: 349.97,
        shippingCost: 0,
        tax: 28.00,
        discount: 0,
        total: 377.97,
        shippingAddress: Address(
          id: '1',
          name: 'Home',
          fullName: 'Ahmed Benali',
          street: '123 Rue Didouche Mourad',
          city: 'Algiers',
          state: 'Alger Centre',
          zipCode: '16000',
          country: 'Algeria',
          phone: '+213 555 123 456',
          isDefault: true,
        ),
        status: OrderStatus.delivered,
        orderDate: DateTime.now().subtract(const Duration(days: 7)),
        deliveredDate: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Order(
        id: 'ORD-2024-002',
        items: [
          OrderItem(
            product: products[2],
            quantity: 1,
            selectedSize: 'L',
            selectedColor: 'Blue',
          ),
        ],
        subtotal: 149.99,
        shippingCost: 15.99,
        tax: 12.00,
        discount: 15.00,
        total: 162.98,
        shippingAddress: Address(
          id: '2',
          name: 'Work',
          fullName: 'Ahmed Benali',
          street: '45 Boulevard Colonel Amirouche',
          city: 'Oran',
          state: 'Oran',
          zipCode: '31000',
          country: 'Algeria',
          phone: '+213 555 789 012',
          isDefault: false,
        ),
        status: OrderStatus.shipped,
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        deliveredDate: null,
      ),
      Order(
        id: 'ORD-2024-003',
        items: [
          OrderItem(
            product: popularProducts[3],
            quantity: 3,
            selectedSize: 'S',
            selectedColor: 'White',
          ),
        ],
        subtotal: 269.97,
        shippingCost: 0,
        tax: 21.60,
        discount: 0,
        total: 291.57,
        shippingAddress: Address(
          id: '1',
          name: 'Home',
          fullName: 'Ahmed Benali',
          street: '123 Rue Didouche Mourad',
          city: 'Algiers',
          state: 'Alger Centre',
          zipCode: '16000',
          country: 'Algeria',
          phone: '+213 555 123 456',
          isDefault: true,
        ),
        status: OrderStatus.processing,
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        deliveredDate: null,
      ),
      Order(
        id: 'ORD-2024-004',
        items: [
          OrderItem(
            product: products[4],
            quantity: 1,
            selectedSize: 'M',
            selectedColor: 'Black',
          ),
        ],
        subtotal: 169.99,
        shippingCost: 15.99,
        tax: 13.60,
        discount: 0,
        total: 199.58,
        shippingAddress: Address(
          id: '3',
          name: 'Parents',
          fullName: 'Ahmed Benali',
          street: '78 Avenue des Palmiers',
          city: 'Constantine',
          state: 'Constantine',
          zipCode: '25000',
          country: 'Algeria',
          phone: '+213 555 456 789',
          isDefault: false,
        ),
        status: OrderStatus.cancelled,
        orderDate: DateTime.now().subtract(const Duration(days: 10)),
        deliveredDate: null,
      ),
    ];
  }
}

class OrderItem {
  final ProductModel product;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;

  OrderItem({
    required this.product,
    required this.quantity,
    this.selectedSize,
    this.selectedColor,
  });
}
