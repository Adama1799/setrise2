// lib/presentation/screens/shop/cart/widgets/payment_section.dart
import 'package:flutter/cupertino.dart';
import '../../checkout_models.dart';

class PaymentSection extends StatelessWidget {
  final List<PaymentMethod> methods;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const PaymentSection({super.key, required this.methods, required this.selectedIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: methods.asMap().entries.map((e) {
        final i = e.key;
        final m = e.value;
        return RadioListTile<int>(
          value: i,
          groupValue: selectedIndex,
          onChanged: (v) => onChanged(v!),
          title: Text(m.name, style: const TextStyle(color: CupertinoColors.white)),
          subtitle: Text(m.details, style: const TextStyle(color: CupertinoColors.systemGrey)),
        );
      }).toList(),
    );
  }
}
