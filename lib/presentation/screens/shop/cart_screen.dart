// lib/presentation/screens/shop/cart_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'shop_screen.dart'; // For CartService

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  double _discountAmount = 0.0;
  double _taxRate = 0.08; // 8% tax

  // Mock cart items
  List<CartItem> _cartItems = [
    CartItem(
      id: '1',
      productId: 'prod1',
      name: 'Wireless Headphones',
      price: 89.99,
      imageUrl: 'https://via.placeholder.com/100x100',
      quantity: 1,
    ),
    CartItem(
      id: '2',
      productId: 'prod2',
      name: 'Smart Watch',
      price: 199.99,
      imageUrl: 'https://via.placeholder.com/100x100',
      quantity: 1,
    ),
    CartItem(
      id: '3',
      productId: 'prod3',
      name: 'Phone Case',
      price: 24.99,
      imageUrl: 'https://via.placeholder.com/100x100',
      quantity: 2,
    ),
  ];

  List<CartItem> _savedForLater = [];

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  double get subtotal {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get shipping {
    return subtotal > 100 ? 0 : 5.99; // Free shipping over $100
  }

  double get tax {
    return (subtotal - _discountAmount) * _taxRate;
  }

  double get total {
    return subtotal - _discountAmount + shipping + tax;
  }

  void _removeItem(String id) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == id);
      CartService().setItemCount(_cartItems.length);
    });
  }

  void _updateQuantity(String id, int newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(id);
      return;
    }
    
    setState(() {
      final item = _cartItems.firstWhere((item) => item.id == id);
      item.quantity = newQuantity;
    });
  }

  void _moveToSaved(String id) {
    setState(() {
      final item = _cartItems.firstWhere((item) => item.id == id);
      _cartItems.remove(item);
      _savedForLater.add(item);
      CartService().setItemCount(_cartItems.length);
    });
  }

  void _moveToCart(String id) {
    setState(() {
      final item = _savedForLater.firstWhere((item) => item.id == id);
      _savedForLater.remove(item);
      _cartItems.add(item);
      CartService().setItemCount(_cartItems.length);
    });
  }

  void _applyCoupon() {
    final coupon = _couponController.text.toUpperCase();
    if (coupon == 'SAVE10') {
      setState(() {
        _discountAmount = subtotal * 0.1; // 10% discount
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coupon applied successfully!'),
          backgroundColor: AppColors.electricBlue,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid coupon code'),
          backgroundColor: AppColors.neonRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          "Shopping Cart (${_cartItems.length})",
          style: AppTextStyles.h5.copyWith(color: AppColors.white),
        ),
        centerTitle: false,
      ),
      body: _cartItems.isEmpty && _savedForLater.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: () async {
                // Refresh cart
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cart Items
                          if (_cartItems.isNotEmpty)
                            Text(
                              'Cart Items',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          const SizedBox(height: 12),
                          
                          ..._cartItems.map((item) => _buildCartItem(item)).toList(),
                          
                          // Saved for Later
                          if (_savedForLater.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Saved for Later (${_savedForLater.length})',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _savedForLater.forEach((item) {
                                        _cartItems.add(item);
                                      });
                                      _savedForLater.clear();
                                      CartService().setItemCount(_cartItems.length);
                                    });
                                  },
                                  child: Text(
                                    'Move All to Cart',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.electricBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            
                            ..._savedForLater.map((item) => _buildSavedItem(item)).toList(),
                          ],
                          
                          const SizedBox(height: 16),
                          
                          // Coupon Input
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _couponController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter coupon code',
                                          hintStyle: AppTextStyles.body1.copyWith(
                                            color: AppColors.grey2,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: AppColors.grey2.withOpacity(0.3),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: AppColors.electricBlue,
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                        ),
                                        style: AppTextStyles.body1.copyWith(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: _applyCoupon,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.electricBlue,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                      ),
                                      child: Text(
                                        'Apply',
                                        style: AppTextStyles.body1.copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Order Summary
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                                const SizedBox(height: 8),
                                _buildSummaryRow('Shipping', shipping == 0 
                                    ? 'FREE' 
                                    : '\$${shipping.toStringAsFixed(2)}'),
                                const SizedBox(height: 8),
                                if (_discountAmount > 0)
                                  _buildSummaryRow('Discount', '-\$${_discountAmount.toStringAsFixed(2)}'),
                                const SizedBox(height: 8),
                                _buildSummaryRow('Tax', '\$${tax.toStringAsFixed(2)}'),
                                const SizedBox(height: 12),
                                const Divider(color: AppColors.grey2),
                                const SizedBox(height: 8),
                                _buildSummaryRow(
                                  'Total',
                                  '\$${total.toStringAsFixed(2)}',
                                  isTotal: true,
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Proceed to Checkout
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to checkout
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      'Proceed to Checkout',
                                      style: AppTextStyles.labelLarge.copyWith(
                                        color: AppColors.white,
                                      ),
                                    ),
                                    content: Text(
                                      'This would navigate to the checkout process.',
                                      style: AppTextStyles.body1.copyWith(
                                        color: AppColors.grey2,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'Cancel',
                                          style: AppTextStyles.body1.copyWith(
                                            color: AppColors.grey2,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // Navigate to checkout screen
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.electricBlue,
                                        ),
                                        child: Text(
                                          'Continue',
                                          style: AppTextStyles.body1.copyWith(
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.electricBlue,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Proceed to Checkout',
                                style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: AppColors.grey2,
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: AppTextStyles.h5.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some items to your cart',
            style: AppTextStyles.body1.copyWith(color: AppColors.grey2),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate back to shop
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricBlue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text(
              'Continue Shopping',
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Dismissible(
      key: Key('cart_${item.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _removeItem(item.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: AppColors.neonRed,
        child: const Icon(
          Icons.delete,
          color: AppColors.white,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: AppColors.grey,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: AppColors.grey2,
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
                    item.name,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.electricBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Quantity Selector
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: () => _updateQuantity(item.id, item.quantity - 1),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                            ),
                            Text(
                              '${item.quantity}',
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: () => _updateQuantity(item.id, item.quantity + 1),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Move to saved
                      TextButton(
                        onPressed: () => _moveToSaved(item.id),
                        child: Text(
                          'Save for later',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.grey2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: AppColors.grey,
                child: const Icon(
                  Icons.image_not_supported,
                  color: AppColors.grey2,
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
                  item.name,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.electricBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _moveToCart(item.id),
            child: Text(
              'Move to Cart',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.electricBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body1.copyWith(
            color: isTotal ? AppColors.white : AppColors.grey2,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body1.copyWith(
            color: isTotal ? AppColors.white : AppColors.grey2,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class CartItem {
  String id;
  String productId;
  String name;
  double price;
  String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });
}
