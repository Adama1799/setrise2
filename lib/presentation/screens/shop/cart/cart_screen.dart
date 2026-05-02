// lib/presentation/screens/shop/cart/cart_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/cart_service.dart';
import 'package:setrise/presentation/screens/shop/cart/widgets/cart_item.dart';
import 'package:setrise/presentation/screens/shop/cart/widgets/coupon_section_cart.dart';
import 'package:setrise/presentation/screens/shop/cart/widgets/order_summary_cart.dart';
import 'package:setrise/presentation/screens/shop/cart/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final _couponController = TextEditingController();
  double _couponDiscount = 0.0;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    if (_couponController.text.trim().toUpperCase() == 'SAVE10') {
      setState(() => _couponDiscount = _cartService.subtotal * 0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Cart', style: TextStyle(color: AppColors.white)),
      ),
      child: ValueListenableBuilder<List<CartItem>>(
        valueListenable: _cartService.items,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.cart, size: 60, color: AppColors.grey2),
                  const SizedBox(height: 12),
                  const Text('Your cart is empty', style: TextStyle(color: AppColors.white)),
                ],
              ),
            );
          }

          final subtotal = items.fold(0.0, (sum, item) => sum + item.price * item.quantity);
          final shipping = subtotal > 100 ? 0.0 : 5.99;
          final total = subtotal - _couponDiscount + shipping;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return CartItemWidget(
                      imageUrl: item.imageUrl,
                      brand: item.brand,
                      name: item.name,
                      price: item.price,
                      quantity: item.quantity,
                      onDecrement: () => _cartService.updateQuantity(item.id, item.quantity - 1),
                      onIncrement: () => _cartService.updateQuantity(item.id, item.quantity + 1),
                    );
                  },
                ),
              ),
              CouponSectionCart(
                controller: _couponController,
                onApply: _applyCoupon,
                discount: _couponDiscount,
                enabled: _couponDiscount == 0,
              ),
              OrderSummaryCart(
                subtotal: subtotal,
                shipping: shipping,
                discount: _couponDiscount,
                total: total,
                onCheckout: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => CheckoutScreen(
                        subtotal: subtotal,
                        shippingCost: shipping,
                        tax: 0,
                        total: total,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
