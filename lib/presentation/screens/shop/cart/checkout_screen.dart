// lib/presentation/screens/shop/cart/checkout_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/checkout_models.dart';
import 'package:setrise/presentation/screens/shop/cart/widgets/address_section.dart';
import 'package:setrise/presentation/screens/shop/cart/widgets/payment_section.dart';
import 'package:setrise/presentation/screens/shop/cart/widgets/order_summary_section.dart';

class CheckoutScreen extends StatefulWidget {
  final double subtotal, shippingCost, tax, total;
  const CheckoutScreen({
    super.key,
    required this.subtotal,
    required this.shippingCost,
    required this.tax,
    required this.total,
  });
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _addrIdx = 0;
  int _payIdx = 0;

  final List<Address> _addresses = [
    Address(id: '1', name: 'Home', fullName: 'Ahmed Benali', street: '123 Rue Didouche Mourad', city: 'Algiers', state: 'Alger', zipCode: '16000', country: 'Algeria', phone: '+213 555 123 456', isDefault: true),
    Address(id: '2', name: 'Work', fullName: 'Ahmed Benali', street: '45 Bd Colonel Amirouche', city: 'Oran', state: 'Oran', zipCode: '31000', country: 'Algeria', phone: '+213 555 789 012'),
  ];

  final List<PaymentMethod> _methods = [
    PaymentMethod(id: '1', type: PaymentType.creditCard, name: 'Credit Card', icon: CupertinoIcons.creditcard, details: '**** 4242'),
    PaymentMethod(id: '2', type: PaymentType.paypal, name: 'PayPal', icon: CupertinoIcons.money_dollar, details: 'ahmed@email.com'),
    PaymentMethod(id: '3', type: PaymentType.cashOnDelivery, name: 'Cash on Delivery', icon: CupertinoIcons.money_dollar_circle, details: 'Pay on delivery'),
  ];

  @override
  Widget build(BuildContext context) {
    final total = widget.total;
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.surface,
        middle: Text('Checkout', style: TextStyle(color: AppColors.white)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Shipping Address', style: TextStyle(color: AppColors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            AddressSection(addresses: _addresses, selectedIndex: _addrIdx, onChanged: (v) => setState(() => _addrIdx = v)),
            const SizedBox(height: 24),
            const Text('Payment Method', style: TextStyle(color: AppColors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            PaymentSection(methods: _methods, selectedIndex: _payIdx, onChanged: (v) => setState(() => _payIdx = v)),
            const SizedBox(height: 24),
            OrderSummarySection(subtotal: widget.subtotal, shipping: widget.shippingCost, tax: widget.tax, discount: 0, total: total, couponApplied: false),
            const SizedBox(height: 24),
            CupertinoButton(
              color: AppColors.shop,
              child: Text('Place Order • \$${total.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)),
              onPressed: () {},
            ),
          ]),
        ),
      ),
    );
  }
}
