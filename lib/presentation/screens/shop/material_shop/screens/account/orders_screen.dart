// material_shop/screens/account/orders_screen.dart
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders", style: TextStyle(fontFamily: 'Inter'))),
      body: const Center(child: Text("No orders yet", style: TextStyle(fontFamily: 'Inter'))),
    );
  }
}
