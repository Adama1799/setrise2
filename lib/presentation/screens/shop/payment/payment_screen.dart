// lib/presentation/screens/shop/payment/payment_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/card_preview.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final VoidCallback onSuccess;
  const PaymentScreen({super.key, required this.amount, required this.onSuccess});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cardNumberCtrl = TextEditingController(), _cardHolderCtrl = TextEditingController(), _expiryCtrl = TextEditingController(), _cvvCtrl = TextEditingController();
  bool _saveCard = false, _processing = false;

  String _formatCard(String v) {
    v = v.replaceAll(RegExp(r'\D'), '');
    if (v.length > 16) v = v.substring(0, 16);
    final buf = StringBuffer();
    for (int i = 0; i < v.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(v[i]);
    }
    return buf.toString();
  }

  void _pay() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _processing = false);
    showCupertinoDialog(context: context, builder: (ctx) => CupertinoAlertDialog(
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(CupertinoIcons.check_mark_circled, color: AppColors.success, size: 48),
        const SizedBox(height: 12),
        const Text('Payment Successful!', style: TextStyle(color: CupertinoColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ]),
      actions: [CupertinoDialogAction(child: const Text('Continue'), onPressed: () { Navigator.pop(ctx); widget.onSuccess(); })],
    ));
  }

  @override
  void dispose() {
    _cardNumberCtrl.dispose(); _cardHolderCtrl.dispose(); _expiryCtrl.dispose(); _cvvCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Payment', style: TextStyle(color: CupertinoColors.white)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            CardPreview(
              cardNumber: _cardNumberCtrl.text,
              cardHolder: _cardHolderCtrl.text,
              expiry: _expiryCtrl.text,
            ),
            const SizedBox(height: 20),
            _textField('Card Number', _cardNumberCtrl, TextInputType.number, [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(19)], onChanged: (v) => setState(() {
              _cardNumberCtrl.value = TextEditingValue(text: _formatCard(v), selection: TextSelection.collapsed(offset: _formatCard(v).length));
            })),
            const SizedBox(height: 12),
            _textField('Cardholder Name', _cardHolderCtrl, TextInputType.text, []),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _textField('MM/YY', _expiryCtrl, TextInputType.number, [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)])),
              const SizedBox(width: 12),
              Expanded(child: _textField('CVV', _cvvCtrl, TextInputType.number, [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)], obscure: true)),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              CupertinoSwitch(value: _saveCard, onChanged: (v) => setState(() => _saveCard = v)),
              const SizedBox(width: 8),
              const Text('Save card', style: TextStyle(color: CupertinoColors.white)),
            ]),
            const SizedBox(height: 24),
            CupertinoButton(
              color: AppColors.shop,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
              child: _processing ? const CupertinoActivityIndicator() : Text('Pay \$${widget.amount.toStringAsFixed(2)}', style: TextStyle(color: CupertinoColors.black, fontWeight: FontWeight.bold)),
              onPressed: _processing ? null : _pay,
            ),
          ]),
        ),
      ),
    );
  }

  Widget _textField(String label, TextEditingController ctrl, TextInputType type, List<TextInputFormatter> formatters, {bool obscure = false, Function(String)? onChanged}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(color: AppColors.grey2, fontSize: 13)),
      const SizedBox(height: 6),
      CupertinoTextField(
        controller: ctrl, keyboardType: type, obscureText: obscure, inputFormatters: formatters,
        style: const TextStyle(color: CupertinoColors.white), placeholder: label,
        placeholderStyle: const TextStyle(color: AppColors.grey2),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.grey.withOpacity(0.2))),
        onChanged: onChanged,
      ),
    ]);
  }
}
