// widgets/order_summary_card.dart
import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  final double subtotal, shipping, tax, total;
  const OrderSummaryCard({
    Key? key,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Subtotal: \$${subtotal.toStringAsFixed(2)}", style: const TextStyle(fontFamily: 'Inter')),
            Text("Shipping: \$${shipping.toStringAsFixed(2)}", style: const TextStyle(fontFamily: 'Inter')),
            Text("Tax: \$${tax.toStringAsFixed(2)}", style: const TextStyle(fontFamily: 'Inter')),
            const Divider(),
            Text("Total: \$${total.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
          ],
        ),
      ),
    );
  }
}
