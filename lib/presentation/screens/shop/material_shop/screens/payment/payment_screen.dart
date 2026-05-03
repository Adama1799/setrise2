// material_shop/screens/payment/payment_screen.dart
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final double amount;
  final VoidCallback onSuccess;
  const PaymentScreen({Key? key, required this.amount, required this.onSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardNumberCtrl = TextEditingController();
    final expiryCtrl = TextEditingController();
    final cvvCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Payment", style: TextStyle(fontFamily: 'Inter'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: cardNumberCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontFamily: 'Inter'),
              ),
              style: const TextStyle(fontFamily: 'Inter'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expiryCtrl,
                    decoration: const InputDecoration(
                      labelText: 'MM/YY',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontFamily: 'Inter'),
                    ),
                    style: const TextStyle(fontFamily: 'Inter'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: cvvCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontFamily: 'Inter'),
                    ),
                    style: const TextStyle(fontFamily: 'Inter'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onSuccess();
              },
              child: Text("Pay \$${amount.toStringAsFixed(2)}", style: const TextStyle(fontFamily: 'Inter')),
            ),
          ],
        ),
      ),
    );
  }
}
