import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/cart_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _currentStep = 0;
  String _selectedPayment = 'card';
  bool _isPlacingOrder = false;

  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  void dispose() {
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _zipCtrl.dispose();
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    setState(() => _isPlacingOrder = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    ref.read(cartProvider.notifier).clearCart();
    setState(() => _isPlacingOrder = false);
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: AppColors.statusDeliveredBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_outline,
                    size: 48, color: AppColors.success),
              ),
              const SizedBox(height: AppDimensions.lg),
              Text('Order Placed!', style: AppTextStyles.headline2),
              const SizedBox(height: AppDimensions.xs),
              Text(
                'Your order has been placed successfully.\nYou\'ll receive a confirmation shortly.',
                style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.xl),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ctaPrimaryBg,
                    foregroundColor: AppColors.ctaPrimaryFg,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMd)),
                  ),
                  child: Text('Back to Shop', style: AppTextStyles.buttonLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: AppColors.textPrimary),
        ),
        title: Text('Checkout', style: AppTextStyles.headline3),
      ),
      body: Column(
        children: [
          // ─── Steps Indicator ───
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg, vertical: AppDimensions.sm),
            child: Row(
              children: [
                _StepDot(step: 0, current: _currentStep, label: 'Address'),
                _StepLine(active: _currentStep >= 1),
                _StepDot(step: 1, current: _currentStep, label: 'Payment'),
                _StepLine(active: _currentStep >= 2),
                _StepDot(step: 2, current: _currentStep, label: 'Review'),
              ],
            ),
          ),

          // ─── Step Content ───
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: _currentStep == 0
                  ? _AddressStep(
                      addressCtrl: _addressCtrl,
                      cityCtrl: _cityCtrl,
                      zipCtrl: _zipCtrl,
                    )
                  : _currentStep == 1
                      ? _PaymentStep(
                          selectedPayment: _selectedPayment,
                          onPaymentChanged: (v) =>
                              setState(() => _selectedPayment = v),
                          cardNumberCtrl: _cardNumberCtrl,
                          expiryCtrl: _expiryCtrl,
                          cvvCtrl: _cvvCtrl,
                        )
                      : _ReviewStep(cart: cart),
            ),
          ),

          // ─── Bottom Button ───
          Container(
            padding: const EdgeInsets.fromLTRB(
                AppDimensions.lg, AppDimensions.sm,
                AppDimensions.lg, AppDimensions.lg),
            decoration: const BoxDecoration(
              color: AppColors.backgroundSecondary,
              border: Border(
                  top: BorderSide(color: AppColors.borderSubtle, width: 0.5)),
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Padding(
                    padding: const EdgeInsets.only(right: AppDimensions.sm),
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () =>
                            setState(() => _currentStep--),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.borderSubtle),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMd)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.lg),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, size: 16),
                      ),
                    ),
                  ),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isPlacingOrder
                          ? null
                          : () {
                              if (_currentStep < 2) {
                                setState(() => _currentStep++);
                              } else {
                                _placeOrder();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ctaPrimaryBg,
                        disabledBackgroundColor: AppColors.ctaPrimaryDisabledBg,
                        foregroundColor: AppColors.ctaPrimaryFg,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMd)),
                      ),
                      child: _isPlacingOrder
                          ? const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.ctaPrimaryFg),
                            )
                          : Text(
                              _currentStep == 0
                                  ? 'Continue to Payment'
                                  : _currentStep == 1
                                      ? 'Review Order'
                                      : 'Place Order  \$${cart.total.toStringAsFixed(2)}',
                              style: AppTextStyles.buttonLabel,
                            ),
                    ),
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

// ─── Step 1: Address ───
class _AddressStep extends StatelessWidget {
  final TextEditingController addressCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController zipCtrl;

  const _AddressStep({
    required this.addressCtrl,
    required this.cityCtrl,
    required this.zipCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping Address', style: AppTextStyles.headline3),
        const SizedBox(height: AppDimensions.lg),
        _Field(controller: addressCtrl, label: 'Street Address', hint: '123 Main Street', icon: Icons.home_outlined),
        const SizedBox(height: AppDimensions.md),
        Row(
          children: [
            Expanded(child: _Field(controller: cityCtrl, label: 'City', hint: 'New York', icon: Icons.location_city_outlined)),
            const SizedBox(width: AppDimensions.sm),
            SizedBox(width: 110, child: _Field(controller: zipCtrl, label: 'ZIP Code', hint: '10001', icon: Icons.markunread_mailbox_outlined, keyboardType: TextInputType.number)),
          ],
        ),
        const SizedBox(height: AppDimensions.xl),
        // Saved address shortcut
        Text('Saved Addresses', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
        const SizedBox(height: AppDimensions.sm),
        _SavedAddressCard(
          name: 'Home',
          address: '742 Evergreen Terrace, Springfield, 62701',
          icon: '🏠',
          onTap: () {
            addressCtrl.text = '742 Evergreen Terrace';
            cityCtrl.text = 'Springfield';
            zipCtrl.text = '62701';
          },
        ),
        const SizedBox(height: AppDimensions.sm),
        _SavedAddressCard(
          name: 'Work',
          address: '350 5th Avenue, New York, 10118',
          icon: '🏢',
          onTap: () {
            addressCtrl.text = '350 5th Avenue';
            cityCtrl.text = 'New York';
            zipCtrl.text = '10118';
          },
        ),
      ],
    );
  }
}

