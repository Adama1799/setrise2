// lib/presentation/screens/shop/checkout_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CheckoutScreen extends StatefulWidget {
  final double subtotal;
  final double shippingCost;
  final double tax;
  final double total;

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
  int _selectedAddressIndex = 0;
  int _selectedPaymentIndex = 0;
  final TextEditingController _couponController = TextEditingController();
  bool _couponApplied = false;
  double _discount = 0;

  // Mock addresses
  final List<Address> _addresses = [
    Address(
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
    Address(
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
  ];

  // Payment methods
  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      id: '1',
      type: PaymentType.creditCard,
      name: 'Credit Card',
      icon: Icons.credit_card_rounded,
      details: '**** **** **** 4242',
    ),
    PaymentMethod(
      id: '2',
      type: PaymentType.paypal,
      name: 'PayPal',
      icon: Icons.account_balance_wallet_rounded,
      details: 'ahmed@email.com',
    ),
    PaymentMethod(
      id: '3',
      type: PaymentType.cashOnDelivery,
      name: 'Cash on Delivery',
      icon: Icons.payments_rounded,
      details: 'Pay when you receive',
    ),
  ];

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    if (_couponController.text.trim().toUpperCase() == 'WELCOME10') {
      setState(() {
        _couponApplied = true;
        _discount = widget.subtotal * 0.1; // 10% discount
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coupon applied! 10% discount'),
          backgroundColor: AppColors.neonGreen,
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

  void _placeOrder() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.neonGreen,
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Order Placed Successfully!',
              style: AppTextStyles.h5.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your order has been placed and will be processed shortly.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  // Pop back to shop screen (or orders)
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.shop,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Continue Shopping',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double get _finalTotal => widget.total - _discount;

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
          'Checkout',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping Address Section
            _buildSectionHeader('Shipping Address', Icons.location_on_outlined),
            const SizedBox(height: 12),
            _buildAddressSection(),
            const SizedBox(height: 24),

            // Payment Method Section
            _buildSectionHeader('Payment Method', Icons.payment_outlined),
            const SizedBox(height: 12),
            _buildPaymentSection(),
            const SizedBox(height: 24),

            // Coupon Code
            _buildSectionHeader('Coupon Code', Icons.local_offer_outlined),
            const SizedBox(height: 12),
            _buildCouponSection(),
            const SizedBox(height: 24),

            // Order Summary
            _buildSectionHeader('Order Summary', Icons.receipt_outlined),
            const SizedBox(height: 12),
            _buildOrderSummary(),
            const SizedBox(height: 24),

            // Place Order Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.shop,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Place Order • \$${_finalTotal.toStringAsFixed(2)}',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.shop,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _addresses.length,
            itemBuilder: (context, index) {
              final address = _addresses[index];
              final isSelected = _selectedAddressIndex == index;
              return RadioListTile<int>(
                value: index,
                groupValue: _selectedAddressIndex,
                onChanged: (value) {
                  setState(() {
                    _selectedAddressIndex = value!;
                  });
                },
                activeColor: AppColors.shop,
                title: Row(
                  children: [
                    Text(
                      address.name,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (address.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.shop.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Default',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.shop,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      address.fullName,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      '${address.street}, ${address.city}, ${address.state} ${address.zipCode}',
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
                secondary: IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.grey2,
                    size: 18,
                  ),
                  onPressed: () {
                    // TODO: Edit address
                  },
                ),
              );
            },
          ),
          const Divider(color: AppColors.grey, height: 1),
          TextButton.icon(
            onPressed: () {
              // TODO: Add new address
            },
            icon: const Icon(
              Icons.add_rounded,
              color: AppColors.shop,
              size: 18,
            ),
            label: Text(
              'Add New Address',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.shop,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: _paymentMethods.asMap().entries.map((entry) {
          final index = entry.key;
          final method = entry.value;
          final isSelected = _selectedPaymentIndex == index;
          return RadioListTile<int>(
            value: index,
            groupValue: _selectedPaymentIndex,
            onChanged: (value) {
              setState(() {
                _selectedPaymentIndex = value!;
              });
            },
            activeColor: AppColors.shop,
            title: Row(
              children: [
                Icon(
                  method.icon,
                  color: isSelected ? AppColors.shop : AppColors.grey2,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  method.name,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 34),
              child: Text(
                method.details,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.grey2,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCouponSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _couponController,
              enabled: !_couponApplied,
              style: AppTextStyles.bodyMedium.copyWith(
                color: _couponApplied ? AppColors.grey2 : AppColors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Enter coupon code',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey2,
                ),
                border: InputBorder.none,
                suffixIcon: _couponApplied
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.neonGreen,
                      )
                    : null,
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ),
          if (!_couponApplied)
            ElevatedButton(
              onPressed: _applyCoupon,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.shop,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Apply',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', widget.subtotal),
          const SizedBox(height: 8),
          _buildSummaryRow('Shipping', widget.shippingCost),
          const SizedBox(height: 8),
          _buildSummaryRow('Tax (8%)', widget.tax),
          if (_couponApplied) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Discount (10%)',
              -_discount,
              valueColor: AppColors.neonGreen,
            ),
          ],
          const SizedBox(height: 12),
          const Divider(color: AppColors.grey),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Total',
            _finalTotal,
            isTotal: true,
          ),
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
              ? AppTextStyles.labelLarge.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                )
              : AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey2,
                ),
        ),
        Text(
          '${amount < 0 ? '-' : ''}\$${amount.abs().toStringAsFixed(2)}',
          style: isTotal
              ? AppTextStyles.labelLarge.copyWith(
                  color: displayColor,
                  fontWeight: FontWeight.bold,
                )
              : AppTextStyles.bodyMedium.copyWith(
                  color: displayColor,
                ),
        ),
      ],
    );
  }
}

// ===== ADDRESS MODEL =====
class Address {
  final String id;
  final String name;
  final String fullName;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String phone;
  final bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.fullName,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.phone,
    this.isDefault = false,
  });
}

// ===== PAYMENT METHOD MODEL =====
enum PaymentType { creditCard, paypal, cashOnDelivery }

class PaymentMethod {
  final String id;
  final PaymentType type;
  final String name;
  final IconData icon;
  final String details;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.name,
    required this.icon,
    required this.details,
  });
}
