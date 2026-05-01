// lib/presentation/screens/shop/cart/checkout_screen.dart
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import '../checkout_models.dart';
import 'widgets/address_section.dart';
import 'widgets/payment_section.dart';
import 'widgets/coupon_section_cart.dart';
import 'widgets/order_summary_section.dart';

class CheckoutScreen extends StatefulWidget {
  final double subtotal, shippingCost, tax, total;
  const CheckoutScreen({super.key, required this.subtotal, required this.shippingCost, required this.tax, required this.total});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _addrIdx = 0, _payIdx = 0;
  final _couponCtrl = TextEditingController();
  bool _couponApplied = false;
  double _discount = 0;

  final List<Address> _addresses = [
    Address(id: '1', name: 'Home', fullName: 'Ahmed Benali', street: '123 Rue Didouche Mourad', city: 'Algiers', state: 'Alger Centre', zipCode: '16000', country: 'Algeria', phone: '+213 555 123 456', isDefault: true),
    Address(id: '2', name: 'Work', fullName: 'Ahmed Benali', street: '45 Boulevard Colonel Amirouche', city: 'Oran', state: 'Oran', zipCode: '31000', country: 'Algeria', phone: '+213 555 789 012'),
  ];

  final List<PaymentMethod> _methods = [
    PaymentMethod(id: '1', type: PaymentType.creditCard, name: 'Credit Card', icon: CupertinoIcons.creditcard, details: '**** **** **** 4242'),
    PaymentMethod(id: '2', type: PaymentType.paypal, name: 'PayPal', icon: CupertinoIcons.money_dollar, details: 'ahmed@email.com'),
    PaymentMethod(id: '3', type: PaymentType.cashOnDelivery, name: 'Cash on Delivery', icon: CupertinoIcons.money_dollar_circle, details: 'Pay when you receive'),
  ];

  double get _finalTotal => widget.total - _discount;

  void _placeOrder() {
    showCupertinoDialog(context: context, builder: (ctx) => CupertinoAlertDialog(
      title: const Text('Order Confirmed'),
      content: Text('Your order of \$${_finalTotal.toStringAsFixed(2)} has been placed.'),
      actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.popUntil(context, (route) => route.isFirst))],
    ));
  }

  @override
  Widget build(BuildContext context) {
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
            OrderSummarySection(
              subtotal: widget.subtotal,
              shipping: widget.shippingCost,
              tax: widget.tax,
              discount: _discount,
              total: _finalTotal,
              couponApplied: _couponApplied,
            ),
            const SizedBox(height: 24),
            CupertinoButton(
              color: AppColors.shop,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text('Place Order • \$${_finalTotal.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)),
              onPressed: _placeOrder,
            ),
          ]),
        ),
      ),
    );
  }
}