// ─── Step 2: Payment ───
class _PaymentStep extends StatelessWidget {
  final String selectedPayment;
  final ValueChanged<String> onPaymentChanged;
  final TextEditingController cardNumberCtrl;
  final TextEditingController expiryCtrl;
  final TextEditingController cvvCtrl;

  const _PaymentStep({
    required this.selectedPayment,
    required this.onPaymentChanged,
    required this.cardNumberCtrl,
    required this.expiryCtrl,
    required this.cvvCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: AppTextStyles.headline3),
        const SizedBox(height: AppDimensions.lg),
        _PaymentOption(
          value: 'card',
          selected: selectedPayment,
          label: 'Credit / Debit Card',
          icon: Icons.credit_card,
          onTap: () => onPaymentChanged('card'),
        ),
        const SizedBox(height: AppDimensions.sm),
        _PaymentOption(
          value: 'paypal',
          selected: selectedPayment,
          label: 'PayPal',
          icon: Icons.account_balance_wallet_outlined,
          onTap: () => onPaymentChanged('paypal'),
        ),
        const SizedBox(height: AppDimensions.sm),
        _PaymentOption(
          value: 'cod',
          selected: selectedPayment,
          label: 'Cash on Delivery',
          icon: Icons.payments_outlined,
          onTap: () => onPaymentChanged('cod'),
        ),
        if (selectedPayment == 'card') ...[
          const SizedBox(height: AppDimensions.xl),
          Text('Card Details', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: AppDimensions.sm),
          _Field(
            controller: cardNumberCtrl,
            label: 'Card Number',
            hint: '0000 0000 0000 0000',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppDimensions.md),
          Row(
            children: [
              Expanded(child: _Field(controller: expiryCtrl, label: 'Expiry', hint: 'MM/YY', icon: Icons.calendar_today_outlined)),
              const SizedBox(width: AppDimensions.sm),
              SizedBox(width: 110, child: _Field(controller: cvvCtrl, label: 'CVV', hint: '123', icon: Icons.lock_outlined, keyboardType: TextInputType.number)),
            ],
          ),
        ],
      ],
    );
  }
}

// ─── Step 3: Review ───
class _ReviewStep extends ConsumerWidget {
  final CartState cart;
  const _ReviewStep({required this.cart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Review', style: AppTextStyles.headline3),
        const SizedBox(height: AppDimensions.lg),
        ...cart.items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.sm),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Row(
              children: [
                Text('${item.quantity}x', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary, fontWeight: FontWeight.w700)),
                const SizedBox(width: AppDimensions.sm),
                Expanded(child: Text(item.product.name, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
                Text('\$${item.subtotal.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.ctaPrimaryBg)),
              ],
            ),
          ),
        )),
        const SizedBox(height: AppDimensions.md),
        Container(
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Column(
            children: [
              _Row('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: AppDimensions.xs),
              _Row('Shipping', cart.shipping == 0 ? 'FREE' : '\$${cart.shipping.toStringAsFixed(2)}', valueColor: cart.shipping == 0 ? AppColors.success : null),
              const SizedBox(height: AppDimensions.xs),
              _Row('Tax', '\$${cart.tax.toStringAsFixed(2)}'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppDimensions.sm),
                child: Divider(color: AppColors.borderSubtle, height: 1),
              ),
              _Row('Total', '\$${cart.total.toStringAsFixed(2)}', isBold: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;
  const _Row(this.label, this.value, {this.isBold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isBold ? AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700) : AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
        Text(value, style: isBold ? AppTextStyles.priceMedium.copyWith(fontWeight: FontWeight.w800) : AppTextStyles.bodySmall.copyWith(color: valueColor ?? AppColors.textPrimary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ─── Shared Widgets ───
class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: AppColors.textTertiary),
        labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
        hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textQuaternary),
        filled: true,
        fillColor: AppColors.backgroundSecondary,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md, vertical: AppDimensions.md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.ctaPrimaryBg, width: 1.5),
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String value;
  final String selected;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.value,
    required this.selected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.statusActiveBg : AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.fromBorderSide(BorderSide(
            color: isSelected ? AppColors.ctaPrimaryBg : AppColors.borderSubtle,
            width: isSelected ? 1.5 : 0.5,
          )),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22,
                color: isSelected ? AppColors.ctaPrimaryBg : AppColors.textTertiary),
            const SizedBox(width: AppDimensions.md),
            Text(label, style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary)),
            const Spacer(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 20, height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.ctaPrimaryBg : AppColors.borderMedium,
                  width: 2,
                ),
                color: isSelected ? AppColors.ctaPrimaryBg : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedAddressCard extends StatelessWidget {
  final String name;
  final String address;
  final String icon;
  final VoidCallback onTap;

  const _SavedAddressCard({
    required this.name,
    required this.address,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: const Border.fromBorderSide(
              BorderSide(color: AppColors.borderSubtle, width: 0.5)),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                  Text(address, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Text('Use', style: AppTextStyles.caption.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int step;
  final int current;
  final String label;
  const _StepDot({required this.step, required this.current, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDone = current > step;
    final isActive = current == step;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 32, height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? AppColors.success
                : isActive
                    ? AppColors.ctaPrimaryBg
                    : AppColors.backgroundTertiary,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text('${step + 1}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : AppColors.textQuaternary,
                    )),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: AppTextStyles.caption.copyWith(
              color: isActive ? AppColors.ctaPrimaryBg : AppColors.textQuaternary,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            )),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool active;
  const _StepLine({required this.active});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 2,
          color: active ? AppColors.ctaPrimaryBg : AppColors.borderSubtle,
        ),
      ),
    );
  }
}
