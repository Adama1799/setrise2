// lib/presentation/screens/shop/payment_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final VoidCallback onPaymentSuccess;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.onPaymentSuccess,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  bool _saveCard = false;
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  String _formatCardNumber(String value) {
    value = value.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    if (value.length > 16) value = value.substring(0, 16);
    final buffer = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(value[i]);
    }
    return buffer.toString();
  }

  String _formatExpiry(String value) {
    value = value.replaceAll(RegExp(r'[^\d]'), '');
    if (value.length > 4) value = value.substring(0, 4);
    if (value.length >= 2) {
      return '${value.substring(0, 2)}/${value.substring(2)}';
    }
    return value;
  }

  void _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isProcessing = false);

    if (!mounted) return;

    // Show success dialog
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
              'Payment Successful!',
              style: AppTextStyles.h5.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your payment of \$${widget.amount.toStringAsFixed(2)} has been processed successfully.',
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
                  Navigator.pop(context);
                  widget.onPaymentSuccess();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.shop,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Continue',
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

  Widget _buildCardTypeIcon() {
    final cardNumber = _cardNumberController.text.replaceAll(' ', '');
    IconData icon;
    Color color;

    if (cardNumber.isEmpty) {
      icon = Icons.credit_card_rounded;
      color = AppColors.grey2;
    } else if (cardNumber.startsWith('4')) {
      icon = Icons.credit_card_rounded; // Visa
      color = const Color(0xFF1A1F71);
    } else if (cardNumber.startsWith('5')) {
      icon = Icons.credit_card_rounded; // Mastercard
      color = const Color(0xFFEB001B);
    } else if (cardNumber.startsWith('3')) {
      icon = Icons.credit_card_rounded; // Amex
      color = const Color(0xFF2E77BC);
    } else {
      icon = Icons.credit_card_rounded;
      color = AppColors.grey2;
    }

    return Icon(icon, color: color, size: 32);
  }

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
          'Payment',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount display
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.shop.withOpacity(0.8),
                      AppColors.shop.withOpacity(0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.black.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${widget.amount.toStringAsFixed(2)}',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Payment methods tabs
              Text(
                'Payment Method',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.shop,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.credit_card_rounded,
                              color: AppColors.black,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Credit Card',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_wallet_rounded,
                              color: AppColors.grey2,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'PayPal',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.grey2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Card preview
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2C3E50),
                      const Color(0xFF1A252F),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 20,
                      right: 20,
                      child: _buildCardTypeIcon(),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _cardNumberController.text.isEmpty
                                ? '•••• •••• •••• ••••'
                                : _cardNumberController.text,
                            style: AppTextStyles.h5.copyWith(
                              color: AppColors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CARD HOLDER',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.grey2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _cardHolderController.text.isEmpty
                                        ? 'YOUR NAME'
                                        : _cardHolderController.text.toUpperCase(),
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EXPIRES',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.grey2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _expiryController.text.isEmpty
                                        ? 'MM/YY'
                                        : _expiryController.text,
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Card Number
              Text(
                'Card Number',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.grey2,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19),
                ],
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                ),
                decoration: InputDecoration(
                  hintText: '1234 5678 9012 3456',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey2,
                  ),
                  prefixIcon: const Icon(
                    Icons.credit_card_rounded,
                    color: AppColors.grey2,
                  ),
                  filled: true,
                  fillColor: AppColors.grey.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: AppColors.shop,
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _cardNumberController.value = TextEditingValue(
                      text: _formatCardNumber(value),
                      selection: TextSelection.collapsed(
                        offset: _formatCardNumber(value).length,
                      ),
                    );
                  });
                },
                validator: (value) {
                  if (value == null || value.replaceAll(' ', '').isEmpty) {
                    return 'Please enter card number';
                  }
                  if (value.replaceAll(' ', '').length < 16) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Card Holder
              Text(
                'Card Holder Name',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.grey2,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cardHolderController,
                textCapitalization: TextCapitalization.words,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'John Doe',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey2,
                  ),
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.grey2,
                  ),
                  filled: true,
                  fillColor: AppColors.grey.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: AppColors.shop,
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter card holder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Expiry and CVV Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expiry Date',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.grey2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _expiryController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(5),
                          ],
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'MM/YY',
                            hintStyle: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.grey2,
                            ),
                            filled: true,
                            fillColor: AppColors.grey.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _expiryController.value = TextEditingValue(
                                text: _formatExpiry(value),
                                selection: TextSelection.collapsed(
                                  offset: _formatExpiry(value).length,
                                ),
                              );
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (value.length < 5) {
                              return 'Invalid';
                            }
                            final parts = value.split('/');
                            final month = int.tryParse(parts[0]);
                            final year = int.tryParse(parts[1]);
                            if (month == null || month < 1 || month > 12) {
                              return 'Invalid month';
                            }
                            if (year == null) return 'Invalid year';
                            final now = DateTime.now();
                            final expiry = DateTime(2000 + year, month);
                            if (expiry.isBefore(now)) {
                              return 'Card expired';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CVV',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.grey2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          obscureText: true,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: '123',
                            hintStyle: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.grey2,
                            ),
                            filled: true,
                            fillColor: AppColors.grey.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (value.length < 3) {
                              return 'Invalid CVV';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Save card checkbox
              Row(
                children: [
                  Checkbox(
                    value: _saveCard,
                    onChanged: (value) {
                      setState(() => _saveCard = value ?? false);
                    },
                    activeColor: AppColors.shop,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Text(
                    'Save card for future payments',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.grey2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Pay Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.shop,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.black,
                          ),
                        )
                      : Text(
                          'Pay \$${widget.amount.toStringAsFixed(2)}',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Secure payment note
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.grey2,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Secure payment • 256-bit encryption',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
