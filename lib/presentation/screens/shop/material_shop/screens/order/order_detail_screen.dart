// screens/order/order_detail_screen.dart
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details", style: TextStyle(fontFamily: 'Inter'))),
      body: const Center(child: Text("Order #123 details", style: TextStyle(fontFamily: 'Inter'))),
    );
  }
}
