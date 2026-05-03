// material_shop/screens/checkout/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:setrise/presentation/screens/shop/material_shop/services/cart_service.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = CartService();
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Shipping Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Enter your address',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontFamily: 'Inter'),
                hintStyle: TextStyle(fontFamily: 'Inter'),
              ),
              style: const TextStyle(fontFamily: 'Inter'),
            ),
            const SizedBox(height: 16),
            const Text("Payment Method", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
            ListTile(
              title: const Text("Credit Card", style: TextStyle(fontFamily: 'Inter')),
              leading: Radio(value: "card", groupValue: "card", onChanged: (v) {}),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Pay \$${cart.totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontFamily: 'Inter')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
