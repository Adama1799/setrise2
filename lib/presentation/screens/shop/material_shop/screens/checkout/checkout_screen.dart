import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/cart_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/orders_provider.dart';

// ─── Address Model ───────────────────────────────────────────
class SavedAddress {
  final String id, label, street, city, zip, country;
  bool isDefault;

  SavedAddress({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.zip,
    required this.country,
    this.isDefault = false,
  });

  String get full => '$street, $city $zip, $country';
}

// ─── Address Provider ────────────────────────────────────────
class AddressNotifier extends StateNotifier<List<SavedAddress>> {
  AddressNotifier()
      : super([
          SavedAddress(
            id: 'a1',
            label: '🏠 Home',
            street: '742 Evergreen Terrace',
            city: 'Springfield',
            zip: '62701',
            country: 'United States',
            isDefault: true,
          ),
          SavedAddress(
            id: 'a2',
            label: '🏢 Work',
            street: '350 5th Avenue',
            city: 'New York',
            zip: '10118',
            country: 'United States',
          ),
        ]);

  void add(SavedAddress address) => state = [...state, address];

  void remove(String id) => state = state.where((a) => a.id != id).toList();

  void setDefault(String id) {
    state = [
      for (final a in state)
        SavedAddress(
          id: a.id,
          label: a.label,
          street: a.street,
          city: a.city,
          zip: a.zip,
          country: a.country,
          isDefault: a.id == id,
        )
    ];
  }

  SavedAddress? get defaultAddress =>
      state.isEmpty ? null : state.firstWhere((a) => a.isDefault, orElse: () => state.first);
}

final addressProvider =
    StateNotifierProvider<AddressNotifier, List<SavedAddress>>(
  (_) => AddressNotifier(),
);

// ─── Checkout Screen ─────────────────────────────────────────
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _step = 0;
  String _payment = 'card';
  bool _placing = false;
  String? _selectedAddressId;
  String _smsCode = '';
  bool _smsVerified = false;
  bool _smsSent = false;

  final _cardCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _smsCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final def = ref.read(addressProvider).firstOrNull;
      if (def != null) {
        setState(() => _selectedAddressId = def.id);
      }
    });
  }

  @override
  void dispose() {
    _cardCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _smsCtrl.dispose();
    super.dispose();
  }

  void _sendSms() {
    final code = (100000 + Random().nextInt(900000)).toString();
    setState(() {
      _smsCode = code;
      _smsSent = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '📱 SMS sent! Code: $code (demo)',
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppDimensions.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _verifySms() {
    if (_smsCtrl.text.trim() == _smsCode) {
      setState(() => _smsVerified = true);
      HapticFeedback.mediumImpact();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '❌ Wrong code. Try again.',
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(AppDimensions.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
      );
    }
  }

  bool get _stepValid {
    if (_step == 0) return _selectedAddressId != null;
    if (_step == 1) return _payment.isNotEmpty;
    if (_step == 2) return _smsVerified;
    return true;
  }

  Future<void> _placeOrder() async {
    setState(() => _placing = true);
    final cart = ref.read(cartProvider);

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    ref.read(ordersProvider.notifier).placeOrder(cart);
    ref.read(cartProvider.notifier).clearCart();

    setState(() => _placing = false);
    _showSuccess();
  }

  void _showSuccess() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: AppColors.statusDeliveredBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 48,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),
                Text(
                  'Order Placed! 🎉',
                  style: AppTextStyles.headline2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  'Your order has been confirmed.\nCheck My Orders for tracking.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
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
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd,
                        ),
                      ),
                    ),
                    child: Text('Back to Shop', style: AppTextStyles.buttonLabel),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final addresses = ref.watch(addressProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text('Checkout', style: AppTextStyles.headline3),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.lg,
              vertical: AppDimensions.md,
            ),
            child: Row(
              children: [
                _Dot(step: 0, current: _step, label: 'Address'),
                _Line(active: _step >= 1),
                _Dot(step: 1, current: _step, label: 'Payment'),
                _Line(active: _step >= 2),
                _Dot(step: 2, current: _step, label: 'Confirm'),
                _Line(active: _step >= 3),
                _Dot(step: 3, current: _step, label: 'Review'),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: _step == 0
                  ? _AddressStep(
                      addresses: addresses,
                      selected: _selectedAddressId,
                      onSelect: (id) => setState(() => _selectedAddressId = id),
                    )
                  : _step == 1
                      ? _PaymentStep(
                          selected: _payment,
                          onChanged: (v) => setState(() => _payment = v),
                          cardCtrl: _cardCtrl,
                          expiryCtrl: _expiryCtrl,
                          cvvCtrl: _cvvCtrl,
                        )
                      : _step == 2
                          ? _SmsStep(
                              sent: _smsSent,
                              verified: _smsVerified,
                              ctrl: _smsCtrl,
                              onSend: _sendSms,
                              onVerify: _verifySms,
                            )
                          : _ReviewStep(cart: cart),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                )
              ],
            ),
            padding: EdgeInsets.fromLTRB(
              AppDimensions.lg,
              AppDimensions.sm,
              AppDimensions.lg,
              MediaQuery.of(context).padding.bottom + AppDimensions.sm,
            ),
            child: Row(
              children: [
                if (_step > 0)
                  Padding(
                    padding: const EdgeInsets.only(right: AppDimensions.sm),
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => setState(() => _step--),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.borderSubtle),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMd,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.lg,
                          ),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, size: 16),
                      ),
                    ),
                  ),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: (!_stepValid || _placing)
                          ? null
                          : () {
                              if (_step < 3) {
                                setState(() => _step++);
                              } else {
                                _placeOrder();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ctaPrimaryBg,
                        disabledBackgroundColor: AppColors.ctaPrimaryDisabledBg,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMd,
                          ),
                        ),
                      ),
                      child: _placing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _step == 0
                                  ? 'Continue to Payment'
                                  : _step == 1
                                      ? 'Continue to Verify'
                                      : _step == 2
                                          ? 'Review Order'
                                          : 'Place Order  ·  \$${cart.total.toStringAsFixed(2)}',
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

