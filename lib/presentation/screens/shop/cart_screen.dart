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
        title: Text('Cart', style: AppTextStyles.h4.copyWith(color: AppColors.white)),
        centerTitle: false,
        foregroundColor: AppColors.white,
      ),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: _cartService.items,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: AppColors.grey2),
                  const SizedBox(height: 16),
                  Text('Your cart is empty', style: AppTextStyles.h4.copyWith(color: AppColors.white)),
                  const SizedBox(height: 8),
                  Text('Add items to get started', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2)),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Dismissible(
                      key: Key(item.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _cartService.removeFromCart(item.id),
                      background: Container(
                        color: AppColors.error,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete_rounded, color: Colors.white),
                      ),
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(item.imageUrl, width: 80, height: 80, fit: BoxFit.cover)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.brand, style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey2)),
                  const SizedBox(height: 4),
                  Text(item.name, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text('\$${item.price.toStringAsFixed(2)}', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(icon: Icon(Icons.remove_circle_outline_rounded, color: AppColors.grey2), onPressed: () => _cartService.updateQuantity(item.id, item.quantity - 1)),
                Text(item.quantity.toString(), style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
                IconButton(icon: Icon(Icons.add_circle_outline_rounded, color: AppColors.primary), onPressed: () => _cartService.updateQuantity(item.id, item.quantity + 1)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          TextField(
            controller: _couponController,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
            decoration: InputDecoration(
              labelText: 'Enter coupon code',
              labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              filled: true,
              fillColor: AppColors.background,
              suffixIcon: IconButton(icon: Icon(Icons.check_rounded, color: AppColors.primary), onPressed: _applyCoupon),
            ),
          ),
          if (_couponDiscount > 0) ...[
            const SizedBox(height: 8),
            Text('Coupon applied: -\$${_couponDiscount.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.success)),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderSummary(List<CartItem> items) {
    final subtotal = items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    final shipping = subtotal > 100 ? 0.0 : 5.99;
    final total = subtotal - _couponDiscount + shipping;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildSummaryRow('Shipping', shipping == 0 ? 'FREE' : '\$${shipping.toStringAsFixed(2)}'),
          if (_couponDiscount > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow('Discount', '-\$${_couponDiscount.toStringAsFixed(2)}', color: AppColors.success),
          ],
          const SizedBox(height: 12),
          Divider(color: AppColors.grey3),
          const SizedBox(height: 12),
          _buildSummaryRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Proceed to Checkout', style: AppTextStyles.button.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isTotal ? AppTextStyles.h5.copyWith(color: AppColors.white) : AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2)),
        Text(value, style: isTotal ? AppTextStyles.h5.copyWith(color: color ?? AppColors.primary) : AppTextStyles.bodyMedium.copyWith(color: color ?? AppColors.white)),
      ],
    );
  }
}
