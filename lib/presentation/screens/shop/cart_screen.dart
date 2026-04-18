// lib/presentation/screens/shop/cart_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'shop_screen.dart'; // لاستخدام CartService

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final TextEditingController _couponController = TextEditingController();
  double _couponDiscount = 0.0;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    if (_couponController.text.trim().toUpperCase() == 'SAVE10') {
      setState(() => _couponDiscount = _cartService.subtotal * 0.1);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coupon applied!'), backgroundColor: AppColors.success));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid coupon'), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Cart', style: AppTextStyles.headline2.copyWith(color: AppColors.primaryText)),
        centerTitle: false,
        foregroundColor: AppColors.primaryText,
      ),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: _cartService.items,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.shopping_bag_outlined, size: 80, color: AppColors.secondaryText), const SizedBox(height: 16), Text('Your cart is empty', style: AppTextStyles.headline2), const SizedBox(height: 8), Text('Add items to get started', style: AppTextStyles.body2.copyWith(color: AppColors.secondaryText))]));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Dismissible(
                      key: Key(item.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _cartService.removeFromCart(item.id),
                      background: Container(color: AppColors.error, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 16), child: const Icon(Icons.delete, color: Colors.white)),
                      child: _buildCartItem(item),
                    );
                  },
                ),
              ),
              _buildCouponSection(),
              _buildOrderSummary(items),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(item.imageUrl, width: 80, height: 80, fit: BoxFit.cover)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.brand, style: AppTextStyles.body2.copyWith(color: AppColors.secondaryText)),
                  Text(item.name, style: AppTextStyles.body1),
                  const SizedBox(height: 8),
                  Text('\$${item.price.toStringAsFixed(2)}', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(icon: const Icon(Icons.remove_circle_outline, color: AppColors.secondaryText), onPressed: () => _cartService.updateQuantity(item.id, item.quantity - 1)),
                Text(item.quantity.toString(), style: AppTextStyles.body1),
                IconButton(icon: const Icon(Icons.add_circle_outline, color: AppColors.accent), onPressed: () => _cartService.updateQuantity(item.id, item.quantity + 1)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(
        children: [
          TextField(
            controller: _couponController,
            decoration: InputDecoration(
              labelText: 'Enter coupon code',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: IconButton(icon: const Icon(Icons.check, color: AppColors.accent), onPressed: _applyCoupon),
            ),
          ),
          if (_couponDiscount > 0) ...[const SizedBox(height: 8), Text('Coupon applied: -\$${_couponDiscount.toStringAsFixed(2)}', style: AppTextStyles.body2.copyWith(color: AppColors.success))],
        ],
      ),
    );
  }

  Widget _buildOrderSummary(List<CartItem> items) {
    final subtotal = items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    final shipping = subtotal > 100 ? 0.0 : 5.99;
    final total = subtotal - _couponDiscount + shipping;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildSummaryRow('Shipping', shipping == 0 ? 'FREE' : '\$${shipping.toStringAsFixed(2)}'),
          if (_couponDiscount > 0) ...[const SizedBox(height: 8), _buildSummaryRow('Discount', '-\$${_couponDiscount.toStringAsFixed(2)}', color: AppColors.success)],
          const SizedBox(height: 8),
          const Divider(color: AppColors.border),
          const SizedBox(height: 8),
          _buildSummaryRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text('Proceed to Checkout', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isTotal ? AppTextStyles.headline2 : AppTextStyles.body1),
        Text(value, style: isTotal ? AppTextStyles.headline2 : AppTextStyles.body1.copyWith(color: color)),
      ],
    );
  }
}
