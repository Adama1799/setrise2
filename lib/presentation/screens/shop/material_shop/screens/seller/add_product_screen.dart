// screens/seller/add_product_screen.dart
import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product", style: TextStyle(fontFamily: 'Inter'))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontFamily: 'Inter'),
              ),
              style: const TextStyle(fontFamily: 'Inter'),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontFamily: 'Inter'),
              ),
              style: const TextStyle(fontFamily: 'Inter'),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontFamily: 'Inter'),
              ),
              style: const TextStyle(fontFamily: 'Inter'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Add Product", style: TextStyle(fontFamily: 'Inter')),
            ),
          ],
        ),
      ),
    );
  }
}