// ─── Step 1: Address Book ────────────────────────────────────
class _AddressStep extends ConsumerWidget {
  final List<SavedAddress> addresses;
  final String? selected;
  final ValueChanged<String> onSelect;

  const _AddressStep({
    required this.addresses,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Shipping Address', style: AppTextStyles.headline3),
            const Spacer(),
            GestureDetector(
              onTap: () => _showAddDialog(context, ref),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.statusActiveBg,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      size: 14,
                      color: AppColors.ctaPrimaryBg,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Add New',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.ctaPrimaryBg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.md),
        ...addresses.map(
          (addr) => _AddressCard(
            address: addr,
            isSelected: selected == addr.id,
            onTap: () => onSelect(addr.id),
            onSetDefault: () =>
                ref.read(addressProvider.notifier).setDefault(addr.id),
            onDelete: addr.isDefault
                ? null
                : () => ref.read(addressProvider.notifier).remove(addr.id),
          ),
        ),
      ],
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final labelCtrl = TextEditingController();
    final streetCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final zipCtrl = TextEditingController();
    final countryCtrl = TextEditingController(text: 'United States');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        title: Text('Add New Address', style: AppTextStyles.headline3),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Field(
                ctrl: labelCtrl,
                label: 'Label',
                hint: 'e.g. 🏠 Home',
                icon: Icons.label_outline,
              ),
              const SizedBox(height: AppDimensions.sm),
              _Field(
                ctrl: streetCtrl,
                label: 'Street',
                hint: '123 Main Street',
                icon: Icons.home_outlined,
              ),
              const SizedBox(height: AppDimensions.sm),
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      ctrl: cityCtrl,
                      label: 'City',
                      hint: 'New York',
                      icon: Icons.location_city_outlined,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  SizedBox(
                    width: 100,
                    child: _Field(
                      ctrl: zipCtrl,
                      label: 'ZIP',
                      hint: '10001',
                      icon: Icons.markunread_mailbox_outlined,
                      keyboard: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.sm),
              _Field(
                ctrl: countryCtrl,
                label: 'Country',
                hint: 'United States',
                icon: Icons.flag_outlined,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (streetCtrl.text.isNotEmpty && cityCtrl.text.isNotEmpty) {
                ref.read(addressProvider.notifier).add(
                      SavedAddress(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        label:
                            labelCtrl.text.isEmpty ? '📍 New Address' : labelCtrl.text,
                        street: streetCtrl.text,
                        city: cityCtrl.text,
                        zip: zipCtrl.text,
                        country: countryCtrl.text,
                      ),
                    );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ctaPrimaryBg,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
            ),
            child: Text('Save', style: AppTextStyles.buttonLabel),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final SavedAddress address;
  final bool isSelected;
  final VoidCallback onTap, onSetDefault;
  final VoidCallback? onDelete;

  const _AddressCard({
    required this.address,
    required this.isSelected,
    required this.onTap,
    required this.onSetDefault,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: AppDimensions.sm),
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.statusActiveBg : Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: isSelected
                  ? AppColors.ctaPrimaryBg
                  : AppColors.borderSubtle,
              width: isSelected ? 1.5 : 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.ctaPrimaryBg : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.ctaPrimaryBg
                        : AppColors.borderMedium,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.label,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (address.isDefault) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.statusDeliveredBg,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusXs,
                              ),
                            ),
                            child: Text(
                              'Default',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address.full,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Row(
                      children: [
                        if (!address.isDefault)
                          GestureDetector(
                            onTap: onSetDefault,
                            child: Text(
                              'Set as Default',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.ctaPrimaryBg,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        const Spacer(),
                        if (onDelete != null)
                          GestureDetector(
                            onTap: onDelete,
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                              color: AppColors.error,
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

// ─── Step 2: Payment ─────────────────────────────────────────
class _PaymentStep extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  final TextEditingController cardCtrl, expiryCtrl, cvvCtrl;

  const _PaymentStep({
    required this.selected,
    required this.onChanged,
    required this.cardCtrl,
    required this.expiryCtrl,
    required this.cvvCtrl,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Method', style: AppTextStyles.headline3),
          const SizedBox(height: AppDimensions.lg),
          _PayOpt(
            value: 'card',
            cur: selected,
            label: 'Credit / Debit Card',
            sub: 'Visa, Mastercard, Amex',
            icon: Icons.credit_card_rounded,
            onTap: () => onChanged('card'),
          ),
          const SizedBox(height: AppDimensions.sm),
          _PayOpt(
            value: 'paypal',
            cur: selected,
            label: 'PayPal',
            sub: 'Pay securely with PayPal',
            icon: Icons.account_balance_wallet_outlined,
            onTap: () => onChanged('paypal'),
          ),
          const SizedBox(height: AppDimensions.sm),
          _PayOpt(
            value: 'apple',
            cur: selected,
            label: 'Apple Pay',
            sub: 'Touch ID or Face ID',
            icon: Icons.phone_iphone_rounded,
            onTap: () => onChanged('apple'),
          ),
          const SizedBox(height: AppDimensions.sm),
          _PayOpt(
            value: 'cod',
            cur: selected,
            label: 'Cash on Delivery',
            sub: 'Pay when delivered',
            icon: Icons.payments_outlined,
            onTap: () => onChanged('cod'),
          ),
          if (selected == 'card') ...[
            const SizedBox(height: AppDimensions.lg),
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                children: [
                  _Field(
                    ctrl: cardCtrl,
                    label: 'Card Number',
                    hint: '0000  0000  0000  0000',
                    icon: Icons.credit_card_rounded,
                    keyboard: TextInputType.number,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Row(
                    children: [
                      Expanded(
                        child: _Field(
                          ctrl: expiryCtrl,
                          label: 'Expiry',
                          hint: 'MM/YY',
                          icon: Icons.calendar_today_outlined,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      SizedBox(
                        width: 110,
                        child: _Field(
                          ctrl: cvvCtrl,
                          label: 'CVV',
                          hint: '•••',
                          icon: Icons.lock_outline_rounded,
                          keyboard: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      );
}

// ─── Step 3: SMS Verification ────────────────────────────────
class _SmsStep extends StatelessWidget {
  final bool sent, verified;
  final TextEditingController ctrl;
  final VoidCallback onSend, onVerify;

  const _SmsStep({
    required this.sent,
    required this.verified,
    required this.ctrl,
    required this.onSend,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Verify Your Phone', style: AppTextStyles.headline3),
          const SizedBox(height: AppDimensions.xs),
          Text(
            'We\'ll send a one-time code to confirm your order.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppDimensions.xl),
          if (verified) ...[
            Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: AppColors.statusDeliveredBg,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: AppColors.success,
                    size: 28,
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone Verified ✓',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.success,
                          ),
                        ),
                        Text(
                          'You can proceed to review your order.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        color: AppColors.textTertiary,
                        size: 20,
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      Text(
                        '+1 (555) 000-0000',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onSend,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.md,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.ctaPrimaryBg,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusSm,
                            ),
                          ),
                          child: Text(
                            sent ? 'Resend' : 'Send Code',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (sent) ...[
                    const SizedBox(height: AppDimensions.md),
                    const Divider(color: AppColors.borderSubtle, height: 1),
                    const SizedBox(height: AppDimensions.md),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: ctrl,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            style: AppTextStyles.headline3.copyWith(
                              letterSpacing: 8,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: '------',
                              counterText: '',
                              hintStyle: AppTextStyles.headline3.copyWith(
                                letterSpacing: 8,
                                color: AppColors.textQuaternary,
                              ),
                              filled: true,
                              fillColor: AppColors.backgroundPrimary,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusSm,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusSm,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.ctaPrimaryBg,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: onVerify,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.ctaPrimaryBg,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusSm,
                                ),
                              ),
                            ),
                            child: Text('Verify', style: AppTextStyles.buttonLabel),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      );
}

// ─── Step 4: Review ──────────────────────────────────────────
class _ReviewStep extends ConsumerWidget {
  final CartState cart;
  const _ReviewStep({required this.cart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressProvider);
    final selected = addresses.firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Review', style: AppTextStyles.headline3),
        const SizedBox(height: AppDimensions.md),
        if (selected != null)
          Container(
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.ctaPrimaryBg,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selected.label,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        selected.full,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppDimensions.md),
        Container(
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
            ],
          ),
          child: Column(
            children: [
              ...cart.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.xs),
                  child: Row(
                    children: [
                      Text(
                        '${item.quantity}x',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.xs),
                      Expanded(
                        child: Text(
                          item.product.name,
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${item.subtotal.toStringAsFixed(2)}',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.ctaPrimaryBg,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(color: AppColors.borderSubtle, height: 16),
              _Row('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 4),
              _Row(
                'Shipping',
                cart.shipping == 0
                    ? 'FREE'
                    : '\$${cart.shipping.toStringAsFixed(2)}',
                color: cart.shipping == 0 ? AppColors.success : null,
              ),
              const SizedBox(height: 4),
              _Row('Tax', '\$${cart.tax.toStringAsFixed(2)}'),
              const Divider(color: AppColors.borderSubtle, height: 16),
              _Row(
                'Total',
                '\$${cart.total.toStringAsFixed(2)}',
                bold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final String l, v;
  final bool bold;
  final Color? color;
  const _Row(this.l, this.v, {this.bold = false, this.color});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l,
            style: bold
                ? AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  )
                : AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
          ),
          Text(
            v,
            style: bold
                ? AppTextStyles.priceMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  )
                : AppTextStyles.bodySmall.copyWith(
                    color: color ?? AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
          ),
        ],
      );
}

// ─── Shared Widgets ──────────────────────────────────────────
class _Dot extends StatelessWidget {
  final int step, current;
  final String label;
  const _Dot({
    required this.step,
    required this.current,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final done = current > step;
    final active = current == step;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done
                ? AppColors.success
                : active
                    ? AppColors.ctaPrimaryBg
                    : AppColors.backgroundTertiary,
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.ctaPrimaryBg.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ]
                : null,
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: active ? Colors.white : AppColors.textQuaternary,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.ctaPrimaryBg : AppColors.textQuaternary,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  final bool active;
  const _Line({required this.active});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 2,
            color: active ? AppColors.success : AppColors.borderSubtle,
          ),
        ),
      );
}

class _PayOpt extends StatelessWidget {
  final String value, cur, label, sub;
  final IconData icon;
  final VoidCallback onTap;

  const _PayOpt({
    required this.value,
    required this.cur,
    required this.label,
    required this.sub,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sel = value == cur;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: sel ? AppColors.statusActiveBg : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: sel ? AppColors.ctaPrimaryBg : AppColors.borderSubtle,
            width: sel ? 1.5 : 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: sel
                    ? AppColors.ctaPrimaryBg.withOpacity(0.1)
                    : AppColors.backgroundPrimary,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(
                icon,
                size: 20,
                color: sel ? AppColors.ctaPrimaryBg : AppColors.textTertiary,
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: sel
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    sub,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: sel ? AppColors.ctaPrimaryBg : Colors.white,
                border: Border.all(
                  color: sel ? AppColors.ctaPrimaryBg : AppColors.borderMedium,
                  width: 2,
                ),
              ),
              child: sel
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String label, hint;
  final IconData icon;
  final TextInputType keyboard;

  const _Field({
    required this.ctrl,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) => TextField(
        controller: ctrl,
        keyboardType: keyboard,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, size: 18, color: AppColors.textTertiary),
          labelStyle: AppTextStyles.caption.copyWith(
            color: AppColors.textTertiary,
          ),
          hintStyle: AppTextStyles.caption.copyWith(
            color: AppColors.textQuaternary,
          ),
          filled: true,
          fillColor: AppColors.backgroundPrimary,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.md,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            borderSide: const BorderSide(
              color: AppColors.ctaPrimaryBg,
              width: 1.5,
            ),
          ),
        ),
      );
}

extension FirstOrNullExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
